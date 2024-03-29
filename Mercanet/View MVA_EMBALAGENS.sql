---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	31/01/2014	TIAGO PRADELLA	CRIACAO
-- 1.0001   24/06/2014  tiago           incluido campo embalagem
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_EMBALAGENS AS
SELECT DB_TBEMB_CODIGO	  CODIGO_EMB, 
	   DB_TBEMB_DESCR	  DESCRICAO_EMB,
	   DB_TBEMB_CUBAGEM   CUBAGEM_EMB,
	   DB_TBEMB_MASTER	  MASTER_EMB,
	   DB_TBEMB_QTDE      EMBALAGEM_EMB
  FROM DB_TB_EMBALAGEM
