---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	10/07/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW  MVA_AREASATUACAO AS
SELECT DB_AREA_CODIGO	CODIGO_AREAATU,
       DB_AREA_DESCR	DESCRICAO_AREATU,
	   USUARIO
  FROM DB_AREA_ATUACAO,
       DB_USUARIO          USU,
       DB_GRUPO_USUARIOS   GRUPO_USU,
       DB_FILTRO_GRUPOUSU  FILTRO
 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
   AND FILTRO.CODIGO_GRUPO        = USU.GRUPO_USUARIO
   AND FILTRO.ID_FILTRO           = 'AREAATUACAO' -- MARCA PRODUTO
   AND FILTRO.VALOR_STRING        = DB_AREA_CODIGO
   UNION all
   SELECT distinct DB_AREA_CODIGO	CODIGO_AREAATU,
       DB_AREA_DESCR	DESCRICAO_AREATU,
	   USUARIO
  FROM DB_AREA_ATUACAO,
       DB_USUARIO          USU
   where NOT EXISTS ( SELECT 1 FROM DB_FILTRO_GRUPOUSU  FILTRO
                      WHERE FILTRO.CODIGO_GRUPO  = USU.GRUPO_USUARIO
                        AND FILTRO.ID_FILTRO   = 'AREAATUACAO')
