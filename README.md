# Rifa Premiada — site completo (base para publicação)

Projeto de site responsivo em Next.js + TypeScript + Tailwind + Supabase, com identidade visual azul, páginas públicas, cadastro/login, área do cliente e painel administrativo protegido por banco de dados.

> **Importante:** esta é uma base de site pronta para configurar e publicar, mas não existe como colocar um site real no ar apenas enviando arquivos ao GitHub. Você ainda precisará conectar o projeto ao Supabase e a um serviço de hospedagem. O projeto não usa nenhuma IA externa.

## O que está incluído

- Página inicial responsiva, menu, rodapé, campanhas e perguntas frequentes.
- Lista e detalhes de campanhas ativas no banco.
- Cadastro de usuário com nome, e-mail, CPF, telefone e senha.
- Login e área pessoal.
- Painel administrativo para criar rascunhos e gerir estado das campanhas.
- Supabase Auth, esquema PostgreSQL e políticas de segurança (RLS).
- Termos e política de privacidade como modelos para revisão.
- Manifesto PWA básico, favicon, `.env.example` e `.gitignore`.
- Integração de pagamentos intencionalmente desativada.

## Antes de publicar: legalidade

No Brasil, rifas/sorteios com venda de números podem estar sujeitos a restrições e autorização prévia, conforme a modalidade e a legislação aplicável. Confirme a modalidade legal, as autorizações e as regras com profissional jurídico e órgão competente antes de oferecer participação paga. **Não ative venda, reserva de números ou pagamento sem essa confirmação.** O site desta versão não vende números e não processa pagamentos.

## 1. Criar o banco e a autenticação

1. Crie um projeto no Supabase.
2. Abra **SQL Editor** no painel do Supabase.
3. Copie e execute todo o arquivo `supabase/schema.sql`.
4. Em **Authentication → URL Configuration**, defina a URL local `http://localhost:3000` e depois adicione a URL de produção quando publicar.
5. Em **Authentication → Providers**, deixe habilitado o provedor de e-mail.
6. Se quiser exigir confirmação de e-mail, mantenha a confirmação ativada e configure o serviço de e-mail do Supabase.

### Tornar sua conta a administradora

1. No arquivo `.env.local`, configure `ADMIN_EMAIL=ifroalimentos.25@gmail.com`.
2. Inicie o site e crie a conta com esse e-mail pelo formulário `/cadastro`.
3. Confirme o e-mail, se o Supabase exigir.
4. No SQL Editor do Supabase, execute:

```sql
update public.profiles p
set role = 'admin'
from auth.users u
where p.id = u.id
  and lower(u.email) = lower('ifroalimentos.25@gmail.com');
```

5. Saia e entre novamente e acesse `/admin`.

O acesso administrativo exige tanto o papel `admin` no banco quanto o e-mail configurado. Não conceda esse papel a contas públicas.

## 2. Configurar o projeto

Instale Node.js LTS no computador. No terminal, dentro da pasta do projeto:

```bash
npm install
```

Copie `.env.example` para `.env.local` e preencha as variáveis:

```env
NEXT_PUBLIC_SUPABASE_URL=https://SEU-PROJETO.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=SUA_CHAVE_ANON_PUBLICA
ADMIN_EMAIL=ifroalimentos.25@gmail.com
```

A chave `anon`/publishable do Supabase pode ser usada no navegador com RLS corretamente configurado. **Nunca** use a chave `service_role` no código do navegador ou em arquivos versionados.

Depois execute:

```bash
npm run dev
```

Abra `http://localhost:3000`.

Antes de publicar, faça uma compilação de verificação:

```bash
npm run build
```

## 3. Enviar para o GitHub

1. Crie um repositório novo no GitHub, por exemplo `rifa-premiada`.
2. Envie todos os arquivos desta pasta para a raiz do repositório.
3. Não envie `.env.local`, senhas, chaves privadas ou dados reais. O `.gitignore` já ignora os arquivos `.env`.
4. Se algum segredo for enviado por engano, remova-o do repositório e revogue/rotacione a credencial no serviço correspondente.

## 4. Publicar o site na internet

Uma opção simples para Next.js é Vercel:

1. Crie uma conta na Vercel (não é uma IA; é um serviço de hospedagem).
2. Importe o repositório GitHub.
3. A Vercel detectará Next.js automaticamente.
4. Em **Project Settings → Environment Variables**, cadastre as mesmas variáveis de ambiente usadas em `.env.local`.
5. Faça o deploy e aguarde a compilação.
6. Copie a URL publicada e adicione-a em Supabase → Authentication → URL Configuration e às URLs de redirecionamento permitidas.
7. Teste cadastro, confirmação de e-mail, login, logout, leitura de campanhas e acesso negado ao `/admin` por contas comuns.

O domínio próprio é opcional e pode ser conectado nas configurações de domínio da hospedagem.

## 5. Limitações conhecidas desta versão

- Pagamentos Pix/cartão, webhooks, reembolsos e reserva/venda de números não estão implementados.
- Não há sorteio automático, seleção/numeração transacional, histórico de pedidos, notificações por SMS/WhatsApp ou envio de e-mail customizado.
- Upload de imagens de campanhas ainda não está ligado ao Supabase Storage; `image_url` aceita uma URL de imagem acessível.
- CPF é verificado no formulário para reduzir erros comuns e o banco impede duplicidades, mas ainda é necessário revisar o fluxo de tratamento de dados e a prevenção contra abuso antes de uso comercial.
- A página de termos e a política de privacidade são modelos. Identifique o controlador de dados, as bases legais, os prazos de retenção e os canais de direitos dos titulares.
- Para produção, configure proteção contra abuso, monitoramento, backups, política de recuperação de conta, MFA administrativo e revisão independente de segurança.

## Estrutura

```text
rifa-premiada/
├── public/
│   ├── favicon.svg
│   └── manifest.json
├── src/
│   ├── app/
│   │   ├── admin/
│   │   ├── cadastro/
│   │   ├── campanhas/
│   │   ├── login/
│   │   ├── minha-conta/
│   │   ├── privacidade/
│   │   ├── termos/
│   │   ├── globals.css
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── components/
│   ├── lib/supabase/
│   └── middleware.ts
├── supabase/schema.sql
├── .env.example
├── .gitignore
├── package.json
└── README.md
```
