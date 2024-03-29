ALTER VIEW MVA_REDECLIENTESESTOQUE  AS
 select codigo      codigo_RCLIE,
		sequencia   sequencia_RCLIE,
		cliente	    cliente_RCLIE,
		cnpj	    cnpj_RCLIE,
		cli.USUARIO
  from db_est_redeclientes
     , MVA_CLIENTE cli
 where ( (isnull(cliente, 0) <> 0 and cli.CODIGO_CLIEN = cliente)
        or (isnull(cnpj, '') <> '' and SUBSTRING(cli.CNPJ_CLIEN, 1, 8) = CNPJ))
