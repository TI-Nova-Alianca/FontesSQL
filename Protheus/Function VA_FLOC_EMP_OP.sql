SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Cooperativa Nova Alianca Ltda
-- Funcao para verificar qual o almoxarifado de onde um produto deve ser empenhado em OP.
-- Autor: Robert Koch
-- Data:  11/05/2017
-- Historico de alteracoes:
-- 22/07/2020 - Robert - Incluido tratamento para itens 4191 e 4360 (almox.08)
--

ALTER FUNCTION [dbo].[VA_FLOC_EMP_OP]
(
	@FILIAL  VARCHAR(2),
	@PRODUTO VARCHAR(15)
)
RETURNS VARCHAR(2)
AS
BEGIN
RETURN (SELECT
		CASE
			WHEN @FILIAL = '01' THEN CASE
					WHEN B1_TIPO = 'ME' OR B1_COD IN ('4191', '4360') THEN '08'
					ELSE CASE
							WHEN B1_TIPO = 'PS' OR
								B1_GRUPO IN ('4000'
								, '0407') THEN '07'
							ELSE B1_LOCPAD
						END
				END
			ELSE B1_LOCPAD
		END
		AS LOCEMP
	FROM SB1010
	WHERE D_E_L_E_T_ = ''
	AND B1_FILIAL = '  '
	AND B1_COD = @PRODUTO)
END
GO
