---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	25/11/2014	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_OPCOESFATURAMENTO  AS
 SELECT DB_OFAT_CODIGO      CODIGO_OPFATUR,
		DB_OFAT_DESCRICAO   DESCRICAO_OPFATUR,
		DB_OFAT_FAT_PARC    FATURAPARCIAL_OPFATUR,
		DB_OFAT_PADRAO      PADRAO_OPFATUR,
		DB_OFAT_GRD_COMP	gradeCompl_OPFATUR,
		DB_OFAT_ANT_FAT		antFatur_OPFATUR
   FROM DB_OPCAO_FATURA
