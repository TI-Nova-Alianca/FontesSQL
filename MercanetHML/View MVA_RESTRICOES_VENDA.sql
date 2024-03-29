---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   29/03/2017	TIAGO PRADELLA	   CRIACAO
-- 1.0002   18/04/2017  tiago              converto para varchar, DB_RESR_CODIGO, por causa dos tipo de dados diferentes
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_RESTRICOES_VENDA  AS
WITH politica as ( select distinct CODIGOPOLITICA_POLIT from MVA_POLITICAS )
 select DB_RESR_CODIGO		codigo_RESVDA,
		DB_RESR_SEQ			sequencia_RESVDA,
		DB_RESR_SEQPAI      regra_RESVDA,
		DB_RESR_TAGFILTRO   tagFiltro_RESVDA,
		DB_RESR_VARIAVEL    variavel_RESVDA
   from DB_RESTR_REGRAS, politica   pol
  where cast(DB_RESR_CODIGO as varchar) = pol.CODIGOPOLITICA_POLIT
    and isnull(DB_RESR_VARIAVEL, '') <> ''
