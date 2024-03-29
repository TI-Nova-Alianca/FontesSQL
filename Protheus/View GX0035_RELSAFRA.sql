

ALTER VIEW [dbo].[GX0035_RELSAFRA] AS 
-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de cargas de uva do Protheus para NaWeb.
-- Autor: Guilherme Oliveira
-- Data:  2020
-- Historico de alteracoes:
--

SELECT
VA_VCARGA.FILIAL AS GX0035_RELSAFRA_FILIAL,
VA_VCARGA.SAFRA AS GX0035_RELSAFRA_SAFRA,
LOCAL AS GX0035_RELSAFRA_LOCAL,  
REPLACE(TRIM(DESCLOCAL), ' ', '_') as GX0035_RELSAFRA_DESCLOCAL,
REPLACE(TRIM(REPLACE(CCAssociadoGrpFam.CCAssociadoGrpFam, 'GRUPO DE ', '')), ' ', '_')  as GX0035_RELSAFRA_GRP_FAM,
ASSOCIADO AS GX0035_RELSAFRA_COD_ASSOC,
LOJA_ASSOC AS GX0035_RELSAFRA_LOJA_ASSOC,
REPLACE(TRIM(NOME_ASSOC), ' ', '_') as GX0035_RELSAFRA_NOME_ASSOC,
CCAssociadoGrpFam.CCAssociadoGrpFamNucleo as GX0035_RELSAFRA_NUCLEO,
CCAssociadoGrpFam.CCAssociadoGrpFamSubNucleo as GX0035_RELSAFRA_GRUPO,
CCAssociadoGrpFam.CCAssociadoUtilizaCadCampo as GX0035_RELSAFRA_eCC,
VA_VCARGA.CARGA AS GX0035_RELSAFRA_CARGA,
AGLUTINACAO AS GX0035_RELSAFRA_AGLUT,
protheus.dbo.VA_DTOC(DATA) AS GX0035_RELSAFRA_DATA,
SUBSTRING(DATA, 1, 4) + '-' + SUBSTRING(DATA, 5, 2) + '-' + SUBSTRING(DATA, 7, 2)  AS GX0035_RELSAFRA_DATA2,
HORA AS GX0035_RELSAFRA_HORA,
DATEDIFF(MINUTE, '00:00', FORMAT(CAST(HORA as DateTime), N'HH:mm')) as GX0035_RELSAFRA_HORA_COEF,
HORA_RECEBIMENTO AS GX0035_RELSAFRA_HORA_REC,
PLACA AS GX0035_RELSAFRA_PLACA,
NF_PRODUTOR AS GX0035_RELSAFRA_NF_PROD,
SERIE_NF_PRODUTOR AS GX0035_RELSAFRA_SERIE_NF_PROD,
CONTRANOTA AS GX0035_RELSAFRA_CONTRANOTA,
SERIE_CONTRANOTA AS GX0035_RELSAFRA_SER_CONTRANOTA,
PESO_BRUTO AS GX0035_RELSAFRA_PESO_BRUTO,
PESO_TARA AS GX0035_RELSAFRA_PESO_TARA,
B1.B1_CODPAI AS GX0035_RELSAFRA_PRODUTO_CV, 
PRODUTO AS GX0035_RELSAFRA_PRODUTO,
REPLACE(TRIM(DESCRICAO), ' ', '_') as GX0035_RELSAFRA_DESC,
CASE
	WHEN B1.B1_CODPAI = ''
		THEN REPLACE(TRIM(DESCRICAO), ' ', '_')
	ELSE
		REPLACE(TRIM((select top 1 B1_DESC from protheus.dbo.SB1010 where B1_COD = B1.B1_CODPAI and D_E_L_E_T_ = '')), ' ', '_')
