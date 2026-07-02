create table garden_plants.veggies.vegetable_details
(
plant_name varchar(25)
, root_depth_code varchar(1)    
);


select * from vegetable_details;


--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW06' as step
 ,( select count(*) 
   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
   where table_name = 'VEGETABLE_DETAILS') as actual
 , 1 as expected
 ,'VEGETABLE_DETAILS Table' as description
); 


select * from garden_plants.veggies.vegetable_details;
select * from garden_plants.veggies.vegetable_details
WHERE PLANT_NAME='Spinach' AND ROOT_DEPTH_CODE = 'D';

DELETE FROM garden_plants.veggies.vegetable_details
WHERE PLANT_NAME='Spinach' AND ROOT_DEPTH_CODE = 'D';


--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW07' as step
 ,( select row_count 
   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
   where table_name = 'VEGETABLE_DETAILS') as actual
 , 41 as expected
 , 'VEG_DETAILS row count' as description
); 



create or replace TABLE FLOWER_DETAILS (
	PLANT_NAME VARCHAR(25),
	ROOT_DEPTH_CODE VARCHAR(1)
);

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. 
-- THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN

SHOW NOTEBOOKS IN ACCOUNT;
CREATE OR REPLACE TEMPORARY TABLE temp_notebooks AS
  SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
   SELECT 'DWW08' as step
   ,(select iff(count(*)=0, 0, count(*)/count(*))
     from temp_notebooks
     where "name" ilike '%Uncle Yer%') as actual
   , 1 as expected
   , 'Notebook success!' as description
);


create or replace TABLE FRUIT_DETAILS (
	PLANT_NAME VARCHAR(25),
	ROOT_DEPTH_CODE VARCHAR(1)
);


--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW09' as step
 ,( select iff(count(*)=0, 0, count(*)/count(*)) 
    from snowflake.account_usage.query_history
    where query_text like 'execute streamlit "GARDEN_PLANTS"."FRUITS".%'
   ) as actual
 , 1 as expected
 ,'SiS App Works' as description
); 

TRUNCATE TABLE GARDEN_PLANTS.FRUITS.FRUIT_DETAILS;
insert into garden_plants.fruits.fruit_details select 'Apricot','S';

SHOW TABLES LIKE 'FRUIT_DETAILS' IN SCHEMA GARDEN_PLANTS.FRUITS;



--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW10' as step
  ,( 
    select count(*) 
    from UTIL_DB.INFORMATION_SCHEMA.stages
    where stage_name='MY_INTERNAL_STAGE'
    AND stage_type IS NULL
    ) as actual
  , 1 as expected
  , 'Internal stage created' as description
 ); 

 copy into my_table_name
from @my_internal_stage
files = ( 'IF_I_HAD_A_FILE_LIKE_THIS.txt')
file_format = ( format_name='EXAMPLE_FILEFORMAT' );


create or replace table GARDEN_PLANTS.VEGGIES.vegetable_details_soil_type
( plant_name varchar(25)
 ,soil_type number(1,0)
);

create file format garden_plants.veggies.PIPECOLSEP_ONEHEADROW 
    type = 'CSV'--csv is used for any flat file (tsv, pipe-separated, etc)
    field_delimiter = '|' --pipes as column separators
    skip_header = 1 --one header row to skip
    ;

copy into garden_plants.veggies.vegetable_details_soil_type
from @util_db.public.my_internal_stage
files = ( 'VEG_NAME_TO_SOIL_TYPE_PIPE.txt')
file_format = ( format_name=GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW);


--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
  SELECT 'DWW11' as step
  ,( select row_count 
    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
    where table_name = 'VEGETABLE_DETAILS_SOIL_TYPE') as actual
  , 42 as expected
  , 'Veg Det Soil Type Count' as description
 ); 


 create file format garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW 
    TYPE = 'CSV'--csv for comma separated files
    FIELD_DELIMITER = ',' --commas as column separators
    SKIP_HEADER = 1 --one header row  
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
--this means that some values will be wrapped in double-quotes bc they have commas in them
    ;


--The data in the file, with no FILE FORMAT specified
select $1
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv;

--Same file but with one of the file formats we created earlier  
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW);

--Same file but with the other file format we created earlier
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.PIPECOLSEP_ONEHEADROW );


 create file format garden_plants.veggies.L9_CHALLENGE_FF 
    TYPE = 'CSV'--csv for comma separated files
    FIELD_DELIMITER = '\t' --commas as column separators
    SKIP_HEADER = 1 --one header row  
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' --this means that some values will be wrapped in double-quotes bc they have commas in them
    ;

select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.L9_CHALLENGE_FF );

create or replace table LU_SOIL_TYPE(
SOIL_TYPE_ID number,	
SOIL_TYPE varchar(15),
SOIL_DESCRIPTION varchar(75)
);

copy into garden_plants.veggies.LU_SOIL_TYPE
from @util_db.public.my_internal_stage
files = ('LU_SOIL_TYPE.tsv')
file_format = (format_name=GARDEN_PLANTS.VEGGIES.L9_CHALLENGE_FF);

