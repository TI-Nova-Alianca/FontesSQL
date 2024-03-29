



ALTER VIEW [dbo].[VA_VINSPECOES_SAFRA_2019]
AS
-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View para buscar no NaWeb as inspecoes das cargas de uva
-- Autor: Robert Koch
-- Data:  17/01/2019
-- Historico de alteracoes:
--

with c as (
	-- Usa DISTINCT por que, quando a agenda ocupa mais de um horario, pode retornar varios registros. 
	SELECT distinct TrnAgeAgendaSafra, TrnAgeTombadorFil, TrnAgeAgendaCarCod, TrnAgeAgendaSit, I.*
FROM LKSRV_NAWEB.naweb.dbo.TrnAgeAgenda A
	,LKSRV_NAWEB.naweb.dbo.TrnAgeTombador T,
	LKSRV_NAWEB.naweb.dbo.TrnAgeCargaItem I
WHERE A.TrnAgeTombadorCod = T.TrnAgeTombadorCod
AND A.TrnAgeTombadorCod = T.TrnAgeTombadorCod
and I.TrnAgeCargaSeq = A.TrnAgeAgendaCarSeq
AND A.TrnAgeAgendaSafra = '2019'  -- Para outras safras certamente vai precisar tratamento especifico.
)
select TrnAgeAgendaSafra as SAFRA, TrnAgeTombadorFil as FILIAL, TrnAgeAgendaCarCod as CARGA, TrnAgeAgendaSit as SITUACAO
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '0.6' and TrnAgeCargaItemConforme = 'N' then 'S-' + rtrim (TrnAgeCargaItemObsIns) else '' end) as MISTURA_VARIEDADES
,max (case when TrnAgeCargaItemTip = 'Cabine'   AND TrnAgeCargaItemCodAgro = '0.4' and TrnAgeCargaItemConforme = 'N' then 'S-' + rtrim (TrnAgeCargaItemObsIns) else '' end) as VAR_NAO_PREV_CAD_VIT
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '1.1' then TrnAgeCargaItemConforme else '' end) as ENTREGOU_CADERNO_CPO
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = '7'  then TrnAgeCargaItemRes else '' end) as BOTRYTIS_PATIO
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = '41' then TrnAgeCargaItemRes else '' end) as BOTRYTIS_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = '8'  then TrnAgeCargaItemRes else '' end) as GLOMERELLA_PATIO
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = '42' then TrnAgeCargaItemRes else '' end) as GLOMERELLA_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = '9'  then TrnAgeCargaItemRes else '' end) as ASPERGILLUS_PATIO
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = '43' then TrnAgeCargaItemRes else '' end) as ASPERGILLUS_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = '10' then TrnAgeCargaItemRes else '' end) as PODRIDAO_ACIDA_PATIO
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.1' and TrnAgeCargaItemCod = '44' then TrnAgeCargaItemRes else '' end) as PODRIDAO_ACIDA_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.2' and TrnAgeCargaItemCod = '11' then TrnAgeCargaItemRes else '' end) as ACIDEZ_VOLATIL_PATIO
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.2' and TrnAgeCargaItemCod = '45' then TrnAgeCargaItemRes else '' end) as ACIDEZ_VOLATIL_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.3' and TrnAgeCargaItemCod = '12' then TrnAgeCargaItemRes else '' end) as MATERIAIS_ESTRANHOS_PATIO
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.3' and TrnAgeCargaItemCod = '46' then TrnAgeCargaItemRes else '' end) as MATERIAIS_ESTRANHOS_TOMBADOR
,max (case when TrnAgeCargaItemTip = 'Pátio'    AND TrnAgeCargaItemCodAgro = '3.4' and TrnAgeCargaItemCod = '34' then TrnAgeCargaItemRes else '' end) as DESUNIFORMIDADE_MATURACAO_PATIO
,max (case when TrnAgeCargaItemTip = 'Tombador' AND TrnAgeCargaItemCodAgro = '3.4' and TrnAgeCargaItemCod = '47' then TrnAgeCargaItemRes else '' end) as DESUNIFORMIDADE_MATURACAO_TOMBADOR
from c
group by TrnAgeAgendaSafra, TrnAgeAgendaCarCod, TrnAgeTombadorFil, TrnAgeAgendaSit


