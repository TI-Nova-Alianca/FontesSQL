ALTER VIEW MVA_GRADESTAMANHO AS
 select DB_GRDT_GRADE	grade_GRDT,
		DB_GRDT_TAMANHO tamanho_GRDT,
		DB_GRDT_QTDE	quantidade_GRDT,
		DB_GRDT_DESCR	descricao_GRDT
   from db_grade_tam,
       MVA_GRADESTIPO 
 where DB_GRDT_GRADE = MVA_GRADESTIPO.codigo_GRD
