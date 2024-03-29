-- Script para criar usuarios e acessos nas diversas bases de dados SQL Server
-- Data: jah faz tempo...
-- Autor: Robert Koch
--
-- Historico de alteracoes:
-- 13/10/2021 - Robert - Criado usuário PBI_PCP
-- 07/12/2021 - Robert - Criada view VPBI_DADOS_OS
-- 02/02/2022 - Robert - Criado usuario newrelic (monitoramento)
-- 25/03/2022 - Robert - Criado usuario pbi.azure
-- 01/04/2022 - Robert - Reorganizado em blocos separados para criar cada conta.
-- 20/04/2022 - Robert - Liberadas tabelas/views VA_RENTABILIDADE e VPBI_SUPERV_VENDA para usuario pbi.azure
-- 25/05/2022 - Robert - Criados usuarios GX_Safra, GX_NAweb, GX_NAmob
-- 10/08/2022 - Robert - Criados acessos para usuario GX_Naweb e GX_Namob aos databases naweb, protheus, SIRH, TI, BI_ALIANCA.
-- 29/09/2022 - Robert - Criacao de linked server migrada para arquivo em separado.
-- 07/11/2022 - Robert - Criada tabela VA_LOGS e funcao VA_LOG no database TI (acesso p/ usr. 'consultas')
-- 20/11/2022 - Robert - Criado acesso EXEC para a procedure [VA_SP_HORARIOS_PARA_AD] em SIRH
-- 16/02/2023 - Robert - Liberada tabela SF4 para PowerBI
-- 22/06/2023 - Robert - Criado acesso ALTER ANY CONNECTION para Cláudia, Sandra e Daiana
-- 16/07/2023 - Robert - Acessos à view SIRH.dbo.VA_VPESSOAS
-- 17/11/2023 - Robert - Acesso para pbi-azure à view (por enquanto em testes) de DRE
--


-- Usuario para o Protheus
USE [master]
	CREATE LOGIN [siga] WITH PASSWORD=N'siga', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	GRANT VIEW SERVER STATE TO [siga]
	GRANT SELECT ON sys.dm_tran_locks to [siga]  -- https://tdn.totvs.com/pages/viewpage.action?pageId=327323773 - Em builds superiores a 18.2.1.1 será necessário liberar explicitamente o direito GRANT SELECT ON sys.dm_tran_locks no banco master.  O acesso a consulta da view de sistema de bloqueios é necessário para o mecanismo de limpeza de tabelas temporárias não permitir o envio de uma instrução de DROP para uma tabela temporária que ainda está em uso – aberta com um select por exemplo – por outro processo. 
	GRANT ALTER ANY CONNECTION to [siga]  -- https://tdn.totvs.com/pages/viewpage.action?pageId=327323773 - Em builds superiores a 18.2.1.1, a nova funcionalidade de encerramento de conexão do DBAccess solicita ao Banco de Dados o encerramento (kill) de uma conexão, caso ela esteja em processamento no Banco. Para essa instrução ser executada no Banco de Dados, deve ser liberado o direito "GRANT ALTER ANY CONNECTION" para o usuário usado na conexão com o MSSQL no banco Master. 
USE protheus
	EXEC dbo.sp_changedbowner @loginame = N'siga', @map = false  -- No database criado para atender a este ambiente, o usuário criado deve ser definido como owner através do Database Role db_owner.
USE BI_ALIANCA
	EXEC dbo.sp_changedbowner @loginame = N'siga', @map = false
USE [naweb]
	CREATE USER [siga] FOR LOGIN [siga]
	GRANT SELECT TO [siga]
USE SIRH  -- Conectar ao SQL do servidor do Metadados para executar o trecho abaixo
	CREATE USER [siga] FOR LOGIN [siga]
	ALTER USER [siga] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT ON [dbo].RHCONTASPAGARHIST TO [siga]     -- integracao financeira
	GRANT UPDATE ON [dbo].RHCONTASPAGARHIST TO [siga]     -- integracao financeira
	GRANT SELECT ON [dbo].RHCONTASPAGARHISTLOG TO [siga]  -- integracao financeira
	GRANT INSERT ON [dbo].RHCONTASPAGARHISTLOG TO [siga]  -- integracao financeira
	GRANT SELECT ON [dbo].RHDEPOSITOSANALITICO TO [siga]  -- integracao financeira
	GRANT SELECT ON [dbo].RHDARFANALITICO TO [siga]       -- integracao financeira
	GRANT SELECT ON [dbo].RHLANCTOSCONTABCONTR TO [siga]  -- integracao contabil
	GRANT SELECT ON [dbo].[VA_VFUNCIONARIOS] TO [siga]    -- integracao funcionarios para vendas lojas
	GRANT SELECT ON [dbo].[VA_VPESSOAS] TO [siga]         -- unificacao usuarios Protheus X pessoas Metadados
	GRANT SELECT ON [dbo].[VA_VFORNECEDORES] TO [siga]    -- integracao funcionarios para vendas lojas
	GRANT SELECT ON [dbo].[VA_VTITULOS_CPAGAR3] TO [siga] -- integracao contas a pagar
