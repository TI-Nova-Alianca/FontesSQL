ALTER VIEW MVA_DISTRIBUICOES AS
 SELECT DB_DIST_TIPO			TIPO_DISTR,
		DB_DIST_ARTIGO			ARTIGO_DISTR,
		DB_DIST_COR				COR_DISTR,
		DB_DIST_DISTRIBUICAO	DISTRIBUICAO_DISTR,
		DB_DIST_SITUACAO		SITUACAO_DISTR,
		DB_DIST_DATAALTERACAO	DATAALTER,
		DB_DIST_LISTATPPEDIDO   LISTATPPEDIDO
   FROM DB_DISTRIBUICAO
