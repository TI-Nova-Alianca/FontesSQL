USE [BL01]
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPORTA_TABELAS_MEDICOES_CARGAS_PARA_SERVIDOR]    Script Date: 28/02/2022 15:03:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- script a ser agendado EM CADA ESTACAO DE MEDICAO DE GRAU
--
-- Descricao: Exporta dados das tabelas de medicoes de cargas (lidas do Access do BL01) para o servidor.
-- Data:      17/02/2020
-- Autor:     Robert Koch
--
-- Historico de alteracoes:
--

ALTER PROCEDURE [dbo].[SP_EXPORTA_TABELAS_MEDICOES_CARGAS_PARA_SERVIDOR]
AS
BEGIN

	-- No servidor eh necessario ter uma tabela com a mesma estrutura
	-- Usei um linked server (a ser criado em cada estacao de medicao de grau) para comunicar com o servidor.
	insert into LKSRV_SERVERSQL_BL01.BL01.dbo.SQL_BL01_TABLE
		select *
		from SQL_BL01_TABLE estacao
		where not exists (select *
						from LKSRV_SERVERSQL_BL01.BL01.dbo.SQL_BL01_TABLE servidor
						where servidor.ZZA_FILIAL = estacao.ZZA_FILIAL COLLATE DATABASE_DEFAULT
						and servidor.ZZA_SAFRA    = estacao.ZZA_SAFRA  COLLATE DATABASE_DEFAULT
						and servidor.ZZA_CARGA    = estacao.ZZA_CARGA  COLLATE DATABASE_DEFAULT
						and servidor.ZZA_PRODUT   = estacao.ZZA_PRODUT COLLATE DATABASE_DEFAULT)  -- Ainda nao deve existir no servidor


	insert into LKSRV_SERVERSQL_BL01.BL01.dbo.SQL_BL01_SAMPLES
		select *
		from SQL_BL01_SAMPLES estacao
		where not exists (select *
						from LKSRV_SERVERSQL_BL01.BL01.dbo.SQL_BL01_SAMPLES servidor
						where servidor.ZZA_FILIAL = estacao.ZZA_FILIAL COLLATE DATABASE_DEFAULT
						and servidor.ZZA_SAFRA    = estacao.ZZA_SAFRA  COLLATE DATABASE_DEFAULT
						and servidor.ZZA_CARGA    = estacao.ZZA_CARGA  COLLATE DATABASE_DEFAULT
						and servidor.ZZA_PRODUT   = estacao.ZZA_PRODUT COLLATE DATABASE_DEFAULT
						and servidor.SAMPLE       = estacao.SAMPLE)  -- Ainda nao deve existir no servidor

end