USE [MercanetPRD]
	CREATE USER [siga] FOR LOGIN [siga]
	ALTER USER [siga] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT TO [siga]
	GRANT INSERT ON [dbo].[DB_INTERFACE_PROTHEUS] TO [siga]
	GRANT update ON [dbo].[ZC5010] TO [siga]
	GRANT update ON [dbo].[ZA1010] TO [siga]
USE BL01
	CREATE USER [siga] FOR LOGIN [siga]
	ALTER USER [siga] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, DELETE, UPDATE TO [siga]
USE TI
	CREATE USER [siga]  FOR LOGIN [siga]
	ALTER USER [siga] WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT, SELECT, INSERT, EXECUTE TO [siga] -- Necessario para executar funcoes dentro de queries



-- Usuario para o PowerBI acessar nosso servidor interno a partir da nuvem.
USE [master]
	CREATE LOGIN [pbi.azure] WITH PASSWORD=N'Mdjdf784j5',  DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	ALTER LOGIN [pbi.azure] WITH DEFAULT_DATABASE=[BI_ALIANCA], DEFAULT_LANGUAGE=[us_english]
USE protheus
	drop user [pbi.azure]; CREATE USER [pbi.azure] FOR LOGIN [pbi.azure]
	ALTER USER [pbi.azure] WITH DEFAULT_SCHEMA=[dbo]
	GRANT EXECUTE ON [VA_FSTATUS_PED_VENDA] TO [pbi.azure]
	GRANT SELECT ON [dbo].CQ0010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].CT1010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].CTS010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].SA1010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].SA3010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].SA4010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].SB1010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].SB2010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].SC5010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].SC6010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].SF4010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].SH1010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].ZAE010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].ZX5010 to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].VA_VRENDIMENTOS_VINIFICACAO to [pbi.azure]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.


-- Usuario para o BI da empresa Mirar acessar nosso database DW na nuvem da Azure (eles nao acessam nosso servidor interno)
-- conectar em db-alianca.database.windows.net
use master
	CREATE LOGIN pbimirar WITH PASSWORD = 'M1ra89@23!'
	CREATE LOGIN server_interno WITH PASSWORD = 'Tdedpn23!'
	-- esta propriedade nao existe na Azure ---> ALTER LOGIN pbimirar WITH DEFAULT_DATABASE=[DW]
use DW
	CREATE USER [pbimirar] FOR LOGIN [pbimirar]
	CREATE USER [server_interno] FOR LOGIN [server_interno]
	ALTER ROLE db_owner ADD MEMBER [pbimirar];  -- nao to gostando deste aqui...
	GRANT SELECT, INSERT, UPDATE, DELETE on DRE TO [server_interno]
	GRANT SELECT on DRE TO [pbimirar]


use BI_ALIANCA
	CREATE USER [pbi.azure] FOR LOGIN [pbi.azure]
	ALTER USER [pbi.azure] WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT TO [pbi.azure]
	GRANT SELECT ON [dbo].[VA_FATDADOS]            to [pbi.azure]
	GRANT SELECT ON [dbo].[VA_RENTABILIDADE]       to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_CLIENTES]          to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_REPRESENTANTES]    to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_SUPERV_VENDA]      to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_TRANSPORTADORAS]   to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_PRODUTOS]          to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_GRUPOS_EMBALAGENS] to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_LINHAS_COMERCIAIS] to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_LINHAS_DE_ENVASE]  to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_MARCAS_COMERCIAIS] to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_MOTIVOS_DEVOLUCAO] to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_PEDIDOS_DE_VENDA]  to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_SALDOS_ESTOQUES]   to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_SALDOS_ESTOQUES]   to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_DRE]               to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_BALPAT]            to [pbi.azure]
	GRANT SELECT ON [dbo].[VPBI_RENDIMENTOS_VINIFICACAO] to [pbi.azure]


-- Usuario para gravacao de dados de medicao de grau na safra (Software da Maselli)
USE [master]
	CREATE LOGIN [brix] WITH PASSWORD=N'Brx2011a', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
use protheus
	CREATE USER [brix] FOR LOGIN [brix]
	ALTER USER [brix] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, UPDATE ON [dbo].[ZZA010] TO [brix]
	GRANT SELECT, INSERT, ALTER, DELETE, UPDATE ON [dbo].[LEITURAS_BRIX] TO [brix]
	GRANT SELECT, INSERT ON [dbo].[VA_PESOS_BALANCA_MATRIZ] TO [brix]
	GRANT SELECT, INSERT ON [dbo].[VA_PESOS_BALANCA_F07] TO [brix]
	GRANT SELECT, INSERT ON [dbo].[VA_DESVIOS_PROCESSAMENTO_UVA] TO [brix]


-- Usuario para o banco SQL Express que roda nas estacoes de medicao ed grau
-- A intencao eh que o grau opere vendo somente o SQL local, e toda a
-- integracao com a retaguarda seria feita pelo PowerShell+SQL para agilizar
-- o tempo de gravacao e nao travar em caso de falha de conexao com o SQL do servidor.
USE [master]
	CREATE LOGIN [brix] WITH PASSWORD=N'Brx2011a', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
use BL01
	CREATE USER [brix] FOR LOGIN [brix]
	ALTER USER [brix] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, UPDATE ON [dbo].[ZZA010] TO [brix]
	CREATE USER [brix.local] FOR LOGIN [brix.local]
	ALTER USER [brix.local] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, UPDATE ON [dbo].[ZZA010] TO [brix.local]


