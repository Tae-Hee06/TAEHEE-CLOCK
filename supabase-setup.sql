-- TIMESHOT: Supabase SQL Editor에 통째로 붙여넣고 Run 하세요.

create table if not exists public.shots (
  id    text primary key,   -- 날짜_시간_사람
  uid   text not null,
  day   text not null,      -- 2026-11-26
  hour  int  not null,
  at    bigint not null,    -- 올린 시각 (ms)
  memo  text default '',
  thumb text,               -- 작은 사진 (동그라미용)
  img   text                -- 큰 사진
);

create index if not exists shots_day_at on public.shots (day, at);

alter table public.shots enable row level security;

-- 누구나 보기 / 올리기 / 같은 시간에 다시 올리면 덮어쓰기
drop policy if exists "read"   on public.shots;
drop policy if exists "insert" on public.shots;
drop policy if exists "update" on public.shots;
create policy "read"   on public.shots for select to anon using (true);
create policy "insert" on public.shots for insert to anon with check (length(coalesce(img, '')) < 400000);
create policy "update" on public.shots for update to anon using (true) with check (length(coalesce(img, '')) < 400000);
