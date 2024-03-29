---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_REGIOESCOMERCIAIS  AS
SELECT TB01_CODIGO		CODIGO_RECOM,
	   TB01_DESCR		DESCRICAO_RECOM,
	   TB01_LSTDISTR	listaDistribuidores_RECOM,
	   USU.USUARIO
  FROM MTB01,
       DB_USUARIO   USU,
	   DB_FILTRO_GRUPOUSU FILTRO
 WHERE FILTRO.ID_FILTRO = 'REGIAOCOM'
   AND FILTRO.VALOR_STRING = TB01_CODIGO
   AND USU.GRUPO_USUARIO = FILTRO.CODIGO_GRUPO
UNION 
SELECT TB01_CODIGO		CODIGO_RECOM,
	   TB01_DESCR		DESCRICAO_RECOM,
	   TB01_LSTDISTR	listaDistribuidores_RECOM,
	   USU.USUARIO
  FROM MTB01,
       DB_USUARIO   USU
 WHERE NOT EXISTS (SELECT 1
					 FROM DB_FILTRO_GRUPOUSU FILTRO
				    WHERE FILTRO.CODIGO_GRUPO = USU.GRUPO_USUARIO
					  AND FILTRO.ID_FILTRO = 'REGIAOCOM'
                      AND USU.GRUPO_USUARIO = FILTRO.CODIGO_GRUPO)
