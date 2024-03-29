ALTER VIEW MVA_ABASPEDIDO  AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	24/05/2013	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
SELECT ABA.GRUPO_USUARIO	  GRUPOUSUARIO_ABAPED,
	   ABA.ABA		          ABA_ABAPED,
	   ABA.LABEL			  LABEL_ABAPED,
	   ABA.APRESENTA_PEDIDO	  APRESENTAPEDIDO_ABAPED,
	   ABA.EXIBE_COLUNAS	  EXIBECOLUNAS_ABAPED,
	   isnull(AGRUPAMENTO_PADRAO, 0)     agrupPadrao_ABAPED,
	   isnull(ATRIBUTO_AGRUPAMENTO, 0)	  atribAgrup_ABAPED,
	   USU.USUARIO
  FROM DB_MOB_ABAS_PEDIDO ABA, DB_USUARIO USU, DB_GRUPO_USUARIOS GRUPO 
 WHERE USU.GRUPO_USUARIO = GRUPO.CODIGO
   AND ABA.GRUPO_USUARIO = USU.GRUPO_USUARIO
