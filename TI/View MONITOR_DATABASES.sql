SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View auxiliar para monitoramento de tamanhos dos arquivos dos bancos de dados.
-- Autor: Robert Koch
-- Data:  12/08/2021
-- Historico de alteracoes:
-- 04/08/2022 - Robert - Acrescentado database protheus_R33
--

ALTER view [dbo].[MONITOR_DATABASES]
AS

-- max_size eh guardado em qt.de paginas de 8Kb
with c as(SELECT 'protheus'     AS nome_database, (SELECT size * 8 FROM protheus.sys.database_files        WHERE type = 0) AS Tamanho_atual_arq_dados_em_Kb, (select recovery_model_desc from sys.databases                 where name = 'protheus')     as recovery_model_desc, df.max_size * 8 AS Tamanho_max_arq_log_em_Kb, total_log_size_in_bytes / 1024 AS Tamanho_atual_arq_log_em_Kb, (total_log_size_in_bytes / 1024 * 100) / (max_size * 8 * 1.0) * (dm_lsu.used_log_space_in_percent / 100) AS Percent_uso_log_em_relacao_ao_tam_max, dm_lsu.used_log_space_in_percent, (select count (*) from protheus.sys.tables)        AS Quant_tabelas FROM protheus.sys.dm_db_log_space_usage        dm_lsu, protheus.sys.database_files        df where df.type = 1  -- type 1 = arquivo de log
union all SELECT 'protheus_R33' AS nome_database, (SELECT size * 8 FROM naweb.sys.database_files           WHERE type = 0) AS Tamanho_atual_arq_dados_em_Kb, (select recovery_model_desc from sys.databases                 where name = 'protheus_R33') as recovery_model_desc, df.max_size * 8 AS Tamanho_max_arq_log_em_Kb, total_log_size_in_bytes / 1024 AS Tamanho_atual_arq_log_em_Kb, (total_log_size_in_bytes / 1024 * 100) / (max_size * 8 * 1.0) * (dm_lsu.used_log_space_in_percent / 100) AS Percent_uso_log_em_relacao_ao_tam_max, dm_lsu.used_log_space_in_percent, (select count (*) from naweb.sys.tables)           AS Quant_tabelas FROM naweb.sys.dm_db_log_space_usage           dm_lsu, naweb.sys.database_files           df where df.type = 1  -- type 1 = arquivo de log
union all SELECT 'naweb'        AS nome_database, (SELECT size * 8 FROM naweb.sys.database_files           WHERE type = 0) AS Tamanho_atual_arq_dados_em_Kb, (select recovery_model_desc from sys.databases                 where name = 'naweb')        as recovery_model_desc, df.max_size * 8 AS Tamanho_max_arq_log_em_Kb, total_log_size_in_bytes / 1024 AS Tamanho_atual_arq_log_em_Kb, (total_log_size_in_bytes / 1024 * 100) / (max_size * 8 * 1.0) * (dm_lsu.used_log_space_in_percent / 100) AS Percent_uso_log_em_relacao_ao_tam_max, dm_lsu.used_log_space_in_percent, (select count (*) from naweb.sys.tables)           AS Quant_tabelas FROM naweb.sys.dm_db_log_space_usage           dm_lsu, naweb.sys.database_files           df where df.type = 1  -- type 1 = arquivo de log
union all SELECT 'BI_ALIANCA'   AS nome_database, (SELECT size * 8 FROM BI_ALIANCA.sys.database_files      WHERE type = 0) AS Tamanho_atual_arq_dados_em_Kb, (select recovery_model_desc from sys.databases                 where name = 'BI_ALIANCA')   as recovery_model_desc, df.max_size * 8 AS Tamanho_max_arq_log_em_Kb, total_log_size_in_bytes / 1024 AS Tamanho_atual_arq_log_em_Kb, (total_log_size_in_bytes / 1024 * 100) / (max_size * 8 * 1.0) * (dm_lsu.used_log_space_in_percent / 100) AS Percent_uso_log_em_relacao_ao_tam_max, dm_lsu.used_log_space_in_percent, (select count (*) from BI_ALIANCA.sys.tables)      AS Quant_tabelas FROM BI_ALIANCA.sys.dm_db_log_space_usage      dm_lsu, BI_ALIANCA.sys.database_files      df where df.type = 1  -- type 1 = arquivo de log
union all SELECT 'SIRH'         AS nome_database, (SELECT size * 8 FROM LKSRV_SIRH.SIRH.sys.database_files WHERE type = 0) AS Tamanho_atual_arq_dados_em_Kb, (select recovery_model_desc from LKSRV_SIRH.SIRH.sys.databases where name = 'SIRH')         as recovery_model_desc, df.max_size * 8 AS Tamanho_max_arq_log_em_Kb, total_log_size_in_bytes / 1024 AS Tamanho_atual_arq_log_em_Kb, (total_log_size_in_bytes / 1024 * 100) / (max_size * 8 * 1.0) * (dm_lsu.used_log_space_in_percent / 100) AS Percent_uso_log_em_relacao_ao_tam_max, dm_lsu.used_log_space_in_percent, (select count (*) from LKSRV_SIRH.SIRH.sys.tables) AS Quant_tabelas FROM LKSRV_SIRH.SIRH.sys.dm_db_log_space_usage dm_lsu, LKSRV_SIRH.SIRH.sys.database_files df where df.type = 1  -- type 1 = arquivo de log
union all SELECT 'MercanetPRD'  AS nome_database, (SELECT size * 8 FROM MercanetPRD.sys.database_files     WHERE type = 0) AS Tamanho_atual_arq_dados_em_Kb, (select recovery_model_desc from sys.databases                 where name = 'MercanetPRD')  as recovery_model_desc, df.max_size * 8 AS Tamanho_max_arq_log_em_Kb, total_log_size_in_bytes / 1024 AS Tamanho_atual_arq_log_em_Kb, (total_log_size_in_bytes / 1024 * 100) / (max_size * 8 * 1.0) * (dm_lsu.used_log_space_in_percent / 100) AS Percent_uso_log_em_relacao_ao_tam_max, dm_lsu.used_log_space_in_percent, (select count (*) from MercanetPRD.sys.tables)     AS Quant_tabelas FROM MercanetPRD.sys.dm_db_log_space_usage     dm_lsu, MercanetPRD.sys.database_files     df where df.type = 1  -- type 1 = arquivo de log
)
select * from c
GO
