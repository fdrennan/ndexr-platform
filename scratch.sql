select *
from postgres.public.submission_summary
where over_18::numeric/n_submissions::numeric >= .9 and
      n_submissions > 100
order by random()
limit 10