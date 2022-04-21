-- ########
-- creates an unpriviledged role and a user
-- creates database objects
-- requires a grant to create databases
-- Setup for data sharing on Jerelle's US East 1 SNF account
-- ########

-- use admin and create account objects
use role accountadmin;

create role if not exists andyb_demo comment = "Andy B's demo role for data sharing";
grant role andyb_demo to user andyb;

create or replace warehouse andyb_demo_wh
  with warehouse_size = 'xsmall'
  auto_suspend = 60
  auto_resume = true
  initially_suspended = true;


-- the following grant could be changed to grant usage
grant all on warehouse andyb_demo_wh to role andyb_demo;


-- the following grant is required to create a DB from a share
grant create database on account to role andyb_demo;
