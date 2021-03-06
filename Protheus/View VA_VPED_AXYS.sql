USE [protheus]
GO

/****** Object:  View [dbo].[VA_VPED_AXYS]    Script Date: 10/05/2022 13:40:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de pedidos em aberto, para uso no Axysweb.
-- Autor: Robert Koch
-- Data:  13/10/2015
-- Historico de alteracoes:
-- 11/11/2015 - Robert  - Funcao VA_QTCX renomeada para VA_FQtCx e nao recebe mais parametro de 'empresa'.
-- 10/05/2022 - Claudia - Alterado o peso bruto para B1_PESBRU. GLPI: 11822
--

ALTER VIEW [dbo].[VA_VPED_AXYS] as
SELECT
	SM0.M0_NOME AS EMPRESA,
	SM0.M0_FILIAL AS FILIAL,
	C5_EMISSAO AS EMISSAO,
	C5_NUM AS PEDVENDA,
	dbo.VA_FSTATUS_PED_VENDA (SC5.C5_FILIAL, SC5.C5_NUM) AS STATUS_PEDIDO,
	SC5.C5_CLIENTE + SC5.C5_LOJACLI AS CODCLI,
	RTRIM(ISNULL(CASE
		WHEN SC5.C5_TIPO IN ('B', 'D') THEN RTRIM(SA2.A2_NOME)
		ELSE RTRIM(SA1.A1_NOME)
	END, '')) AS CLIENTE,
	ISNULL(CASE
		WHEN SC5.C5_TIPO IN ('B', 'D') THEN SA2.A2_VACBASE + SA2.A2_VALBASE
		ELSE SA1.A1_VACBASE + SA1.A1_VALBASE
	END, '') AS COD_MAT_CLI,
	ISNULL(CASE
		WHEN SC5.C5_TIPO IN ('B', 'D') THEN dbo.VA_FORMATA_CGC(SA2.A2_CGC)
		ELSE dbo.VA_FORMATA_CGC(SA1.A1_CGC)
	END, '') AS CNPJ_CLI,
	RTRIM(ISNULL(CASE
		WHEN SC5.C5_TIPO IN ('B', 'D') THEN SA2BASE.A2_NOME
		ELSE SA1BASE.A1_NOME
	END, '')) AS MATRIZ_CLIENTE,
	RTRIM(ISNULL(SX5_88.X5_DESCRI, '')) AS LINHA,
	SC6.C6_PRODUTO AS PRODUTO,
	RTRIM(SB1.B1_DESC) AS DESCRICAO,
	RTRIM(ISNULL(SX5_98.X5_DESCRI, '')) AS EMBALAGEM,
	(SC6.C6_QTDVEN - SC6.C6_QTDENT) * SB1.B1_LITROS AS LITRAGEM,
	SC6.C6_UM AS UN_MEDIDA,
	dbo.VA_FQtCx(SC6.C6_PRODUTO, SC6.C6_QTDVEN - SC6.C6_QTDENT) AS QT_CAIXAS,
	RTRIM(ISNULL(SX5_Z7.X5_DESCRI, '')) AS MARCA,
	(SC6.C6_QTDVEN - SC6.C6_QTDENT) * B1_PESBRU AS PESOBRUTO,
	SC6.C6_VALOR + SC6.C6_PVCOND AS VALMERC,
	SB1.B1_VLR_IPI * (SC6.C6_QTDVEN - SC6.C6_QTDENT) AS VALIPI,
	0 AS VALST,
	SC5.C5_VEND1 AS VEND1,
	ISNULL (RTRIM (SA3.A3_NOME), '') AS NOMEVEND,
	SA3.A3_VAGEREN AS COORDENADOR,
	ISNULL (RTRIM (SX5_80.X5_DESCRI), '') AS NOMECOORD,
	C5_TPFRETE AS TIPO_FRETE,
	ISNULL (SA4.A4_NOME, '') AS TRANSP,
	CASE SA1.A1_PESSOA
		WHEN 'F' THEN 'FISICA'
		WHEN 'J' THEN 'JURIDICA'
		WHEN 'X' THEN 'EXTERIOR'
		ELSE '?'
	END AS PESSOA
FROM	SB1010 SB1
		LEFT JOIN SX5010 SX5_88
			ON (SX5_88.D_E_L_E_T_ != '*'
			AND SX5_88.X5_FILIAL = '  '
			AND SX5_88.X5_TABELA = '88'
			AND SX5_88.X5_CHAVE = SB1.B1_CODLIN)
		LEFT JOIN SX5010 SX5_98
			ON (SX5_98.D_E_L_E_T_ != '*'
			AND SX5_98.X5_FILIAL = '  '
			AND SX5_98.X5_TABELA = '98'
			AND SX5_98.X5_CHAVE = SB1.B1_GRPEMB)
		LEFT JOIN SX5010 SX5_Z7
			ON (SX5_Z7.D_E_L_E_T_ != '*'
			AND SX5_Z7.X5_FILIAL = '  '
			AND SX5_Z7.X5_TABELA = 'Z7'
			AND SX5_Z7.X5_CHAVE = SB1.B1_VAMARCM),
		SC6010 SC6,
		SC5010 SC5
		LEFT JOIN SA1010 SA1
		LEFT JOIN SA1010 SA1BASE
			ON (SA1BASE.D_E_L_E_T_ != '*'
			AND SA1BASE.A1_FILIAL = SA1.A1_FILIAL
			AND SA1BASE.A1_COD = SA1.A1_VACBASE
			AND SA1BASE.A1_LOJA = SA1.A1_VALBASE)
			ON (SA1.D_E_L_E_T_ != '*'
			AND SA1.A1_FILIAL = '  '
			AND SA1.A1_COD = SC5.C5_CLIENTE
			AND SA1.A1_LOJA = SC5.C5_LOJACLI
			)
		LEFT JOIN SA2010 SA2
		LEFT JOIN SA2010 SA2BASE
			ON (SA2BASE.D_E_L_E_T_ != '*'
			AND SA2BASE.A2_FILIAL = SA2.A2_FILIAL
			AND SA2BASE.A2_COD = SA2.A2_VACBASE
			AND SA2BASE.A2_LOJA = SA2.A2_VALBASE)
			ON (SA2.D_E_L_E_T_ != '*'
			AND SA2.A2_FILIAL = '  '
			AND SA2.A2_COD = SC5.C5_CLIENTE
			AND SA2.A2_LOJA = SC5.C5_LOJACLI
			)
		LEFT JOIN SA3010 SA3
			ON (SA3.D_E_L_E_T_ != '*'
			AND SA3.A3_FILIAL = '  '
			AND SA3.A3_COD = SC5.C5_VEND1)
			LEFT JOIN SX5010 SX5_80
				ON (SX5_80.D_E_L_E_T_ != '*'
				AND SX5_80.X5_FILIAL = '  '
				AND SX5_80.X5_TABELA = '80'
				AND SX5_80.X5_CHAVE = SA3.A3_VAGEREN)
		LEFT JOIN SA4010 SA4
			ON (SA4.D_E_L_E_T_ != '*'
			AND SA4.A4_FILIAL = '  '
			AND SA4.A4_COD = SC5.C5_TRANSP)
		LEFT JOIN VA_SM0 SM0
			ON (SM0.D_E_L_E_T_ != '*'
			AND SM0.M0_CODIGO = '01'
			AND SM0.M0_CODFIL = SC5.C5_FILIAL)
WHERE SB1.D_E_L_E_T_ != '*'
AND SB1.B1_FILIAL = '  '
AND SB1.B1_COD = SC6.C6_PRODUTO
AND SC5.D_E_L_E_T_ = ''
AND SC5.C5_FILIAL = SC6.C6_FILIAL
AND SC5.C5_NUM = SC6.C6_NUM
AND SC6.D_E_L_E_T_ = ''
AND SC6.C6_QTDVEN > SC6.C6_QTDENT
AND SC6.C6_BLQ != 'R'  -- ELIMINADO RESIDUO

GO


