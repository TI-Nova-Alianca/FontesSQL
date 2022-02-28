SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
-- Descricao: Retorna valor de um titulo do SE2 que foi consumida em fatura
--            Criado inicialmente para relatorios de safra, cujos titulos podem ser
--            parcialmente compensados, pagos ou convertidos em fatura.
-- Autor....: Robert Koch
-- Data.....: 27/02/2022
--
-- Historico de alteracoes:
--

ALTER FUNCTION [dbo].[VA_FSE2_CONSUMIDO_EM_FATURA]
(
	@RECNO_SE2 INT
	,@DTLIMITE VARCHAR (8)
)
RETURNS FLOAT
AS

BEGIN
	RETURN ISNULL ((SELECT SUM (FK2_VALOR)
                      FROM SE2010 SE2,
					       FK7010 FK7,
                           FK2010 FK2
                     WHERE SE2.R_E_C_N_O_ = @RECNO_SE2
					   AND FK7.D_E_L_E_T_ = ''
					   AND FK7.FK7_FILIAL = SE2.E2_FILIAL
					   AND FK7.FK7_ALIAS  = 'SE2'
					   AND FK7.FK7_CHAVE  = SE2.E2_FILIAL + '|' + SE2.E2_PREFIXO + '|' + SE2.E2_NUM + '|' + SE2.E2_PARCELA + '|' + SE2.E2_TIPO + '|' + SE2.E2_FORNECE + '|' + SE2.E2_LOJA
					   AND FK2.D_E_L_E_T_ = ''
					   AND FK2.FK2_FILIAL = FK7.FK7_FILIAL
					   AND FK2.FK2_IDDOC  = FK7.FK7_IDDOC
					   AND FK2.FK2_MOTBX  = 'FAT'
					   AND FK2.FK2_TPDOC != 'ES'  -- ES=Movimento de estorno
					   AND FK2.FK2_DATA  <= @DTLIMITE
					   AND dbo.VA_FESTORNADO_FK2 (FK2.FK2_FILIAL, FK2.FK2_IDFK2) = 0
           ), 0)
END
GO
