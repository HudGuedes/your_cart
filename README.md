<h1>Your Cart</h1>

Uma API para gestão dos seus produtos em seu carrinho.

<h1>Tecnologias utilizadas;</h1>

- ruby 3.3.1
- rails 7.1.3.2
- postgres 16
- redis 7.0.15


<h2>Bibliotecas utilizadas;</h2>

- rspec-rails
- factory_bot_rails
- faker
- byebug
- sidekiq
- docker

<h2>Modo de utilizar;</h2>

- Clone este repositório para sua máquina.
- Na raiz do projeto crie um arquivo chamado `.env`, copie e cole e mude as credenciais:
```json
POSTGRES_HOST=localhost
POSTGRES_USER= #seu_usuário_do_banco
POSTGRES_PASSWORD= #sua_senha_do_banco
```
- Configure o arquivo database.yml e coloque as credenciais do seu banco PostgreSQL.
- Abre o prompt e entre no diretório deste repositório, execute o comando `docker-compose up --build` para instalar as dependências do docker.
- Após finalizar rode ainda em outro prompt o comando `docker-compose exec web rails db:create db:migrate`

<h2>ROTAS DA API</h2>

Utilize alguma ferramenta de testar APIs como insomnia ou postman

Primeiramente crie um produto, para criar:
- URL: POST http://localhost:3000/products
- Corpo da Requisição:
```json
{
	"name": "Camiseta da Adidas M",
	"price": 99.9
}
```

Para listar todos os produtos:
- URL: GET http://localhost:3000/products

Para adicionar o produto ao carrinho:
- URL: POST http://localhost:3000/carts
- Corpo da Requisição:
```json
{
	"product_id": 1,
	"quantity": 4 
}
```

Para listar todos os produtos do carrinho:
- URL: GET http://localhost:3000/carts

Para alterar a quantidade de produtos no carrinho:
- URL: POST http://localhost:3000/carts/add_item
- Corpo da Requisição:
```json
{
	"product_id": 1,
	"quantity": 10
}
```

Para remover um produto do carrinho:
- URL: DELETE http://localhost:3000/cart/1

<h2>Rodar o Sidekiq</h2>

No prompt rode o comando docker-compose exec web bundle exec sidekiq.
Para conseguir testar o job, altere no banco o carrinho criado ou via console, alterando o campo last_interaction_at para menos de 3 horas ou mais e assim podemos forçar o Worker criado no rails console, no prompt rode rails c e execute o comando `MarkCartAsAbandonedJob.perform_async`

<h2>Rodar os Testes</h2>

No prompt execute o comando `docker-compose exec web rspec`