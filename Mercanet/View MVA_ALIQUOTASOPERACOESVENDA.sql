---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   14/06/2013  ALENCAR\TIAGO   MUDADO WHERE PARA UMA SUB COM IN
-- 1.0003   17/06/2013  TIAGO           INCLUIDO CAMPO BONIFICACAO
-- 1.0004   23/09/2014  TIAGO           INCLUIDO CAMPO CFOP_AOPER
-- 1.0004   29/09/2014  tiago           traz todas operacoes caso o usuario nao tenha filtro
-- 1.0005   04/11/2014  tiago           ajustes para melhorar a performance
-- 1.0006   20/03/2015  tiago           incluido campo ICMSDescontado_AOPER
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ALIQUOTASOPERACOESVENDA AS
SELECT DB_TBOPSI_COD      OPERACAOVENDA_AOPER , 
       DB_TBOPSI_UF_ORIG  UFORIGEM_AOPER  , 
       DB_TBOPSI_UF       UFDESTINO_AOPER   , 
       DB_TBOPSI_ICMS     ALIQUOTA_AOPER   ,       
       DB_TBOPSI_BASERED  BASE_AOPER,
       DB_TBOPSI_BONIF    BONIFICACAO_AOPER,
       DB_TBOPSI_CFOP     CFOP_AOPER,
	   DB_TBOPSI_ICMSDSCTO  ICMSDescontado_AOPER,
       oper.USUARIO USUARIO 
 FROM DB_TB_OPERS_UF,
      MVA_OPERACOESVENDA OPER
WHERE DB_TBOPSI_COD = OPER.CODIGO_OPERV 
  AND DB_TBOPSI_UF IN (SELECT (VALOR_STRING) 
                         FROM DB_FILTRO_GRUPOUSU  FILTRO 
                            , db_usuario   usu2
                         WHERE FILTRO.CODIGO_GRUPO = USU2.GRUPO_USUARIO
                           AND FILTRO.ID_FILTRO = 'UF'
                           AND OPER.USUARIO = USU2.USUARIO)
union all
SELECT DB_TBOPSI_COD      OPERACAOVENDA_AOPER , 
       DB_TBOPSI_UF_ORIG  UFORIGEM_AOPER  , 
       DB_TBOPSI_UF       UFDESTINO_AOPER   , 
       DB_TBOPSI_ICMS     ALIQUOTA_AOPER   ,       
       DB_TBOPSI_BASERED  BASE_AOPER,
       DB_TBOPSI_BONIF    BONIFICACAO_AOPER,
       DB_TBOPSI_CFOP     CFOP_AOPER,
	   DB_TBOPSI_ICMSDSCTO  ICMSDescontado_AOPER,
       oper.USUARIO USUARIO 
 FROM DB_TB_OPERS_UF , 
      MVA_OPERACOESVENDA OPER
WHERE DB_TBOPSI_COD = OPER.CODIGO_OPERV 
  AND not exists (SELECT UPPER(VALOR_STRING) 
                   FROM DB_FILTRO_GRUPOUSU  FILTRO 
                      , db_usuario   usu2
                   WHERE FILTRO.CODIGO_GRUPO = USU2.GRUPO_USUARIO
                     AND FILTRO.ID_FILTRO = 'UF'
                     AND OPER.USUARIO = USU2.USUARIO)