-- Conta para o sistema FullWMS
USE [master]
	CREATE LOGIN [FullWMS] WITH PASSWORD=N'IntegraFull', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
use protheus
	CREATE USER [FullWMS] FOR LOGIN [FullWMS]
	ALTER USER [FullWMS] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT ON [dbo].[v_wms_codbarras] TO [FullWMS]
	GRANT SELECT ON [dbo].[v_wms_entrada] TO [FullWMS]
	GRANT SELECT ON [dbo].[v_wms_estoques] TO [FullWMS]
	GRANT SELECT ON [dbo].[v_wms_item] TO [FullWMS]
	GRANT SELECT ON [dbo].[v_wms_pedido] TO [FullWMS]
	GRANT SELECT ON [dbo].[v_wms_transportadoras] TO [FullWMS]
	GRANT SELECT ON [dbo].[v_wms_bloqueios] TO [FullWMS]
	GRANT INSERT, SELECT, UPDATE ON [dbo].[tb_wms_entrada] TO [FullWMS]
	GRANT INSERT, SELECT, UPDATE ON [dbo].[tb_wms_etiquetas] TO [FullWMS]
	GRANT INSERT, SELECT, UPDATE ON [dbo].[tb_wms_lotes] TO [FullWMS]
	GRANT INSERT, SELECT, UPDATE ON [dbo].[tb_wms_movimentacoes] TO [FullWMS]
	GRANT INSERT, SELECT, UPDATE ON [dbo].[tb_wms_pedidos] TO [FullWMS]
	GRANT INSERT, SELECT, UPDATE ON [dbo].[tb_wms_volumes] TO [FullWMS]
	GRANT INSERT, SELECT, UPDATE ON [dbo].[tb_wms_bloqueios] TO [FullWMS]


-- Conta para o sistema Mercanet
USE [master]
	CREATE LOGIN [mercanet] WITH PASSWORD=N'Mnet#', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
USE [msdb]
	CREATE USER [mercanet] FOR LOGIN [mercanet]  -- para o pessoal de suporte consultar os jobs (GLPI 10056)
	ALTER ROLE SQLAgentReaderRole ADD MEMBER [mercanet]  -- para o pessoal de suporte consultar os jobs (GLPI 10056)
use protheus
	CREATE USER [mercanet] FOR LOGIN [mercanet]
	ALTER USER mercanet WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT                          TO [mercanet]  -- Necessario para rodar algumas views
	GRANT EXECUTE ON VA_FQtCx             TO [mercanet]  -- Necessario para rodar algumas views
	GRANT EXECUTE ON VA_FSTATUS_PED_VENDA TO [mercanet]  -- Necessario para rodar algumas views
	GRANT EXECUTE ON VA_FRAPELPADRAO      TO [mercanet]  -- Necessario para rodar algumas views
USE BI_ALIANCA
	CREATE USER [mercanet] FOR LOGIN [mercanet]
	ALTER USER [mercanet] WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT, SELECT, EXECUTE TO [mercanet] -- Necessario para executar funcoes dentro de queries
use naweb
	CREATE USER [mercanet] FOR LOGIN [mercanet]
	GRANT SELECT TO [mercanet]  -- Mercanet tem consultas que buscam dados em views do Protheus, que buscam no NaWeb...
USE TI
	CREATE USER [mercanet]  FOR LOGIN [mercanet]
	ALTER USER [mercanet] WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT, SELECT, INSERT, EXECUTE TO [mercanet] -- Necessario para executar funcoes dentro de queries



-- Contas para os aplicativos gerados pelo Genexus
USE [master]  -- executar em todos os servidores onde houver Genexus (SRVSQL, SrvNaWeb, aplicativo de safra, caderno de campo, etc.)
	-- quero eliminar esta conta  CREATE LOGIN [genexus]   WITH PASSWORD=N'genesio',     DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	CREATE LOGIN GX_Naweb WITH PASSWORD=N'GXN@web!123', DEFAULT_DATABASE=[naweb],     CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	CREATE LOGIN GX_NAmob WITH PASSWORD=N'GXN@mob!123', DEFAULT_DATABASE=[naweb],     CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	CREATE LOGIN GX_Safra WITH PASSWORD=N'GXS@fr@!123', DEFAULT_DATABASE=[GAM_SAFRA], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	-- em desuso CREATE LOGIN [gx_dbret]  WITH PASSWORD=N'gx_dbret',    DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
--
use naweb  -- executar no SRVSQL
use SessionState-Naweb  -- database onde o IIS guarda dados de sessao. Ajustar para base teste se for o caso.
	CREATE USER [GX_Naweb] FOR LOGIN [GX_Naweb]
	CREATE USER [GX_NAmob] FOR LOGIN [GX_NAmob]
	ALTER USER GX_Naweb WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER GX_NAmob WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [GX_Naweb]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [GX_NAmob]
