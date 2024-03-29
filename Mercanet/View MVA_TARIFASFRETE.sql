---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	05/03/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_TARIFASFRETE  AS
 SELECT DB_TBTAR_TRANSP	       TRANSPORTADOR_TARF,
		DB_TBTAR_CONDFRETE	   CONDICAOFRETE_TARF,
		DB_TBTAR_SEQ	       SEQUENCIA_TARF,
		DB_TBTAR_VALIDINI	   VALIDADEINICIAL_TARF,
		DB_TBTAR_VALIDFIM	   VALIDADEFINAL_TARF,
		DB_TBTAR_FATPESO	   FATORPESO_TARF,		
		DB_TBTAR_TPTARIFA	   tipoTarifa_TARF,
		T.USUARIO
   FROM DB_TB_FRETE_TARIFA,
        MVA_TRANSPORTADORES T
  WHERE DB_TBTAR_TRANSP = T.CODIGO_TRANS
    AND DB_TBTAR_VALIDFIM >= GETDATE()
