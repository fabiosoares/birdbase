# Proposição de pipelines de CI/CD e Infraestrutura como Código — Esteira Birdbase

## Visão Geral

A esteira do projeto Birdbase garante deploy automatizado, orquestração de ingestão e transformação de dados, e infraestrutura reprodutível via código. Utilizamos GCP, Terraform, GitHub Actions, Cloud Run, Workflows, Scheduler e dbt.

---

## Fluxo resumido do pipeline

1. **Cloud Scheduler** dispara o pipeline automaticamente na data/hora configurada (cron).
2. **Cloud Workflows** orquestra a execução:
   - Inicia ingestão paralela dos endpoints `/birds/birdbase`, `/birds/names` e `/birds/images`.
   - Cada endpoint executa sua lógica de ingestão (dados, nomes, imagens incrementais).
   - Após ingestão, o Workflow executa o Cloud Run Job do dbt para transformação dos dados.
3. **Cloud Run** executa a API Flask e o Job dbt.
4. **BigQuery** recebe os dados transformados.
5. **Logs** centralizados no GCP para auditoria e troubleshooting.

---

## Arquitetura da Esteira

- **CI/CD**: GitHub Actions para build, teste, deploy e provisionamento de infraestrutura
- **Infraestrutura como Código**: Terraform (`infra/main.tf`) para todos os recursos GCP
- **Orquestração**: Cloud Workflows + Cloud Scheduler para pipeline E2E
- **Execução**: Cloud Run (API Flask), Cloud Run Job (dbt), GCS, BigQuery

---

## Componentes Criados

### 1. Repositórios
- `elt-birdbase`: API Flask, ingestão, orquestração, infra
- `birdbase`: Projeto dbt (transformação)

### 2. Infraestrutura (Terraform)
- **Buckets GCS**: `birdbase-database`, `birdbase-birds-of-the-world` (com versionamento e `prevent_destroy`)
- **Cloud Run Service**: `birdbase-api` (timeout 3600s, min/max instances configuráveis)
- **Cloud Run Job**: `birdbase-dbt` (timeout 1800s, executa dbt)
- **Artifact Registry**: para imagens Docker
- **Workflows**: pipeline paralelizando ingestões e rodando dbt
- **Service Accounts**: deployer (WIF), runtime (Cloud Run/Job), orchestrator (Workflows/Scheduler)
- **Workload Identity Federation**: deploy seguro via GitHub Actions (aceita ambos os repositórios)
- **IAM**: permissões mínimas necessárias para cada SA
- **Scheduler**: agenda execução mensal (cron configurável)
![Exemplo visual do agendamento (cron)](../img/schedule-cron.png)

> *A imagem acima ilustra o agendamento automático do pipeline via Cloud Scheduler, que dispara o workflow conforme a configuração de cron.*

### Exemplo de configuração do Cloud Scheduler (cron)

```hcl
resource "google_cloud_scheduler_job" "birdbase_daily" {
  name        = "birdbase-daily-pipeline"
  description = "Executa pipeline birdbase mensalmente"
  schedule    = "0 20 18 * *"  # Executa dia 18 de cada mês às 20:00 (BRT)
  time_zone   = "America/Sao_Paulo"
  region      = var.region

  http_target {
    http_method = "POST"
    uri         = "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.birdbase_pipeline.id}/executions"
    oauth_token {
      service_account_email = google_service_account.orchestrator.email
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
    }
  }
}
```

*O horário do cron pode ser ajustado conforme a necessidade do projeto.*

### 3. CI/CD (GitHub Actions)
- **CI**: Lint, teste, validação Terraform, dbt compile/test
- **CD**: Build/push Docker, Terraform apply, deploy Cloud Run/Job
- **Secrets**: WIF, GCP project, etc
- **Importação idempotente**: pipelines importam recursos existentes para evitar conflitos

---

## Pipeline Orquestrado (Workflows)

1. **Ingestão paralela**:
   - `/birds/birdbase` (dados)
   - `/birds/names` (nomes PT-BR)
   - `/birds/images` (imagens — incremental, consulta GCS)
2. **Transformação**:
   - Executa Cloud Run Job do dbt

> ![Exemplo visual do workflow](../img/execute-workflow.png)
> 
> *A imagem acima mostra o fluxo orquestrado pelo Cloud Workflows: ingestão paralela dos dados, nomes e imagens, seguida da execução do dbt.*

### Exemplo do YAML do Workflow

```yaml
main:
  steps:
    - parallel_ingest: # Ingestão paralela dos três endpoints
        parallel:
          branches:
            - ingest_birdbase_branch: ... # Ingestão dos dados principais
            - ingest_names_branch: ...    # Ingestão dos nomes PT-BR
            - ingest_images_branch: ...   # Ingestão incremental de imagens
    - run_dbt: ...        # Executa o job dbt
    - log_dbt: ...        # Loga o resultado do dbt
    - return_result: ...  # Retorna o status final
```

---

## Incremental de Imagens — Solução

- **Endpoint**: checa duplicatas direto no bucket GCS (`birdbase-birds-of-the-world`). Isso garante que apenas imagens realmente novas sejam baixadas e enviadas, tornando o processo incremental, rápido e eficiente mesmo com milhares de espécies já processadas. O sistema pula automaticamente qualquer espécie cuja imagem já esteja presente no bucket, evitando retrabalho e uso desnecessário de recursos.
- **Carga no BigQuery** só ocorre se houver novas imagens (append, não replace)
- **dbt** roda sempre ao final

---

## Comandos Úteis

- Rodar pipeline manualmente:
  ```sh
  gcloud workflows run birdbase-pipeline --location=us-east1 --project=mackenzie-engenharia-dados
  ```
- Ver logs do dbt:
  ```sh
  gcloud logging read 'resource.type="cloud_run_job" AND resource.labels.job_name="birdbase-dbt"' --project=mackenzie-engenharia-dados --limit=50 --format="value(textPayload)"
  ```
- Rodar ingestão de imagens manualmente:
  ```sh
  curl -X POST https://<CLOUD_RUN_URL>/birds/images
  ```

---

## Troubleshooting & Dicas

- **Timeouts**: aumente o timeout do Cloud Run Service/Job se necessário (já configurado para 30min/1800s)
- **Permissões**: verifique IAM das Service Accounts (runtime, deployer, orchestrator)
- **Importação de recursos**: pipelines importam recursos existentes para evitar erros 409
- **BigQuery**: a tabela de imagens é append-only, não sobrescreve dados existentes
- **WIF**: Workload Identity Federation aceita ambos os repositórios (API e dbt)

---

## Observações
- O endpoint `/birds/images` é rápido mesmo com milhares de espécies, pois só processa o que não está no bucket
- Toda infra pode ser destruída/recriada via Terraform
- O deploy é seguro e auditável via WIF + GitHub Actions
- O pipeline é orquestrado de ponta a ponta, com logs centralizados no GCP

## Contato para dúvidas/manutenção

Em caso de dúvidas, sugestões ou necessidade de manutenção, entre em contato pelo Slack do time de dados ou pelo e-mail: dados@seudominio.com.br

---
