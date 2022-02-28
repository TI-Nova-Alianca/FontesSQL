USE [BL01]
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPORTA_TABELA_MEDICAO_CONTINUA_PARA_SERVIDOR]    Script Date: 28/02/2022 15:04:31 ******/
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
--

ALTER PROCEDURE [dbo].[SP_EXPORTA_TABELA_MEDICAO_CONTINUA_PARA_SERVIDOR]
AS
BEGIN

	-- No servidor eh necessario ter uma tabela com a mesma estrutura
	-- Usei um linked server (a ser criado em cada estacao de medicao de grau) para comunicar com o servidor.
	insert into LKSRV_SERVERSQL_BL01.BL01.dbo.MEDICOES_CONTINUAS
		select *
		from MEDICOES_CONTINUAS estacao
		where not exists (select *
						from LKSRV_SERVERSQL_BL01.BL01.dbo.MEDICOES_CONTINUAS servidor
						where servidor.FILIAL = estacao.FILIAL COLLATE DATABASE_DEFAULT
						and servidor.LINHA = estacao.LINHA
						and servidor.HORA = estacao.HORA)  -- Ainda nao deve existir no servidor
		
		-- Somente os ultimos dias para nao ficar muito pesado. Se precisar atualizacao completa, comentariar esta linha.
		and HORA >= dateadd (day, -5, CURRENT_TIMESTAMP)

end
