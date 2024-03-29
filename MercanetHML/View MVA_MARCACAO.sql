ALTER VIEW MVA_MARCACAO AS
 SELECT CODIGO				 codigo_MAR,
		DESCRICAO			 descricao_MAR,
		VARIACAO			 variacao_MAR,
		TIPO_MARCACAO		 tipoMarcacao_MAR,
		GRUPO				 grupo_MAR,
		SITUACAO			 situacao_MAR,
		DATA_VALIDADE   	 dataValidade_MAR,
		GETDATE()		   	 dataTransmissao_MAR,
	    ISNULL(DATA_ALTERACAO, GETDATE()) dataalter
   FROM DB_MARCACAO
  WHERE SITUACAO = 'A'
    AND DATA_VALIDADE >= CONVERT(DATE, FORMAT(GETDATE(), 'yyyy-MM-dd')) -- se DATA_VALIDADE = NULL entao o registro nao sera enviado ao mobile
