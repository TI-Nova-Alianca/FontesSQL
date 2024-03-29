ALTER VIEW MVA_REGRAS_PP_ATRIB_CLIENTE AS
 SELECT CODIGO_REGRA	regra_RPPATC,	
		ATRIBUTO		atributo_RPPATC,
		dbo.MERCF_PIECE(valor, ',', p_temporaria.linha) valor_RPPATC
   FROM DB_REGRAS_PP_ATRIB_CLIENTE, MVA_REGRAS_PRAZO_PRECO,		
        (SELECT TOP 50 ROW_NUMBER() OVER (ORDER BY NAME) LINHA  FROM SYS.OBJECTS) P_TEMPORARIA
  where isnull(dbo.MERCF_PIECE(valor, ',', p_temporaria.linha), '') <> ''
    and CODIGO_REGRA = MVA_REGRAS_PRAZO_PRECO.CODIGO_REGPP
