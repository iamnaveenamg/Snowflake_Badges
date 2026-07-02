// Create an Ingestion Table for the NESTED JSON Data
create or replace table library_card_catalog.public.nested_ingest_json 
(
  raw_nested_book VARIANT
);


CREATE FILE FORMAT library_card_catalog.public.book_author_json_ff
    TYPE = 'JSON'
    COMPRESSION = 'AUTO'
    ENABLE_OCTAL = FALSE
    ALLOW_DUPLICATE = FALSE
    STRIP_OUTER_ARRAY = TRUE       -- ✅ Breaks outer [ ... ] into individual book records
    STRIP_NULL_VALUES = FALSE
    IGNORE_UTF8_ERRORS = TRUE;


COPY INTO library_card_catalog.public.nested_ingest_json
FROM @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/NESTED_INGEST_JSON.json
FILE_FORMAT = (FORMAT_NAME = library_card_catalog.public.book_author_json_ff)
ON_ERROR = 'CONTINUE';


-- a few simple queries
select raw_nested_book
from nested_ingest_json;

select raw_nested_book:year_published
from nested_ingest_json;

select raw_nested_book:authors
from nested_ingest_json;



//Use these example flatten commands to explore flattening the nested book and author data
select value:first_name
from library_card_catalog.public.nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);



select value:first_name
from library_card_catalog.public.nested_ingest_json
,table(flatten(raw_nested_book:authors));


//Add a CAST command to the fields returned
SELECT value:first_name::varchar, value:last_name::varchar
from library_card_catalog.public.nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);



//Assign new column  names to the columns using "AS"
select value:first_name::varchar as first_nm
, value:last_name::varchar as last_nm
from library_card_catalog.public.nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);



select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (   
     SELECT 'DWW17' as step 
      ,( select row_count 
        from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES 
        where table_name = 'NESTED_INGEST_JSON') as actual 
      , 5 as expected 
      ,'Check number of rows' as description  
); 


CREATE OR REPLACE DATABASE SOCIAL_MEDIA_FLOODGATES;


create or replace database SOCIAL_MEDIA_FLOODGATES;


USE DATABASE SOCIAL_MEDIA_FLOODGATES;
USE SCHEMA PUBLIC;

CREATE OR REPLACE TABLE public.TWEET_INGEST  (
    RAW_STATUS VARIANT
);


CREATE OR REPLACE FILE FORMAT SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_JSON_FF
    TYPE = 'JSON'
    COMPRESSION = 'AUTO'
    ENABLE_OCTAL = FALSE
    ALLOW_DUPLICATE = FALSE
    STRIP_OUTER_ARRAY = TRUE    -- ✅ Treats each element of the top-level array as a separate row
    STRIP_NULL_VALUES = FALSE
    IGNORE_UTF8_ERRORS = TRUE;

CREATE OR REPLACE FILE FORMAT TWEET_JSON_FF
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;


COPY INTO SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST
FROM @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/nutrition_tweets.json
FILE_FORMAT = (FORMAT_NAME = SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_JSON_FF);
ON_ERROR = 'CONTINUE'
-- purge = true
-- force = true
;


//simple select statements -- are you seeing 9 rows?
select raw_status
from tweet_ingest;

select raw_status:entities
from tweet_ingest;

select raw_status:entities:hashtags
from tweet_ingest;


//Explore looking at specific hashtags by adding bracketed numbers
//This query returns just the first hashtag in each tweet
select raw_status:entities:hashtags[0].text
from tweet_ingest;


//This version adds a WHERE clause to get rid of any tweet that 
//doesn't include any hashtags
select raw_status:entities:hashtags[0].text
from tweet_ingest
where raw_status:entities:hashtags[0].text is not null;


//Perform a simple CAST on the created_at key
//Add an ORDER BY clause to sort by the tweet's creation date
select raw_status:created_at::date
from tweet_ingest
order by raw_status:created_at::date;

//Flatten statements can return nested entities only (and ignore the higher level objects)
select value
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls);


select value
from tweet_ingest
,table(flatten(raw_status:entities:urls));


-- /Flatten and return just the hashtag text, CAST the text as VARCHAR
select value:text::varchar as hashtag_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags);

//Add the Tweet ID and User ID to the returned table so we could join the hashtag back to it's source tweet
select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:text::varchar as hashtag_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags);


select util_db.public.GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
   SELECT 'DWW18' as step
  ,( select row_count 
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.TABLES 
    where table_name = 'TWEET_INGEST') as actual
  , 9 as expected
  ,'Check number of rows' as description  
 ); 

 
--19
 select util_db.public.GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( SELECT 'DWW18' as step ,( select row_count from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.TABLES where table_name = 'TWEET_INGEST') as actual , 9 as expected ,'Check number of rows' as description );



 create or replace view social_media_floodgates.public.urls_normalized as
(select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:display_url::text as url_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls)
);


select * from social_media_floodgates.public.urls_normalized;


CREATE OR REPLACE VIEW SOCIAL_MEDIA_FLOODGATES.PUBLIC.HASHTAGS_NORMALIZED AS
SELECT
 RAW_STATUS:user:screen_name::STRING AS USERNAME,
    RAW_STATUS:id::STRING AS TWEET_ID,
    HASH.value:text::STRING AS HASHTAG
FROM SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST,
     LATERAL FLATTEN(INPUT => RAW_STATUS:entities:hashtags) AS HASH;

SELECT * 
FROM SOCIAL_MEDIA_FLOODGATES.PUBLIC.HASHTAGS_NORMALIZED;



select util_db.public.GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT 'DWW19' as step
  ,( select count(*) 
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.VIEWS 
    where table_name = 'HASHTAGS_NORMALIZED') as actual
  , 1 as expected
  ,'Check number of rows' as description
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



select GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( 
   SELECT 'DWW08' as step 
   ,( select iff(count(*)=0, 0, count(*)/count(*))
      from table(information_schema.query_history())
      where query_text like 'execute NOTEBOOK%Uncle Yer%') as actual 
   , 1 as expected 
   , 'Notebook success!' as description 
); 

select 'execute NOTEBOOK%Uncle Yer%'

select * from table (information_schema.query_history())

select *
      from table(information_schema.query_history())
      where query_text like 'execute NOTEBOOK%Uncle Yer%'