--
-- habilita acessos para o NaWeb consultar Protheus e outras aplicacoes.
use protheus  -- executar no SRVSQL
	-- quero eliminar esta conta  CREATE USER [genexus]   FOR LOGIN [genexus]
	-- quero eliminar esta conta  CREATE USER [gx_dbret]  FOR LOGIN [gx_dbret]
	-- quero eliminar esta conta  ALTER USER genexus                         WITH DEFAULT_SCHEMA=[dbo]
	-- quero eliminar esta conta  ALTER USER gx_dbret                        WITH DEFAULT_SCHEMA=[dbo]
	-- quero eliminar esta conta  GRANT SELECT, SHOWPLAN, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE TO genexus
	CREATE USER [GX_Naweb] FOR LOGIN [GX_Naweb]
	CREATE USER [GX_NAmob] FOR LOGIN [GX_NAmob]
	ALTER USER GX_Naweb WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER GX_NAmob WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE TO GX_Naweb
	GRANT SELECT, SHOWPLAN, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE TO GX_NAmob
	--
USE BI_ALIANCA  -- executar no SRVSQL
	CREATE USER [GX_Naweb]                       FOR LOGIN [GX_Naweb]
	ALTER USER [GX_Naweb]                       WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT, SELECT, EXECUTE TO [GX_Naweb] -- Necessario para executar funcoes dentro de queries
USE TI  -- executar no SRVSQL
	CREATE USER [GX_Naweb]  FOR LOGIN [GX_Naweb]
	ALTER USER [GX_Naweb] WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT, SELECT, INSERT, EXECUTE TO [GX_Naweb] -- Necessario para executar funcoes dentro de queries
--
USE SIRH  -- Conectar ao SQL do servidor do Metadados para executar o trecho abaixo
	CREATE LOGIN GX_Naweb WITH PASSWORD=N'GXN@web!123', DEFAULT_DATABASE=[SIRH],     CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	CREATE USER [GX_Naweb] FOR LOGIN [GX_Naweb]
	ALTER USER GX_Naweb WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT ON [dbo].[VA_VFUNCIONARIOS] TO [GX_Naweb]
	GRANT SELECT ON [dbo].[VA_VPESSOAS] TO [GX_Naweb]    -- View VISAO_GERAL_ACESSOS

-- executar em servidores onde rodam aplicacoes Genexus (SRVWEB, servidor de desenvolvimento, etc.)
CREATE LOGIN GX_Naweb WITH PASSWORD=N'GXN@web!123', DEFAULT_DATABASE=[naweb],     CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
CREATE LOGIN GX_NAmob WITH PASSWORD=N'GXN@mob!123', DEFAULT_DATABASE=[GAM_CAD],   CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
CREATE LOGIN GX_Safra WITH PASSWORD=N'GXS@fr@!123', DEFAULT_DATABASE=[GAM_SAFRA], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
use [SessionState-Naweb]
	CREATE USER [GX_Naweb] FOR LOGIN [GX_Naweb]
	CREATE USER [GX_Safra] FOR LOGIN [GX_Safra]
	CREATE USER [GX_NAmob] FOR LOGIN [GX_NAmob]
	ALTER USER GX_Naweb WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER GX_Safra WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER GX_NAmob WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [GX_Safra]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [GX_NAmob]
use GAM
	CREATE USER [GX_Safra] FOR LOGIN [GX_Safra]
	CREATE USER [GX_NAmob] FOR LOGIN [GX_NAmob]
	ALTER USER GX_Safra WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER GX_NAmob WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [GX_Safra]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [GX_NAmob]
use GAM_CAD
	CREATE USER [GX_Safra] FOR LOGIN [GX_Safra]
	CREATE USER [GX_NAmob] FOR LOGIN [GX_NAmob]
	ALTER USER GX_Safra WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER GX_NAmob WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [GX_Safra]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [GX_NAmob]
use GAM_SAFRA
	CREATE USER [GX_Safra] FOR LOGIN [GX_Safra]
	CREATE USER [GX_NAmob] FOR LOGIN [GX_NAmob]
	ALTER USER GX_Safra WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER GX_NAmob WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [GX_Safra]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [GX_NAmob]



-- Cria usuarios para manutencao da KB e bancos do Genexus nos servidores onde se usa Genexus (ServerNaWeb, SrvWeb, caderno de campo, safra, etc.)
use master
	CREATE LOGIN [VINHOS-ALIANCA\daiana.ribas] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
	ALTER LOGIN [VINHOS-ALIANCA\daiana.ribas] WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
	GRANT ALTER TO [VINHOS-ALIANCA\daiana.ribas]
use GAM_CAD --GAM_SAFRA --GX_KB_NAWeb
	CREATE USER [VINHOS-ALIANCA\daiana.ribas] FOR LOGIN [VINHOS-ALIANCA\daiana.ribas]
	ALTER USER [VINHOS-ALIANCA\daiana.ribas] WITH DEFAULT_SCHEMA=[dbo]
	-- database protheus: GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE TO [VINHOS-ALIANCA\daiana.ribas]
	-- databases do Genexus: GRANT ALTER TO [VINHOS-ALIANCA\daiana.ribas]



-- Conta para consultas em geral (monitoramento, Excel, PowerBI, etc.)
USE [master]
	CREATE LOGIN [consultas] WITH PASSWORD=N'consultas',   DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	GRANT VIEW SERVER STATE TO [consultas]  -- para monitorar via Zabbix
USE [msdb]
	CREATE USER [consultas] FOR LOGIN [consultas]  -- para monitoramento de jobs via zabbix
	GRANT SELECT TO [consultas]
	GRANT EXECUTE ON agent_datetime to [consultas]
