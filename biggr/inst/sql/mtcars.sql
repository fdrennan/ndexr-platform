CREATE TABLE mtcars
(
  vehicle varchar,
  mpg double precision,
  cyl double precision,
  disp double precision,
  hp double precision,
  drat double precision,
  wt double precision,
  qsec double precision,
  vs double precision,
  am double precision,
  gear double precision,
  carb double precision
);

COPY mtcars FROM '/mtcars.csv'  WITH (FORMAT csv);

