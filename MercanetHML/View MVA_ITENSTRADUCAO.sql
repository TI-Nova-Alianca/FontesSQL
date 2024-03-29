---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	16/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   30/11/2015  TIAGO           INCLUIDO CAMPOS hash_ITRA e textoOrigem_ITRA
-- 1.0002   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ITENSTRADUCAO AS
SELECT DB_ITTR_PRODUTO	     PRODUTO_ITRA,
	   DB_ITTR_CATALOGO	     CATALOGO_ITRA,
	   DB_ITTR_TIPO_TEXTO    TIPOTEXTO_ITRA,
	   DB_ITTR_IDIOMA	     IDIOMA_ITRA,
	   DB_ITTR_TRADUCAO	     TRADUCAO_ITRA,
	   DB_ITTR_HASH          hash_ITRA,
	   DB_ITTR_TEXTO_ORIGEM  textoOrigem_ITRA,
	   I.USUARIO,
	   I.DATAALTER
  FROM DB_ITEM_TRADUCAO, MVA_ITENSCATALOGO I
 WHERE I.PRODUTO_ITCAT = DB_ITTR_PRODUTO
