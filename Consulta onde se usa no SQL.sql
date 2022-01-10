
-- Pesquisa por determinado nome de objeto no banco de dados
declare @nome varchar (max) = 'OPENQUERY'

-- Define em qual banco de dados deve ser feita a pesquisa
use protheus

SELECT rtrim (OBJECT_NAME(sm.object_id)) AS object_name, rtrim (o.type_desc)
	 FROM sys.sql_modules AS sm
	     JOIN sys.objects AS o ON sm.object_id = o.object_id
	where upper (sm.definition) like upper ('%' + @nome + '%') collate SQL_Latin1_General_CP1_CI_AS


select *
from sys.objects
where upper (name) like upper ('%' + @nome + '%') collate SQL_Latin1_General_CP1_CI_AS

