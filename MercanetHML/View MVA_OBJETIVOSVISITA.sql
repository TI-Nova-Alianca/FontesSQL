---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   07/10/2014  TIAGO           INCLUIDO CAMPO TIPO VENDA
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_OBJETIVOSVISITA AS
SELECT DB_TBORV_CODIGO         CODIGO_OBJVI,
       DB_TBORV_DESCRICAO      DESCRICAO_OBJVI,
	   DB_TBORV_VENDA          VENDA_OBJVI,
       DB_TBORV_JUSTNVISITA    justnVisita_OBJVI
  FROM DB_TB_OBJRELVIS
