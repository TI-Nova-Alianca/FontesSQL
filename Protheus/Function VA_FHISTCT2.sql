SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Descricao: Retorna historico completo de lcto do CT2, concatenando as sequencias de continuacao de historico.
-- Autor....: Robert Koch
-- Data.....: 19/09/2015
--
-- Historico de alteracoes:
--

ALTER FUNCTION [dbo].[VA_FHISTCT2]
(
	@RECNO INT
)
RETURNS VARCHAR(MAX)
AS

BEGIN
	RETURN (
		SELECT BASE.CT2_HIST
		       + ISNULL ((
						SELECT RTRIM(CONT.CT2_HIST)
						FROM CT2010 AS CONT
						WHERE CONT.D_E_L_E_T_ = ''
						AND CONT.CT2_FILIAL = BASE.CT2_FILIAL
						AND CONT.CT2_DATA = BASE.CT2_DATA
						AND CONT.CT2_LOTE = BASE.CT2_LOTE
						AND CONT.CT2_SBLOTE = BASE.CT2_SBLOTE
						AND CONT.CT2_DOC = BASE.CT2_DOC
						AND CONT.CT2_SEQLAN = BASE.CT2_SEQLAN
						AND CONT.CT2_SEQUEN = BASE.CT2_SEQUEN
						AND CONT.CT2_EMPORI = BASE.CT2_EMPORI
						AND CONT.CT2_FILORI = BASE.CT2_FILORI
						AND CONT.CT2_SEQHIS > BASE.CT2_SEQHIS
						ORDER BY CONT.CT2_SEQHIS
						FOR XML PATH (''), TYPE),
						'').value('.', 'VARCHAR (MAX)') AS TEXTO
	FROM CT2010 BASE
	WHERE BASE.R_E_C_N_O_ = @RECNO)
END
GO
