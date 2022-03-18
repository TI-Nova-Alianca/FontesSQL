USE [msdb]
GO

/****** Object:  Job [Bkp_log_MercanetPRD]    Script Date: 17/03/2022 11:39:09 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 17/03/2022 11:39:09 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Bkp_log_MercanetPRD', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'VINHOS-ALIANCA\Administrador', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Bkp_log_MercanetPRD]    Script Date: 17/03/2022 11:39:09 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Bkp_log_MercanetPRD', 
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

declare @nome_banco varchar (50) set @nome_banco = ''MercanetPRD'';
declare @data_formato varchar (max) set @data_formato =(select format (CURRENT_TIMESTAMP, ''dd-MM-yyyy HH-mm''));

/****** Se for Mandar pro DELL-T440-02 192.168.1.104 ******/
declare @destino varchar (max) set @destino = ''\\192.168.1.104\bkp-SQL\MercanetPRD\''; 
exec xp_cmdshell ''net use N: /delete''
exec xp_cmdshell ''net use N: \\192.168.1.104\bkp-sql /user:bkp.srvsql T4p3Cor3!''

/******   Se for mandar pro NAS 192.168.1.9 ******/
--declare @destino varchar (max) set @destino = ''\\192.168.1.9\bkp-SQL\''; 
--exec xp_cmdshell ''net use k: /delete''
--exec xp_cmdshell ''net use k: \\192.168.1.9\bkp-sql /user:admin Alianca164''

--declare @name_file varchar (max) set @name_file = @nome_banco+''_Log ''+@data_formato ;

DECLARE @Extensao varchar (max) set @Extensao = N''trn''; ;
DECLARE @sql NVARCHAR(4000);
DECLARE @servidor varchar (50) set @servidor = ''serverSQL'';;
DECLARE @processo varchar (50) set @processo = ''backup_log'';

set @sql = '''';
set @sql = @sql + '' BACKUP LOG ''+@nome_banco;
set @sql = @sql + '' TO DISK = '''''' + @destino + @nome_banco + ''_Log '' + @data_formato + ''.'' + @Extensao + '''''''';
set @sql = @sql + '' WITH STATS = 10'';
print @sql;
exec (@sql);
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Diario a Cada 1Hr as 01:00', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130528, 
		@active_end_date=99991231, 
		@active_start_time=12500, 
		@active_end_time=235959, 
		@schedule_uid=N'4ccc7313-4dcd-45bd-8719-2a0f43e3bdaf'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


