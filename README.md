# Rifa Premiada — site para GitHub Pages

Site responsivo em HTML, CSS e JavaScript, com identidade azul, ilustrações SVG, campanhas, cadastro/login Supabase, área do cliente e painel administrativo.

**Importante:** a interface está pronta para configurar; cadastro, login e campanhas reais dependem do Supabase. Enquanto não houver conexão, aparecem campanhas de demonstração. Esta versão não vende números nem processa pagamentos. Verifique as exigências legais aplicáveis antes de operar rifas pagas.

## Arquivos principais
- `index.html`: página inicial, campanhas, cadastro e login.
- `styles.css`: identidade visual responsiva.
- `app.js`: autenticação e carregamento de campanhas.
- `admin.html` e `dashboard.js`: painel para criar campanhas e alterar status.
- `minha-conta.html` e `account.js`: área do cliente.
- `supabase/schema.sql`: tabelas e políticas de segurança.
- `assets/`: logo, favicon e ilustrações locais.
- `termos.html` e `privacidade.html`: modelos que precisam ser personalizados.

## 1. Enviar e publicar no GitHub Pages
1. Crie um repositório no GitHub (por exemplo `rifa-premiada`).
2. Envie **o conteúdo desta pasta** para a raiz do repositório. `index.html` deve ficar na raiz, não dentro de uma pasta extra.
3. No repositório, abra **Settings → Pages**.
4. Em **Build and deployment**, escolha **Deploy from a branch**.
5. Selecione branch `main` e pasta `/(root)`, depois salve.
6. Aguarde a publicação e abra o endereço que o GitHub mostrar.

O GitHub Pages hospeda arquivos estáticos; não cria nem hospeda o banco de dados.

## 2. Criar banco de dados no Supabase
1. Acesse https://supabase.com/ e crie uma conta e um projeto.
2. Guarde a senha do banco em um local seguro. **Não coloque essa senha nos arquivos do site.**
3. No projeto, abra **SQL Editor → New query**.
4. Abra `supabase/schema.sql`, copie o conteúdo completo, cole no editor e execute.
5. Abra **Project Settings → API** (ou seção equivalente) e copie a **Project URL** e a chave pública `anon`/publishable.
6. No GitHub, abra `app.js`, `dashboard.js` e `account.js`. Em cada arquivo, substitua `COLE_AQUI_A_URL_DO_SEU_PROJETO` pela URL e `COLE_AQUI_SUA_CHAVE_PUBLICA_ANON` pela chave pública.
7. Salve e faça commit dos três arquivos.
8. Em **Authentication → URL Configuration**, configure a URL publicada como Site URL e Redirect URL.

Use apenas a chave pública `anon`/publishable no navegador e somente com RLS ativa. **Nunca use `service_role`, chaves secretas ou a senha do banco nos arquivos públicos.**

## 3. Criar conta de administrador
1. Abra o site publicado e crie a conta com o e-mail administrativo que você controla. O e-mail predefinido no código é `ifroalimentos.25@gmail.com`; altere `ADMIN_EMAIL` nos arquivos JS se necessário.
2. Confirme o e-mail, se solicitado.
3. No Supabase, abra SQL Editor e execute:

```sql
update public.profiles
set role = 'admin'
where lower(email) = lower('ifroalimentos.25@gmail.com');
```

4. Confira se uma linha foi atualizada. Se não, verifique se a conta foi criada e se o e-mail está correto.
5. Entre no site e abra `admin.html`. Crie uma campanha e defina como “Em andamento” ou “Em breve” para aparecer na página inicial.

A tabela de perfis não permite que usuários atualizem seu próprio papel. Mantenha a senha administrativa privada.

## 4. Testar antes de divulgar
- Teste o site no celular e computador.
- Teste cadastro, confirmação de e-mail, login e área do cliente.
- Teste criar uma campanha e veja se aparece no site público.
- Teste com uma conta comum e confirme que ela não consegue administrar campanhas.
- Personalize termos, privacidade, contato e campanhas antes de divulgar.

## Avisos e limitações
- Não há pagamentos, reserva de números, sorteio/apuração de ganhadores ou impressão nesta versão.
- CPF, e-mail, nome e telefone são dados pessoais; revise o tratamento conforme a LGPD.
- No Brasil, sorteios, promoções comerciais e rifas pagas podem estar sujeitos a regras e autorizações diferentes. Procure orientação jurídica e confirme a modalidade aplicável antes de receber dinheiro ou anunciar participação paga.
- O projeto precisa ser configurado e testado por você; não foi publicado automaticamente.

## Solução de problemas
- **Só aparece texto/sem visual:** confirme que `styles.css`, `app.js` e a pasta `assets/` foram enviados e que `index.html` está na raiz.
- **Campanhas reais não aparecem:** confirme URL/chave pública nos três JS e veja as tabelas/policies no Supabase.
- **Painel nega acesso:** confirme a criação da conta, a confirmação do e-mail e a atualização do perfil para `admin`.
