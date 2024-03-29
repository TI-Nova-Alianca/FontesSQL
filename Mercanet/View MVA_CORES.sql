---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	31/01/2014	TIAGO PRADELLA	CRIACAO
-- 1.0001   14/02/2014  tiago           envia _P.pngm ou _G.pngm para a cor
-- 1.0002   25/05/2014  tiago           incluido campo DATAALTER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CORES AS
SELECT DB_COR_CODIGO	    CODIGO_COR ,
	   case when DB_COR_IMG_TEMPLATE is not null then cast(DB_COR_CODIGO as varchar) + '_P.pngm' else '' end	IMAGEMPEQUENA_COR ,
	   case when DB_COR_IMG_LISTA is not null 	 then cast(DB_COR_CODIGO as varchar) + '_G.pngm' else '' end   IMAGEMGRANDE_COR,
	   DB_COR_DESCR			DESCRICAO_COR,
	   DB_COR_DATAALTER     DATAALTER
  FROM DB_COR
