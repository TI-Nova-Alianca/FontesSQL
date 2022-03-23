SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Descricao: Cria sononimos para os caminhos/nomes das tabelas com integracao com ERP.
--            Royalties para https://www.baud.cz/blog/database-alias-in-microsoft-sql-server
-- Autor....: Robert Koch
-- Data.....: 17/03/2022
--
-- Historico de alteracoes:
-- 23/03/2022 - Robert - Criado sinonimo para VA_VRAPEL_PADRAO
--

alter PROCEDURE [dbo].[MERCP_CRIA_SINONIMOS_TABELAS] AS
BEGIN

    -- Cria sononimos para os caminhos/nomes das tabelas, de modo que possa ser usada a mesma
    -- rotina de integracao, mas de forma que essa rotina 'veja' a base de dados correta do
    -- Protheus, conforme o ambiente em que estiver sendo executada:
    --        MercanetPRD <---> protheus
    --        MercanetHML <---> protheus_teste
    --
    -- Elimina e recria sempre os sinomimos, de forma que, quando a base de dados for copiada da producao
    -- para homologacao, nao seja necessario dar manutencao manual nos sinonimos.
    drop synonym if exists INTEGRACAO_PROTHEUS_CC2
    drop synonym if exists INTEGRACAO_PROTHEUS_CC3
    drop synonym if exists INTEGRACAO_PROTHEUS_DA0
    drop synonym if exists INTEGRACAO_PROTHEUS_DA1
    drop synonym if exists INTEGRACAO_PROTHEUS_SA1
    drop synonym if exists INTEGRACAO_PROTHEUS_SA3
    drop synonym if exists INTEGRACAO_PROTHEUS_SA4
    drop synonym if exists INTEGRACAO_PROTHEUS_SA5
    drop synonym if exists INTEGRACAO_PROTHEUS_SA6
    drop synonym if exists INTEGRACAO_PROTHEUS_SB1
    drop synonym if exists INTEGRACAO_PROTHEUS_SB5
    drop synonym if exists INTEGRACAO_PROTHEUS_SBM
    drop synonym if exists INTEGRACAO_PROTHEUS_SC5
    drop synonym if exists INTEGRACAO_PROTHEUS_SC6
    drop synonym if exists INTEGRACAO_PROTHEUS_SD1
    drop synonym if exists INTEGRACAO_PROTHEUS_SD2
    drop synonym if exists INTEGRACAO_PROTHEUS_SE1
    drop synonym if exists INTEGRACAO_PROTHEUS_SE3
    drop synonym if exists INTEGRACAO_PROTHEUS_SE4
    drop synonym if exists INTEGRACAO_PROTHEUS_SE5
    drop synonym if exists INTEGRACAO_PROTHEUS_SF1
    drop synonym if exists INTEGRACAO_PROTHEUS_SF2
    drop synonym if exists INTEGRACAO_PROTHEUS_SF4
    drop synonym if exists INTEGRACAO_PROTHEUS_SX5
    drop synonym if exists INTEGRACAO_PROTHEUS_SYA
    drop synonym if exists INTEGRACAO_PROTHEUS_ZAZ
    drop synonym if exists INTEGRACAO_PROTHEUS_ZC5
    drop synonym if exists INTEGRACAO_PROTHEUS_ZC6
    drop synonym if exists INTEGRACAO_PROTHEUS_ZX5
    drop synonym if exists INTEGRACAO_PROTHEUS_VA_VRAPEL_PADRAO

    if (select DB_NAME()) = 'MercanetPRD'
    BEGIN
        print 'Criando sinonimos para ambiente de PRODUCAO'
        create synonym INTEGRACAO_PROTHEUS_CC2 for LKSRV_PROTHEUS.protheus.dbo.CC2010
        create synonym INTEGRACAO_PROTHEUS_CC3 for LKSRV_PROTHEUS.protheus.dbo.CC3010
        create synonym INTEGRACAO_PROTHEUS_DA0 for LKSRV_PROTHEUS.protheus.dbo.DA0010
        create synonym INTEGRACAO_PROTHEUS_DA1 for LKSRV_PROTHEUS.protheus.dbo.DA1010
        create synonym INTEGRACAO_PROTHEUS_SA1 for LKSRV_PROTHEUS.protheus.dbo.SA1010
        create synonym INTEGRACAO_PROTHEUS_SA3 for LKSRV_PROTHEUS.protheus.dbo.SA3010
        create synonym INTEGRACAO_PROTHEUS_SA4 for LKSRV_PROTHEUS.protheus.dbo.SA4010
        create synonym INTEGRACAO_PROTHEUS_SA5 for LKSRV_PROTHEUS.protheus.dbo.SA5010
        create synonym INTEGRACAO_PROTHEUS_SA6 for LKSRV_PROTHEUS.protheus.dbo.SA6010
        create synonym INTEGRACAO_PROTHEUS_SB1 for LKSRV_PROTHEUS.protheus.dbo.SB1010
        create synonym INTEGRACAO_PROTHEUS_SB5 for LKSRV_PROTHEUS.protheus.dbo.SB5010
        create synonym INTEGRACAO_PROTHEUS_SBM for LKSRV_PROTHEUS.protheus.dbo.SBM010
        create synonym INTEGRACAO_PROTHEUS_SC5 for LKSRV_PROTHEUS.protheus.dbo.SC5010
        create synonym INTEGRACAO_PROTHEUS_SC6 for LKSRV_PROTHEUS.protheus.dbo.SC6010
        create synonym INTEGRACAO_PROTHEUS_SD1 for LKSRV_PROTHEUS.protheus.dbo.SD1010
        create synonym INTEGRACAO_PROTHEUS_SD2 for LKSRV_PROTHEUS.protheus.dbo.SD2010
        create synonym INTEGRACAO_PROTHEUS_SE1 for LKSRV_PROTHEUS.protheus.dbo.SE1010
        create synonym INTEGRACAO_PROTHEUS_SE3 for LKSRV_PROTHEUS.protheus.dbo.SE3010
        create synonym INTEGRACAO_PROTHEUS_SE4 for LKSRV_PROTHEUS.protheus.dbo.SE4010
        create synonym INTEGRACAO_PROTHEUS_SE5 for LKSRV_PROTHEUS.protheus.dbo.SE5010
        create synonym INTEGRACAO_PROTHEUS_SF1 for LKSRV_PROTHEUS.protheus.dbo.SF1010
        create synonym INTEGRACAO_PROTHEUS_SF2 for LKSRV_PROTHEUS.protheus.dbo.SF2010
        create synonym INTEGRACAO_PROTHEUS_SF4 for LKSRV_PROTHEUS.protheus.dbo.SF4010
        create synonym INTEGRACAO_PROTHEUS_SX5 for LKSRV_PROTHEUS.protheus.dbo.SX5010
        create synonym INTEGRACAO_PROTHEUS_SYA for LKSRV_PROTHEUS.protheus.dbo.SYA010
        create synonym INTEGRACAO_PROTHEUS_ZAZ for LKSRV_PROTHEUS.protheus.dbo.ZAZ010
        create synonym INTEGRACAO_PROTHEUS_ZC5 for LKSRV_PROTHEUS.protheus.dbo.ZC5010
        create synonym INTEGRACAO_PROTHEUS_ZC6 for LKSRV_PROTHEUS.protheus.dbo.ZC6010
        create synonym INTEGRACAO_PROTHEUS_ZX5 for LKSRV_PROTHEUS.protheus.dbo.ZX5010
        create synonym INTEGRACAO_PROTHEUS_VA_VRAPEL_PADRAO for LKSRV_PROTHEUS.protheus.dbo.VA_VRAPEL_PADRAO
    END
    ELSE
    BEGIN
        print 'Criando sinonimos para ambiente de HOMOLOGACAO'
        create synonym INTEGRACAO_PROTHEUS_CC2 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.CC2010
        create synonym INTEGRACAO_PROTHEUS_CC3 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.CC3010
        create synonym INTEGRACAO_PROTHEUS_DA0 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.DA0010
        create synonym INTEGRACAO_PROTHEUS_DA1 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.DA1010
        create synonym INTEGRACAO_PROTHEUS_SA1 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SA1010
        create synonym INTEGRACAO_PROTHEUS_SA3 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SA3010
        create synonym INTEGRACAO_PROTHEUS_SA4 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SA4010
        create synonym INTEGRACAO_PROTHEUS_SA5 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SA5010
        create synonym INTEGRACAO_PROTHEUS_SA6 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SA6010
        create synonym INTEGRACAO_PROTHEUS_SB1 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SB1010
        create synonym INTEGRACAO_PROTHEUS_SB5 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SB5010
        create synonym INTEGRACAO_PROTHEUS_SBM for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SBM010
        create synonym INTEGRACAO_PROTHEUS_SC5 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SC5010
        create synonym INTEGRACAO_PROTHEUS_SC6 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SC6010
        create synonym INTEGRACAO_PROTHEUS_SD1 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SD1010
        create synonym INTEGRACAO_PROTHEUS_SD2 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SD2010
        create synonym INTEGRACAO_PROTHEUS_SE1 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SE1010
        create synonym INTEGRACAO_PROTHEUS_SE3 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SE3010
        create synonym INTEGRACAO_PROTHEUS_SE4 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SE4010
        create synonym INTEGRACAO_PROTHEUS_SE5 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SE5010
        create synonym INTEGRACAO_PROTHEUS_SF1 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SF1010
        create synonym INTEGRACAO_PROTHEUS_SF2 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SF2010
        create synonym INTEGRACAO_PROTHEUS_SF4 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SF4010
        create synonym INTEGRACAO_PROTHEUS_SX5 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SX5010
        create synonym INTEGRACAO_PROTHEUS_SYA for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.SYA010
        create synonym INTEGRACAO_PROTHEUS_ZAZ for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.ZAZ010
        create synonym INTEGRACAO_PROTHEUS_ZC5 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.ZC5010
        create synonym INTEGRACAO_PROTHEUS_ZC6 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.ZC6010
        create synonym INTEGRACAO_PROTHEUS_ZX5 for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.ZX5010
        create synonym INTEGRACAO_PROTHEUS_VA_VRAPEL_PADRAO for LKSRV_PROTHEUS_TESTE.protheus_teste.dbo.VA_VRAPEL_PADRAO
    END
END
GO
