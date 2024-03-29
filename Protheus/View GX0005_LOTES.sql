
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar os Produtos do Protheus.
-- Autor: ?
-- Data:  ?
-- Historico de alteracoes:
-- 14/02/2022 - Robert - Acrescentada clausula B1_FILIAL = '  '
--

CREATE view [dbo].[GX0005_LOTES]
AS
SELECT
	B8_FILIAL  AS GX0005_FILIAL,
	B8_LOTECTL AS GX0005_LOTE,
	B8_PRODUTO AS GX0005_PRODUTO,
   	B1_DESC    AS GX0005_PRODUTO_DES
FROM SB8010, SB1010
WHERE 
	B8_PRODUTO = B1_COD AND 
	B8_DATA >= '20170101' AND
	SB8010.D_E_L_E_T_ = '' AND 
	SB1010.D_E_L_E_T_ = '' AND
    SB1010.B1_FILIAL = '  '

