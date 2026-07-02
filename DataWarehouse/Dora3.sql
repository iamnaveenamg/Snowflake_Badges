create or replace table garden_plants.veggies.VEGETABLE_DETAILS_PLANT_HEIGHT (
plant_name varchar(50),	
UOM varchar(10),
Low_End_of_Range int,
High_End_of_Range int

 );

 SELECT * FROM garden_plants.veggies.VEGETABLE_DETAILS_PLANT_HEIGHT;


 create file format garden_plants.veggies.PIPECOLSEP_ONEHEADROW 
    type = 'CSV'--csv is used for any flat file (tsv, pipe-separated, etc)
    field_delimiter = '|' --pipes as column separators
    skip_header = 1 --one header row to skip
    ;

    create file format garden_plants.veggies.VEGETABLE_DETAILS_PLANT_HEIGHT_FF 
    type = 'CSV'--csv is used for any flat file (tsv, pipe-separated, etc)
    field_delimiter = ',' --pipes as column separators
    skip_header = 1 --one header row to skip
    ;

CREATE OR REPLACE FILE FORMAT garden_plants.veggies.VEGETABLE_DETAILS_PLANT_HEIGHT_FF 
    TYPE = 'CSV'                  -- CSV for comma-separated data
    FIELD_DELIMITER = ','         -- Comma as column separator
    SKIP_HEADER = 1               -- Skip the first header line
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'  -- To handle values with commas or parentheses safely
    NULL_IF = ('', 'NULL')        -- Treat empty strings or 'NULL' as NULLs
    EMPTY_FIELD_AS_NULL = TRUE;   -- Optional, for better NULL handling


copy into garden_plants.veggies.VEGETABLE_DETAILS_PLANT_HEIGHT
from @util_db.public.my_internal_stage
files = ('veg_plant_height.csv')
file_format = (format_name=GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_PLANT_HEIGHT_FF);




--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
      SELECT 'DWW12' as step 
      ,( select row_count 
        from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
        where table_name = 'VEGETABLE_DETAILS_PLANT_HEIGHT') as actual 
      , 41 as expected 
      , 'Veg Detail Plant Height Count' as description   
); 


--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
     SELECT 'DWW13' as step 
     ,( select row_count 
       from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
       where table_name = 'LU_SOIL_TYPE') as actual 
     , 8 as expected 
     ,'Soil Type Look Up Table' as description   
); 

-- Set your worksheet drop lists
-- DO NOT EDIT THE CODE 
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( 
     SELECT 'DWW14' as step 
     ,( select count(*) 
       from GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS 
       where FILE_FORMAT_NAME='L9_CHALLENGE_FF' 
       and FIELD_DELIMITER = '\t') as actual 
     , 1 as expected 
     ,'Challenge File Format Created' as description  
); 


use role sysadmin;


// Create a new database and set the context to use the new database
create database library_card_catalog comment = 'DWW Lesson 10 ';

//Set the worksheet context to use the new database
use database library_card_catalog;


use database library_card_catalog;
use role sysadmin;

// Create the book table and use AUTOINCREMENT to generate a UID for each new row

create or replace table book
( book_uid number autoincrement
 , title varchar(50)
 , year_published number(4,0)
);


// Insert records into the book table
// You don't have to list anything for the
// BOOK_UID field because the AUTOINCREMENT property 
// will take care of it for you

insert into book(title, year_published)
values
 ('Food',2001)
,('Food',2006)
,('Food',2008)
,('Food',2016)
,('Food',2015);

select * from book;


-- / Create Author table
create or replace table author (
   author_uid number 
  ,first_name varchar(50)
  ,middle_name varchar(50)
  ,last_name varchar(50)
);

// Insert the first two authors into the Author table
insert into author(author_uid, first_name, middle_name, last_name)  
values
(1, 'Fiona', '','Macdonald')
,(2, 'Gian','Paulo','Faleschini');

// Look at your table with it's new rows
select * 
from author;


use role sysadmin;

create or replace sequence LIBRARY_CARD_CATALOG.PUBLIC.SEQ_AUTHOR_UID 
start with 1 increment by 1 order;

//See how the nextval function works
select seq_author_uid.nextval;

select seq_author_uid.nextval,seq_author_uid.nextval;

