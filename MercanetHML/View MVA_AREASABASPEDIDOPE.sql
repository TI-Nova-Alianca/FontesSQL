ALTER VIEW MVA_AREASABASPEDIDOPE AS
---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   02/09/2014	TIAGO PRADELLA	   CRIACAO
---------------------------------------------------------------------------------------------------
 SELECT ABA.GRUPO_USUARIO       GRUPOUSUARIO_AREAPE,
        ABA.ABA					ABA_AREAPE,
        ABA.AREA				AREA_AREAPE,
        ABA.COLUNAS				COLUNAS_AREAPE,
        USU.USUARIO
   FROM DB_MOB_AREAS_ABAS_PEDIDO_PE ABA,
        DB_USUARIO USU,
        DB_GRUPO_USUARIOS GRUPO
  WHERE USU.GRUPO_USUARIO = GRUPO.CODIGO
    AND ABA.GRUPO_USUARIO = USU.GRUPO_USUARIO
    AND ABA.ABA IN (SELECT ABA
                      FROM MVA_ABASPEDIDOPE ABA2
                     WHERE USU.USUARIO = ABA2.USUARIO);
