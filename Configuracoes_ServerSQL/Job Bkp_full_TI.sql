USE [msdb]
GO

/****** Object:  Job [Bkp_full_TI]    Script Date: 17/03/2022 11:39:22 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Data Collector]    Script Date: 17/03/2022 11:39:22 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Data Collector' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Data Collector'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Bkp_full_TI', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'Data Collector', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Bkp_full_TI]    Script Date: 17/03/2022 11:39:23 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Bkp_full_TI', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE [master]
GO

declare @nome_banco varchar (max) set @nome_banco = ''TI'';
declare @data_formato varchar (max) set @data_formato =(select format (CURRENT_TIMESTAMP, ''HH-mm dd-MM-yyyy''));

/****** Se for Mandar pro DELL-T440-02 192.168.1.104 ******/
declare @destino varchar (max) set @destino = ''\\192.168.1.104\bkp-SQL\TI\''; 
exec xp_cmdshell ''net use N: /delete''
exec xp_cmdshell ''net use N: \\192.168.1.104\bkp-sql /user:bkp.srvsql T4p3Cor3!''
declare @name_file varchar (max) set @name_file = @destino+@nome_banco+''_Full ''+@data_formato ;

/******   Se for mandar pro NAS 192.168.1.9 ******/
--declare @destino varchar (max) set @destino = ''\\192.168.1.9\bkp-SQL\''; 
--exec xp_cmdshell ''net use k: /delete''
--exec xp_cmdshell ''net use k: \\192.168.1.9\bkp-sql /user:admin Alianca164''
--declare @name_file varchar (max) set @name_file = @destino+@nome_banco+''_Full ''+@data_formato ;

declare @sql varchar (max);
set @sql = ''BACKUP DATABASE '' +@nome_banco+ '' TO DISK = '''''' + @name_file + ''.bak''''''  + '' WITH COMPRESSION, INIT''
print @sql
exec (@sql);
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Bkp_full_TI', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190905, 
		@active_end_date=99991231, 
		@active_start_time=50000, 
		@active_end_time=235959, 
		@schedule_uid=N'8ca3a634-2add-40b5-b550-86429fae46ea'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


