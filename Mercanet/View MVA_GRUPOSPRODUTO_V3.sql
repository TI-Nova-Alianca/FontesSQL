
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   20/02/2013  tiago           incluido funcao MERCF_PIECE validando o campo valor_string,
--                                      pegando somente a parte da lista que corresponde ao grupo 
-- 1.0003   18/02/2014  tiago           alterado join das tabelas para quem nao tem grupo informado
---------------------------------------------------------------------------------------------------

ALTER VIEW MVA_GRUPOSPRODUTO_V3 AS

WITH
prod as ( SELECT (CODIGO_PRODU) PRODUTO, usuario, grupo_produ, familia_produ
                FROM MVA_PRODUTOS_V3
			   WHERE MVA_PRODUTOS_V3.USUARIO in ( select usuario
															  from DB_USUARIO_SESSIONID
															 where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID) ))

SELECT GRUPO.DB_GRUPO_COD        CODIGO_GRPRO,
       GRUPO.DB_GRUPO_DESCRICAO  DESCRICAO_GRPRO,
       GRUPO.DB_GRUPO_FAMILIA    FAMILIA_GRPRO,
       USU.USUARIO
  FROM DB_USUARIO          USU,
       DB_GRUPO_USUARIOS   GRUPO_USU,
       DB_FILTRO_GRUPOUSU  FILTRO,
       DB_TB_GRUPO         GRUPO,
	   PROD
 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
   AND FILTRO.CODIGO_GRUPO        = USU.GRUPO_USUARIO
   AND FILTRO.ID_FILTRO           = 'GRUPOPROD' -- GRUPO PRODUTO
  and GRUPO.DB_GRUPO_COD = substring(FILTRO.VALOR_STRING, 1, charindex(',', FILTRO.VALOR_STRING) - 1)
   and GRUPO.DB_GRUPO_FAMILIA = substring(FILTRO.VALOR_STRING, charindex(',', FILTRO.VALOR_STRING) + 1, len(FILTRO.VALOR_STRING))   
   
   AND USU.USUARIO = PROD.USUARIO  
   and PROD.grupo_produ  = grupo.DB_GRUPO_COD 
   and PROD.familia_produ  = GRUPO.DB_GRUPO_FAMILIA
				 


UNION

SELECT GRUPO.DB_GRUPO_COD        CODIGO_GRPRO,
       GRUPO.DB_GRUPO_DESCRICAO  DESCRICAO_GRPRO,
       GRUPO.DB_GRUPO_FAMILIA    FAMILIA_GRPRO,
       USU.USUARIO
  FROM DB_USUARIO          USU,
       DB_GRUPO_USUARIOS   GRUPO_USU ,
       DB_TB_GRUPO         GRUPO,
	   PROD
 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
   AND NOT EXISTS ( SELECT 1 FROM DB_FILTRO_GRUPOUSU  FILTRO
                      WHERE FILTRO.CODIGO_GRUPO     = USU.GRUPO_USUARIO
                         AND FILTRO.ID_FILTRO        = 'GRUPOPROD') -- GRUPO PRODUTO 
   AND USU.USUARIO = PROD.USUARIO  
   and PROD.grupo_produ  = grupo.DB_GRUPO_COD 
   and PROD.familia_produ  = GRUPO.DB_GRUPO_FAMILIA
