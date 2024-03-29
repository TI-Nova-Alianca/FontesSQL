

ALTER VIEW [dbo].[NW001_AMOSTRA] AS 

SELECT
	TrnLabAmostra.TrnLabAmostraFilial AS NW001_AMOSTRA_FILIAL, 
	TrnLabAmostra.TrnLabAmostraCarga AS NW001_AMOSTRA_CARGA, 
	AVG(TrnLabAmostraRespH) AS NW001_AMOSTRA_pH, 
	AVG(TrnLabAmostraResAT) AS NW001_AMOSTRA_AT, 
	AVG(TrnLabAmostraResBrix) AS NW001_AMOSTRA_BRIX,
	 AVG(TrnLabAmostraResBabo) AS NW001_AMOSTRA_BABO,
	AVG(TrnLabAmostraResDen) AS NW001_AMOSTRA_DEN,
	COUNT(TrnLabAmostraResRep) as NW001_AMOSTRA_QTD_REP 
from TrnLabAmostraResultado left join TrnLabAmostra on (TrnLabAmostraResultado.TrnLabAmostraId = TrnLabAmostra.TrnLabAmostraId)
group by TrnLabAmostraFilial, TrnLabAmostraCarga



