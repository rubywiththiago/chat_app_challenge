# Desafio

O desafio para essa vaga consiste em criar uma aplicação monolítica (Ruby on Rails + VueJS) de um mini app de mensagens com autenticação de usuários e CRUD de mensagens em um canal único.

## Requisitos técnicos

- Ruby on Rails (obrigatório);
- VueJS (obrigatório, empacotamento fica ao seu critério);
- Banco de dados é livre porém, temos preferência pelo PostgreSQL;
- Websockets para conexões realtime;
- RSpec para testes (testes exclusivos em frontend é livre)

> Você está livre para usar as ferramentas e padrões que desejar, mas, é obrigatório que a estrutura da aplicação seja monolítica.

## Regras de negócio

### Usuário

- Nome: obrigatório e deverá ter entre 3-255 caracteres;
- Username: obrigatório e deverá ter entre 5-50 caracteres e permitir apenas letras, números e os caracteres `-` e `_`.  Deve ser único;
- Email: obrigatório e deverá ser válido. Também deve ser único;
- Senha: obrigatória e deverá ter entre 20-100 caracteres. Deve ter o campo de confirmação.

### Mensagem

- Texto: deve ser obrigatório e ter até 1000 caracteres;
- Apenas o autor pode editar/remover suas mensagens;

## Fluxo da Aplicação

### Página Inicial

- Deve obedecer a seguinte lógica: Quando o usuário estiver logado, a página é o canal de mensagens. Caso contrário, deverá ser a página de login;
- Sem ser autenticado, o usuário poderá apenas fazer login e registro;

## Autenticação

- Usuário deverá ser logado apenas se o seu username/email e senha estiverem validado;
- Opcional: Travar login por 1h após 5 tentativas não sucedidas de autenticação. Deverá conter desbloqueio.

## Registro

- No registro de um usuário, após criá-lo, é preciso enviar um link de confirmação para o seu email (envio simulado é aceitável);
- Usuários duplicados são inaceitáveis;

## Canal de Mensagens

- Deverá listar todas as mensagens (ordenados das mais recentes);
- Um form/componente para nova mensagem;
- Botões para editar/excluir mensagem;
- Visualização de mensagens em tempo real;
- Opcional: Buscar mensagens por texto e filtrar por autor.

## Avaliação

- Iremos avaliar se a regra de negócio foi aplicada corretamente, e, a qualidade do código (organização, estrutura interna). Tratamento de erros e edge cases são levados em conta. Cobertura de testes serão levados em conta;
- A interface pode ser bem simples. Visual, UI e UX contarão pontos;
- Requisitos opcionais podem ser deixados de lado, porém, farão diferença em sua avaliação.

## Critérios

1. TUDO, absolutamente TUDO, será olhado (sim, teremos carinho pelo seu tempo gasto e olharemos com destreza seu teste);
2. Esse desafio foca na questão fullstack, então, backend e frontend são igualmente importantes;
3. Deployar sua aplicação em modo produção será um plus fundamental, porém, opcional. A plataforma fica a critério do candidato;
4. A atitude faz total diferença para um verdadeiro profissional em sua resolução de problemas. Interprete esse item como desejar.

## Entrega

Deverá fazer o fork desse repositório. O candidato tem a 7 dias a partir do recebimento do desafio por email para entregá-lo. Aos que concluírem o desafio em tempo, em respeito ao tempo dedicado, faremos um feedback técnico da forma mais detalhada e coesa possível.