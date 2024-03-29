



ALTER VIEW [dbo].[VPBI_PEDIDOS_DE_VENDA]
AS

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de pedidos de venda, para uso no PowerBI
-- Autor: Robert Koch
-- Data:  03/2022
-- Historico de alteracoes:
-- 21/04/2022 - Robert - Ampliado periodo para buscar pedidos a partir de 2017.
-- 17/08/2022 - Robert - Adicionadas colunas vend1, vend2, vaest, codlin, vamarcm, prcven
-- 05/09/2022 - Robert - Incluido campo B1_TIPO
-- 04/01/2023 - Robert - Filtra pelo C5_EMISSAO e nao mais pelo C6_EMISS (que estah vazio em alguns pedidos)
-- 13/02/2023 - Robert - Passa a mostrar somente pedidos com saldo
-- 15/02/2023 - Robert - Passa a mostrar somente C5_TIPO='N' e F4_MARGEM='1'
--

WITH C AS (
SELECT
	C6_FILIAL
	,C6_NUM
	,SC6.C6_PRODUTO
	,SC5.C5_CLIENTE
	,SC5.C5_LOJACLI
	,protheus.dbo.VA_FSTATUS_PED_VENDA(C5_FILIAL, C5_NUM) AS STATUS_PEDIDO
	,SC6.C6_QTDVEN
	,SC6.C6_QTDENT
	,CASE
		WHEN SC6.C6_BLQ = 'R' THEN SC6.C6_QTDVEN - SC6.C6_QTDENT
		ELSE 0
	END AS QTD_CANCELADA
	,SC6.C6_PRCVEN   -- PRECO DE VENDA
	,SC5.C5_EMISSAO as C6_EMISS
	,SC6.C6_ENTREG
	,SC5.C5_VEND1    -- REPRESENTANTE
	,SC5.C5_VEND2    -- GERENTE/SUPERVISOR
	,SC5.C5_VAEST    -- ESTADO (UF) DO CLIENTE
	,SB1.B1_CODLIN   -- VINCULADO A VPBI_LINHAS_COMERCIAIS
	,SB1.B1_VAMARCM  -- VINCULADO A VPBI_MARCAS_COMERCIAIS
	,SB1.B1_TIPO
FROM protheus.dbo.SC6010 SC6
	,protheus.dbo.SC5010 SC5
	,protheus.dbo.SB1010 SB1
	,protheus.dbo.SF4010 SF4
WHERE SC6.D_E_L_E_T_ = ''
AND SC5.D_E_L_E_T_ = ''
AND SC5.C5_FILIAL = SC6.C6_FILIAL
AND SC5.C5_NUM = SC6.C6_NUM
AND SC5.C5_EMISSAO >= '20170101'
AND SC5.C5_TIPO = 'N'
AND SB1.D_E_L_E_T_ = ''
AND B1_FILIAL = '  '
AND B1_COD = C6_PRODUTO
AND SF4.D_E_L_E_T_ = ''
AND SF4.F4_FILIAL = '  '
AND SF4.F4_CODIGO = SC6.C6_TES
AND SF4.F4_MARGEM = '1'
)
SELECT *
FROM C
WHERE C6_QTDVEN > (C6_QTDENT + QTD_CANCELADA)  -- QUERO VER APENAS PEDIDOS EM ABERTO


