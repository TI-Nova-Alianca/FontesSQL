ALTER VIEW  MVA_CONDICOESFRETE AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	04/09/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   09/09/2013  TIAGO           VALIDA LISTA DE TRANSPORTADORA
-- 1.0002   13/01/2014  tiago           traz dados caso nao exista nenhuma transportadora no filtro
---------------------------------------------------------------------------------------------------
 SELECT DB_TBCF_CODIGO	     CODIGO_CONFR,
		DB_TBCF_DESCR	     DESCRICAO_CONFR,
		DB_TBCF_DATA_INI	 DATAINICIAL_CONFR,
		DB_TBCF_DATA_FIM	 DATAFINAL_CONFR,
		DB_TBCF_TIPO	     TIPOCONDICAO_CONFR,		
		DB_TBCF_COMENT	     COMENTARIO_CONFR,		
		DB_TBCF_VLR_TARIFA	 CALCULACONFORMETARIFA_CONFR,
		DB_TBCF_CLI_REDE	 CONSIDERACLIENTEREDE_CONFR,
		DB_TBCF_EXC_CLI	     EXCLUICLIENTELISTA_CONFR,
        DB_TBCF_TPAVAL	     TIPOAVALIACAO_CONFR,
		DB_TBCF_MENSAGEM     mensagem_CONFR,
		DB_TBCF_VALORPEDIDO  valorPedido_CONFR,
		DB_TBCF_RATEIOFRETE  rateioFrete_CONFR,
		USU.USUARIO,
		--- campos lista
		DB_TBCF_ESTADOS	     ESTADO,
		DB_TBCF_LPRECOS	     LISTAPRECO,
		DB_TBCF_RAMOATVS	 RAMOATIVIDADE,	
		DB_TBCF_CLASSCOM	 CLASSIFICACAOCOMERCIAL,
		DB_TBCF_EMPRESAS	 EMPRESA,
		DB_TBCF_OPERACAO	 OPERACAO,
		DB_TBCF_REPRES	     REPRESENTANTE,
		DB_TBCF_CLIENTES	 CLIENTE,
		DB_TBCF_TIPOFATUR    TIPOFATUR,
		DB_TBCF_TIPOPEDIDO   TIPOPEDIDO,
		DB_TBCF_RAMOATVSII   RAMOATVSII,
		DB_TBCF_FORCA_VENDAS FORCAVENDAS
     FROM DB_TB_COND_FRETE, DB_USUARIO USU, DB_FILTRO_GRUPOUSU GRUPO, DB_TB_COND_FRETRP
  WHERE GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO
    AND GRUPO.ID_FILTRO = 'TRANSPORTADORA'	
	and dbo.MERCF_VALIDA_LISTA(grupo.valor_num, case isnull(DB_TBCFT_TRANSP, '') when '' then '-' else DB_TBCFT_TRANSP end , 0, ';') = 1	
	and DB_TBCF_CODIGO = DB_TBCFT_CODIGO
	and cast(DB_TBCF_DATA_FIM as date) >= cast(getdate() as date)
	and (exists (select 1 from DB_FILTRO_GRUPOUSU 
				  where CODIGO_GRUPO = USU.GRUPO_USUARIO 
					and ID_FILTRO = 'UF' and ',' + DB_TBCF_ESTADOS + ',' like '%,' + VALOR_STRING + ',%')
				 or not exists ( select 1 
	                    from DB_FILTRO_GRUPOUSU GRUPO
				       where GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND GRUPO.ID_FILTRO = 'UF' )  or isnull(DB_TBCF_ESTADOS, '') = '' )
   and (exists (select 1 from DB_FILTRO_GRUPOUSU 
				  where CODIGO_GRUPO = USU.GRUPO_USUARIO 
					and ID_FILTRO = 'LISTAPRECO' and ',' + DB_TBCF_LPRECOS + ',' like '%,' + VALOR_STRING + ',%')
				 or not exists ( select 1 
	                    from DB_FILTRO_GRUPOUSU GRUPO
				       where GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND GRUPO.ID_FILTRO = 'LISTAPRECO' ) or isnull(DB_TBCF_LPRECOS, '') = '' )
	and (exists (select 1 from DB_FILTRO_GRUPOUSU 
				  where CODIGO_GRUPO = USU.GRUPO_USUARIO 
					and ID_FILTRO = 'RAMOATIV' and ',' + DB_TBCF_RAMOATVS + ',' like '%,' + VALOR_STRING + ',%')
				 or not exists ( select 1 
	                    from DB_FILTRO_GRUPOUSU GRUPO
				       where GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND GRUPO.ID_FILTRO = 'RAMOATIV' ) or isnull(DB_TBCF_RAMOATVS, '') = '' )
	and (exists (select 1 from DB_GRUPO_USU_EMP 
						where GRUPO_USUARIO = USU.GRUPO_USUARIO 
						and ',' + DB_TBCF_EMPRESAS + ',' like '%,' + EMPRESA + ',%')
						or not exists ( select 1 
							from DB_GRUPO_USU_EMP GRUPO
							where GRUPO_USUARIO = USU.GRUPO_USUARIO ) or isnull(DB_TBCF_EMPRESAS, '') = '' )
	and (exists (select 1 from DB_FILTRO_GRUPOUSU 
					  where CODIGO_GRUPO = USU.GRUPO_USUARIO 
						and ID_FILTRO = 'OPERACAO' and ',' + DB_TBCF_OPERACAO + ',' like '%,' + VALOR_STRING + ',%')
					 or not exists ( select 1 
							from DB_FILTRO_GRUPOUSU GRUPO
						   where GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND GRUPO.ID_FILTRO = 'OPERACAO' ) or isnull(DB_TBCF_OPERACAO, '') = '' )
	and (exists (select 1 from DB_FILTRO_GRUPOUSU 
					  where CODIGO_GRUPO = USU.GRUPO_USUARIO 
						and ID_FILTRO = 'TIPOPED' and ',' + DB_TBCF_TIPOPEDIDO + ',' like '%,' + VALOR_STRING + ',%')
					 or not exists ( select 1 
							from DB_FILTRO_GRUPOUSU GRUPO
						   where GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND GRUPO.ID_FILTRO = 'TIPOPED' ) or isnull(DB_TBCF_TIPOPEDIDO, '') = '' )