END AS GX0035_RELSAFRA_DESC_CV,
VARUVA AS GX0035_RELSAFRA_VARUVA,
ORGANICA AS GX0035_RELSAFRA_ORG,
PESO_LIQ AS GX0035_RELSAFRA_PESO_LIQ,
GRAU AS GX0035_RELSAFRA_GRAU,
CAD_VITIC AS GX0035_RELSAFRA_CV,
QT_EMBALAG AS GX0035_RELSAFRA_QT_EMB,
REPLACE(TRIM(EMBALAGEM), ' ', '_') as GX0035_RELSAFRA_EMB,
REPLACE(TRIM(ACUCAR), ' ', '_') as GX0035_RELSAFRA_ACUCAR,
REPLACE(TRIM(SANIDADE), ' ', '_') as GX0035_RELSAFRA_SANIDADE,
REPLACE(TRIM(MATURACAO), ' ', '_') as GX0035_RELSAFRA_MATURACAO,
REPLACE(TRIM(MAT_ESTRANHO), ' ', '_') as GX0035_RELSAFRA_MAT_ESTRANHO,
REPLACE(TRIM(CLAS_FINAL), ' ', '_') as GX0035_RELSAFRA_CLAS_FINAL,
REPLACE(TRIM(CLAS_ABD), ' ', '_') as GX0035_RELSAFRA_CLAS_ABD,
REPLACE(TRIM(NAO_CONF01), ' ', '_') as GX0035_RELSAFRA_NAO_CONF01,
REPLACE(TRIM(DESC_NC01), ' ', '_') as GX0035_RELSAFRA_DESC_NC01,
REPLACE(TRIM(NAO_CONF02), ' ', '_') as GX0035_RELSAFRA_NAO_CONF02,
REPLACE(TRIM(DESC_NC02), ' ', '_') as GX0035_RELSAFRA_DESC_NC02,
REPLACE(TRIM(NAO_CONF03), ' ', '_') as GX0035_RELSAFRA_NAO_CONF03,
REPLACE(TRIM(DESC_NC03), ' ', '_') as GX0035_RELSAFRA_DESC_NC03,
REPLACE(TRIM(NAO_CONF04), ' ', '_') as GX0035_RELSAFRA_NAO_CONF04,
REPLACE(TRIM(DESC_NC04), ' ', '_') as GX0035_RELSAFRA_DESC_NC04,
ITEMCARGA AS GX0035_RELSAFRA_ITEM_CARGA,
COR AS GX0035_RELSAFRA_COR,
TIPO_FORNEC AS GX0035_RELSAFRA_TIPO_FORNEC,
FORMA_CLAS_UVA_FINA AS GX0035_RELSAFRA_FORMA_CLAS_UVA_FINA,
PARA_ESPUMANTE AS GX0035_RELSAFRA_PARA_ESPUMANTE,
PESO_ESTIMADO AS GX0035_RELSAFRA_PESO_ESTIMADO,
TOMBADOR AS GX0035_RELSAFRA_TOMBADOR,
TINTOREA AS GX0035_RELSAFRA_TINTOREA,
REPLACE(TRIM(NF_DEVOLUCAO), ' ', '_') as GX0035_RELSAFRA_NF_DEVOLUCAO,
STATUS AS GX0035_RELSAFRA_STATUS,
PROPR_RURAL AS GX0035_RELSAFRA_PROP_RURAL,

CASE
	WHEN ISNULL((select SUM(CCParcelaArea) from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO), 0) = 0
		THEN (select SUM(CCParcelaArea) from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = B1.B1_CODPAI)
	ELSE
		(select SUM(CCParcelaArea) from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO) 
END AS GX0035_RELSAFRA_AREA,

CASE 
	WHEN ISNULL((select top 1 CCParcelaAltitude from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO order by CCParcelaSeq), 0) = 0
		THEN (select top 1 CCParcelaAltitude from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = B1.B1_CODPAI order by CCParcelaSeq)
	ELSE
		(select top 1 CCParcelaAltitude from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO order by CCParcelaSeq)
END AS GX0035_RELSAFRA_ALT,

CASE
	WHEN ISNULL((select top 1 CCParcelaLongitude from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO order by CCParcelaSeq), '') = ''
		THEN (select top 1 CCParcelaLongitude from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = B1.B1_CODPAI order by CCParcelaSeq)
	ELSE
		(select top 1 CCParcelaLongitude from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO order by CCParcelaSeq)
END AS GX0035_RELSAFRA_LON,

