-- RIFA PREMIADA
-- Estrutura inicial do banco de dados Supabase

create extension if not exists pgcrypto;

-- Perfis dos usuários
create table if not exists public.profiles (
    id uuid primary key references auth.users(id) on delete cascade,
    full_name text not null,
    cpf text unique,
    phone text,
    role text not null default 'customer'
        check (role in ('customer', 'admin')),
    created_at timestamptz not null default now()
);

-- Campanhas de rifas
create table if not exists public.campaigns (
    id uuid primary key default gen_random_uuid(),
    title text not null,
    description text,
    image_url text,
    ticket_price numeric(10,2) not null default 0
        check (ticket_price >= 0),
    status text not null default 'draft'
        check (status in ('draft', 'active', 'finished', 'cancelled')),
    created_by uuid references public.profiles(id),
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

-- Ativar segurança por linha
alter table public.profiles enable row level security;
alter table public.campaigns enable row level security;

-- Perfis: cada usuário pode consultar somente o próprio perfil
create policy "Users can read own profile"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

-- Campanhas publicadas podem ser vistas por qualquer pessoa
create policy "Anyone can read active campaigns"
on public.campaigns
for select
to anon, authenticated
using (status = 'active');

-- Administradores podem consultar todas as campanhas
create policy "Admins can read all campaigns"
on public.campaigns
for select
to authenticated
using (
    exists (
        select 1
        from public.profiles
        where profiles.id = auth.uid()
          and profiles.role = 'admin'
    )
);

-- Somente administradores podem criar campanhas
create policy "Admins can create campaigns"
on public.campaigns
for insert
to authenticated
with check (
    exists (
        select 1
        from public.profiles
        where profiles.id = auth.uid()
          and profiles.role = 'admin'
    )
);

-- Somente administradores podem atualizar campanhas
create policy "Admins can update campaigns"
on public.campaigns
for update
to authenticated
using (
    exists (
        select 1
        from public.profiles
        where profiles.id = auth.uid()
          and profiles.role = 'admin'
    )
)
with check (
    exists (
        select 1
        from public.profiles
        where profiles.id = auth.uid()
          and profiles.role = 'admin'
    )
);

-- Somente administradores podem excluir campanhas
create policy "Admins can delete campaigns"
on public.campaigns
for delete
to authenticated
using (
    exists (
        select 1
        from public.profiles
        where profiles.id = auth.uid()
          and profiles.role = 'admin'
    )
);

-- Impedir que usuários comuns alterem seu próprio perfil
-- A função administrativa deverá ser concedida com segurança,
-- usando o SQL Editor do Supabase.
revoke update on public.profiles from authenticated;
