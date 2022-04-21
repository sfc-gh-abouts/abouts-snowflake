-- ##
-- reference: https://docs.snowflake.com/en/user-guide/governance-classify-using.html#classification-workflow
-- ##

-- set the context
use role dba_citibike;
alter warehouse load_wh set warehouse_size = 'xxlarge' auto_suspend=120 wait_for_completion = true;
use warehouse load_wh;
use schema citibike.demo;

-- this query should take about 15s with 2XL
create or replace table trips_tbl as select * from trips_vw sample(25000 rows);

-- optional
-- select count(*) from trips_tbl;


-------#########-------
-- admin creates data_engineer role and applies grant
use role accountadmin;
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
-- this needs grants so it can be effectively used -- right now this is just an empty role

-------#########-------
-- update the context; then run stored procs
use role data_engineer;
use warehouse load_wh;


-- step 1 call the extract_semantic_categories function to generate the JSON output
-- this query should take about 30s with 2XL
select extract_semantic_categories('citibike.demo.trips_tbl');

-- step 2 call the associate_semantic_category_tags S-P apply JSON output to the table
-- this query should take about 30s with 2XL
call associate_semantic_category_tags('citibike.demo.trips_tbl',
                                      extract_semantic_categories('citibike.demo.trips_tbl'));


-- step 3 retrieve the tags
-- use role policy_admin;
-- this query should take about 15s with medium
use role accountadmin;
alter warehouse load_wh set warehouse_size = 'medium' auto_suspend=60 wait_for_completion = true;

select * from snowflake.account_usage.tag_references
    where tag_name = 'PRIVACY_CATEGORY'
    and tag_value IN ('IDENTIFIER', 'QUASI_IDENTIFIER');
    
