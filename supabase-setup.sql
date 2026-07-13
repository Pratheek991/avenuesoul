-- Avenue Seoul: run this once in Supabase Dashboard → SQL Editor.
-- After you sign up with your real email, replace YOUR_ADMIN_EMAIL below and run
-- the final UPDATE statement to promote that account to admin.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  role text not null default 'customer' check (role in ('customer', 'admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  slug text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null,
  price integer not null check (price >= 0),
  stock integer not null default 0 check (stock >= 0),
  image_url text,
  description text,
  rating numeric(2,1) default 5.0,
  badge text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email)
  values (new.id, coalesce(new.email, ''));
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users for each row execute procedure public.handle_new_user();

-- Also create profiles for any users who signed up before this script was run.
insert into public.profiles (id, email)
select id, coalesce(email, '') from auth.users
on conflict (id) do nothing;

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;

alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;

drop policy if exists "users read own profile" on public.profiles;
create policy "users read own profile" on public.profiles for select to authenticated using ((select auth.uid()) = id);
drop policy if exists "admins manage profiles" on public.profiles;
create policy "admins manage profiles" on public.profiles for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "public reads categories" on public.categories;
create policy "public reads categories" on public.categories for select using (true);
drop policy if exists "admins manage categories" on public.categories;
create policy "admins manage categories" on public.categories for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "public reads products" on public.products;
create policy "public reads products" on public.products for select using (true);
drop policy if exists "admins manage products" on public.products;
create policy "admins manage products" on public.products for all to authenticated using (public.is_admin()) with check (public.is_admin());

insert into public.categories (name, slug) values
  ('Women', 'women'), ('Men', 'men'), ('Kids', 'kids'),
  ('Accessories', 'accessories'), ('Footwear', 'footwear'), ('Bags', 'bags')
on conflict (slug) do nothing;

-- Run this AFTER creating an account in the storefront. Replace the value first.
-- update public.profiles set role = 'admin' where email = 'YOUR_ADMIN_EMAIL';
