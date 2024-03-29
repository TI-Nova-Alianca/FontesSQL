ALTER VIEW MVA_ESTOQUEDISTR AS
  SELECT DB_ESTD_DISTR		distribuidor_EDIS, 
		DB_ESTD_EAN_PROD	eanProduto_EDIS,
		DB_ESTD_PRODUTO		produto_EDIS,
		DB_ESTD_QTDE		quantidade_EDIS,
		mva_produtos.USUARIO
   FROM DB_ESTOQUE_DISTR
       ,mva_produtos
  where mva_produtos.CODIGO_PRODU = DB_ESTD_PRODUTO           
    and db_estd_qtde > 0
    and exists( select 1 from db_tb_repres1, db_repres_usuario 
                        where db_tbrep1_codigo = representante 
                          and db_repres_usuario.usuario = mva_produtos.USUARIO
                          and charindex (',' + cast(db_estd_distr as varchar) + ',', ',' + db_tbrep_lstdistr + ',') > 0 )
