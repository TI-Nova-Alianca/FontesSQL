---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	16/10/2012	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_FAIXASNUMERACAO   AS
SELECT DB_NUMP_REPRES      REPRESENTANTE_FANUM,
	   DB_NUMP_SEQ         SEQUENCIA_FANUM,
	   DB_NUMP_TIPO        TIPO_FANUM,
	   DB_NUMP_FXINI       FAIXAINICIAL_FANUM,
	   DB_NUMP_FXFIN       FAIXAFINAL_FANUM,
	   DB_NUMP_FXUTI       FAIXAUTILIZADA_FANUM,
	   usu.USUARIO
  FROM DB_NUM_PEDIDO, db_usuario usu
 WHERE  DB_NUMP_FXTIPO = 2
   and usu.FAIXA_NUMERACAO = DB_NUMP_REPRES