CASE 
	WHEN ISNULL((select top 1 CCParcelaLatitude from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO order by CCParcelaSeq), '') = ''
		THEN (select top 1 CCParcelaLatitude from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = B1.B1_CODPAI order by CCParcelaSeq)
	ELSE
		(select top 1 CCParcelaLatitude from naweb.dbo.CCParcela where CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO order by CCParcelaSeq)
END AS GX0035_RELSAFRA_LAT,

CASE
	WHEN ISNULL(STUFF((SELECT ',' + TRIM(CCParcelaCod) FROM naweb.dbo.CCParcela WHERE CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO order by CCParcelaSeq FOR XML PATH('')), 1, 1, '' ), '') = ''
		THEN STUFF((SELECT ',' + TRIM(CCParcelaCod) FROM naweb.dbo.CCParcela WHERE CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = B1.B1_CODPAI order by CCParcelaSeq FOR XML PATH('')), 1, 1, '' )
	ELSE
		STUFF((SELECT ',' + TRIM(CCParcelaCod) FROM naweb.dbo.CCParcela WHERE CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO order by CCParcelaSeq FOR XML PATH('')), 1, 1, '' )
END AS GX0035_RELSAFRA_PARCELAS,

CASE
	WHEN (SELECT COUNT(CCParcelaCod) FROM naweb.dbo.CCParcela WHERE CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO) = 0
		THEN (SELECT COUNT(CCParcelaCod) FROM naweb.dbo.CCParcela WHERE CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = B1.B1_CODPAI)
	ELSE
		(SELECT COUNT(CCParcelaCod) FROM naweb.dbo.CCParcela WHERE CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and CCVariedadeCod = PRODUTO)
END AS GX0035_RELSAFRA_QT_PAR,

CASE
	WHEN CCAssociadoGrpFam.CCAssociadoUtilizaCadCampo <> 'S'
		THEN
			CASE
				WHEN ISNULL(STUFF((SELECT DISTINCT ',' + TRIM(STR(CCParcela.CCParcelaCadernoCampo)) FROM naweb.dbo.CCParcela WHERE CCParcela.CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCParcela.CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and  CCParcela.CCVariedadeCod = PRODUTO FOR XML PATH('')), 1, 1, '' ), '') = ''
					THEN STUFF((SELECT DISTINCT ',' + TRIM(STR(CCParcela.CCParcelaCadernoCampo)) FROM naweb.dbo.CCParcela WHERE CCParcela.CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCParcela.CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and  CCParcela.CCVariedadeCod = B1.B1_CODPAI FOR XML PATH('')), 1, 1, '' )
				 ELSE
					STUFF((SELECT DISTINCT ',' + TRIM(STR(CCParcela.CCParcelaCadernoCampo)) FROM naweb.dbo.CCParcela WHERE CCParcela.CCParcelaGrpFamCod = SFInspCarga.InspCargaGrpFamCod and CCParcela.CCPropriedadeCod = CAST(PROPR_RURAL as bigint) and  CCParcela.CCVariedadeCod = PRODUTO FOR XML PATH('')), 1, 1, '' )
			END 
	ELSE
		STUFF((SELECT DISTINCT ',' + TRIM(STR(CCLoteParcela.CCLoteCadCampo)) FROM naweb.dbo.CCLoteParcela INNER JOIN naweb.dbo.SFInspCargaCadCampo ON (CCLoteParcela.CCLoteNr = SFInspCargaCadCampo.InspCargaNrCC) WHERE SFInspCargaCadCampo.InspCargaId = SFInspCarga.InspCargaId FOR XML PATH('')), 1, 1, '' )
END AS GX0035_RELSAFRA_CAD_CAMPO,

CASE
	WHEN CCAssociadoGrpFam.CCAssociadoUtilizaCadCampo = 'S'
		THEN	
			(select top 1 InspCargaNrCC from naweb.dbo.SFInspCargaCadCampo where SFInspCargaCadCampo.InspCargaId = SFInspCarga.InspCargaId)
	ELSE
		''
