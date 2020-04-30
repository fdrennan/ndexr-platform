CREATE OR REPLACE FUNCTION round_time(TIMESTAMP WITH TIME ZONE)
RETURNS TIMESTAMP WITH TIME ZONE AS $$
  SELECT date_trunc('hour', $1) + INTERVAL '5 min' * ROUND(date_part('minute', $1) / 5.0)
$$ LANGUAGE SQL;


CREATE FUNCTION date_round(base_date timestamptz, round_interval INTERVAL) RETURNS timestamptz AS $BODY$
SELECT TO_TIMESTAMP((EXTRACT(epoch FROM $1)::INTEGER + EXTRACT(epoch FROM $2)::INTEGER / 2)
                / EXTRACT(epoch FROM $2)::INTEGER * EXTRACT(epoch FROM $2)::INTEGER)
$BODY$ LANGUAGE SQL STABLE;