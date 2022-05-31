SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Descricao: Retorna conteudo de campo memo lido do SYP.
-- Autor....: Robert Koch
-- Data.....: 28/10/2014
--
-- Historico de alteracoes:
-- 19/06/2015 - Robert - Removida funcao STUFF, que estava perdendo o inicio do memo original.
--

ALTER FUNCTION [dbo].[VA_FLE_MEMO]
(
	@FILIAL  VARCHAR(2),
	@CHAVE   VARCHAR(6)
)
RETURNS VARCHAR(MAX)
AS

BEGIN
	-- ainda falta melhorar bastante... 
	RETURN (
	    SELECT 
	               (
	                   SELECT RTRIM(YP_TEXTO)
	                   FROM   SYP010 AS Y2
	                   WHERE  Y2.D_E_L_E_T_ = ''
	                          AND Y2.YP_FILIAL = Y1.YP_FILIAL
	                          AND Y2.YP_CHAVE = Y1.YP_CHAVE
	                          AND Y2.YP_SEQ >= Y1.YP_SEQ
	                   ORDER BY
	                          YP_SEQ
	                          FOR XML PATH(''),
	                          TYPE
	               ).value ('.', 'VARCHAR (MAX)') AS TEXTO
	    FROM   SYP010 Y1
	    WHERE  YP_FILIAL = @FILIAL
	           AND YP_CHAVE = @CHAVE
	           AND Y1.YP_SEQ = '001'
	)
END
GO
