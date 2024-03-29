---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	05/03/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_TRANSPEQUIPAMENTOS AS
 SELECT DB_EQTR_EQUIP	CODIGOEQUIPAMENTO_TRANE,
		DB_EQTR_TRANSP	CODIGOTRANSPORTADOR_TRANE,
		DB_EQTR_PADRAO	PADRAO_TRANE,
		T.USUARIO
   FROM DB_EQUIP_TRANSP,
        MVA_TRANSPORTADORES T
  WHERE T.CODIGO_TRANS = DB_EQTR_TRANSP
