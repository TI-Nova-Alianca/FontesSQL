
ALTER VIEW [dbo].[NW0001_SAC_INTERACAO] AS 

SELECT
	count(sac_interacao_status) as NW0001_SAC_INTERACAO_QTD,
	sac_status_desc AS NW0001_SAC_INTERACAO_DESC,
	month(sac_interacao_data) as NW0001_SAC_INTERACAO_MES,
	year(sac_interacao_data) as NW0001_SAC_INTERACAO_ANO
FROM SacInteracao 
	INNER JOIN sac_status ON (sac_interacao_status = sac_status_id)
GROUP BY sac_status_desc, sac_interacao_data

