USE [protheus]
GO

/****** Object:  View [dbo].[VA_VMONITOR_ETIQ_FULL]    Script Date: 13/12/2021 15:26:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[VA_VMONITOR_ETIQ_FULL]
AS

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de integracao Protheus X FullWMS.
-- Autor: Robert Koch
-- Data:  02/05/2017
-- Historico de alteracoes:
-- 15/05/2017 - Robert - Incluida columa B1_DESC
-- 31/05/2017 - Robert - Incluidas colunas de status da transferencia no Protheus
-- 07/08/2018 - Robert - Criada coluna VALID_ENVIADA_PARA_FULL (serve tanto para ter a data como para saber se consta na tabela tb_wms_etiquetas)
-- 24/10/2018 - Robert - Pesquisa tb_wms_entrada com chave 'ZA1%' alem do 'SD3%' para contemplar entradas por NF e por transf.manual
--                     - Acrescentadas colunas ZA1_IDTRANSF e ULTIMO_EVENTO.
-- 13/12/2021 - Robert - Acrescentada descricao de alguns status_protheus.
--

SELECT
	ZA1.ZA1_FILIAL AS FILIAL
	,ZA1.ZA1_CODIGO AS ETIQUETA
	,ZA1.ZA1_DATA AS DT_GERACAO
	,ZA1.ZA1_APONT AS APONT
	,ZA1.ZA1_IMPRES AS IMPRESSA
	,CASE ZA1.ZA1_APONT
		WHEN 'S' THEN 'APONTADA'
		WHEN 'E' THEN 'ESTORNADA'
		WHEN 'I' THEN 'INUTILIZADA'
		ELSE CASE ZA1.ZA1_IMPRES
				WHEN 'S' THEN 'IMPRESSA'
				ELSE 'NAO IMPRESSA'
			END
	END AS DESCRI_STATUS_PROTHEUS
	,ZA1.ZA1_PROD AS PRODUTO
	,SB1.B1_DESC AS DESCRI_PRODUTO
	,ZA1.ZA1_OP AS OP
	,ISNULL (APONT.D3_VADTINC, '') AS DT_APONT
	,ISNULL (APONT.D3_VAHRINC, '') AS HR_APONT
	,ISNULL (APONT.D3_DOC, '') AS DOC_APONT
	,ISNULL (APONT.D3_LOCAL, '') AS ALM_APONT
	,ISNULL (APONT.D3_QUANT, '') AS QT_APONT
	,ISNULL (APONT.D3_PERDA, '') AS QT_PERDA
	,ISNULL (APONT.D3_USUARIO, '') AS USR_APONT
	,ISNULL ((select dbo.VA_DatetimeToVarchar(validade) from tb_wms_etiquetas where id = ZA1.ZA1_CODIGO), '') as VALID_ENVIADA_PARA_FULL
	,ISNULL (t.status, '') AS STATUS_FULL
	,CASE ISNULL (t.status, '')
		WHEN '1' THEN 'Ja visualizado'
		WHEN '2' THEN 'Recebto.autorizado'
		WHEN '3' THEN 'Recebto.finalizado'
		WHEN '9' THEN 'Recebto.excluido'
		ELSE ''
	END AS DESCRI_STATUS_FULL
	,ISNULL (t.status_protheus, '') AS STATUS_TRANSF
	,CASE ISNULL (t.status_protheus, '')
		WHEN '1' THEN 'Falta estq. no ERP p/transferir'
		WHEN '2' THEN 'Erro nao tratado ao transferir'
		WHEN '3' THEN 'Transferido OK'
		WHEN '4' THEN 'Diferenca quant. ERP x Full'
		WHEN '5' THEN 'Qt.movimentada menor que executada'
		WHEN '9' THEN 'Cancelado no ERP'
		WHEN 'C' THEN 'Cancelamento manual no ERP'
		ELSE ''
	END AS DESCRI_STATUS_TRANSF
	,CASE t.status
		WHEN '3' THEN t.qtde_exec
		ELSE 0
	END AS QT_EXECUTADA_FULL
	,ISNULL (TRANSF_DEST.D3_LOCAL, '') AS ALM_GUARDA
	,ISNULL (TRANSF_ORI.D3_QUANT, 0) AS QT_GUARDA
	,ISNULL (dbo.VA_DatetimeToVarchar(t.dthr), '') AS DT_ULT_ATU_FULL
	,ISNULL (RIGHT('0' + RTRIM(DATEPART(HOUR, t.dthr)), 2) + ':' + RIGHT('0' + RTRIM(DATEPART(MINUTE, t.dthr)), 2), '') AS HR_ULT_ATU_FULL
	,ISNULL (TRANSF_ORI.D3_VADTINC, '') AS DT_TRANSF
	,ISNULL (TRANSF_ORI.D3_VAHRINC, '') AS HR_TRANSF
	,ZA1.ZA1_IDZAG as ID_SOLIC_TRANSF_ESTQ
-- criar antes um indice pelo ZN_ETIQ	,ISNULL ((SELECT TOP 1 ZN_DATA + '-' + ZN_HORA + '-' + RTRIM (ZN_USUARIO) + '-' + RTRIM (ZN_TEXTO)
-- criar antes um indice pelo ZN_ETIQ	    from SZN010 SZN 
-- criar antes um indice pelo ZN_ETIQ	   WHERE SZN.D_E_L_E_T_ = '' AND SZN.ZN_FILIAL = ZA1.ZA1_FILIAL AND ZN_ETIQ = ZA1_CODIGO
-- criar antes um indice pelo ZN_ETIQ	   ORDER BY ZN_DATA DESC, ZN_HORA DESC
-- criar antes um indice pelo ZN_ETIQ	   ), '') AS ULTIMO_EVENTO

FROM	SB1010 SB1
		,ZA1010 ZA1
		LEFT JOIN SD3010 APONT
			ON (APONT.D_E_L_E_T_ = ''
			AND APONT.D3_FILIAL = ZA1.ZA1_FILIAL
			AND APONT.D3_VAETIQ = ZA1.ZA1_CODIGO
			AND APONT.D3_CF LIKE 'PR%'
			AND APONT.D3_ESTORNO != 'S'
			)
		LEFT JOIN tb_wms_entrada t
			ON ((t.entrada_id = 'SD3' + D3_FILIAL + D3_DOC + D3_OP + D3_COD + D3_NUMSEQ)
			    or
			    (t.entrada_id = 'ZA1' + ZA1_FILIAL + ZA1_CODIGO)
			   )
		LEFT JOIN SD3010 TRANSF_ORI
				INNER JOIN SD3010 TRANSF_DEST
					ON (TRANSF_DEST.D_E_L_E_T_ = ''
					AND TRANSF_DEST.D3_FILIAL = TRANSF_ORI.D3_FILIAL
					AND TRANSF_DEST.D3_NUMSEQ = TRANSF_ORI.D3_NUMSEQ
					AND TRANSF_DEST.D3_CF = 'DE4'
					AND TRANSF_DEST.D3_ESTORNO != 'S')
			ON (TRANSF_ORI.D_E_L_E_T_ = ''
			AND TRANSF_ORI.D3_FILIAL = APONT.D3_FILIAL
			AND TRANSF_ORI.D3_VAETIQ = APONT.D3_VAETIQ
			AND TRANSF_ORI.D3_CF = 'RE4'
			AND TRANSF_ORI.D3_ESTORNO != 'S')
WHERE ZA1.D_E_L_E_T_ = ''
AND SB1.D_E_L_E_T_ = ''
AND SB1.B1_FILIAL = '  '
AND SB1.B1_COD = ZA1.ZA1_PROD

GO


