create or replace view sith_persons as
  select
    id,
    prename || ' ' || surname as name,
    alive
    from sith_characters_t;