-- Script para criar linked servers nas diversas bases de dados SQL Server
-- Data: 29/09/2022 (desmembrado do antigo 'cria acessos sql')
-- Autor: Robert Koch
--
-- Historico de alteracoes:
-- 29/09/2022 - Robert - protheus_teste estah, por enquanto, no mesmo servidor da producao.
-- 11/10/2022 - Robert - criado linked server para base teste do FullWMS na logistica.
-- 07/11/2022 - Robert - Criado linked server para o SIRH gravar logs no database TI.
--

-- Cria linked server para outros databases consultarem o Metadados.
USE [master]
EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_SIRH', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'SRVMETA', @provstr=N'Provider=SQLNCLI10.1;Password=siga;Persist Security Info=True;User ID=siga;Initial Catalog=SIRH', @catalog=N'SIRH'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_SIRH', @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_SIRH', @locallogin = 'siga' , @useself = N'True', @rmtuser = N'siga'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_SIRH', @locallogin = 'consultas' , @useself = N'True', @rmtuser = N'consultas'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_SIRH', @locallogin = 'genexus', @useself = N'False', @rmtuser = N'consultas', @rmtpassword = N'consultas'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_SIRH', @locallogin = N'VINHOS-ALIANCA\robert.koch', @useself = N'False', @rmtuser = N'consultas', @rmtpassword = N'consultas'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_SIRH', @locallogin = N'VINHOS-ALIANCA\claudia.lionco', @useself = N'False', @rmtuser = N'consultas', @rmtpassword = N'consultas'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_SIRH', @locallogin = N'VINHOS-ALIANCA\sandra.sugari', @useself = N'False', @rmtuser = N'consultas', @rmtpassword = N'consultas'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_SIRH', @locallogin = N'VINHOS-ALIANCA\daiana.ribas', @useself = N'False', @rmtuser = N'consultas', @rmtpassword = N'consultas'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_SIRH', @locallogin = N'NT SERVICE\SQLSERVERAGENT', @useself = N'False', @rmtuser = N'consultas', @rmtpassword = N'consultas'  -- para que o job diario de historicos consiga acessar.


-- Cria linked server para o MercanetHML consultar o protheus_teste
USE [master]
--EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_PROTHEUS_TESTE', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'serverSQL', @provstr=N'Provider=SQLNCLI11;Password=Mnet#;Persist Security Info=True;User ID=mercanet;Initial Catalog=protheus_teste;Data Source=192.168.1.8', @catalog=N'protheus_teste'
EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_PROTHEUS_TESTE', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'serverSQL', @provstr=N'Provider=SQLNCLI11;Password=Mnet#;Persist Security Info=True;User ID=mercanet;Initial Catalog=protheus_teste;Data Source=192.168.1.4', @catalog=N'protheus_teste'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS_TESTE', @optname=N'use remote collation', @optvalue=N'true'
USE [master]
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_PROTHEUS_TESTE', @locallogin = NULL , @useself = N'False', @rmtuser = N'mercanet', @rmtpassword = N'Mnet#'


-- Cria linked server para o protheus consultar o Mercanet
USE [master]
EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_MERCANETPRD', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'SERVER02\SQL2014', @provstr=N'Provider=SQLNCLI10.1;Password=Mnet#;Persist Security Info=True;User ID=mercanet;Initial Catalog=MercanetHML;Data Source=192.168.1.2', @catalog=N'MercanetPrd'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETPRD', @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_MERCANETPRD', @locallogin = NULL , @useself = N'False', @rmtuser = N'siga', @rmtpassword = N'siga'


-- Cria linked server para o protheus_teste consultar o MercanetHML
USE [master]
EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_MERCANETHML', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'serverSQL', @provstr=N'Provider=SQLNCLI10.1;Password=Mnet#;Persist Security Info=True;User ID=mercanet;Initial Catalog=MercanetHML;Data Source=192.168.1.4', @catalog=N'MercanetHML'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_MERCANETHML', @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_MERCANETHML', @locallogin = NULL , @useself = N'False', @rmtuser = N'siga', @rmtpassword = N'siga'


-- Cria linked server para o Mercanet consultar o Protheus
USE [master]
EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_PROTHEUS', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'serverSQL', @provstr=N'Provider=SQLNCLI11;Password=Mnet#;Persist Security Info=True;User ID=mercanet;Initial Catalog=protheus;Data Source=192.168.1.4', @catalog=N'protheus'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_PROTHEUS', @optname=N'use remote collation', @optvalue=N'true'
USE [master]
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_PROTHEUS', @locallogin = NULL , @useself = N'False', @rmtuser = N'mercanet', @rmtpassword = N'Mnet#'


