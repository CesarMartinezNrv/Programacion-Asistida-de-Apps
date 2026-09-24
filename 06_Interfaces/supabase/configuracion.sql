create table if not exists perfiles (
  id uuid primary key references auth.users (id) on delete cascade,
  nombre text not null,
  creado_en timestamptz default now()
);

alter table perfiles enable row level security;

create policy "cualquiera autenticado ve los perfiles"
on perfiles for select
to authenticated
using (true);

create policy "cada quien crea solo su perfil"
on perfiles for insert
to authenticated
with check (auth.uid() = id);
