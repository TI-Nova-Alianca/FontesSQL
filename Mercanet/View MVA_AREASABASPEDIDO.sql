ALTER VIEW MVA_AREASABASPEDIDO  AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	24/05/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   04/11/2014  tiago           incluido campo SUBAREA_AREAPED
-- 1.0003   25/06/2015  tiago           incluido campos label e apresenta pedido
---------------------------------------------------------------------------------------------------
SELECT ABA.GRUPO_USUARIO	GRUPOUSUARIO_AREAPED,
	   ABA.ABA				ABA_AREAPED,
	   ABA.AREA				AREA_AREAPED,
	   ABA.COLUNAS			COLUNAS_AREAPED,
	   SUBAREA              SUBAREA_AREAPED,
	   LABEL                LABEL_AREAPED,
	   APRESENTA_PEDIDO     APRESENTAPEDIDO_AREAPED,
	   APRESENTA_RECOLHIDO  APRESENTARECOLHIDO_AREAPED,
	   APRESENTA_IMAGEM		APRESENTAIMAGEM_AREAPED,
	   PERMITE_EXPANDIR		permiteExpandir_AREAPED,
	   NUMERO_LINHAS		numeroLinhas_AREAPED,
	   ALINHAMENTO			alinhamento_AREAPED,
	   NAO_EXIBE_ROLAGEM	naoExibeRolagem_AREAPED,
	   USU.USUARIO
  FROM DB_MOB_AREAS_ABAS_PEDIDO ABA, DB_USUARIO USU, DB_GRUPO_USUARIOS GRUPO
 WHERE USU.GRUPO_USUARIO = GRUPO.CODIGO
   AND ABA.GRUPO_USUARIO = USU.GRUPO_USUARIO
   AND ABA.ABA IN (SELECT ABA 
                     FROM MVA_ABASPEDIDO ABA2
					WHERE USU.USUARIO = ABA2.USUARIO)
