ALTER VIEW MVA_GRADESTIPO AS
 select DB_GRD_CODIGO		codigo_GRD,
		DB_GRD_DESCR		descricao_GRD,
		DB_GRD_TIPO			tipo_GRD,
		DB_GRD_SITUACAO		situacao_GRD,
		DB_GRD_QTDE			quantidade_GRD,
		DB_GRD_FECHAMENTO	fechamento_GRD,
		DB_GRD_QTDEMIN		qtdeMin_GRD,
		DB_GRD_DATAALTER    dataalter
   from db_grade