use protheus
	CREATE USER [consultas] FOR LOGIN [consultas]
	ALTER USER consultas                       WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT, SELECT, EXECUTE TO [consultas] -- Necessario para executar funcoes dentro de queries
USE BI_ALIANCA
	CREATE USER [consultas]                     FOR LOGIN [consultas]
	ALTER USER [consultas]                     WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT, SELECT, EXECUTE TO [consultas] -- Necessario para executar funcoes dentro de queries
	deny select on [dbo].[DRE_INDL]                        to [consultas]  -- Analise especifica - acesso somente para auditoria e diretoria (executar depois que o Protheus tiver criado essas tabelas).
	deny select on [dbo].[DRE_INDL_ITENS]                  to [consultas]  -- Analise especifica - acesso somente para auditoria e diretoria (executar depois que o Protheus tiver criado essas tabelas).
	deny select on [dbo].[DRE_INDL_VENDAS_RATEADO_FILIAIS] to [consultas]  -- Analise especifica - acesso somente para auditoria e diretoria (executar depois que o Protheus tiver criado essas tabelas).
	deny select on [dbo].[CONTAB]                          to [consultas]  -- Analise especifica - acesso somente para auditoria e diretoria (executar depois que o Protheus tiver criado essas tabelas).
use naweb
	CREATE USER [consultas] FOR LOGIN [consultas]
	GRANT SELECT ON [CCVariedade] TO [consultas]  -- Inicialmente para a agronomia fazer algumas consultas
use SIRH
	CREATE USER [consultas] FOR LOGIN [consultas]
	GRANT SELECT ON [dbo].[VA_VFUNCIONARIOS] TO [consultas]  -- monitoramento de contas de usuarios em ferias/afastados/demitidos
	GRANT SELECT ON [dbo].[VA_VPESSOAS] TO [consultas]    -- View VISAO_GERAL_ACESSOS
	GRANT SELECT ON [dbo].[VA_FVERIFICAHORARIO] TO [consultas]  -- monitoramento de contas de usuarios em ferias/afastados/demitidos
	GRANT SELECT ON [dbo].[VA_FVERIFICAHORARIO2] TO [consultas]  -- monitoramento de contas de usuarios em ferias/afastados/demitidos
--	GRANT SELECT ON [dbo].[VA_FHORARIOS_PARA_AD] TO [consultas]  -- monitoramento de contas de usuarios em ferias/afastados/demitidos
	GRANT EXEC ON [dbo].[VA_SP_HORARIOS_PARA_AD] TO [consultas]  -- monitoramento de contas de usuarios em ferias/afastados/demitidos
	GRANT EXEC ON [dbo].[VA_SP_HORARIOS_PARA_AD] TO [siga]  -- monitoramento de contas de usuarios em ferias/afastados/demitidos
use TI
	CREATE USER [consultas] FOR LOGIN [consultas]
	ALTER USER [consultas] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT ON [MONITOR_DATABASES] TO [consultas]
	GRANT SELECT ON [dbo].[MONITOR_PEDIDOS_MERCANET] TO [consultas]
	GRANT select, insert, update, delete ON [dbo].[USUARIOS_AD] TO [consultas]
	GRANT SELECT ON [MONITOR_DATABASES] TO [consultas]
	GRANT select, insert ON [dbo].[VA_LOGS] TO [consultas]
	GRANT EXECUTE ON [VA_LOG] TO [consultas]

use MercanetPRD
	CREATE USER [consultas] FOR LOGIN [consultas]
	GRANT SELECT ON [dbo].[ZC5010] TO [consultas]



-- Conta para o sistema Metadados
USE [master]
	CREATE LOGIN [metadados] WITH PASSWORD=nao_te_digo,    DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
USE SIRH
	EXEC dbo.sp_changedbowner @loginame = N'metadados', @map = false



-- Conta para o PowerBI (desenvolvimento interno que eu espero poder unificar, mais tarde, com a nuvem)
USE [master]
	CREATE LOGIN [PBI_PCP]   WITH PASSWORD=N'PBI',         DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	ALTER LOGIN [PBI_PCP]                       WITH DEFAULT_DATABASE=[BI_ALIANCA], DEFAULT_LANGUAGE=[us_english]
use protheus
	CREATE USER [PBI_PCP]   FOR LOGIN [PBI_PCP]
	ALTER USER PBI_PCP                         WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT ON [dbo].[SB1010]       to [PBI_PCP]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
	GRANT SELECT ON [dbo].[VA_VDADOS_OS] to [PBI_PCP]  -- Orientar usuarios do PowerBI a acessar views no BI_ALIANCA, mas precisa ter acesso ao database 'protheus' para poder chegar aos dados.
use BI_ALIANCA
	CREATE USER [PBI_PCP]                       FOR LOGIN [PBI_PCP]
	ALTER USER [PBI_PCP]                       WITH DEFAULT_SCHEMA=[dbo]
	GRANT CONNECT TO [PBI_PCP]
	GRANT SELECT ON [dbo].[VPBI_SB1]      to [PBI_PCP]
	GRANT SELECT ON [dbo].VA_MATERIAIS    to PBI_PCP
	GRANT SELECT ON [dbo].[VPBI_DADOS_OS] to [PBI_PCP]



