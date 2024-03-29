---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	20/10/2015	TIAGO PRADELLA	CRIACAO
-- 1.0002   05/04/2016  tiago           incluido campo motivo bonificacao
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_LUCFATORATRIBUTOSCLIENTE AS
WITH TEMPNUMBER AS
(
  SELECT LINHA = 1
  WHERE 1 < 50
  UNION ALL
  SELECT  LINHA + 1
  FROM TEMPNUMBER
  WHERE LINHA + 1 <= 50
)
 SELECT CODIGO_FATOR    CODIGOFATOR_LUCFATRC,
		ATRIBUTO		ATRIBUTO_LUCFATRC,
        DBO.MERCF_PIECE(VALOR, ',', P_TEMPORARIA.LINHA)	 VALOR_LUCFATRC 
   FROM DB_LUC_FATOR_ATRIB_CLIENTE,
		MVA_LUCRA_FATOR,
        TEMPNUMBER P_TEMPORARIA
  WHERE ISNULL(DBO.MERCF_PIECE(VALOR, ',', P_TEMPORARIA.LINHA), '') <> ''
	AND CODIGO_LUCFAT = CODIGO_FATOR