union 
 SELECT DB_TBCF_CODIGO	     CODIGO_CONFR,
		DB_TBCF_DESCR	     DESCRICAO_CONFR,
		DB_TBCF_DATA_INI	 DATAINICIAL_CONFR,
		DB_TBCF_DATA_FIM	 DATAFINAL_CONFR,
		DB_TBCF_TIPO	     TIPOCONDICAO_CONFR,		
		DB_TBCF_COMENT	     COMENTARIO_CONFR,		
		DB_TBCF_VLR_TARIFA	 CALCULACONFORMETARIFA_CONFR,
		DB_TBCF_CLI_REDE	 CONSIDERACLIENTEREDE_CONFR,
		DB_TBCF_EXC_CLI	     EXCLUICLIENTELISTA_CONFR,
        DB_TBCF_TPAVAL	     TIPOAVALIACAO_CONFR,
		DB_TBCF_MENSAGEM     mensagem_CONFR,
		DB_TBCF_VALORPEDIDO  valorPedido_CONFR,
		DB_TBCF_RATEIOFRETE  rateioFrete_CONFR,
		USU.USUARIO,
		--- campos lista
		DB_TBCF_ESTADOS	     ESTADO,
		DB_TBCF_LPRECOS	     LISTAPRECO,
		DB_TBCF_RAMOATVS	 RAMOATIVIDADE,	
		DB_TBCF_CLASSCOM	 CLASSIFICACAOCOMERCIAL,
		DB_TBCF_EMPRESAS	 EMPRESA,
		DB_TBCF_OPERACAO	 OPERACAO,
		DB_TBCF_REPRES	     REPRESENTANTE,
		DB_TBCF_CLIENTES	 CLIENTE,
		DB_TBCF_TIPOFATUR    TIPOFATUR,
		DB_TBCF_TIPOPEDIDO   TIPOPEDIDO,
		DB_TBCF_RAMOATVSII   RAMOATVSII,
		DB_TBCF_FORCA_VENDAS FORCAVENDAS
   FROM DB_TB_COND_FRETE, DB_USUARIO USU
   WHERE (not exists ( select 1 
	                    from DB_FILTRO_GRUPOUSU GRUPO
				       where GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO
						 AND GRUPO.ID_FILTRO = 'TRANSPORTADORA' ) or DB_TBCF_TPAVAL = 3)
	and cast(DB_TBCF_DATA_FIM as date) >= cast(getdate() as date)
	and (exists (select 1 from DB_FILTRO_GRUPOUSU 
				  where CODIGO_GRUPO = USU.GRUPO_USUARIO 
					and ID_FILTRO = 'UF' and ',' + DB_TBCF_ESTADOS + ',' like '%,' + VALOR_STRING + ',%')
				 or not exists ( select 1 
	                    from DB_FILTRO_GRUPOUSU GRUPO
				       where GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND GRUPO.ID_FILTRO = 'UF' )  or isnull(DB_TBCF_ESTADOS, '') = '' )
   and (exists (select 1 from DB_FILTRO_GRUPOUSU 
				  where CODIGO_GRUPO = USU.GRUPO_USUARIO 
					and ID_FILTRO = 'LISTAPRECO' and ',' + DB_TBCF_LPRECOS + ',' like '%,' + VALOR_STRING + ',%')
				 or not exists ( select 1 
	                    from DB_FILTRO_GRUPOUSU GRUPO
				       where GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND GRUPO.ID_FILTRO = 'LISTAPRECO' ) or isnull(DB_TBCF_LPRECOS, '') = '' )
	and (exists (select 1 from DB_FILTRO_GRUPOUSU 
				  where CODIGO_GRUPO = USU.GRUPO_USUARIO 
					and ID_FILTRO = 'RAMOATIV' and ',' + DB_TBCF_RAMOATVS + ',' like '%,' + VALOR_STRING + ',%')
				 or not exists ( select 1 
	                    from DB_FILTRO_GRUPOUSU GRUPO
				       where GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND GRUPO.ID_FILTRO = 'RAMOATIV' ) or isnull(DB_TBCF_RAMOATVS, '') = '' )
	and (exists (select 1 from DB_GRUPO_USU_EMP 
						where GRUPO_USUARIO = USU.GRUPO_USUARIO 
						and ',' + DB_TBCF_EMPRESAS + ',' like '%,' + EMPRESA + ',%')
						or not exists ( select 1 
							from DB_GRUPO_USU_EMP GRUPO
							where GRUPO_USUARIO = USU.GRUPO_USUARIO ) or isnull(DB_TBCF_EMPRESAS, '') = '' )
	and (exists (select 1 from DB_FILTRO_GRUPOUSU 
					  where CODIGO_GRUPO = USU.GRUPO_USUARIO 
						and ID_FILTRO = 'OPERACAO' and ',' + DB_TBCF_OPERACAO + ',' like '%,' + VALOR_STRING + ',%')
					 or not exists ( select 1 
							from DB_FILTRO_GRUPOUSU GRUPO
						   where GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND GRUPO.ID_FILTRO = 'OPERACAO' ) or isnull(DB_TBCF_OPERACAO, '') = '' )
	and (exists (select 1 from DB_FILTRO_GRUPOUSU 
					  where CODIGO_GRUPO = USU.GRUPO_USUARIO 
						and ID_FILTRO = 'TIPOPED' and ',' + DB_TBCF_TIPOPEDIDO + ',' like '%,' + VALOR_STRING + ',%')
					 or not exists ( select 1 
							from DB_FILTRO_GRUPOUSU GRUPO
						   where GRUPO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND GRUPO.ID_FILTRO = 'TIPOPED' ) or isnull(DB_TBCF_TIPOPEDIDO, '') = '' )
