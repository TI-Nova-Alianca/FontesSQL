










ALTER VIEW [dbo].[GX0043_INSPECOES_2020] AS

with c as (
	-- Usa DISTINCT por que, quando a agenda ocupa mais de um horario, pode retornar varios registros. 
	SELECT distinct TrnAgeAgendaSafra, TrnAgeTombadorFil, InspCargaCod, TrnAgeAgendaSit, Min(TrnAgeAgendaHor) as TrnAgeAgendaHor, Max(TrnAgeAgendaQtdOri) as TrnAgeAgendaQtdOri, Max(TrnAgeAgendaDat) as TrnAgeAgendaDat, TrnAgeAgendaVitRec,  I.*
FROM LKSRV_NAWEB.naweb.dbo.TrnAgeAgenda A
	,LKSRV_NAWEB.naweb.dbo.TrnAgeTombador T,
	LKSRV_NAWEB.naweb.dbo.SFInspCargaItem I,
	LKSRV_NAWEB.naweb.dbo.SFInspCarga J
WHERE A.TrnAgeTombadorCod = T.TrnAgeTombadorCod
AND A.TrnAgeTombadorCod = T.TrnAgeTombadorCod
AND J.InspCargaAgendaId = A.TrnAgeAgendaOri
AND J.InspCargaId = I.InspCargaId
AND A.TrnAgeAgendaSafra = '2020' -- Para outras safras certamente vai precisar tratamento especifico.
AND TrnAgeAgendaSit in ('AGE', 'INS', 'LIB', 'CON', 'SEG')
Group By TrnAgeAgendaSafra, TrnAgeTombadorFil, InspCargaCod, TrnAgeAgendaSit, InspCargaCod, InspCargaItemId, I.InspCargaId, InspCargaItemPerId, InspCargaItemCodAgro, InspCargaItemPergunta, InspCargaItemResposta, InspCargaItemConforme, InspCargaItemTipoInspecao, InspCargaItemHora, InspCargaItemData, InspCargaItemModo, InspCargaItemUsu, TrnAgeAgendaVitRec) 


select InspCargaCod as CARGA, TrnAgeAgendaSafra as SAFRA, TrnAgeTombadorFil as FILIAL, TrnAgeAgendaSit as SITUACAO, Min(TrnAgeAgendaHor) as HORA_AGD, Max(TrnAgeAgendaQtdOri) as QTD_TOT, Max(TrnAgeAgendaDat) as DATA_AGD, TrnAgeAgendaVitRec
-- CABINE --
,max (case when InspCargaItemTipoInspecao = 'C'  AND InspCargaItemCodAgro = '0.2' and InspCargaItemPerId = 2  then InspCargaItemResposta else '' end) as NF_PREENCHIDA_CABINE
,max (case when InspCargaItemTipoInspecao = 'C'  AND InspCargaItemCodAgro = '0.3' and InspCargaItemPerId = 3  then InspCargaItemResposta else '' end) as DADOS_CADASTRAIS_CABINE
,max (case when InspCargaItemTipoInspecao = 'C'  AND InspCargaItemCodAgro = '0.4' and InspCargaItemPerId = 4 then InspCargaItemResposta else '' end) as VARIEDADES_DESCRITAS_CABINE
-- PATIO --
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '0.1' and InspCargaItemPerId = 1  then InspCargaItemResposta else '' end) as NOTA_FISCAL_PATIO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '0.5' and InspCargaItemPerId = 6  then InspCargaItemResposta else '' end) as VARIEDADE_NOTA_X_VAR_CARGA_PATIO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '0.6' and InspCargaItemPerId = 7  then InspCargaItemResposta else '' end) as VAR_CARGA_X_VAR_CV_PATIO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '1.1' and InspCargaItemPerId = 9   then InspCargaItemResposta else '' end) as CADERNO_CAMPO_PATIO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '1.2' and InspCargaItemPerId = 10   then InspCargaItemResposta else '' end) as AGROTOXICO_CADERNO_CAMPO_PATIO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '1.3' and InspCargaItemPerId = 11  then InspCargaItemResposta else '' end) as DATA_COLHEITA_AGRO_APLICADO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '1.4' and InspCargaItemPerId = 12  then InspCargaItemResposta else '' end) as AGROTOXICO_PROIBIDO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '2.1' and InspCargaItemPerId = 13   then InspCargaItemResposta else '' end) as LONA_PATIO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '2.2' and InspCargaItemPerId = 14  then InspCargaItemResposta else '' end) as LONA_SUPERIOR
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 15   then InspCargaItemResposta else '' end) as BOTRYTIS_PATIO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 16   then InspCargaItemResposta else '' end) as GLOMERELLA_PATIO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 17   then InspCargaItemResposta else '' end) as ASPERGILLUS_PATIO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 18  then InspCargaItemResposta else '' end) as PODRIDAO_ACIDA_PATIO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '3.2' and InspCargaItemPerId = 24  then InspCargaItemResposta else '' end) as ACIDEZ_VOLATIL_PATIO
,max (case when InspCargaItemTipoInspecao = 'P'    AND InspCargaItemCodAgro = '3.3' and InspCargaItemPerId = 25  then InspCargaItemResposta else '' end) as MATERIAIS_ESTRANHOS_PATIO
-- TOMBADOR --
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '0.5' and InspCargaItemPerId = 5  then InspCargaItemResposta else '' end) as VAR_NOTA_X_VAR_CARGA_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '0.6' and InspCargaItemPerId = 8  then InspCargaItemResposta else '' end) as MISTURA_VAR_X_TICKET_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 19  then InspCargaItemResposta else '' end) as BOTRYTIS_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 20  then InspCargaItemResposta else '' end) as GLOMERELLA_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 21  then InspCargaItemResposta else '' end) as ASPERGILLUS_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 22  then InspCargaItemResposta else '' end) as PODRIDAO_ACIDA_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.2' and InspCargaItemPerId = 23  then InspCargaItemResposta else '' end) as ACIDEZ_VOLATIL_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.3' and InspCargaItemPerId = 26  then InspCargaItemResposta else '' end) as MATERIAIS_ESTRANHOS_TOMBADOR

from c
group by InspCargaCod, TrnAgeAgendaSafra, TrnAgeTombadorFil, TrnAgeAgendaSit, TrnAgeAgendaVitRec

