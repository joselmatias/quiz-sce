-- Quiz interactivo SCE - Supabase setup
-- Ejecutar una vez desde el SQL editor del proyecto Supabase.

create extension if not exists "pgcrypto";

create table if not exists public.game_state (
  id           text primary key default 'sala1',
  activo       boolean default false,
  pregunta_idx integer default 0,
  revelada     boolean default false,
  updated_at   timestamptz default now()
);

create table if not exists public.respuestas (
  id           uuid primary key default gen_random_uuid(),
  sala         text default 'sala1',
  jugador      text not null,
  pregunta_idx integer not null,
  opcion       integer not null,
  correcta     boolean,
  tiempo_ms    integer,
  created_at   timestamptz default now()
);

create index if not exists idx_respuestas_sala_pregunta
  on public.respuestas(sala, pregunta_idx);

create unique index if not exists idx_respuestas_unicas_por_jugador
  on public.respuestas(sala, jugador, pregunta_idx);

alter table public.game_state disable row level security;
alter table public.respuestas disable row level security;

grant select, insert, update, delete on public.game_state to anon, authenticated;
grant select, insert, update, delete on public.respuestas to anon, authenticated;

alter table public.game_state replica identity full;
alter table public.respuestas replica identity full;

insert into public.game_state (id, activo, pregunta_idx, revelada)
values ('sala1', false, 0, false)
on conflict (id) do nothing;

do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    if not exists (
      select 1
      from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = 'game_state'
    ) then
      execute 'alter publication supabase_realtime add table public.game_state';
    end if;

    if not exists (
      select 1
      from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = 'respuestas'
    ) then
      execute 'alter publication supabase_realtime add table public.respuestas';
    end if;
  end if;
end
$$;
