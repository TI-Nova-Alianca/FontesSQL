
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   1/11/2012   TIAGO PRADELLA  INCLUIDA CONDICAO DE FAMILIA NO WHERE
-- 1.0003   20/02/2013  tiago           condicao para buscar familias que pertencem ao grupo cadastrado do usuario
-- 1.0004   18/02/2014  tiago           alterado join das tabelas para quem nao tem familia informada
-- 1.0005   11/12/2014  TIAGO           INCLUIDO NOVOS CAMPO: custoIndustrialProduzido_FAPRO, custoIndustrialRevenda_FAPRO, custoAdministrativo_FAPRO, custoComercial_FAPRO
-- 1.0006   15/09/2015  tiago           retirado distinct
---------------------------------------------------------------------------------------------------

ALTER VIEW MVA_FAMILIASPRODUTO_V3 AS

WITH
prod as ( SELECT (CODIGO_PRODU) PRODUTO, FAMILIA_PRODU
                FROM MVA_PRODUTOS_V3
			   WHERE MVA_PRODUTOS_V3.USUARIO in ( select usuario
															  from DB_USUARIO_SESSIONID
															 where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID) ))

, USU_SESSION  AS (select usuario
						from DB_USUARIO_SESSIONID
					   where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID))


SELECT FAMILIA.DB_TBFAM_CODIGO     CODIGO_FAPRO,
       FAMILIA.DB_TBFAM_DESCRICAO         DESCRICAO_FAPRO,
	   CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_IND, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_IND
			ELSE DB_TBFAM_CFFAT_IND END      custoIndustrialProduzido_FAPRO,
		CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_ADM, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_INR
			ELSE DB_TBFAM_CFFAT_INR END         custoIndustrialRevenda_FAPRO,
		CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_IND, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_ADM
			ELSE DB_TBFAM_CFFAT_ADM  END custoAdministrativo_FAPRO,
		CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_COM, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_COM
			ELSE DB_TBFAM_CFFAT_COM END    custoComercial_FAPRO,
       USU.USUARIO
  FROM DB_USUARIO          USU,
       DB_GRUPO_USUARIOS   GRUPO_USU,
       DB_FILTRO_GRUPOUSU  FILTRO,
       DB_TB_FAMILIA       FAMILIA,
	   PROD,
	   USU_SESSION
 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
   AND FILTRO.CODIGO_GRUPO        = USU.GRUPO_USUARIO
   AND UPPER(FILTRO.ID_FILTRO)    = 'FAMILIAPROD' -- FAMILIA PRODUTO
   AND FILTRO.VALOR_STRING        = FAMILIA.DB_TBFAM_CODIGO
   and PROD.FAMILIA_PRODU = FAMILIA.DB_TBFAM_CODIGO
	--and (DB_TBFAM_CODIGO in (SELECT dbo.MERCF_PIECE(g.VALOR_STRING, ',', 2) 
	--                        FROM DB_FILTRO_GRUPOUSU  g
	--								  WHERE g.CODIGO_GRUPO     = USU.GRUPO_USUARIO
	--									 AND g.ID_FILTRO        = 'GRUPOPROD')
	--	 or FILTRO.VALOR_STRING = FAMILIA.DB_TBFAM_CODIGO)
	and USU_SESSION.usuario = usu.usuario
	

UNION

SELECT FAMILIA.DB_TBFAM_CODIGO CODIGO_FAPRO,
       FAMILIA.DB_TBFAM_DESCRICAO  DESCRICAO_FAPRO,
	   CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_IND, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_IND
			ELSE DB_TBFAM_CFFAT_IND END      custoIndustrialProduzido_FAPRO,
		CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_ADM, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_INR
			ELSE DB_TBFAM_CFFAT_INR END         custoIndustrialRevenda_FAPRO,
		CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_IND, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_ADM
			ELSE DB_TBFAM_CFFAT_ADM  END custoAdministrativo_FAPRO,
		CASE WHEN (SELECT ISNULL(DB_PRM_CUSTO_COM, 0) FROM DB_PARAMETRO1) = 0
	        THEN DB_TBFAM_CUSTO_COM
			ELSE DB_TBFAM_CFFAT_COM END    custoComercial_FAPRO,
       usu.USUARIO
   FROM DB_USUARIO          USU,
       DB_GRUPO_USUARIOS   GRUPO_USU,
       DB_TB_FAMILIA       FAMILIA,
	   PROD,
	   USU_SESSION
 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
   AND NOT EXISTS ( SELECT 1 FROM DB_FILTRO_GRUPOUSU  FILTRO
                      WHERE FILTRO.CODIGO_GRUPO      = USU.GRUPO_USUARIO
                         AND UPPER(FILTRO.ID_FILTRO) = 'FAMILIAPROD') -- FAMILIA PRODUTO
  and PROD.FAMILIA_PRODU = FAMILIA.DB_TBFAM_CODIGO
  and USU_SESSION.usuario = usu.usuario
