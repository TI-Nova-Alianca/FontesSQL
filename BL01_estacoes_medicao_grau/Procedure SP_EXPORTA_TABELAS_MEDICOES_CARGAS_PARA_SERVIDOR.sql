USE [BL01]
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPORTA_TABELAS_MEDICOES_CARGAS_PARA_SERVIDOR]    Script Date: 02/03/2022 09:03:26 ******/
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
-- 01/03/2022 - Robert - Passa a receber filial e safra por parametro
--                     - Gera tabelas temporarias de cargas jah presentes no servidor antes
--                       de fazer o insert (melhora de performance)
--

ALTER PROCEDURE [dbo].[SP_EXPORTA_TABELAS_MEDICOES_CARGAS_PARA_SERVIDOR]
(
	@filial VARCHAR (2)
	,@safra VARCHAR (4)
) AS
BEGIN

	-- Gera uma tabela temporaria com as cargas (TABLE) jah presentes no servidor, para posteriormente
	-- poder verificar se cada medicao deve ou nao ser exportada.
	drop table if exists #BL01_TABLE_jah_no_servidor
	select ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_PRODUT
	      , (select max (SAMPLE)
		       from LKSRV_SERVERSQL_BL01.BL01.dbo.SQL_BL01_SAMPLES S
			  where S.ZZA_FILIAL = T.ZZA_FILIAL
			    and S.ZZA_SAFRA  = T.ZZA_SAFRA
			    and S.ZZA_CARGA  = T.ZZA_CARGA
			    and S.ZZA_PRODUT = T.ZZA_PRODUT) as maior_sample
		into #BL01_TABLE_jah_no_servidor
		from LKSRV_SERVERSQL_BL01.BL01.dbo.SQL_BL01_TABLE T
		where ZZA_FILIAL = @filial
		  and ZZA_SAFRA  = @safra
	create nonclustered index ind1 on #BL01_TABLE_jah_no_servidor (ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_PRODUT)
	PRINT 'GEREI TABELA 1'

	-- Gera uma tabela temporaria com as amostras (SAMPLE) jah presentes no servidor, para posteriormente
	-- poder verificar se cada medicao deve ou nao ser exportada.
	drop table if exists #BL01_SAMPLE_jah_no_servidor
	select ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_PRODUT, SAMPLE
		into #BL01_SAMPLE_jah_no_servidor
		from LKSRV_SERVERSQL_BL01.BL01.dbo.SQL_BL01_SAMPLES
		where ZZA_FILIAL = @filial
		  and ZZA_SAFRA  = @safra
	create nonclustered index ind1 on #BL01_SAMPLE_jah_no_servidor (ZZA_FILIAL, ZZA_SAFRA, ZZA_CARGA, ZZA_PRODUT, SAMPLE)
	PRINT 'GEREI TABELA 2'

	-- No servidor eh necessario ter uma tabela com a mesma estrutura
	-- Usei um linked server (a ser criado em cada estacao de medicao de grau) para comunicar com o servidor.
	insert into LKSRV_SERVERSQL_BL01.BL01.dbo.SQL_BL01_TABLE
		select *
		from SQL_BL01_TABLE estacao
	   where not exists (select *
						--from LKSRV_SERVERSQL_BL01.BL01.dbo.SQL_BL01_TABLE servidor
						from #BL01_TABLE_jah_no_servidor servidor
						where servidor.ZZA_FILIAL = estacao.ZZA_FILIAL COLLATE DATABASE_DEFAULT
						and servidor.ZZA_SAFRA    = estacao.ZZA_SAFRA  COLLATE DATABASE_DEFAULT
						and servidor.ZZA_CARGA    = estacao.ZZA_CARGA  COLLATE DATABASE_DEFAULT
						and servidor.ZZA_PRODUT   = estacao.ZZA_PRODUT COLLATE DATABASE_DEFAULT)  -- Ainda nao deve existir no servidor
		  and ZZA_FILIAL = @filial
		  and ZZA_SAFRA  = @safra
	PRINT 'INSERI DADOS 1'


	insert into LKSRV_SERVERSQL_BL01.BL01.dbo.SQL_BL01_SAMPLES
		select *
		from SQL_BL01_SAMPLES estacao
		  where not exists (select *
						--from LKSRV_SERVERSQL_BL01.BL01.dbo.SQL_BL01_SAMPLES servidor
						from #BL01_SAMPLE_jah_no_servidor servidor
						where servidor.ZZA_FILIAL  = estacao.ZZA_FILIAL COLLATE DATABASE_DEFAULT
						and servidor.ZZA_SAFRA     = estacao.ZZA_SAFRA  COLLATE DATABASE_DEFAULT
						and servidor.ZZA_CARGA     = estacao.ZZA_CARGA  COLLATE DATABASE_DEFAULT
						and servidor.ZZA_PRODUT    = estacao.ZZA_PRODUT COLLATE DATABASE_DEFAULT
						and servidor.SAMPLE        = estacao.SAMPLE)  -- Ainda nao deve existir no servidor
		  and ZZA_FILIAL = @filial
		  and ZZA_SAFRA  = @safra
	PRINT 'INSERI DADOS 2'

end
