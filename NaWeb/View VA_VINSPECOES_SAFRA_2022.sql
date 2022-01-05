USE [naweb]
GO

/****** Object:  View [dbo].[VA_VINSPECOES_SAFRA_2021]    Script Date: 17/12/2021 10:44:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter VIEW [dbo].[VA_VINSPECOES_SAFRA_2022]
AS
 -- Cooperativa Agroindustrial Nova Alianca Ltda
 -- View para buscar no NaWeb as inspecoes das cargas de uva
 -- Autor: Robert Koch
 -- Data:  17/12/2021
 -- Historico de alteracoes:

with c as (
	-- Usa DISTINCT por que, quando a agenda ocupa mais de um horario, pode retornar varios registros. 
	SELECT distinct TrnAgeAgendaSafra, TrnAgeTombadorFil, I.InspCargaCod, TrnAgeAgendaOri, TrnAgeAgendaSit, J.*
FROM LKSRV_NAWEB.naweb.dbo.TrnAgeAgenda A
	,LKSRV_NAWEB.naweb.dbo.TrnAgeTombador T,
	LKSRV_NAWEB.naweb.dbo.SFInspCarga I,
	LKSRV_NAWEB.naweb.dbo.SFInspCargaItem J
WHERE A.TrnAgeTombadorCod = T.TrnAgeTombadorCod
AND A.TrnAgeTombadorCod = T.TrnAgeTombadorCod
AND I.InspCargaAgendaId = A.TrnAgeAgendaOri
AND A.TrnAgeAgendaSafra = '2022'  -- Para outras safras certamente vai precisar tratamento especifico.
AND J.InspCargaId = I.InspCargaId
)
select TrnAgeAgendaSafra as SAFRA, TrnAgeTombadorFil as FILIAL, InspCargaCod as CARGA, TrnAgeAgendaOri AGENDAORI, TrnAgeAgendaSit as SITUACAO
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '0.6' and InspCargaItemConforme = 'N' then 'S'					else '' end) as MISTURA_VARIEDADES
,max (case when InspCargaItemTipoInspecao = 'C' AND InspCargaItemCodAgro = '0.4' and InspCargaItemConforme = 'N' then 'S'					else '' end) as VAR_NAO_PREV_CAD_VIT
,max (case when InspCargaItemTipoInspecao = 'P' AND InspCargaItemCodAgro = '1.1'								 then InspCargaItemConforme else '' end) as ENTREGOU_CADERNO_CPO
,max (case when InspCargaItemTipoInspecao = 'P' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 15	 then InspCargaItemResposta else '' end) as BOTRYTIS_PATIO
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 19	 then InspCargaItemResposta else '' end) as BOTRYTIS_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'P' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 16	 then InspCargaItemResposta else '' end) as GLOMERELLA_PATIO
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 20	 then InspCargaItemResposta else '' end) as GLOMERELLA_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'P' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 17	 then InspCargaItemResposta else '' end) as ASPERGILLUS_PATIO
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 21	 then InspCargaItemResposta else '' end) as ASPERGILLUS_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'P' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 18	 then InspCargaItemResposta else '' end) as PODRIDAO_ACIDA_PATIO
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.1' and InspCargaItemPerId = 22	 then InspCargaItemResposta else '' end) as PODRIDAO_ACIDA_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'P' AND InspCargaItemCodAgro = '3.2' and InspCargaItemPerId = 24	 then InspCargaItemResposta else '' end) as ACIDEZ_VOLATIL_PATIO
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.2' and InspCargaItemPerId = 23	 then InspCargaItemResposta else '' end) as ACIDEZ_VOLATIL_TOMBADOR
,max (case when InspCargaItemTipoInspecao = 'P' AND InspCargaItemCodAgro = '3.3' and InspCargaItemPerId = 25	 then InspCargaItemResposta else '' end) as MATERIAIS_ESTRANHOS_PATIO
,max (case when InspCargaItemTipoInspecao = 'T' AND InspCargaItemCodAgro = '3.3' and InspCargaItemPerId = 26	 then InspCargaItemResposta else '' end) as MATERIAIS_ESTRANHOS_TOMBADOR
from c
group by TrnAgeAgendaSafra, InspCargaCod, TrnAgeTombadorFil, TrnAgeAgendaOri, TrnAgeAgendaSit

GO

