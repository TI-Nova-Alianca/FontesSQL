ALTER VIEW MVA_CLIENTECONDICAOPGTO  AS
 select distinct cliCond.CLIENTE	codigoCliente_CCPG,
		cliCond.COND_PGTO			condicaoPagamento_CCPG,
		cli.usuario
   from DB_CLIENTE_CONDPGTO cliCond,
        MVA_CLIENTE cli,
		MVA_CONDICOESPAGAMENTO cond
  where cli.CODIGO_CLIEN = cliCond.CLIENTE
    and cond.CODIGO_CPGTO = cliCond.COND_PGTO