-- Cria linked server para o Mercanet consultar o BI_ALIANCA
USE [master]
EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_BI_ALIANCA', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'serverSQL', @provstr=N'Provider=SQLNCLI11;Password=consultas;Persist Security Info=True;User ID=consultas;Initial Catalog=BI_ALIANCA;Data Source=192.168.1.4', @catalog=N'BI_ALIANCA'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'rpc out', @optvalue=N'true'  -- usar TRUE para permitir aos batches de geracao de tabelas do Protheus apagarem elas antes de gerar novamente.
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA', @optname=N'use remote collation', @optvalue=N'true'
USE [master]
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_BI_ALIANCA', @locallogin = NULL , @useself = N'False', @rmtuser = N'mercanet', @rmtpassword = N'Mnet#'


-- Cria linked server para o protheus_medio (ambiente temporario de simulacoes de custo medio) consultar o BI_ALIANCA_teste
USE [master]
-- As alternative solution you can use the parameter @datasrc instead of @provstr. @dataSrc works without setting the User ID (https://stackoverflow.com/questions/32084453/sql-linked-server-returns-error-no-login-mapping-exists-when-non-admin-account)
EXEC master.dbo.sp_addlinkedserver
	@server = N'LKSRV_BI_ALIANCA_teste',
	@srvproduct=N'sql_server',
	@provider=N'SQLNCLI',
	@datasrc=N'SERVER17',
	@catalog=N'BI_ALIANCA_teste'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_BI_ALIANCA_teste', @optname=N'use remote collation', @optvalue=N'true'
-- Set up the Linked server to pass along login credentials
EXEC master.dbo.sp_addlinkedsrvlogin
    @rmtsrvname='LKSRV_BI_ALIANCA_teste',
    @useself='true', -- Optional. This is the default
    @locallogin=NULL; -- Optional. This is the default


-- Cria linked server para o Protheus consultar o FullWMS (base quente logistica)
-- Para isso deve ter um client Oracle instalado no servidor e o Net Manager do oracle deve ter sido executado para criar um nome de serviço.
-- ver GLPI 5701: Tentei habilitar a opção `permitir inprocess` nas propriedades do provedor OraOLEDB.Oracle e isso derrubou o serviço do SQL novamente.
-- Pesquisando melhor, verifiquei que após esse passo, o linked server deveria ser recriado. Então excluí o linked server antes de habilitar o inprocess, aí o banco aceitou.
USE [master]
EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_FULLWMS_LOGISTICA', @srvproduct=N'fullwms', @provider=N'OraOLEDB.Oracle', @datasrc=N'fullwms', @provstr=N'(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.1.11)(PORT=1521)))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=fullwms)))'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICA', @optname=N'remote proc transaction promotion', @optvalue=N'true'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_FULLWMS_LOGISTICA', @locallogin = NULL , @useself = N'False', @rmtuser = N'alianca', @rmtpassword = N'v1n1c0l4'


-- Cria linked server para o Protheus consultar o FullWMS (base teste logistica)
-- Para isso deve ter um client Oracle instalado no servidor e o Net Manager do oracle deve ter sido executado para criar um nome de serviço.
USE [master]
EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_FULLWMS_LOGISTICATESTE', @srvproduct=N'fullwms', @provider=N'OraOLEDB.Oracle', @datasrc=N'fullwms', @provstr=N'(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.1.11)(PORT=1521)))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=fullwmsteste)))'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_FULLWMS_LOGISTICATESTE', @optname=N'remote proc transaction promotion', @optvalue=N'true'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_FULLWMS_LOGISTICATESTE', @locallogin = NULL , @useself = N'False', @rmtuser = N'fullwmsteste', @rmtpassword = N'fullwmsteste'
-- pode ser ser testado assim, para ver se diferencia da base quente:
-- SELECT RETORNO FROM openquery (LKSRV_FULLWMS_LOGISTICA,      'select max(dt_mov) as RETORNO from wms_mov_estoques_cd')
-- SELECT RETORNO FROM openquery (LKSRV_FULLWMS_LOGISTICATESTE, 'select max(dt_mov) as RETORNO from wms_mov_estoques_cd')


-- Cria linked server para o protheus consultar o naweb (mesmo que, no momento, estejam no mesmo servidor)
USE [master]
EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_NAWEB', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'SERVERSQL', @provstr=N'Provider=SQLNCLI10.1;Password=siga;Persist Security Info=True;User ID=siga;Initial Catalog=naweb;Data Source=192.168.1.4', @catalog=N'naweb'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB', @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_NAWEB', @locallogin = NULL , @useself = N'False', @rmtuser = N'siga', @rmtpassword = N'siga'