-- Conta para servico de monitoramento em nuvem, direcionado mais ao IIS
USE [master]
	CREATE LOGIN [newrelic]  WITH PASSWORD=N'NR2022!',     DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	GRANT CONNECT SQL          TO [newrelic]
	GRANT VIEW SERVER STATE    TO [newrelic]
	GRANT VIEW ANY DEFINITION  TO [newrelic]
	--
	-- Habilita usuario de monitoramento em todos os databases
	DECLARE @name SYSNAME
	DECLARE db_cursor CURSOR
	READ_ONLY FORWARD_ONLY
	FOR
	SELECT NAME
	FROM master.sys.databases
	WHERE NAME NOT IN ('master','msdb','tempdb','model','rdsadmin','distribution')
	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @name WHILE @@FETCH_STATUS = 0
	BEGIN
		print @name
		EXECUTE('USE "' + @name + '"; CREATE USER newrelic FOR LOGIN newrelic;' );
		FETCH next FROM db_cursor INTO @name
	END
	CLOSE db_cursor
	DEALLOCATE db_cursor



-- Conta para o pessoal de suporte da Totvs, usada em projeto de custo medio no ano de 2020 / 2021
use master
	CREATE LOGIN [VINHOS-ALIANCA\suporte.totvs]  FROM WINDOWS WITH DEFAULT_DATABASE=[master]
	ALTER LOGIN [VINHOS-ALIANCA\suporte.totvs]  WITH DEFAULT_DATABASE=[protheus],   DEFAULT_LANGUAGE=[us_english]
use protheus
	CREATE USER [VINHOS-ALIANCA\suporte.totvs]  FOR LOGIN [VINHOS-ALIANCA\suporte.totvs]
	ALTER USER [VINHOS-ALIANCA\suporte.totvs]  WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE TO [VINHOS-ALIANCA\suporte.totvs]



-- Contas de usuarios do setor de informatica
USE [master]
	CREATE LOGIN [VINHOS-ALIANCA\robert.koch]    FROM WINDOWS WITH DEFAULT_DATABASE=[master]
	CREATE LOGIN [VINHOS-ALIANCA\sandra.sugari]  FROM WINDOWS WITH DEFAULT_DATABASE=[master]
	CREATE LOGIN [VINHOS-ALIANCA\claudia.lionco] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
	CREATE LOGIN [VINHOS-ALIANCA\daiana.ribas]   FROM WINDOWS WITH DEFAULT_DATABASE=[master]
	ALTER LOGIN [VINHOS-ALIANCA\robert.koch]    WITH DEFAULT_DATABASE=[protheus],   DEFAULT_LANGUAGE=[us_english]
	ALTER LOGIN [VINHOS-ALIANCA\sandra.sugari]  WITH DEFAULT_DATABASE=[protheus],   DEFAULT_LANGUAGE=[us_english]
	ALTER LOGIN [VINHOS-ALIANCA\claudia.lionco] WITH DEFAULT_DATABASE=[protheus],   DEFAULT_LANGUAGE=[us_english]
	ALTER LOGIN [VINHOS-ALIANCA\daiana.ribas]   WITH DEFAULT_DATABASE=[naweb],      DEFAULT_LANGUAGE=[us_english]
	GRANT VIEW SERVER STATE, ALTER ANY CONNECTION TO [VINHOS-ALIANCA\robert.koch]  -- VIEW SERVER STATE = usar o monitor; ALTER ANY CONNECTION = derrubar conexoes presas
	GRANT VIEW SERVER STATE, ALTER ANY CONNECTION TO [VINHOS-ALIANCA\sandra.sugari]  -- VIEW SERVER STATE = usar o monitor; ALTER ANY CONNECTION = derrubar conexoes presas
	GRANT VIEW SERVER STATE, ALTER ANY CONNECTION TO [VINHOS-ALIANCA\claudia.lionco]  -- VIEW SERVER STATE = usar o monitor; ALTER ANY CONNECTION = derrubar conexoes presas
	GRANT VIEW SERVER STATE, ALTER ANY CONNECTION TO [VINHOS-ALIANCA\daiana.ribas]  -- VIEW SERVER STATE = usar o monitor; ALTER ANY CONNECTION = derrubar conexoes presas
	ALTER SERVER ROLE [sysadmin] ADD MEMBER [VINHOS-ALIANCA\robert.koch]  -- Com grandes poderes vem grandes responsabilidades [Tio Ben Parker]
USE [msdb]  -- Acessos para manutencao dos jobs
	CREATE USER [VINHOS-ALIANCA\robert.koch]    FOR LOGIN [VINHOS-ALIANCA\robert.koch]
	CREATE USER [VINHOS-ALIANCA\sandra.sugari]  FOR LOGIN [VINHOS-ALIANCA\sandra.sugari]
	CREATE USER [VINHOS-ALIANCA\claudia.lionco] FOR LOGIN [VINHOS-ALIANCA\claudia.lionco]
	CREATE USER [VINHOS-ALIANCA\daiana.ribas]   FOR LOGIN [VINHOS-ALIANCA\daiana.ribas]
	ALTER ROLE [SQLAgentOperatorRole] ADD MEMBER [VINHOS-ALIANCA\robert.koch]  -- Este acesso jah inclui SQLAgentReaderRole e SQLAgentUserRole
	ALTER ROLE [SQLAgentOperatorRole] ADD MEMBER [VINHOS-ALIANCA\sandra.sugari]  -- Este acesso jah inclui SQLAgentReaderRole e SQLAgentUserRole
	ALTER ROLE [SQLAgentOperatorRole] ADD MEMBER [VINHOS-ALIANCA\claudia.lionco]  -- Este acesso jah inclui SQLAgentReaderRole e SQLAgentUserRole
	ALTER ROLE [SQLAgentOperatorRole] ADD MEMBER [VINHOS-ALIANCA\daiana.ribas]  -- Este acesso jah inclui SQLAgentReaderRole e SQLAgentUserRole
