USE [BL01]
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPORTA_TABELA_MEDICAO_CONTINUA_PARA_SERVIDOR]    Script Date: 02/03/2022 08:59:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- script a ser agendado EM CADA ESTACAO DE MEDICAO DE GRAU
--
-- Descricao: Exporta dados da tabela de medicao continua de grau, da estacao para o servidor
-- Data:      24/01/202
-- Autor:     Robert Koch
--
-- Historico de alteracoes:
-- 01/03/2022 - Robert - Passa a receber filial e safra por parametro
--                     - Gera tabelas temporarias de cargas jah presentes no servidor antes
--                       de fazer o insert (melhora de performance)
--

ALTER PROCEDURE [dbo].[SP_EXPORTA_TABELA_MEDICAO_CONTINUA_PARA_SERVIDOR]
(
	@filial VARCHAR (2)
	,@safra VARCHAR (4)
) AS
BEGIN

	-- Gera uma tabela temporaria com as medicoes jah presentes no servidor, para posteriormente
	-- poder verificar se cada medicao deve ou nao ser exportada.
	drop table if exists #MEDICOES_CONTINUAS_jah_no_servidor
	select FILIAL, LINHA, HORA
		into #MEDICOES_CONTINUAS_jah_no_servidor
		from LKSRV_SERVERSQL_BL01.BL01.dbo.MEDICOES_CONTINUAS T
		where FILIAL = cast (@filial as int)
		  and HORA >= @safra
	create nonclustered index ind1 on #MEDICOES_CONTINUAS_jah_no_servidor (FILIAL, LINHA, HORA)
	PRINT 'GEREI TABELA 1'

	-- No servidor eh necessario ter uma tabela com a mesma estrutura
	-- Usei um linked server (a ser criado em cada estacao de medicao de grau) para comunicar com o servidor.
	insert into LKSRV_SERVERSQL_BL01.BL01.dbo.MEDICOES_CONTINUAS
		select top 10000 *  -- poucos registros por vez para nao ficar pesado
	     from MEDICOES_CONTINUAS estacao
		where not exists (select *
					--	from LKSRV_SERVERSQL_BL01.BL01.dbo.MEDICOES_CONTINUAS servidor
						from #MEDICOES_CONTINUAS_jah_no_servidor servidor
						where servidor.FILIAL = estacao.FILIAL COLLATE DATABASE_DEFAULT
						and servidor.LINHA = estacao.LINHA
						and servidor.HORA = estacao.HORA)  -- Ainda nao deve existir no servidor
		  and FILIAL = cast (@filial as int)
		  and HORA >= @safra
		
		-- Somente os ultimos dias para nao ficar muito pesado. Se precisar atualizacao completa, comentariar esta linha.
--		and HORA >= dateadd (day, -5, CURRENT_TIMESTAMP)
	PRINT 'INSERI DADOS 1'

end
