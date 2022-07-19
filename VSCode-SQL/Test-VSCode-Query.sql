-- test sql file using the SNF_abouts_sfc connection in VS Code

--use role public;
-- use warehouse andyb_demo_wh;

select * from A_TEST_DB.A_TEST_SCHEMA.TEST_DATA 
    where date >= '2017-01-01'
    limit 15;
