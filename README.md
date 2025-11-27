# Birdbase - Data Warehouse

![imagem](https://mindthegraph.com/blog/wp-content/uploads/2019/03/image-aves-2022.png)

Os objetivos deste projeto são:
- Uso do dbt
- Armazenar de forma segura as consultas utilizadas na criação de dws e data marts.
- Documentar de forma padronizada estas consultas, para que isto nos auxilie em migrações futuras e saídas de colaboradores.

## Documentação

### Convenções de Nomes
- [JS](https://www.robinwieruch.de/javascript-naming-conventions/)
- [DW](https://wiki.projetoomni.com/pt-br/pix/dados/padroes/bq/tabelas-datasets)

### Nome da consulta programada (diretório sql)

- O nome deve estar em snake case
- Formato: {nome_do_dataset_destino}_{nome_da_tabela_destino}
- Exemplo: omni-dw/ft_produtos

## dbt

### Resources

- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

### Bibliotecas no dbt
Este projeto utiliza bibliotecas que podem ser importadas através do arquivo packages.yaml
O dbt suporta diversos tipos de bibliotecas, para mais informações, consulte o guia de libs:
[Bibliotecas dbt](https://docs.getdbt.com/docs/build/packages)


### Configurar o dbt na sua máquina

Crie um ambiente virtual Python:


### Crie um ambiente virtual Python (LINUX)

**Instalação do python**
``` sh
apt install python3.12-venv 
```

**Crie um ambiente virtual Python**

``` sh
python3.12 -m venv .venv

source .venv/bin/activate
```

### Instale as dependências

```sh
pip3 install -r requirements.txt
```

```sh
dbt deps
```

### Google SDK
Você irá precisar fazer o download da [google-cloud-sdk](https://cloud.google.com/sdk?utm_source=google&utm_medium=cpc&utm_campaign=latam-BR-all-pt-dr-BKWS-all-all-trial-e-dr-1605194-LUAC0008672&utm_content=text-ad-none-any-DEV_c-CRE_526696106061-ADGP_Hybrid%20%7C%20BKWS%20-%20EXA%20%7C%20Txt%20~%20Dev-Tools_SDK-KWID_43700040369790130-kwd-610235859304&utm_term=KW_google%20cloud%20sdk-ST_Google%20Cloud%20SDK&gclid=Cj0KCQjwiIOmBhDjARIsAP6YhSVKjAjopS3ryD-myeprNpCK20IfHcZ9mLoWaVv-fQq5dDsw0_oIO5caAtDzEALw_wcB&gclsrc=aw.ds&hl=pt-br)

**Autenticação**

```sh
gcloud auth application-default login \
  --scopes=https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/bigquery,https://www.googleapis.com/auth/drive
```

### Configure o arquivo profiles.yml localmente

```sh
vim ~/.dbt/profiles.yml
```

```yml
birdbase:
  outputs:
    dev:
      dataset: birdbase_silver
      job_execution_timeout_seconds: 300
      job_retries: 1
      keyfile: /var/www/birdbase/keys/mackenzie-engenharia-dados-dac95f889d36.json
      location: US
      method: service-account
      priority: interactive
      project: mackenzie-engenharia-dados
      threads: 20
      type: bigquery
  target: dev
```

Verificar se o arquivo profiles.yml está configurado
```sh
cat ~/.dbt/profiles.yml
```

Adicionar path para o profile no .bashrc ou equivalente
```sh
export DBT_PROFILES_DIR=~/.dbt
```

## Alguns comandos dbt
Inicializar um novo projeto do zero
```sh
dbt init
```

Realizar o debug para testar se as conexões estão funcionando corretamente
```sh
dbt debug
```

Executar uma tabela - PARTIAL
```sh
dbt run --models nome_da_tabela
```

Executar uma tabela - FULL
```sh
dbt run --full-refresh --models nome_da_tabela
```

Realizar teste de cada coluna baseado no arquivo schema
```sh
dbt test
```

Realizar testes customizados
```sh
dbt test --models nome_da_tabela --select test_type:singular
```

Gerar uma documentação do projeto na pasta target
```sh
dbt docs generate
```
Subir o html do modelo DTB em si
```sh
dbt docs serve
```


Config modelos .sql
```sql
{{
  config(
    alias='alias_table',
    schema = 'schema_referência',
    materialized='type_materialized',
    cluster_by = ["columns"],
    unique_key=["columns"],
    tags=[]
  )
}}
```

Referenciar tabelas do próprio DW nos modelos .sql
```sql
FROM {{ ref('omni_dw', 'ft_vendas_itens') }}: 
```

Referenciar tabelas fora do DW nos modelos .sql
```sql
{{ source('ammo_varejo_pdv', 'employee') }}
```
Lembrar de criar uma pasta com o nome do dataset e um arquivo source.yml [Referência](https://docs.getdbt.com/reference/configs-and-properties#example)
source.yml
```yml
version: 2
sources:
  - name: dataset alias
    database: dataset
    description: "Description"
    tables:
      - name: table_name
```

## Comandos GIT
- git status
- git commit -m "mensagem"
- git pull
- git push

