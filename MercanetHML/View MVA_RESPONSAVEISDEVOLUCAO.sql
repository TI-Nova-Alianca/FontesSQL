---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	08/01/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_RESPONSAVEISDEVOLUCAO AS	
 SELECT DB_TBRAT_CODIGO  CODIGO_RESPDEV,
		DB_TBRAT_NOME   DESCRICAO_RESPDEV,
		DB_TBRAT_TIPO   TIPO_RESPDEV
   FROM DB_TB_RESPASSTEC
