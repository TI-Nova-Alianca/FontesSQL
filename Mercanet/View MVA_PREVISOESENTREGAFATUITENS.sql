---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   19/11/2012  TIAGO PRADELLA  INCLUSAO DE CAMPOS DE RESTRICAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PREVISOESENTREGAFATUITENS AS
SELECT DB_PEND_CODIGO                   CODIGO_PEFIT,
	   DB_PEND_SEQ                      SEQUENCIA_PEFIT,
	   DB_PEND_DIAS                     DIAS_PEFIT,
	   DB_PEND_TP_VEND                  TIPOVENDA_PEFI,
	   DB_PEND_DT_FIXA                  DATAFIXA_PEFIT,
	   DB_PEND_DIASEM                   DIASEMANA_PEFIT,
	   DB_PEND_HORA                     HORA_PEFIT,
	   DB_PEND_DIASENT                  DIASENTREGA_PEFIT,
	   --DB_PEND_                       TIPOAVALIACAO_PEFIT,
	   DB_PEND_PESO                     PESO_PEFIT,
	   ------
	   DB_PEND_PRODUTOS                 PRODUTO,
	   DB_PEND_FAMILIAS                 FAMILIA,
	   DB_PEND_GRUPOS                   GRUPO,
	   DB_PEND_MARCAS                   MARCA,
	   DB_PEND_TP_PROD                  TIPO,
	   cast(DB_PEND_TP_VEND as varchar) TIPOVENDA,
	   DB_PEND_CIDADE                   CIDADEITEM,
	   DB_PEND_UF                       UFITEM,
	   DB_PEND_BAIRRO                   BAIRRO,
	   usu.usuario
  FROM DB_PREVISAO_DIAS,
       db_usuario usu
 WHERE DB_PEND_CODIGO IN (SELECT CODIGO_PENFA
                            FROM MVA_PREVISOESENTREGAFATU
							where usu.USUARIO = usuario)