END AS GX0035_RELSAFRA_LOTE,
CASE
	WHEN (select top 1 SFInspCargaItem.InspCargaItemConforme from naweb.dbo.SFInspCargaItem where SFInspCargaItem.InspCargaId = SFInspCarga.InspCargaId and SFInspCargaItem.InspCargaItemModo = 'R' and SFInspCargaItem.InspCargaItemPerId = 9) = 'N'
		THEN 'N'
	WHEN (select top 1 SFInspCargaItem.InspCargaItemConforme from naweb.dbo.SFInspCargaItem where SFInspCargaItem.InspCargaId = SFInspCarga.InspCargaId and SFInspCargaItem.InspCargaItemModo = 'I' and SFInspCargaItem.InspCargaItemPerId = 9) = 'S'
		THEN 'S'
END AS GX0035_RELSAFRA_ENTREG_CAD_CAMPO,

CASE
	WHEN ISNULL(STUFF((SELECT ',' + TRIM(SFInspCargaCadCampo.InspCargaNrCC) FROM naweb.dbo.SFInspCargaCadCampo WHERE SFInspCargaCadCampo.InspCargaId = SFInspCarga.InspCargaId FOR XML PATH('')), 1, 1, '' ), '') = ''
		THEN 'N'
	ELSE
		'S'
END AS GX0035_RELSAFRA_PRIM_ENTREGA,

CASE
	WHEN (select top 1 TrnAgeAgendaSit from naweb.dbo.TrnAgeAgenda where TrnAgeAgendaOri = SFInspCarga.InspCargaAgendaId) = 'SEG'
		THEN 'N'
	WHEN (select top 1 TrnAgeAgendaSit from naweb.dbo.TrnAgeAgenda where TrnAgeAgendaOri = SFInspCarga.InspCargaAgendaId) = 'REI'
		THEN 'N'
	WHEN (select top 1 TrnAgeAgendaSit from naweb.dbo.TrnAgeAgenda where TrnAgeAgendaOri = SFInspCarga.InspCargaAgendaId) = 'CON'
		THEN 'S'
