with prd as (
SELECT OBJECT_NAME(sm.object_id, DB_ID('MercanetPRD')) as PRD_object_name
        , sm.definition as PRD_definition
FROM MercanetPRD.sys.sql_modules AS sm
   , MercanetPRD.sys.objects AS o
	where o.type_desc = 'SQL_STORED_PROCEDURE'
      and sm.object_id = o.object_id
)
, hml as (
SELECT OBJECT_NAME(sm.object_id, DB_ID('MercanetHML')) as HML_object_name
        , sm.definition as HML_definition
FROM MercanetHML.sys.sql_modules AS sm
   , MercanetHML.sys.objects AS o
	where o.type_desc = 'SQL_STORED_PROCEDURE'
      and sm.object_id = o.object_id
), junto as (
select *
from prd
full outer join hml on (prd.PRD_object_name = hml.HML_object_name)
)
select *
from junto
where HML_definition != PRD_definition
order by PRD_object_name


-- https://stackoverflow.com/questions/21722066/how-to-create-an-alias-of-database-in-sql-server#comment101880584_27533388
-- https://www.baud.cz/blog/database-alias-in-microsoft-sql-server
