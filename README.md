# 💬 Chat App Challenge

Este projeto foi desenvolvido como parte de um **desafio técnico**. Trata-se de uma aplicação de chat completa com autenticação, troca de mensagens em tempo real e testes automatizados — tudo em um único projeto Rails monolítico com Vue.js.

---

## 📚 Descrição

Aplicação fullstack com:

- Backend em **Ruby on Rails**
- Frontend com **Vue.js 3** usando **Vite**
- Autenticação com **Devise (com confirmação por e-mail)**
- Mensagens em tempo real via **ActionCable**
- Interface interativa com filtros de mensagens
- Testes automatizados com **RSpec**

---

## 🎯 Funcionalidades

- ✅ Cadastro e login de usuários com confirmação por e-mail
- ✅ Envio e recebimento de mensagens em tempo real
- ✅ Filtros por autor e conteúdo da mensagem
- ✅ Frontend com Naive UI (Vue)
- ✅ Testes com RSpec para controllers e services

---

## ⚙️ Tecnologias e Ferramentas

- **Ruby on Rails 7**
- **Devise** (`confirmable`, `database_authenticatable`, etc)
- **PostgreSQL**
- **Vue.js 3**
- **Vite + vite_rails**
- **ActionCable (WebSockets)**
- **RSpec + FactoryBot + Faker**
- **Naive UI (Vue)**

---

## 🚀 Como rodar localmente

### 1. Clone o repositório

Antes de rodar a aplicação, crie um usuário no PostgreSQL e adicione no database.yml

```bash
git clone git@github.com:rubywiththiago/chat_app_challenge.git
cd chat_app_challenge

bundle install

rails db:setup

yarn install

# terminal 1
bin/vite dev

# terminal 2
bin/rails server

```
### 2. Rodando Testes RSPEC
```
bundle exec rspec

```

Observações
Este projeto é um monolito Rails que incorpora tanto o backend quanto o frontend, sem separar aplicações. Toda lógica de negócio está encapsulada em services testáveis.
