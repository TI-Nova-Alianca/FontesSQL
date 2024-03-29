---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			 ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	 CRIACAO
-- 1.0002   19/11/2013  tiago            incluido no where DB_TBHC_NAOSOMACC
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_SALDOCONTACORRENTE AS
 SELECT 'SALDOCONTACORRENTE'              NOME_CONFIG,
        ISNULL(SUM(DB_ECON_VALOR), 0)  AS VALOR_CONFIG,
        USUARIO
   FROM DB_TB_HISTCC, DB_ECONOMIA, DB_USUARIO
  WHERE DB_TBHC_CODIGO = DB_ECON_COD_HIST 
    --AND DB_TBHC_DEFAULT = 8
	AND DB_ECON_REPRES IN (SELECT REP.CODIGO_REPRES  FROM MVA_REPRESENTANTES REP WHERE REP.USUARIO = DB_USUARIO.USUARIO)
	and DB_TBHC_NAOSOMACC = 0
  GROUP BY USUARIO
