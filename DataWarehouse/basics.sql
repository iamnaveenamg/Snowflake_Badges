select 'Naveen' as Names
union all
select 'Hello Naveen';

SELECT 'HELLO';

SELECT 'Hello' as Greeting;

SHOW DATABASES;

SHOW SCHEMAS;


--Class 4
create or replace table ROOT_DEPTH (
   ROOT_DEPTH_ID number(1), 
   ROOT_DEPTH_CODE text(1), 
   ROOT_DEPTH_NAME text(7), 
   UNIT_OF_MEASURE text(2),
   RANGE_MIN number(2),
   RANGE_MAX number(2)
   ); 


   insert into root_depth 
values
(
    1,
    'S',
    'Shallow',
    'cm',
    30,
    45
);

SELECT * FROM root_depth;


SELECT *
FROM ROOT_DEPTH 
LIMIT 1;

--To add more than one row at a time
insert into GARDEN_PLANTS.VEGGIES.root_depth (root_depth_id, root_depth_code, root_depth_name, unit_of_measure, range_min, range_max)  values
(5,'X','short','in',66,77)
,(8,'Y','tall','cm',98,99);

-- To remove a row you do not want in the table
delete from root_depth
where root_depth_id = 9;

--To change a value in a column for one particular row
update root_depth
set root_depth_id = 7
where root_depth_id = 9;

--To remove all the rows and start over
truncate table root_depth;

SELECT * FROM GARDEN_PLANTS.VEGGIES.ROOT_DEPTH;


---- Dora 20

