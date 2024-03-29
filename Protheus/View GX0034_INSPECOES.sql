





ALTER VIEW [dbo].[GX0034_INSPECOES] AS

with c as (
	-- Usa DISTINCT por que, quando a agenda ocupa mais de um horario, pode retornar varios registros. 
	SELECT distinct TrnAgeAgendaCarSeq, TrnAgeAgendaSafra, TrnAgeTombadorFil, TrnAgeAgendaCarCod, TrnAgeAgendaSit, Min(TrnAgeAgendaHor) as TrnAgeAgendaHor, Max(TrnAgeAgendaQtdOri) as TrnAgeAgendaQtdOri, Max(TrnAgeAgendaDat) as TrnAgeAgendaDat,  I.*
FROM LKSRV_NAWEB.naweb.dbo.TrnAgeAgenda A
	,LKSRV_NAWEB.naweb.dbo.TrnAgeTombador T,
	LKSRV_NAWEB.naweb.dbo.TrnAgeCargaItem I
WHERE A.TrnAgeTombadorCod = T.TrnAgeTombadorCod
AND A.TrnAgeTombadorCod = T.TrnAgeTombadorCod
and I.TrnAgeCargaSeq = A.TrnAgeAgendaCarSeq
AND A.TrnAgeAgendaSafra = '2019' -- Para outras safras certamente vai precisar tratamento especifico.
AND TrnAgeAgendaSit in ('CON', 'SEG')
Group By TrnAgeAgendaCarSeq, TrnAgeAgendaSafra, TrnAgeTombadorFil, TrnAgeAgendaCarCod, TrnAgeAgendaSit, TrnAgeCargaSeq, TrnAgeCargaItemCod, TrnAgeCargaItemPer, TrnAgeCargaItemRes, TrnAgeCargaItemObs, TrnAgeCargaItemTip, TrnAgeCargaItemObsIns, TrnAgeCargaItemResCon, TrnAgeCargaItemConforme, TrnAgeCargaItemCodAgro
)
select TrnAgeAgendaCarSeq AS CARGA_SEQ, TrnAgeAgendaSafra as SAFRA, TrnAgeTombadorFil as FILIAL, TrnAgeAgendaCarCod as CARGA, TrnAgeAgendaSit as SITUACAO, Min(TrnAgeAgendaHor) as HORA_AGD, Max(TrnAgeAgendaQtdOri) as QTD_TOT, Max(TrnAgeAgendaDat) as DATA_AGD
-- CABINE --
,max (case when TrnAgeCargaItemTip = 'Cabine'   AND TrnAgeCargaItemCodAgro = '0.2' and TrnAgeCargaItemCod = 26  then TrnAgeCargaItemRes else '' end) as NF_PREENCHIDA_CABINE
,max (case when TrnAgeCargaItemTip = 'Cabine'   AND TrnAgeCargaItemCodAgro = '0.3' and TrnAgeCargaItemCod = 27  then TrnAgeCargaItemRes else '' end) as DADOS_CADASTRAIS_CABINE
,max (case when TrnAgeCargaItemTip = 'Cabine'   AND TrnAgeCargaItemCodAgro = '0.4' and TrnAgeCargaItemCod = 35  then TrnAgeCargaItemRes else '' end) as VARIEDADES_DESCRITAS_CABINE
-- PATIO --
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '0.1' and TrnAgeCargaItemCod = 25  then TrnAgeCargaItemRes else '' end) as NOTA_FISCAL_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '0.5' and TrnAgeCargaItemCod = 29  then TrnAgeCargaItemRes else '' end) as VARIEDADE_NOTA_X_VAR_CARGA_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '0.6' and TrnAgeCargaItemCod = 30  then TrnAgeCargaItemRes else '' end) as VAR_CARGA_X_VAR_CV_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '1.1' and TrnAgeCargaItemCod = 1   then TrnAgeCargaItemRes else '' end) as CADERNO_CAMPO_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '1.2' and TrnAgeCargaItemCod = 2   then TrnAgeCargaItemRes else '' end) as AGROTOXICO_CADERNO_CAMPO_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '1.3' and TrnAgeCargaItemCod = 31  then TrnAgeCargaItemRes else '' end) as DATA_COLHEITA_AGRO_APLICADO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '1.4' and TrnAgeCargaItemCod = 32  then TrnAgeCargaItemRes else '' end) as AGROTOXICO_PROIBIDO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '2.1' and TrnAgeCargaItemCod = 4   then TrnAgeCargaItemRes else '' end) as LONA_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '2.2' and TrnAgeCargaItemCod = 33  then TrnAgeCargaItemRes else '' end) as LONA_SUPERIOR
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = 7   then TrnAgeCargaItemRes else '' end) as BOTRYTIS_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = 8   then TrnAgeCargaItemRes else '' end) as GLOMERELLA_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = 9   then TrnAgeCargaItemRes else '' end) as ASPERGILLUS_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = 10  then TrnAgeCargaItemRes else '' end) as PODRIDAO_ACIDA_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.2' and TrnAgeCargaItemCod = 11  then TrnAgeCargaItemRes else '' end) as ACIDEZ_VOLATIL_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.3' and TrnAgeCargaItemCod = 12  then TrnAgeCargaItemRes else '' end) as MATERIAIS_ESTRANHOS_PATIO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.4' and TrnAgeCargaItemCod = 34  then TrnAgeCargaItemRes else '' end) as DESUNIFORMIDADE_PATIO
-- TOMBADOR --
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '0.5' and TrnAgeCargaItemCod = 38  then TrnAgeCargaItemRes else '' end) as VAR_NOTA_X_VAR_CARGA_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '0.6' and TrnAgeCargaItemCod = 39  then TrnAgeCargaItemRes else '' end) as MISTURA_VAR_X_TICKET_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = 41  then TrnAgeCargaItemRes else '' end) as BOTRYTIS_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = 42  then TrnAgeCargaItemRes else '' end) as GLOMERELLA_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = 43  then TrnAgeCargaItemRes else '' end) as ASPERGILLUS_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = 44  then TrnAgeCargaItemRes else '' end) as PODRIDAO_ACIDA_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.2' and TrnAgeCargaItemCod = 45  then TrnAgeCargaItemRes else '' end) as ACIDEZ_VOLATIL_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.3' and TrnAgeCargaItemCod = 46  then TrnAgeCargaItemRes else '' end) as MATERIAIS_ESTRANHOS_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.4' and TrnAgeCargaItemCod = 47  then TrnAgeCargaItemRes else '' end) as DESUNIFORMIDADE_TOMBADOR

from c
group by TrnAgeAgendaCarSeq, TrnAgeAgendaSafra, TrnAgeAgendaCarCod, TrnAgeTombadorFil, TrnAgeAgendaSit

