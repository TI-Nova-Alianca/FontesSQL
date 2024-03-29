
-- Descricao: Recebe solicitacoes de consultas do NaWeb e grava retorno em tabela de integracao
-- Autor: Julio Pedroni
-- Data: 2018
--
-- Historico de alteracoes:
-- 10/09/2018 - Robert - Grava arquivo de log com tempo de execucao para posterior analise.
--

ALTER PROCEDURE [dbo].[NAWEB_EXECUTE]
	@CHAVE NVARCHAR(60),
	@TABELA NVARCHAR(60),
	@SQL   NVARCHAR(MAX)
AS
BEGIN
	
	-- LIMPA DADOS ANTIGOS E GRAVA QUERY EM ARQUIVO DE LOG PARA FUTURAS DEPURACOES.
	/*
	CREATE TABLE [dbo].[VA_LOGS](
		[CHAVE_NAWEB] [varchar](60) NOT NULL,
		[DATAHORA] [datetime] NULL,
		[ORIGEM] [varchar](max) NULL,
		[TEXTO] [varchar](max) NULL,
		[TEMPO_EXEC] [float] NULL,
		INDEX [VA_LOGS_DATAHORA_CHAVE_NAWEB] CLUSTERED ([DATAHORA], [CHAVE_NAWEB] ASC)
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	GO
	*/
	DECLARE @HORAINI DATETIME;
	SET @HORAINI = GETDATE ();
	DELETE VA_LOGS WHERE DATAHORA < DATEADD (DAY, -5, @HORAINI)  -- DEIXA APENAS OS ULTIMOS DIAS
	INSERT INTO VA_LOGS (DATAHORA, CHAVE_NAWEB, ORIGEM, TEXTO) VALUES (@HORAINI, @CHAVE, 'NAWEB_EXECUTE', @SQL)
	
	-- Deleta conteudo anterior, tanto na base quente como na base teste, para nao ficar sobrando lixo.
	DELETE FROM [naweb].[dbo].[VA_INTEGRA_NAWEB] WHERE NAWEB_CHAVE LIKE '%' + SUBSTRING(@CHAVE, 1, CHARINDEX('-', @CHAVE)) + '%' AND NAWEB_TABELA = @TABELA;
	DELETE FROM [naweb_teste].[dbo].[VA_INTEGRA_NAWEB] WHERE NAWEB_CHAVE LIKE '%' + SUBSTRING(@CHAVE, 1, CHARINDEX('-', @CHAVE)) + '%' AND NAWEB_TABELA = @TABELA;
	EXECUTE(@SQL)

	-- GRAVA NO ARQUIVO DE LOGS O TEMPO QUE DEMOROU PARA EXECUTAR
	UPDATE VA_LOGS SET TEMPO_EXEC = DATEDIFF (SECOND, DATAHORA, GETDATE()) WHERE CHAVE_NAWEB = @CHAVE AND DATAHORA = @HORAINI;

END









