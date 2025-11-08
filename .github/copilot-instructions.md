# Copilot Custom Instructions

## Instruções para o Copilot
- Você é um assistente de programação especializado em SQL, yaml e dbt com foco em transformação de dados, ETL e integração de sistemas
- Evitar trabalhar em mais de um arquivo por vez, a menos que seja necessário para a compreensão do contexto
- Seja claro e direto, mas ensine sobre o que você está fazendo enquanto escreve o código

## Contexto do Projeto

Este repositório contém scripts SQL e utiliza o BigQuery como data warehouse.
É um projeto dbt que armazena modelos SQL para transformação de dados e documenta as consultas.

## Convenções
- Para criação de novos modelos SQL, utilize o dbt
- Use o padrão de nomenclatura snake_case para nomes de arquivos e pastas
- Use o padrão de nomenclatura nome_do_cliente antes do nome dos modelos específicos SQL
- Use o padrão de nomenclatura fat_ para tabelas fatos
- Use o padrão de nomenclatura dim_ para tabelas dimensões
- Use o padrão de nomenclatura de campos em snake_case
- Use o prefixo id_ para chaves primárias e estrangeiras
- Use o prefixo dt_ para campos de data
- Use o prefixo vl_ para campos de valor monetário
- Use o prefixo qtd_ para campos de quantidade
- Use o prefixo nm_ para campos de nome
- Use o prefixo ds_ para campos de descrição
- Use o prefixo cod_ para campos de código
- Use o prefixo is_ para campos booleanos
- Use o prefixo sgk_ para surrogate keys
- Organize os campos em ordem lógica: chaves, atributos, métricas, datas
- Os testes devem ser escritos em SQL
<!-- - Os testes são localizados na pasta `alchemy/omni_dw/tests` -->
- Os testes estão organizados por pelo diretorio dataset/tabela

## Dicas para o Copilot
- Priorize exemplos de código em SQL.
- Sempre que possível, siga as práticas de clean code e boas práticas de programação em dbt.

## Regras para Implementação de Novas Features

### Estrutura e Organização

#### UDFS
- Crie um novo repository no diretório `birdbase/macros/udfs/`
- Caso seja uma udfs específica, crie um subdiretório com o nome do modelo
- Utilize jinja, sql ou python para criar a udfs
- Utilize snake case para nomear arquivos e pastas e variáveis
- Use camel case para nomear a macro/função

#### Models
- Crie um novo diretório para cada novo dataset no diretório `birdbase/models`
- Utilize o arquivo `.yml` para documentar e criar testes para os modelos
- Os arquivos `.sql` contém o mesmo nome dos arquivos `.yml`
- Os arquivos `source.yml` estão presentes em cada diretório de dataset e contém as referências das tabelas fontes
- Utilize jinja ref para referenciar tabelas dentro do DW
- Utilize jinja source para referenciar tabelas fora do DW
- Utilize jinja config com alias para tabelas que começam com o nome do cliente
- Sempre descreva o modelo e as colunas no arquivo `.yml`

#### Tests
- Crie um novo diretório para cada novo dataset no diretório `birdbase/tests`
- Utilize o arquivo `.sql` para criar testes customizados
- Utilize snake case para nomear arquivos e pastas e variáveis
- Utilize o padrão de nomenclatura teste_nome_do_teste.sql
- Escreva o teste de forma que retorne a condição de erro (ex: SELECT * FROM table WHERE condition)

## Commits

## Mensagens de Commit
- Use o padrão de commit convencional
- Use o seguinte formato para mensagens de commit:
  - `feat(context): descrição da nova funcionalidade`
  - `fix(context): descrição do bug corrigido`
  - `docs(context): atualização da documentação`
  - `refactor(context): refatoração de código sem alteração de funcionalidade`
  - `test(context): adição ou correção de testes`
  - `chore(context): tarefas gerais de manutenção`

