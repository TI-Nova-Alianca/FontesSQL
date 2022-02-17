USE [protheus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View para buscar os horarios e demoras entre processos do recebimento de safra (GLPI 11579)
-- Autor: Robert Koch
-- Data:  04/02/2022
-- Historico de alteracoes:
-- ??/02/2022 - Ajustes Daiana
--

ALTER view [dbo].[GX0057_TEMPOS_DESCARGA_SAFRA]
AS

-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View para buscar os horarios e demoras entre processos do recebimento de safra (GLPI 11579)
-- Autor: Robert Koch
-- Data:  04/02/2022
-- Historico de alteracoes:
--

/*
-- GERA UMA 'CTE' COM O MENOR HORARIO DE AGENDAMENTO DE CADA CARGA, POIS FICOU MUITO DEMORADO USAR
-- COMO UMA SUBQUERY DURANTE A LEITURA DAS CARGAS.
WITH AGENDA AS (
select A.TrnAgeAgendaSafra, T.TrnAgeTombadorFil, I.InspCargaCod, min (TrnAgeAgendaDatHor) as TrnAgeAgendaDatHor
				from LKSRV_NAWEB.naweb.dbo.TrnAgeAgenda A
					,LKSRV_NAWEB.naweb.dbo.TrnAgeTombador T
					,LKSRV_NAWEB.naweb.dbo.SFInspCarga I
				WHERE T.TrnAgeTombadorCod = A.TrnAgeTombadorCod
					AND I.InspCargaAgendaId = A.TrnAgeAgendaOri
					and A.TrnAgeAgendaSit != 'DIS'
				group by TrnAgeAgendaSafra, TrnAgeTombadorFil, InspCargaCod
)

-- GERA UMA 'CTE' COM DADOS DE CARGAS + CONTRANOTAS + AGENDA
,*/ with CAR AS (
SELECT --SUBSTRING (DATA, 7, 2) AS DIA
	--, SUBSTRING (DATA, 5, 2) AS MES
	--, SUBSTRING (DATA, 1, 4) AS ANO
	  V.SAFRA, V.FILIAL, V.CARGA, V.TOMBADOR
	--, AGENDA.TrnAgeAgendaDatHor AS AGENDAMENTO
	, (select min (TrnAgeAgendaDatHor)
				from LKSRV_NAWEB.naweb.dbo.TrnAgeAgenda A
					,LKSRV_NAWEB.naweb.dbo.TrnAgeTombador T
					,LKSRV_NAWEB.naweb.dbo.SFInspCarga I
				WHERE T.TrnAgeTombadorCod = A.TrnAgeTombadorCod
					AND I.InspCargaAgendaId = A.TrnAgeAgendaOri
					and A.TrnAgeAgendaSit != 'DIS'
					AND A.TrnAgeAgendaSafra = V.SAFRA
					AND T.TrnAgeTombadorFil = V.FILIAL
					AND I.InspCargaCod      = V.CARGA) AS AGENDAMENTO
	, convert(datetime,V.DATA + ' ' + V.HORA,103) AS GERACAO_CARGA
	, convert(datetime,ZZA.ZZA_INIST1,103) AS PESAGEM1
	, convert(datetime,ZZA.ZZA_INIST2,103) AS INI_MED_GRAU
	, convert(datetime,ZZA.ZZA_INIST3,103) AS FIM_MED_GRAU
	, convert(datetime,SPED.DT_HR_AUTORIZ,103) AS CONTRANOTA
	, V.NOME_ASSOC, V.DESCRICAO, V.PESO_LIQ
FROM VA_VCARGAS_SAFRA V
       
	-- BUSCA DATA E HORA EM QUE A CONTRANOTA FOI AUTORIZADA PELA SEFAZ
	LEFT JOIN (
            SELECT SM0.M0_CODFIL,
                    SPED054.NFE_ID,
                    MIN(SPED054.DTREC_SEFR + ' ' + SPED054.HRREC_SEFR) AS 
                    DT_HR_AUTORIZ -- JAH ENCONTREI CASOS DE MAIS DE UM REGISTRO PARA A MESMA NOTA.
            FROM   SPED054,
                    SPED001,
                    VA_SM0 SM0
            WHERE  SM0.D_E_L_E_T_ = ''
                    AND SM0.M0_CODIGO = '01'
                    AND SPED001.D_E_L_E_T_ = ''
                    AND SPED001.CNPJ = SM0.M0_CGC
                    AND SPED001.IE = SM0.M0_INSC
                    AND SPED054.D_E_L_E_T_ = ''
                    AND SPED054.ID_ENT = SPED001.ID_ENT
                    AND SPED054.CSTAT_SEFR = '100' -- AUTORIZADA
            GROUP BY
                    SM0.M0_CODFIL,
                    SPED054.NFE_ID
        ) AS SPED
        ON  (
                SPED.M0_CODFIL = V.FILIAL
                AND SPED.NFE_ID = V.SERIE_CONTRANOTA + V.CONTRANOTA
        )

	-- BUSCA TABELA DE INTEGRACAO COM O PROGRAMA DE MEDICAO DO GRAU
	LEFT JOIN ZZA010 ZZA
		ON (ZZA.D_E_L_E_T_ = ''
		AND ZZA.ZZA_FILIAL = V.FILIAL
		AND ZZA.ZZA_SAFRA = V.SAFRA
		AND ZZA.ZZA_CARGA = V.CARGA
		AND ZZA.ZZA_PRODUT = V.ITEMCARGA)
		/*
	-- BUSCA A CARGA NA 'CTE' GERADA INICIALMENTE
	LEFT JOIN AGENDA
		ON (AGENDA.TrnAgeAgendaSafra = V.SAFRA
		AND AGENDA.TrnAgeTombadorFil = V.FILIAL
		AND AGENDA.InspCargaCod      = V.CARGA)
		*/
 WHERE V.STATUS != 'C'  -- NAO QUERO CARGAS CANCELADAS
	AND AGLUTINACAO != 'O'  -- NAO QUERO CARGAS QUE TENHAM SIDO AGLUTINADAS EM OUTRAS, POIS NAO TEM CONTRANOTA.
)

-- MONTA SAIDA FINAL COM DIFERENCAS DE TEMPOS CALCULADOS ENTRE AS COLUNAS
SELECT SAFRA AS GX0057_SAFRA
	, FILIAL AS GX0057_FILIAL
	, CARGA AS GX0057_CARGA
	, TOMBADOR AS GX0057_TOMBADOR
	, AGENDAMENTO AS GX0057_AGENDAMENTO
	, DATEDIFF (MINUTE, AGENDAMENTO, GERACAO_CARGA) AS GX0057_MIN_CHEGADA
	, GERACAO_CARGA AS GX0057_GERACAO_CARGA
	, DATEDIFF (MINUTE, GERACAO_CARGA, PESAGEM1) AS GX0057_MIN_FILA_RUA
	, PESAGEM1 AS GX0057_PESAGEM1
	, DATEDIFF (MINUTE, PESAGEM1, INI_MED_GRAU) AS GX0057_MIN_FILA_TOMBADOR
	, INI_MED_GRAU AS GX0057_INI_MED_GRAU
	, DATEDIFF (MINUTE, INI_MED_GRAU, FIM_MED_GRAU) AS GX0057_MIN_MEDINDO_GRAU
	, FIM_MED_GRAU AS GX0057_FIM_MED_GRAU
	, CONTRANOTA AS GX0057_CONTRANOTA
	, DATEDIFF (MINUTE, FIM_MED_GRAU, CONTRANOTA) AS GX0057_MIN_FILA_CONTRANOTA
	, DATEDIFF (MINUTE, GERACAO_CARGA, CONTRANOTA) AS GX0057_MIN_TOTAL
	, NOME_ASSOC AS GX0057_NOME_ASSOC
	, DESCRICAO AS GX0057_DESC_VARIEDADE
	, PESO_LIQ AS GX0057_PESO_LIQ
FROM CAR

 --SELECT * FROM GX0057_TEMPOS_DESCARGA_SAFRA WHERE GX0057_FILIAL = '01' AND GX0057_SAFRA = '2022'

GO
