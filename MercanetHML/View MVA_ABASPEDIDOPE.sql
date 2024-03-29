---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   02/09/2014	TIAGO PRADELLA	   CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ABASPEDIDOPE AS
SELECT ABA.GRUPO_USUARIO     GRUPOUSUARIO_ABAPE,
       ABA.ABA               ABA_ABAPE,
       ABA.LABEL             LABEL_ABAPE,
       ABA.APRESENTA_PEDIDO  APRESENTAPEDIDO_ABAPE,
       USU.USUARIO
  FROM DB_MOB_ABAS_PEDIDO_PE ABA, DB_USUARIO USU, DB_GRUPO_USUARIOS GRUPO
 WHERE USU.GRUPO_USUARIO = GRUPO.CODIGO
   AND ABA.GRUPO_USUARIO = USU.GRUPO_USUARIO;
