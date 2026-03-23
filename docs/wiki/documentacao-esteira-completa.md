# Documentação completa da esteira CI/CD — Birdbase

Última atualização: 23/03/2026

## Objetivo

Documentar end-to-end tudo que foi implementado no projeto Birdbase: infraestrutura (Terraform), código (API Flask), publicação (Artifact Registry / Cloud Run / Cloud Run Job), automação (GitHub Actions, Workflows, Scheduler) e decisões técnicas relevantes (WIF, permissões, carga incremental de imagens).

---

## Sumário rápido

- Visão Geral
- O que foi criado (infra e recursos)
- Mudanças de código principais
- CI/CD e publicação (GitHub Actions)
- Orquestração e agendamento (Workflows + Scheduler)
- Como executar e testar manualmente
- Troubleshooting e logs

---

## 1) Visão Geral da solução

A esteira foi projetada para ingestão e transformação de dados do Birdbase com foco em:

- Reprodutibilidade (Infra como código via Terraform)
- Automação segura (Workload Identity Federation + GitHub Actions)
- Orquestração confiável (Cloud Workflows + Cloud Scheduler)
- Execução escalável (Cloud Run para API; Cloud Run Job para dbt)
- Eficiência incremental (checar imagens já presentes no GCS antes de reprocessar)

---

## Fluxo resumido

1. **Cloud Scheduler** dispara o pipeline na data/hora configurada (cron). A imagem abaixo ilustra o agendamento do Scheduler:

  ![Exemplo agendamento](../img/schedule-cron.png)

2. **Cloud Workflows** orquestra a execução:
  - Ingestão paralela dos endpoints `/birds/birdbase`, `/birds/names` e `/birds/images` (imagens com verificação incremental no GCS).
  - Após ingestão, execução do Cloud Run Job (`birdbase-dbt`) para transformação via dbt.

  ![Exemplo visual do workflow](../img/execute-workflow.png)

3. **Cloud Run / BigQuery**: a API e o job executam, dados são carregados no BigQuery; logs centralizados no Cloud Logging.

![Exemplo visual do log](../img/log.png)

---


## 2) Infraestrutura criada (resumo de recursos Terraform)

Todos os recursos são definidos em `elt-birdbase/infra/main.tf` e variáveis em `infra/envs/main.tfvars`.

Recursos principais:

- API & Execução
  - Cloud Run Service: `birdbase-api` (Flask API)
  - Cloud Run Job: `birdbase-dbt` (executa dbt runs)

- Armazenamento
  - Google Cloud Storage buckets:
    - `birdbase-database` (state / arquivos auxiliares)
    - `birdbase-birds-of-the-world` (imagens BOW)

- Publicação de imagens
  - Artifact Registry repository para Docker images

- Orquestração e agendamento
  - Cloud Workflows: `birdbase-pipeline` — orquestra ingestões paralelas e dbt
  - Cloud Scheduler: `birdbase-daily-pipeline` — aciona o Workflow via HTTP (cron configurável)

- Identidade e permissões
  - Service Accounts:
    - `runtime` — conta usada por Cloud Run e Cloud Run Job
    - `deployer` — conta usada via WIF pelo GitHub Actions
    - `orchestrator` — conta usada por Workflows e Scheduler
  - Workload Identity Pool & Provider: aceita tokens do GitHub Actions para WIF
  - IAM bindings mínimos aplicados (roles/run.admin, roles/storage.objectAdmin, roles/bigquery.* etc.)

Observações:
- Alguns buckets foram criados com `prevent_destroy` para proteger dados críticos.
- O `Cloud Run Service` tem timeout configurável (3600s no template atual) e recursos escaláveis.

---

## 3) Mudanças de código importantes

Arquivos alterados no repo `elt-birdbase`:

- `src/models/birds_data_manager.py`
  - Antes: duplicatas eram checadas lendo um JSON local (`birds_of_the_world.json`) — ineficiente em Cloud Run.
  - Agora: checa existência de imagens no bucket GCS (`birdbase-birds-of-the-world`) carregando a lista de blobs uma vez e mantendo cache em memória. Lookup O(1) por blob name.

- `src/controllers/images_controller.py`
  - `process_images` recebe instâncias compartilhadas de `BirdDataManager` e `ImageUploader`, contabiliza novas imagens e só aciona a carga no BigQuery se houver registros novos.
  - Endpoint `/birds/images` agora retorna a contagem de novas imagens processadas.

