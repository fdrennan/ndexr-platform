
create view roze_score as (
    with score_table as (
            select count(*) as cnt, 'true' as label
            from roze
            where detected_roze = 'true'
            union
            select count(*) as cnt, 'false' as label
            from roze
            where detected_roze = 'false'
            union
            select count(*) as cnt, 'null' as label
            from roze
            where detected_roze is null
            union
            select count(*) as cnt, 'total' as label
            from roze
    )

    select *
    from score_table
    order by cnt desc
);


select *
from roze
where detected_roze is null