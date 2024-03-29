---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	18/04/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   04/11/2013  Alencar/Tiago   Criada subquery para melhora de performance
----------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PROGRAMASDEAJUSTE AS
SELECT DB_PROGP_CODIGO     PROGRAMA_PROAJ,
       DB_PROGP_POLITICA   POLITICA_PROAJ,
       DB_PROGP_SEQAPLIC   SEQUENCIAAPLICACAO_PROAJ,
       DB_PROGP_APLSOBRE   APLICASOBRE_PROAJ,
       DB_PROGP_TIPO_POL   TIPOPOLITICA_PROAJ,
       db_usuario.usuario
  FROM DB_PROGA_POLITICAS
     , db_usuario
 WHERE exists ( select * 
                  from DB_PROGA_CLIENTES
                     , MVA_CLIENTE
                 where DB_PROGP_CODIGO = DB_PROGC_CODIGO
                   and DB_PROGC_CLIENTE = CODIGO_CLIEN
                   and PROGRAMAAJUSTE_CLIEN = DB_PROGC_CODIGO
                   and usuario = db_usuario.usuario)
