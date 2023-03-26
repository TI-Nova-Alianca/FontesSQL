-- Script para restaurar backup da base quente do Mercanet por cima da base teste
-- Data: 01/10/2021
-- Autor: Robert Koch
--
-- Historico de alteracoes:
--

Use master
GO


/* Para acessar o arquivo de backup provavelmente seja necessùrio mapear uma unidade PELO SQL (pelo
   Windows nùo funciona). Antes disso, se o SQL ainda nùo estiver com a funùùo de shell habilitada,
   pode ser necessùrio o seguinte :
-- To allow advanced options to be changed.  
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO  
*/

/* Exemplos para mapear o drive K: pelo SQL (nùo adianta fazer pelo Windows):
--exec xp_cmdshell 'net use k: \\192.168.2.94\shared'
--exec xp_cmdshell 'net use n: /delete'
--exec xp_cmdshell 'net use k: \\192.168.1.9\bkp-sql /user:admin Alianca164'
--exec xp_cmdshell 'net use k: \\nas-backup\bkp-sql /user:admin Alianca164'
--exec xp_cmdshell 'net use N: \\192.168.1.104\bkp-SQL /user:bkp.srvsql T4p3Cor3!'
*/

/*
-- Verifica conteudo do arquivo (pode haver mais de 1 backup no arquivo). Nesse caso,
-- usar WITH FILE= no comando de restore para especificar qual backup deve ser restaurado.
declare @nome_arq_bkp varchar (60) = N'n:\MercanetPRD\MercanetPRD_Full 03-41 07-04-2022.bak'
--RESTORE HEADERONLY FROM DISK = @nome_arq_bkp

-- Restaura o backup no database novo. Documentacao em https://docs.microsoft.com/pt-br/sql/relational-databases/backup-restore/restore-a-database-to-a-new-location-sql-server?view=sql-server-2017
use master;
RESTORE DATABASE [MercanetHML]  -- para onde vai ser restaurado
FROM DISK = @nome_arq_bkp  -- de onde vai ser restaurado
WITH FILE = 1,  -- se o arq. de backup tiver mais de um backup, quero o primeiro
REPLACE,  -- para permitir renomear o database (restaurar para um nome diferente do database onde foi feito o backup)
MOVE N'MercanetPRD' TO N'c:\Dados_SQL\MercanetHML.mdf',  -- move o nome logico do database original para o arquivo (fisico) destino do restore
MOVE N'MercanetPRD_log' TO N'c:\Dados_SQL\MercanetHML_log.ldf',  -- move o nome logico do database original para o arquivo (fisico) destino do restore
-- NORECOVERY  -- se quiser restaurar algum arquivo de log em seguida
NOUNLOAD, REPLACE, STATS = 10  -- se nao vai restaurar logs
GO

-- Se for restauras alguns arquivos de backup log
-- use master;
-- RESTORE LOG [MercanetHML] FROM DISK = N'n:\MercanetPRD\MercanetPRD_Log 30-09-2021 02-00.trn' WITH FILE = 1, NORECOVERY

-- monitora processo (abrir em janela separada)
select percent_complete, total_elapsed_time / 60 / 1000 as minutos_executado, estimated_completion_time / 60 / 1000 as minutos_restantes, * from sys.dm_exec_requests where (command = 'RESTORE DATABASE' or command like 'BACKUP%' or command like 'ALTER%' or command = 'DbccFilesCompact')


-- Ajusta seguranca e acessos.
use MercanetHML
EXEC dbo.sp_changedbowner @loginame = N'mercanet', @map = false
GO

-- Altera nome logico dos arquivos (database precisa estar offline) e os arquivos devem ser renomeados pelo Windows.
ALTER DATABASE [MercanetHML] MODIFY FILE (NAME=N'MercanetPRD', NEWNAME=N'MercanetHML')
ALTER DATABASE [MercanetHML] MODIFY FILE (NAME=N'MercanetPRD_log', NEWNAME=N'MercanetHML_log')
ALTER DATABASE [MercanetHML] SET RECOVERY SIMPLE WITH NO_WAIT
GO

*/
