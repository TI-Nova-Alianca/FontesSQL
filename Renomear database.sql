-- Script usado para renomear um database (nome, arquivos (físico) e lógico)
-- royalties para https://www.mssqltips.com/sqlservertip/4419/renaming-physical-database-file-names-for-a-sql-server-database/

use master
alter database protheus_testemedio modify name = protheus_R33

--Disconnect all existing session.
ALTER DATABASE protheus_R33 SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
--Change database in to OFFLINE mode.
ALTER DATABASE protheus_R33 SET OFFLINE

-- Alterar neste momento o nome físico do arquivo .MDF e excluir o arquivo .LDF (direto pelo Windows do servidor).

-- Atualizar o catalogo do sistema
ALTER DATABASE protheus_R33 MODIFY FILE (Name='protheus_testemedio', FILENAME='F:\dados_SQL\protheus_R33.mdf')
GO
ALTER DATABASE protheus_R33 MODIFY FILE (Name='protheus_testemedio_log', FILENAME='F:\dados_SQL\protheus_R33.ldf')
GO

-- Voltar o database para online
ALTER DATABASE protheus_R33 SET ONLINE
Go
ALTER DATABASE protheus_R33 SET MULTI_USER
Go

-- Alterar o nome lógico
ALTER DATABASE protheus_R33 MODIFY FILE (NAME=N'protheus_testemedio', NEWNAME=N'protheus_R33')
ALTER DATABASE protheus_R33 MODIFY FILE (NAME=N'protheus_testemedio_log', NEWNAME=N'protheus_R33_log')

-- Verificar como ficou
use protheus_R33
select file_id, name as nome_logico, physical_name
from sys.database_files