END AS GX0035_RELSAFRA_CONF,
INSP.TrnAgeAgendaVitRec as GX0035_RELSAFRA_COLETA_AMOSTRA,
FORMAT(CAST(INSP.HORA_AGD as DateTime), N'HH:mm') AS GX0035_RELSAFRA_HORA_AGD,
FORMAT(INSP.DATA_AGD, 'dd/MM/yyyy') AS GX0035_RELSAFRA_DATA_AGD,
DATEDIFF(MINUTE, '00:00', FORMAT(CAST(INSP.HORA_AGD as DateTime), N'HH:mm')) as GX0035_RELSAFRA_HORA_AGD_COEF,
INSP.QTD_TOT AS GX0035_RELSAFRA_QTD_TOT_AGD,
INSP.SITUACAO AS GX0035_RELSAFRA_SITUACAO,
NF_PREENCHIDA_CABINE AS GX0035_RELSAFRA_NF_PREENC_CABINE,
DADOS_CADASTRAIS_CABINE AS GX0035_RELSAFRA_DADOS_CAD_CABINE,
VARIEDADES_DESCRITAS_CABINE AS GX0035_RELSAFRA_VAR_DESCR_CABINE,
NOTA_FISCAL_PATIO AS GX0035_RELSAFRA_NF_PATIO,
VARIEDADE_NOTA_X_VAR_CARGA_PATIO AS GX0035_RELSAFRA_VAR_NF_CARGA_PATIO,
VAR_CARGA_X_VAR_CV_PATIO AS GX0035_RELSAFRA_VAR_CARGA_CV_PATIO,
CADERNO_CAMPO_PATIO AS GX0035_RELSAFRA_PER_CAD_CAMPO,
AGROTOXICO_CADERNO_CAMPO_PATIO AS GX0035_RELSAFRA_AGRO_CAD_CAMPO,
DATA_COLHEITA_AGRO_APLICADO AS GX0035_RELSAFRA_CARENCIA,
AGROTOXICO_PROIBIDO AS GX0035_RELSAFRA_AGRO_PROIBIDO,
LONA_PATIO AS GX0035_RELSAFRA_LONA_PATIO,
LONA_SUPERIOR AS GX0035_RELSAFRA_LONA_SUPERIOR,
REPLACE(BOTRYTIS_PATIO, 'Ausente', '0') as GX0035_RELSAFRA_BOTRYTIS_PATIO, 
REPLACE(GLOMERELLA_PATIO, 'Ausente', '0') as GX0035_RELSAFRA_GLOMERELLA_PATIO,
REPLACE(ASPERGILLUS_PATIO, 'Ausente', '0') as GX0035_RELSAFRA_ASPERGILLUS_PATIO,
REPLACE(PODRIDAO_ACIDA_PATIO, 'Ausente', '0') as GX0035_RELSAFRA_PODRIDAO_ACIDA_PATIO,
REPLACE(ACIDEZ_VOLATIL_PATIO, 'Ausente', '0') as GX0035_RELSAFRA_ACIDEZ_VOLATIL_PATIO,
REPLACE(MATERIAIS_ESTRANHOS_PATIO, 'Ausente', '0') as GX0035_RELSAFRA_MATERIAIS_ESTRANHOS_PATIO,
VAR_NOTA_X_VAR_CARGA_TOMBADOR AS GX0035_RELSAFRA_VAR_NF_VAR_TOMBADOR,
MISTURA_VAR_X_TICKET_TOMBADOR AS GX0035_RELSAFRA_VAR_NF_TICKET_TOMBADOR,
REPLACE(BOTRYTIS_TOMBADOR, 'Ausente', '0') as GX0035_RELSAFRA_BOTRYTIS_TOMBADOR,
REPLACE(GLOMERELLA_TOMBADOR, 'Ausente', '0') as GX0035_RELSAFRA_GLOMERELLA_TOMBADOR,
REPLACE(ASPERGILLUS_TOMBADOR, 'Ausente', '0') as GX0035_RELSAFRA_ASPERGILLUS_TOMBADOR, 
REPLACE(PODRIDAO_ACIDA_TOMBADOR, 'Ausente', '0') as GX0035_RELSAFRA_PODRIDAO_ACIDA_TOMBADOR,
REPLACE(ACIDEZ_VOLATIL_TOMBADOR, 'Ausente', '0') as GX0035_RELSAFRA_ACIDEZ_VOLATIL_TOMBADOR,
REPLACE(MATERIAIS_ESTRANHOS_TOMBADOR, 'Ausente', '0') as GX0035_RELSAFRA_MATERIAIS_ESTRANHOS_TOMBADOR,
CAST(DATEDIFF(MINUTE, '00:00', FORMAT(CAST(HORA as DateTime), N'HH:mm')) as float) / CAST(DATEDIFF(MINUTE, '00:00', FORMAT(CAST(INSP.HORA_AGD as DateTime), N'HH:mm')) as float) as GX0035_RELSAFRA_COEF_HORA,
PESO_LIQ / INSP.QTD_TOT as GX0035_RELSAFRA_COEF_PESO,
NW1.NW001_AMOSTRA_pH as GX0035_RELSAFRA_pH,
NW1.NW001_AMOSTRA_AT as GX0035_RELSAFRA_AT,
NW1.NW001_AMOSTRA_BRIX as GX0035_RELSAFRA_BRIX,
NW1.NW001_AMOSTRA_BABO as GX0035_RELSAFRA_BABO,
NW1.NW001_AMOSTRA_DEN as GX0035_RELSAFRA_DEN

from naweb.dbo.SFInspCarga
left join protheus.dbo.VA_VCARGAS_SAFRA as VA_VCARGA on (VA_VCARGA.SAFRA = InspCargaSafra and VA_VCARGA.FILIAL = InspCargaFilial and VA_VCARGA.CARGA = InspCargaCod)
left join protheus.dbo.GX0043_INSPECOES_2020 as INSP on (INSP.SAFRA = InspCargaSafra and INSP.FILIAL = InspCargaFilial and INSP.CARGA = InspCargaCod)
left join naweb.dbo.CCAssociadoGrpFam on (CCAssociadoGrpFam.CCAssociadoGrpFamCod = InspCargaGrpFamCod)
inner join protheus.dbo.SB1010 AS B1 on (B1.B1_COD = VA_VCARGA.PRODUTO)
left join naweb.dbo.NW001_AMOSTRA as NW1 on (NW1.NW001_AMOSTRA_CARGA = SFInspCarga.InspCargaCod and NW1.NW001_AMOSTRA_FILIAL = SFInspCarga.InspCargaFilial)


