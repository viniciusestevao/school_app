# School App

Aplicação Rails para organizar cursos em uma estrutura hierárquica de módulos, recursos e atividades. Administradores criam e ordenam o conteúdo; membros autenticados consultam os cursos.

## Recursos atuais

- Autenticação de usuários com Devise.
- Perfis `member` e `admin`; somente administradores criam, alteram ou removem cursos e sua estrutura.
- Cursos com módulos, recursos e atividades em árvore, incluindo reordenação.
- Atividades com texto rico, pontuação, prazo e tipo de entrega.
- Painel com totais e próximos prazos.

## Requisitos

- Ruby 3.3
- PostgreSQL
- Node.js e Yarn/Corepack para os assets

## Configuração local

1. Instale as dependências Ruby com `bundle install`.
2. Instale as dependências JavaScript com `yarn install`.
3. Configure o banco PostgreSQL conforme `config/database.yml` ou com variáveis de ambiente próprias.
4. Execute `bin/rails db:prepare`.
5. Inicie a aplicação com `bin/dev`.

## Testes

Execute a suíte com `bin/rails test`.

## Próximas etapas de produto

O projeto já permite administrar a estrutura pedagógica, mas ainda não oferece matrícula, atribuição de instrutores, submissões de alunos, correção, progresso ou permissões por curso. Esses recursos devem ser planejados antes de serem expostos como um LMS completo.
