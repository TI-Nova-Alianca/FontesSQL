---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	22/06/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ITEMIMAGEMVINCULADA AS
 SELECT PRODUTO_PRINCIPAL	PRODUTOPRINCIPAL_IMGV,
		PRODUTO_VINCULADO	PRODUTOVINCULADO_IMGV,
		CATALOGO	CATALOGO_IMGV,
		I.USUARIO,
		I.DATAALTER
   FROM DB_ITEM_IMAGEMVINC, MVA_ITENSCATALOGO I
  WHERE (I.PRODUTO_ITCAT = PRODUTO_PRINCIPAL)
    AND CATALOGO = I.CATALOGO_ITCAT
