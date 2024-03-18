
-- tentativas de implementar um monitor semelhante ao do SQL MANAGEMENT STUDIO
/*
SELECT * FROM sys.dm_os_waiting_tasks
SELECT * FROM sys.dm_exec_requests where status = 'suspended'
select * from sysprocesses where spid > 50 and status not in ('running', 'sleeping')
select * from sysprocesses where spid > 50 and spid = 73
 	
select * from MONITOR_BATCHES_PROTHEUS where ATIVO = 'S' and EXECUTOU_OK like 'I%' and EXECUTANDO_MINUTOS >= 30
*/
declare @sql varchar(8000)
set @sql = 'bcp "'
set @sql +=    'select ''['' + format (CURRENT_TIMESTAMP, ''yyyyMMdd HH:mm:ss'') + '']'''
set @sql +=        ' + ''[database: '' + DB_NAME (database_id) + '']'''
set @sql +=        ' + ''[comando: '' + command + '']'''
set @sql +=        ' + ''[status: '' + status + '']'''
set @sql +=        ' + ''[wait_type: '' + isnull (wait_type, '''') + '']'''
set @sql +=        ' + ''[tempo_decorrido: '' + format (total_elapsed_time, ''G'') + '']'''
set @sql +=        ' + ''[percent_completo: '' + format (percent_complete, ''G'') + '']'''
set @sql +=     ' from sys.dm_exec_requests'
set @sql +=    ' where command = ''RESTORE DATABASE'''
set @sql +=       ' or command = ''DbccFilesCompact'''
set @sql +=       ' or command = ''SELECT INTO'''
set @sql +=       ' or command like ''BACKUP%'''
set @sql +=       ' or command like ''ALTER%'''
set @sql +=       ' or command like ''CREATE%'''
set @sql +=       ' or command like ''INSERT%'''
-- habilitar esta linha so quando quiser ter alguma coisa para logar.  set @sql +=       ' or command like ''LOG WRITER%'''
set @sql += '" queryout "C:\temp\monit_SQL_tmp.log" -T -c'
exec master..xp_cmdshell @sql

--declare @sql varchar(8000)
set @sql = 'type C:\temp\monit_SQL_tmp.log >> C:\temp\monit_SQL_'
set @sql += (select format (CURRENT_TIMESTAMP, 'yyyyMMdd'))
set @sql += '.log'
print @sql
exec master..xp_cmdshell @sql

/*

select @sql = 'bcp "select * from EmailVarification..tblTransaction" queryout c:\bcp\Tom.xls -c -t, -T -S' + @@servername
exec master..xp_cmdshell @sql
*/

--EXEC xp_cmdshell 'bcp "SELECT command FROM sys.dm_exec_requests" queryout "C:\temp\bcptest.txt" -T -c'

/*
https://www.sqlshack.com/sql-server-monitoring-tools-for-disk-i-o-performance/

SELECT *
FROM sys.dm_os_wait_stats dows
ORDER BY dows.wait_time_ms DESC

SELECT *
FROM sys.dm_os_waiting_tasks dowt
WHERE dowt.wait_type LIKE '%IO%'
order by wait_duration_ms desc

SELECT *
FROM sys.dm_io_virtual_file_stats(DB_ID('AdventureWorks2014'), NULL) divfs
ORDER BY divfs.io_stall DESC
*/

