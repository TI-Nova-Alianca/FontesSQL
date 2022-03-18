USE [msdb]
GO

/****** Object:  Job [Integr_Mercanet_15_min]    Script Date: 17/03/2022 11:38:48 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 17/03/2022 11:38:48 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Integr_Mercanet_15_min', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Le Clientes (20)]    Script Date: 17/03/2022 11:38:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Le Clientes (20)', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 20', 
		@database_name=N'MercanetPRD', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Le Produtos (40)]    Script Date: 17/03/2022 11:38:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Le Produtos (40)', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 40', 
		@database_name=N'MercanetPRD', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Le Pedidos (30)]    Script Date: 17/03/2022 11:38:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Le Pedidos (30)', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 30', 
		@database_name=N'MercanetPRD', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Le NF saida (37)]    Script Date: 17/03/2022 11:38:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Le NF saida (37)', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 37', 
		@database_name=N'MercanetPRD', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Le dados (diversos)]    Script Date: 17/03/2022 11:38:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Le dados (diversos)', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- Notas de devolucao
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 35

-- produtos
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 40

-- listas de precos
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 41

-- titulos a receber
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 50

-- linhas de produtos
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8004

-- Representantes
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8005

-- TES
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8007

-- condicoes de pagamento
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8012

-- estados (UF)
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8017

-- transportadoras
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8020

-- tipos de produtos
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8100

-- marcas comerciais
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8101

-- cidades
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8103

-- paises
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8104

-- ramos de atividade I
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8105

-- ramos de ativdade II
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8106

-- Bancos
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8107

-- Baixas de titulos
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8108

-- Promotores
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8111

-- grupos de produtos
EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 8112

', 
		@database_name=N'MercanetPRD', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Envia pedidos]    Script Date: 17/03/2022 11:38:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Envia pedidos', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE [dbo].[MERCP_CONCORRENTE_EXPORT_PEDIDOS]', 
		@database_name=N'MercanetPRD', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Envia clientes]    Script Date: 17/03/2022 11:38:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Envia clientes', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE [dbo].[MERCP_CONCORRENTE_EXPORT_CLIENTE]', 
		@database_name=N'MercanetPRD', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Le listas de precos (41)]    Script Date: 17/03/2022 11:38:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Le listas de precos (41)', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE [dbo].[MERCP_CONCORRENTE_INTEGRACOES] 41', 
		@database_name=N'MercanetPRD', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Integr_Mercanet_15_min', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=15, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180727, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'37796c63-82fe-48af-9570-423cb55690eb'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


