select author, count(*) as n_obs
from (
    select *
    from public.comments
    where body ilike '%riot%'
    ) x
group by author
order by n_obs desc
limit 100

select count(*)
from public.comments