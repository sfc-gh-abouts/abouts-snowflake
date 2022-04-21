-- set the context
use role dba_citibike;
use warehouse load_wh;
use schema citibike.demo;

create or replace table trips_tbl as select * from trips_vw sample(2500 rows);

-- optional
-- select count(*) from trips_tbl;

-------#########-------
-- update the context; then update RBAC
use role accountadmin;
use warehouse load_wh;


-------#########-------
--create data_engineer role and apply grants
create or replace role data_engineer;
grant imported privileges on database snowflake to role data_engineer;
grant usage on database citibike to role data_engineer;
grant usage on schema citibike.demo to role data_engineer;
grant select, update on table citibike.demo.trips_tbl to role data_engineer;
grant apply tag on account to role data_engineer;
grant all on warehouse load_wh to role data_engineer;
grant role data_engineer to user JOHN;


-------#########-------
-- create policy_admin role
create or replace role policy_admin;


-------#########-------
-- update the context; then run stored procs
use role data_engineer;
use warehouse load_wh;
alter warehouse if exists load_wh set warehouse_size = 'xxlarge' auto_suspend=120;

select extract_semantic_categories('citibike.demo.trips_tbl');

call associate_semantic_category_tags('citibike.demo.trips_tbl',
                                      extract_semantic_categories('citibike.demo.trips_tbl'));


alter warehouse if exists load_wh set warehouse_size = 'medium' auto_suspend=120;

-- https://docs.snowflake.com/en/user-guide/governance-classify-using.html#classification-workflow                         
-- stopped at policy admin for now