- `src/models/repository/birds_of_the_world_images_table.py`
  - `pandas_gbq.to_gbq(..., if_exists='replace')` foi alterado para `if_exists='append'` para suportar cargas incrementais.

- `src/models/image_uploader.py` e `src/models/image.py` — permanecem responsáveis por upload/download, usando `google-cloud-storage`.

Motivação técnica:
- O JSON local era sempre vazio em containers efêmeros (Cloud Run), por isso o processamento refeito em todas as execuções; consultar GCS resolve isso e permite incremental.

---

## 4) CI/CD e publicação

Arquivos-chave:
- `elt-birdbase/.github/workflows/ci.yml` — pipelines de validação (Python, Terraform)
- `elt-birdbase/.github/workflows/cd.yml` — build, WIF auth, Terraform apply, build/push Docker, deploy Cloud Run & Job
- `birdbase/.github/workflows/*` — build/push imagem dbt e deploy job

Fluxo de publicação (resumido):
1. Pull Request: executa CI (lint, tests, terraform validate)

2. Push em `main`: workflow de CD executa:
   - Autenticação com GCP via WIF (provisionada por Workload Identity Pool/Provider)
   - Terraform apply (infra) — importa recursos existentes quando necessário
   - Build & push de Docker image para Artifact Registry
   - Atualiza Cloud Run Service e Cloud Run Job

Observações de segurança:
- As credenciais não são armazenadas em arquivos; o GitHub Actions troca uma identidade via WIF para a SA `deployer`.

---

## 5) Orquestração e agendamento

- `google_workflows_workflow.birdbase_pipeline` (no Terraform):
  - Executa três branches em paralelo chamando os endpoints:
    - `/birds/birdbase` — ingestão primária
    - `/birds/names` — ingestão de nomes PT-BR
    - `/birds/images` — ingestão incremental de imagens (consulta GCS)
  - Depois aguarda e executa o Cloud Run Job `birdbase-dbt` via API `run.v2.jobs.run`.

- `google_cloud_scheduler_job.birdbase_daily` dispara o Workflow via HTTP com oauth_token configurado para a SA `orchestrator`.

Exemplo de cron usado em Terraform:
```hcl
schedule = "0 20 18 * *"  # dia 18 de cada mês às 20:00 (BRT)
```

---

## 6) Como executar manualmente

- Rodar pipeline manualmente:
```sh
gcloud workflows run birdbase-pipeline --location=us-east1 --project=mackenzie-engenharia-dados
```

- Rodar apenas o endpoint de imagens (teste rápido):
```sh
curl -X POST https://<CLOUD_RUN_URL>/birds/images
```

- Ver logs do dbt job no último run:
```sh
gcloud logging read 'resource.type="cloud_run_job" AND resource.labels.job_name="birdbase-dbt"' --project=mackenzie-engenharia-dados --limit=200 --format="value(textPayload)"
```

---

## 7) Troubleshooting rápido

- Workflow falhando com timeout/504:
  - Verifique se o step de imagens está realmente incremental (consultar GCS)
  - Cheque quotas e rede (Cloud Run outbound) — a chamada externa para birdsoftheworld pode ser lenta

- Erros de permissão (403):
  - Verifique IAM bindings das SAs (`runtime`, `deployer`, `orchestrator`)
  - Confirme que WIF tem a attribute mapping correta e que o membro do SA tem `roles/iam.workloadIdentityUser`

- DBT falhando:
  - Ver logs do Cloud Run Job (ex.: `gcloud logging read 'resource.type="cloud_run_job" ...'`)
  - Conferir que o `dbt` image foi buildado com as dependências corretas (profiles, conexões a BigQuery)

---

## 8) Arquivos e locais importantes

- Infra & workflows
  - `/elt-birdbase/infra/main.tf` (Terraform infra)
  - `/elt-birdbase/infra/envs/main.tfvars` (variáveis de ambiente)

- API & ingestão
  - `/elt-birdbase/src/controllers/images_controller.py`
  - `/elt-birdbase/src/models/birds_data_manager.py`
  - `/elt-birdbase/src/models/repository/birds_of_the_world_images_table.py`

- CI/CD
  - `/elt-birdbase/.github/workflows/*`
  - `/birdbase/.github/workflows/*`

- Documentação
  - `/birdbase/docs/wiki/documentacao-esteira-completa.md`

---