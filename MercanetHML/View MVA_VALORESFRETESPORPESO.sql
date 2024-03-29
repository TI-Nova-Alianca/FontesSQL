---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/03/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   25/03/2013  TIAGO           TIRADO FILTRO POR USUARIO E ESTADO
-- 1.0003   19/01/2015  TIAGO           INCLUIDO CAMPO DB_FP_VALORDESCARGA
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_VALORESFRETESPORPESO AS
 SELECT DB_FP_ID             ID_VFRET,
		DB_FP_EMPRORIG       EMPRESA_VFRET,
		DB_FP_CIDADEDEST     CIDADEDESTINO_VFRET,
		DB_FP_UFDEST         UFDESTINO_VFRET,
		DB_FP_FXINI          FAIXAPESOINICIAL_VFRET,
		DB_FP_FXFIM          FAIXAPESOFINAL_VFRET,
		DB_FP_VALORTN        VALORTONELADA_VFRET,
		DB_FP_VALORMIN       VALORMINIMO_VFRET,
		DB_FP_BASE           VALORBASE_VFRET,
		DB_FP_VALORDESCARGA  VALORDESCARGA_VFRET,
		DB_FP_TIPOPEDIDO     tipoPedido_VFRET,
		db_data_alteracao    dataalter
   FROM DB_FRETE_PESO