USE protheus  -- Executar uma vez para cada database: protheus_teste, protheus_11, CTB2010, ...
	CREATE USER [VINHOS-ALIANCA\robert.koch]    FOR LOGIN [VINHOS-ALIANCA\robert.koch]
	CREATE USER [VINHOS-ALIANCA\sandra.sugari]  FOR LOGIN [VINHOS-ALIANCA\sandra.sugari]
	CREATE USER [VINHOS-ALIANCA\claudia.lionco] FOR LOGIN [VINHOS-ALIANCA\claudia.lionco]
	CREATE USER [VINHOS-ALIANCA\daiana.ribas]   FOR LOGIN [VINHOS-ALIANCA\daiana.ribas]
	ALTER USER [VINHOS-ALIANCA\robert.koch]    WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\sandra.sugari]  WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\claudia.lionco] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\daiana.ribas]   WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [VINHOS-ALIANCA\robert.koch]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [VINHOS-ALIANCA\sandra.sugari]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [VINHOS-ALIANCA\claudia.lionco]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [VINHOS-ALIANCA\daiana.ribas]
USE BI_ALIANCA
	CREATE USER [VINHOS-ALIANCA\robert.koch]    FOR LOGIN [VINHOS-ALIANCA\robert.koch]
	CREATE USER [VINHOS-ALIANCA\sandra.sugari]  FOR LOGIN [VINHOS-ALIANCA\sandra.sugari]
	CREATE USER [VINHOS-ALIANCA\claudia.lionco] FOR LOGIN [VINHOS-ALIANCA\claudia.lionco]
	CREATE USER [VINHOS-ALIANCA\daiana.ribas]   FOR LOGIN [VINHOS-ALIANCA\daiana.ribas]
	ALTER USER [VINHOS-ALIANCA\robert.koch]    WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\sandra.sugari]  WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\claudia.lionco] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\daiana.ribas]   WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE TO [VINHOS-ALIANCA\robert.koch]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE TO [VINHOS-ALIANCA\sandra.sugari]
	GRANT ALTER TO [VINHOS-ALIANCA\claudia.lionco]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE TO [VINHOS-ALIANCA\daiana.ribas]
	GRANT ALTER TO [VINHOS-ALIANCA\robert.koch]
USE [naweb]
	CREATE USER [VINHOS-ALIANCA\robert.koch] FOR LOGIN [VINHOS-ALIANCA\robert.koch]
	CREATE USER [VINHOS-ALIANCA\claudia.lionco] FOR LOGIN [VINHOS-ALIANCA\claudia.lionco]
	CREATE USER [VINHOS-ALIANCA\daiana.ribas] FOR LOGIN [VINHOS-ALIANCA\daiana.ribas]
	CREATE USER [VINHOS-ALIANCA\sandra.sugari] FOR LOGIN [VINHOS-ALIANCA\sandra.sugari]
	ALTER USER [VINHOS-ALIANCA\robert.koch] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\claudia.lionco] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\daiana.ribas] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\sandra.sugari] WITH DEFAULT_SCHEMA=[dbo]
	ALTER ROLE [db_owner] ADD MEMBER [VINHOS-ALIANCA\daiana.ribas]
	ALTER ROLE [db_owner] ADD MEMBER [VINHOS-ALIANCA\robert.koch]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE TO [VINHOS-ALIANCA\claudia.lionco]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE TO [VINHOS-ALIANCA\sandra.sugari]
USE SIRH
	CREATE LOGIN [VINHOS-ALIANCA\robert.koch] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
	CREATE LOGIN [VINHOS-ALIANCA\sandra.sugari] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
	CREATE USER [VINHOS-ALIANCA\robert.koch] FOR LOGIN [VINHOS-ALIANCA\robert.koch]
	CREATE USER [VINHOS-ALIANCA\sandra.sugari] FOR LOGIN [VINHOS-ALIANCA\sandra.sugari]
	ALTER USER [VINHOS-ALIANCA\robert.koch] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\sandra.sugari] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE TO [VINHOS-ALIANCA\robert.koch]
	GRANT SELECT ON [dbo].[VA_VFUNCIONARIOS] TO [VINHOS-ALIANCA\sandra.sugari]
