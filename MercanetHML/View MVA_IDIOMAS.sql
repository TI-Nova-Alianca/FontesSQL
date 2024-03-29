---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	13/11/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   07/02/2014  tiago           adicionado filtro do grupo do usuario
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_IDIOMAS AS
SELECT DB_IDI_CODIGO	 CODIGO_IDI,
	   DB_IDI_DESCRICAO	 DESCRICAO_IDI,
	   DB_IDI_SIGLA	     SIGLA_IDI,
	   DB_IDI_PADRAO	 PADRAO_IDI,
	   usu.usuario,
	   usu.GRUPO_USUARIO
  FROM DB_IDIOMA, 
       DB_GRP_IDIOMA_ITEM, 
	   db_usuario usu
 where db_grpit_codigo = usu.GRUPO_IDIOMA
   and db_grpit_idioma = DB_IDI_CODIGO
