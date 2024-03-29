



ALTER VIEW [dbo].[NW001_PROBLEMAS] AS 

WITH TAB AS
(
	SELECT 
		sac_problema AS PROBLEMA,
		month(sac_data_abertura) as MES,
		year(sac_data_abertura) as ANO
	FROM Sac
	WHERE
	sac_problema <> ''
)


SELECT 
	COUNT(PROBLEMA) AS NW001_PROBLEMAS_QTDE, 

	PROBLEMA AS NW001_PROBLEMAS_COD,  
	CASE 
		WHEN PROBLEMA = 'C' THEN 'Qualidade'
		WHEN PROBLEMA = 'B' THEN 'Biológico'
		WHEN PROBLEMA = 'Q' THEN 'Químico'
		WHEN PROBLEMA = 'F' THEN 'Físico'
	END  as NW001_PROBLEMAS_DESCRICAO,
	MES AS NW001_PROBLEMAS_MES, 
	ANO AS NW001_PROBLEMAS_ANO
FROM TAB
GROUP BY  PROBLEMA, MES, ANO




