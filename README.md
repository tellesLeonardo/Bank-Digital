# Bank Digital

Esse é o projeto Bank Digital, uma aplicação web feita com Elixir e Phoenix. Aqui tem algumas informações de como rodar o projeto usando Docker e Docker Compose.

## Pré-requisitos

Você precisa ter essas coisas instaladas na sua máquina:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Configuração do Projeto

### Clonando o Repositório

Primeiro, clone o repositório:

```bash
git clone https://github.com/tellesLeonardo/Bank-Digital.git
cd Bank-Digital
```

## Configurando o Ambiente
Crie um arquivo .env na raiz do projeto com o seguinte conteúdo:

```bash
# .env
DATABASE_URL=postgres://postgres:postgres@postgresql_db:5432/bank_digital_dev
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=bank_digital_dev
```

## Rodando a Aplicação
### Usando Docker Compose
Tudo já tá configurado no docker-compose.yml. Para rodar a aplicação, use:

```bash
docker-compose up --build
```

Isso vai:

- Construir a imagem Docker da aplicação Elixir.
- Iniciar os serviços (Elixir, PostgreSQL e pgAdmin).
- Expor a aplicação Phoenix na porta 4000.
- Expor o pgAdmin na porta 8081.

## Acessando a Aplicação
Acesse a aplicação Phoenix em http://localhost:4000.


## Rodando Testes Unitários
### Para rodar os testes unitários, use:

```bash
docker-compose run --rm elixir_test
```