USE TI
	CREATE USER [VINHOS-ALIANCA\robert.koch] FOR LOGIN [VINHOS-ALIANCA\robert.koch]
	CREATE USER [VINHOS-ALIANCA\sandra.sugari] FOR LOGIN [VINHOS-ALIANCA\sandra.sugari]
	CREATE USER [VINHOS-ALIANCA\claudia.lionco] FOR LOGIN [VINHOS-ALIANCA\claudia.lionco]
	CREATE USER [VINHOS-ALIANCA\daiana.ribas] FOR LOGIN [VINHOS-ALIANCA\daiana.ribas]
	ALTER USER [VINHOS-ALIANCA\robert.koch] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\sandra.sugari] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\claudia.lionco] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\daiana.ribas] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [VINHOS-ALIANCA\robert.koch]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [VINHOS-ALIANCA\sandra.sugari]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [VINHOS-ALIANCA\claudia.lionco]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE, ALTER TO [VINHOS-ALIANCA\daiana.ribas]
USE MercanetPRD
	CREATE USER [VINHOS-ALIANCA\robert.koch] FOR LOGIN [VINHOS-ALIANCA\robert.koch]
	CREATE USER [VINHOS-ALIANCA\sandra.sugari] FOR LOGIN [VINHOS-ALIANCA\sandra.sugari]
	CREATE USER [VINHOS-ALIANCA\claudia.lionco] FOR LOGIN [VINHOS-ALIANCA\claudia.lionco]
	ALTER USER [VINHOS-ALIANCA\robert.koch] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\sandra.sugari] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\claudia.lionco] WITH DEFAULT_SCHEMA=[dbo]
	GRANT update ON [dbo].[ZC5010] TO [VINHOS-ALIANCA\robert.koch]
	GRANT update ON [dbo].[ZC5010] TO [VINHOS-ALIANCA\sandra.sugari]
	GRANT update ON [dbo].[ZC5010] TO [VINHOS-ALIANCA\claudia.lionco]
	GRANT update ON [dbo].[ZA1010] TO [VINHOS-ALIANCA\robert.koch]
	GRANT update ON [dbo].[ZA1010] TO [VINHOS-ALIANCA\sandra.sugari]
	GRANT update ON [dbo].[ZA1010] TO [VINHOS-ALIANCA\claudia.lionco]
	GRANT SELECT, SHOWPLAN, EXECUTE, VIEW DEFINITION, VIEW DATABASE STATE, CREATE PROCEDURE, ALTER TO [VINHOS-ALIANCA\robert.koch]
	GRANT SELECT, SHOWPLAN, EXECUTE, VIEW DEFINITION, VIEW DATABASE STATE, CREATE PROCEDURE, ALTER TO [VINHOS-ALIANCA\sandra.sugari]
	GRANT SELECT, SHOWPLAN, EXECUTE, VIEW DEFINITION, VIEW DATABASE STATE, CREATE PROCEDURE, ALTER TO [VINHOS-ALIANCA\claudia.lionco]
	-- PRECISA LIBERAR AS PROCEDURES UMA A UMA
	GRANT ALTER ON [dbo].[MERCP_CONCORRENTE_INTEGRACOES] TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_INTEGRA_REGRAS_FISCAIS]  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_CC2010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_CC3010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_DA0010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_DA1010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SA1010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SA3010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SA4010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SA6010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SB1010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SBM010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SC5010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SC6010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SD1010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SD2010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SE1010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SE3010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SE4010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SE5010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SF1010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SF2010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SF4010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SX5010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_SYA010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_ZAZ010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
	GRANT ALTER ON [dbo].[MERCP_ZX5010]                  TO [VINHOS-ALIANCA\robert.koch], [VINHOS-ALIANCA\claudia.lionco]
USE BL01  -- Database para importação do BL01 (leitura grau uva - Maseli)
	CREATE USER [VINHOS-ALIANCA\robert.koch] FOR LOGIN [VINHOS-ALIANCA\robert.koch]
	ALTER USER [VINHOS-ALIANCA\robert.koch] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, INSERT, ALTER, DELETE, UPDATE TO [VINHOS-ALIANCA\robert.koch]
USE [TI]
	CREATE USER [VINHOS-ALIANCA\robert.koch] FOR LOGIN [VINHOS-ALIANCA\robert.koch]
	CREATE USER [VINHOS-ALIANCA\sandra.sugari] FOR LOGIN [VINHOS-ALIANCA\sandra.sugari]
	CREATE USER [VINHOS-ALIANCA\claudia.lionco] FOR LOGIN [VINHOS-ALIANCA\claudia.lionco]
	CREATE USER [VINHOS-ALIANCA\daiana.ribas] FOR LOGIN [VINHOS-ALIANCA\daiana.ribas]
	ALTER USER [VINHOS-ALIANCA\robert.koch] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\sandra.sugari] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\claudia.lionco] WITH DEFAULT_SCHEMA=[dbo]
	ALTER USER [VINHOS-ALIANCA\daiana.ribas] WITH DEFAULT_SCHEMA=[dbo]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE TO [VINHOS-ALIANCA\robert.koch]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE TO [VINHOS-ALIANCA\sandra.sugari]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE TO [VINHOS-ALIANCA\claudia.lionco]
	GRANT SELECT, SHOWPLAN, INSERT, UPDATE, DELETE, VIEW DEFINITION, VIEW DATABASE STATE, EXECUTE, CREATE VIEW, CREATE TABLE, CREATE PROCEDURE TO [VINHOS-ALIANCA\daiana.ribas]
	GRANT ALTER TO [VINHOS-ALIANCA\robert.koch]


