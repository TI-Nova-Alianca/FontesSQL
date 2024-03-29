---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	20/10/2015	TIAGO PRADELLA	CRIACAO
-- 1.0002   05/04/2016  tiago           incluido campo motivo bonificacao
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_LUCFATORATRIBUTOSPRODUTO AS
 WITH TEMPNUMBER AS
(
  SELECT LINHA = 1
  WHERE 1 < 50
  UNION ALL
  SELECT  LINHA + 1
  FROM TEMPNUMBER
  WHERE LINHA + 1 <= 50
)
SELECT CODIGO_FATOR    CODIGOFATOR_LUCFATRP,
        SEQUENCIA       SEQUENCIA_LUCFATRP,
		ATRIBUTO		ATRIBUTO_LUCFATRP,
        DBO.MERCF_PIECE(VALOR, ',', P_TEMPORARIA.LINHA)	 VALOR_LUCFATRP 
   FROM DB_LUC_FATOR_ATRIB_PRODUTO,
		MVA_LUCRA_FATOR,
        TEMPNUMBER P_TEMPORARIA
  WHERE ISNULL(DBO.MERCF_PIECE(VALOR, ',', P_TEMPORARIA.LINHA), '') <> ''
	AND CODIGO_LUCFAT = CODIGO_FATOR
