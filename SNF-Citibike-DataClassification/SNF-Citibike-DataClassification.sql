-- ##
-- reference: https://docs.snowflake.com/en/user-guide/governance-classify-using.html#classification-workflow
-- ##

-- set the context
use role dba_citibike;
alter warehouse load_wh set warehouse_size = 'xxlarge' auto_suspend=120 wait_for_completion = true;
use warehouse load_wh;
use schema citibike.demo;

-- this query should take about 10s with 2XL
create or replace table trips_tbl as select * from trips_vw sample(35000 rows);

-- optional validation
-- select count(*) from trips_tbl;


-------#########-------
-- claim admin to create data_engineer role; then apply grants
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
-- this role will need grants so it can be effectively used -- right now this is just an empty role
create or replace role policy_admin;


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
-- once the grants are setup; then use policy_admin
-- use role policy_admin;
-- use role dba_citibike;
-- either additional grants or admin is required to call the function
use role accountadmin;
alter warehouse load_wh set warehouse_size = 'small' auto_suspend=60 wait_for_completion = true;
use warehouse load_wh;


select * from table(citibike.information_schema.tag_references_all_columns('citibike.demo.trips_tbl', 'table'));

    
