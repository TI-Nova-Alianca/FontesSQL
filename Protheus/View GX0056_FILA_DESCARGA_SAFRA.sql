USE [protheus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].GX0056_FILA_DESCARGA_SAFRA
AS

-- Cooperativa Agroindustrial Nova Alianca Ltda
-- View para buscar situacao das cargas durante a safra e mostrar a fila descarga (GLPI 11376)
-- Autor: Robert Koch
-- Data:  17/12/2021
-- Historico de alteracoes:
--

SELECT 
	ZE_SAFRA AS GX0056_SAFRA,
	ZE_FILIAL AS GX00056_FILIAL,
	ZE_CARGA AS GX00056_CARGA,
	CASE WHEN (select A.TrnAgeAgendaSit
				from LKSRV_NAWEB.naweb.dbo.TrnAgeAgenda A
					,LKSRV_NAWEB.naweb.dbo.TrnAgeTombador T
					,LKSRV_NAWEB.naweb.dbo.SFInspCarga I
				WHERE T.TrnAgeTombadorCod = A.TrnAgeTombadorCod
					AND I.InspCargaAgendaId = A.TrnAgeAgendaOri
					AND A.TrnAgeAgendaSafra = SZE.ZE_SAFRA
					AND T.TrnAgeTombadorFil = SZE.ZE_FILIAL
					AND I.InspCargaCod = SZE.ZE_CARGA)
				IN ('LIB','SEG','CON','INS')
			THEN 'OK'
			ELSE ''
			END AS GX00056_LIB_ENTRADA,
	CASE WHEN SZE.ZE_PESOBRU > 0
		THEN 'OK'
		ELSE ''
		END AS GX00056_1A_PES,
	CASE ZZA.ZZA_STATUS
		WHEN '2' THEN 'EM DESCARGA'  -- STATUS GERADO PELO PROGRAMA DE LEITURA DO GRAU
		WHEN '3' THEN 'OK'  -- STATUS GERADO PELO PROGRAMA DE LEITURA DO GRAU
		WHEN 'M' THEN 'OK'  -- STATUS GERADO PELA 2A.PESAGEM QUANDO O GRAU FOR INFORMADO MANUALMENTE
		ELSE ''
		END AS GX00056_DESCARGA,
	CASE WHEN SZE.ZE_PESOTAR > 0
		THEN 'OK'
		ELSE ''
		END AS GX00056_2A_PES
FROM 
	SZE010 SZE
	LEFT JOIN ZZA010 ZZA
		ON (ZZA.D_E_L_E_T_ = ''
		AND ZZA.ZZA_FILIAL = SZE.ZE_FILIAL
		AND ZZA.ZZA_SAFRA  = SZE.ZE_SAFRA
		AND ZZA.ZZA_CARGA  = SZE.ZE_CARGA
		AND ZZA.ZZA_PRODUT = '01')
WHERE SZE.D_E_L_E_T_ = ''
	AND SZE.ZE_STATUS != 'C'  -- CARGA CANCELADA
	
	-- JAH QUE TENHO INDICE PELO ZE_SAFRA, VALE A PENA USAR.
	-- PEGO JUNTO A SAFRA ANTERIOR POR QUE A SAFRA PODE INICIAR EM DEZEMBRO, BEM COMO FAZEMOS TESTES ANTES DA SAFRA.
	AND ZE_SAFRA >= DATEPART (YEAR, GETDATE ())
	
	-- SOMENTE CARGAS GERADAS NAS ULTIMAS HORAS
	AND cast (SZE.ZE_DATA + ' ' + SZE.ZE_HORA as datetime) >= DATEADD (HOUR, -24, GETDATE())
GO

-- select * from GX0056_FILA_DESCARGA_SAFRA
