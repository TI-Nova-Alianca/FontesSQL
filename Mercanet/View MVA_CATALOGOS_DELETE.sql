---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	24/02/2016	TIAGO PRADELLA	CRIACAO
-- 1.0001   11/03/2016  tiago           envia catalogos inativos
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOS_DELETE AS
SELECT DISTINCT DB_CAT_CODIGO CATALOGO_CAT,
       C.USUARIO
  FROM DB_CATALOGO, MVA_CATALOGOS C
 WHERE (DB_CAT_CODIGO NOT IN (SELECT P.CATALOGO_PERMC FROM MVA_PERMISSOESCATALOGO P WHERE C.USUARIO = P.USUARIO) or DB_CATALOGO.DB_CAT_SITUACAO = 1)