SHOW SEQUENCES;


use role sysadmin;

//Drop and recreate the counter (sequence) so that it starts at 3 
// then we'll add the other author records to our author table
create or replace sequence library_card_catalog.public.seq_author_uid
start = 3 
increment = 1 
ORDER
comment = 'Use this to fill in the AUTHOR_UID every time you add a row';


//Add the remaining author records and use the nextval function instead 
//of putting in the numbers
insert into author(author_uid,first_name, middle_name, last_name) 
values
(seq_author_uid.nextval, 'Laura', 'K','Egendorf')
,(seq_author_uid.nextval, 'Jan', '','Grover')
,(seq_author_uid.nextval, 'Jennifer', '','Clapp')
,(seq_author_uid.nextval, 'Kathleen', '','Petelinsek');


--15
use database library_card_catalog;
use role sysadmin;


// Create the relationships table
// this is sometimes called a "Many-to-Many table"
create table book_to_author
( book_uid number
  ,author_uid number
);


//Insert rows of the known relationships
insert into book_to_author(book_uid, author_uid)
values
 (1,1)  // This row links the 2001 book to Fiona Macdonald
,(1,2)  // This row links the 2001 book to Gian Paulo Faleschini
,(2,3)  // Links 2006 book to Laura K Egendorf
,(3,4)  // Links 2008 book to Jan Grover
,(4,5)  // Links 2016 book to Jennifer Clapp
,(5,6); // Links 2015 book to Kathleen Petelinsek


//Check your work by joining the 3 tables together
//You should get 1 row for every author
select * 
from book_to_author ba 
join author a 
on ba.author_uid = a.author_uid 
join book b 
on b.book_uid=ba.book_uid; 



select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
     SELECT 'DWW15' as step 
     ,( select count(*) 
      from LIBRARY_CARD_CATALOG.PUBLIC.Book_to_Author ba 
      join LIBRARY_CARD_CATALOG.PUBLIC.author a 
      on ba.author_uid = a.author_uid 
      join LIBRARY_CARD_CATALOG.PUBLIC.book b 
      on b.book_uid=ba.book_uid) as actual 
     , 6 as expected 
     , '3NF DB was Created.' as description  
); 


// JSON DDL Scripts
use database library_card_catalog;
use role sysadmin;

// Create an Ingestion Table for JSON Data
create table library_card_catalog.public.author_ingest_json
(
  raw_author variant
);

//Create File Format for JSON Data 
CREATE FILE FORMAT library_card_catalog.public.json_file_format
    TYPE = 'JSON' 
    COMPRESSION = 'AUTO' 
    ENABLE_OCTAL = FALSE              -- Usually set to FALSE unless your JSON uses octal literals
    ALLOW_DUPLICATE = FALSE           -- Rejects duplicate field names within JSON objects
    STRIP_OUTER_ARRAY = TRUE          -- Removes the top-level [ ... ] array and flattens each element as a separate record
    STRIP_NULL_VALUES = FALSE         -- Keeps null fields in the JSON instead of removing them
    IGNORE_UTF8_ERRORS = TRUE;        -- Ignores invalid UTF-8 characters instead of failing the loa

COPY INTO library_card_catalog.public.author_ingest_json
FROM @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/author_with_header.json
FILE_FORMAT = (FORMAT_NAME = library_card_catalog.public.json_file_format)
ON_ERROR = 'CONTINUE';


SELECT * FROM library_card_catalog.public.author_ingest_json;


//returns AUTHOR_UID value from top-level object's attribute
select raw_author:AUTHOR_UID
from library_card_catalog.public.author_ingest_json;

//returns the data in a way that makes it look like a normalized table
SELECT 
 raw_author:AUTHOR_UID
,raw_author:FIRST_NAME::STRING as FIRST_NAME
,raw_author:MIDDLE_NAME::STRING as MIDDLE_NAME
,raw_author:LAST_NAME::STRING as LAST_NAME
FROM library_card_catalog.public.author_ingest_json;


select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT 'DWW16' as step
  ,( select row_count 
    from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES 
    where table_name = 'AUTHOR_INGEST_JSON') as actual
  ,6 as expected
  ,'Check number of rows' as description
 ); 


