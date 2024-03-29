ALTER VIEW MVA_REGRASCONDPGTOITEM  AS
 select CONTROLE		controle_RCON,
		SEQUENCIA		sequencia_RCON,
		CODIGO_REGRA	codigoRegra_RCON,
		TIPO_REGRA		tipoRegra_RCON,
		COND_PGTO		condicaoPagamento_RCON,
		DATA_INICIAL	dataInicial_RCON,
		DATA_FINAL		dataFinal_RCON,
		DATA_ALTER		dataalter,
		(select top 1  PESO from DB_REGCONDPGTOCONTROLE where DB_REGCONDPGTOCONTROLE.CONTROLE = DB_REGCONDPGTOFILTROS.CONTROLE)  	peso_RCON,
		IDENT_REGRA		identRegra_RCON	
   from DB_REGCONDPGTOFILTROS
