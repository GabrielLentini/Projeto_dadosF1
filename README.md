# Bem-vindo ao Repositório `DBT_POSTGRES`

Repositorio que desempenham a transformação e manutenção das tabelas do banco de dados, passando pelas camadas staging, intermediate e
marts, contendo dimensões e fatos.

## Utilizando este Projeto

Para utilizar este projeto voce deverá seguir as seguintes etapas:

- `Iniciação do venv` (para ativar máquina virtual)
- `dbt deps` (para instalar as dependências do repositório)
- `dbt seed` (para importar os CSVs para tabela)
- `dbt run` (para executar os modelos)
- `dbt test` (para executar os testes)
