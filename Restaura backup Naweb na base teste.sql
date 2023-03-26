-- Script para restaurar backup da base quente do NaWeb por cima da base teste
-- Data: 13/10/2021
-- Autor: Robert Koch
--
-- Historico de alteracoes:
--

-- Sugestao: copiar e colar numa sessao direto no servidor SQL (nao rodar de um notebook por exemplo)
Use master
GO

/*
-- Verifica quem esta conectado e possivelmente impedindo o restore.
use naweb_teste
SELECT dec.client_net_address ,
des.program_name ,
des.host_name ,
COUNT(dec.session_id) AS connection_count
FROM sys.dm_exec_sessions AS des
INNER JOIN sys.dm_exec_connections AS dec
ON des.session_id = dec.session_id
GROUP BY dec.client_net_address ,
des.program_name ,
des.host_name
ORDER BY des.program_name,
dec.client_net_address ;
*/

/* Para acessar o arquivo de backup provavelmente seja necessario mapear uma unidade PELO SQL (pelo
   Windows nao funciona). Antes disso, se o SQL ainda nao estiver com a funcao de shell habilitada,
   pode ser necessario o seguinte :
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

/* Exemplos para mapear o drive K: pelo SQL (nao adianta fazer pelo Windows):
--exec xp_cmdshell 'net use k: \\192.168.2.94\shared'
--exec xp_cmdshell 'net use k: /delete'
--exec xp_cmdshell 'net use k: \\192.168.1.9\bkp-sql /user:admin Alianca164'
--exec xp_cmdshell 'net use k: \\nas-backup\bkp-sql /user:admin Alianca164'
--exec xp_cmdshell 'net use N: \\192.168.1.104\bkp-sql /user:bkp.srvsql T4p3Cor3!'
*/

/*
-- Verifica conteudo do arquivo (pode haver mais de 1 backup no arquivo). Nesse caso,
-- usar WITH FILE= no comando de restore para especificar qual backup deve ser restaurado.
declare @nome_arq_bkp varchar (50) = N'n:\naweb\Naweb_Full 01-00 09-02-2023.bak'
--RESTORE HEADERONLY FROM DISK = @nome_arq_bkp

-- Restaura o backup no database novo. Documentacao em https://docs.microsoft.com/pt-br/sql/relational-databases/backup-restore/restore-a-database-to-a-new-location-sql-server?view=sql-server-2017
use master;
RESTORE DATABASE [naweb_teste]
FROM DISK = @nome_arq_bkp
WITH FILE = 1,
MOVE N'naweb' TO N'f:\Dados_SQL\naweb_teste.mdf',
MOVE N'naweb_log' TO N'f:\Dados_SQL\naweb_teste_log.ldf',
NOUNLOAD, REPLACE, STATS = 10
GO

-- monitora processo (abrir em janela separada)
select percent_complete, total_elapsed_time / 60 / 1000 as minutos_executado, estimated_completion_time / 60 / 1000 as minutos_restantes, * from sys.dm_exec_requests where (command = 'RESTORE DATABASE' or command like 'BACKUP%' or command like 'ALTER%' or command = 'DbccFilesCompact')

-- Ajusta seguranca e acessos. Parece que os usuarios que vem junto no backup,
-- apesar de terem nomes jah existentes no database destino, nao sao mais aceitos,
-- entao tive que deletar os usuarios do database e dar novamente os acessos.
use naweb_teste
EXEC dbo.sp_changedbowner @loginame = N'genexus', @map = false
GO

-- Altera nome logico dos arquivos (database precisa estar offline) e os arquivos devem ser renomeados pelo Windows.
ALTER DATABASE [naweb_teste] MODIFY FILE (NAME=N'naweb', NEWNAME=N'naweb_teste')
ALTER DATABASE [naweb_teste] MODIFY FILE (NAME=N'naweb_log', NEWNAME=N'naweb_teste_log')
ALTER DATABASE [naweb_teste] SET RECOVERY SIMPLE WITH NO_WAIT
GO
ALTER DATABASE [naweb_teste] SET RECOVERY SIMPLE 
GO

-- Caso precise renomear os arquivos fisicos: geralmente o Windows remove a permissao
-- de acesso aos arquivos .mdb e .ldf quando renomeados ou movidos para outra pasta.
-- Nesse caso, editar permissão e adicionar nova permissao selecionando o local como
-- o servidor onde encontra-se o banco (nao o dominio) e colar o nome de usuario que
-- pode ser obtido verificando a conta que roda o servico do SQLServer nesse servidor.

--DROP USER [GX_Safra]
--CREATE USER [GX_Safra] FOR LOGIN [GX_Safra] WITH DEFAULT_SCHEMA=[dbo]
--GRANT SELECT TO [GX_Safra]

--DROP USER [GX_NAweb]
--CREATE USER [GX_NAweb] FOR LOGIN [GX_NAweb] WITH DEFAULT_SCHEMA=[dbo]
--GRANT SELECT TO [GX_NAweb]

DROP USER [GX_NAmob]
CREATE USER [GX_NAmob] FOR LOGIN [GX_NAmob] WITH DEFAULT_SCHEMA=[dbo]
GRANT SELECT TO [GX_NAmob]
*/