-- Cria linked server para o protheus_teste consultar o naweb_teste
USE [master]  ---> executar isto no 192.168.1.7 onde estah o database do protheus_teste!!!
EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_NAWEB_TESTE', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'SERVERSQL', @provstr=N'Provider=SQLNCLI10.1;Password=siga;Persist Security Info=True;User ID=siga;Initial Catalog=naweb_teste;Data Source=192.168.1.4', @catalog=N'naweb_teste'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_NAWEB_TESTE', @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_NAWEB_TESTE', @locallogin = NULL , @useself = N'False', @rmtuser = N'siga', @rmtpassword = N'siga'


-- Cria linked server para os outros databases gravarem logs no database TI (mesmo que, no momento, estejam no mesmo servidor)
USE [master]
-- As alternative solution you can use the parameter @datasrc instead of @provstr. @dataSrc works without setting the User ID (https://stackoverflow.com/questions/32084453/sql-linked-server-returns-error-no-login-mapping-exists-when-non-admin-account)
EXEC master.dbo.sp_addlinkedserver
	@server = N'LKSRV_TI',
	@srvproduct=N'sql_server',
	@provider=N'SQLNCLI',
	@datasrc=N'SERVERSQL',
	@catalog=N'TI'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'rpc', @optvalue=N'true'  -- TRUE para poder executar VA_LOG
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'rpc out', @optvalue=N'true'  -- TRUE para poder executar VA_LOG
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'use remote collation', @optvalue=N'true'
-- Set up the Linked server to pass along login credentials
EXEC master.dbo.sp_addlinkedsrvlogin
    @rmtsrvname='LKSRV_TI',
    @useself='true', -- Optional. This is the default
    @locallogin=NULL; -- Optional. This is the default


-- Cria linked server parao SIRH gravar logs no database TI (executar no servidor do SIRH)
-- nao ficou bom....    USE [master]
-- nao ficou bom....    EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_TI', @srvproduct=N'sql_server', @provider=N'SQLNCLI', @datasrc=N'serverSQL', @provstr=N'Provider=SQLNCLI10.1;Password=consultas;Persist Security Info=True;User ID=consultas;Initial Catalog=TI', @catalog=N'TI'
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'collation compatible', @optvalue=N'false'
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'data access', @optvalue=N'true'
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'dist', @optvalue=N'false'
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'pub', @optvalue=N'false'
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'rpc', @optvalue=N'true'  -- TRUE para poder executar VA_LOG
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'rpc out', @optvalue=N'true'  -- TRUE para poder executar VA_LOG
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'sub', @optvalue=N'false'
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'connect timeout', @optvalue=N'0'
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'collation name', @optvalue=null
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'lazy schema validation', @optvalue=N'false'
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'query timeout', @optvalue=N'0'
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'use remote collation', @optvalue=N'true'
-- nao ficou bom....    EXEC master.dbo.sp_serveroption @server=N'LKSRV_TI', @optname=N'remote proc transaction promotion', @optvalue=N'false'
-- nao ficou bom....    EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_TI', @locallogin = 'consultas' , @useself = N'True', @rmtuser = N'consultas'


-- Cria linked server para nosso servidor interno gravar dados no nosso database da nuvem da Azure.
/*
-- Achei que fosse necessario criar uma conexao ODBC antes. Acabei nao precisando, mas fica aqui o registro:
--    Conexoes ODBC -> system DSN -> nova
--    Driver: ODBC driver 17 for DQL Server
--    Nome: AZURE_DB_ALIANCA_DW
--    Server: db-alianca.database.windows.net
--    Seguranca: With SQL Server authentication using a login ID and password entered by the user
--    Login ID: server_interno
--    password: (a mesma que foi usada ao criar o usuario no database da Azure)
--    Selecionar o checkbox "Change default database to"
--    informar manualmente DW no default database (mas NAO selecionar pelo combo por que o usuario nao tem acesso ao database master)
*/
USE [master]
EXEC master.dbo.sp_addlinkedserver @server = N'LKSRV_AZURE_DBALIANCA', @srvproduct=N'', @provider=N'SQLOLEDB', @datasrc=N'db-alianca.database.windows.net', @catalog=N'DW'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'rpc', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'rpc out', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=N'LKSRV_AZURE_DBALIANCA', @optname=N'remote proc transaction promotion', @optvalue=N'true'
USE [master]
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'LKSRV_AZURE_DBALIANCA', @locallogin = NULL , @useself = N'False', @rmtuser = N'server_interno', @rmtpassword = N'Tdedpn23!'
