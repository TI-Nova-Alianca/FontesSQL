




-- Descricao..: View para o PowerBI ler dados de rendimentos de OPs de vinificacao
--              (nao faz a laitura direto do database do Protheus por que o usuario
--              que sincroniza o PowerBI nao tem acesso a esse database.)
-- Data.......: 24/01/2024
-- Autor......: Robert Koch
--
-- Historico de alteracoes:
--

ALTER VIEW [dbo].[VPBI_RENDIMENTOS_VINIFICACAO]
AS 
	SELECT *
	FROM protheus.dbo.VA_VRENDIMENTOS_VINIFICACAO
	where SAFRA >= '2015'  -- Nao adianta olhar dados muito antigos e pouco confiaveis


