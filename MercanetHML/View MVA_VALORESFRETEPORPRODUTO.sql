---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001   14/03/2016  tiago           desenvolvimento
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_VALORESFRETEPORPRODUTO AS
WITH 
    usuario_temp as (select usuario
                      from DB_USUARIO_SESSIONID
                     where session_id = (@@SPID)),
ESTADO as (
select distinct db_cli_estado 
  from db_cliente
     , db_cliente_repres
	 , mva_representantes 
	 , usuario_temp
 where db_cli_codigo = db_clir_cliente 
   and db_clir_repres = codigo_repres 
   and mva_representantes.usuario =  usuario_temp.usuario),
CIDADE as (
select distinct db_cli_cidade
  from db_cliente
     , db_cliente_repres
	 , mva_representantes 
	 , usuario_temp
 where db_cli_codigo = db_clir_cliente 
   and db_clir_repres = codigo_repres 
   and mva_representantes.usuario  = usuario_temp.usuario),
TB_MARCA as ( 
select  marca_produ 
  from mva_produtos , usuario_temp
 where mva_produtos.usuario  = usuario_temp.usuario
union all select ''
					 )
 SELECT ID                   id_VFPP, 
        PRODUTO, 
		TIPO, 
		MARCA, 
		FAMILIA, 
		GRUPO, 
		EMPRESA_ORIGEM, 
		UF_DESTINO, 
		CIDADE_DESTINO, 
		PERCENTUAL_FRETE     percentualFrete_VFPP, 
        PERCENTUAL_DESCARGA  percentualDescarga_VFPP, 
		VALOR_DESCARGA       valorDescarga_VFPP,
		TIPO_CALCULO         tipoCalculo_VFPP,
		PERCENTUAL_REAL      percentualReal_VFPP,
		DATA_ALTERACAO         DATAALTER
   FROM DB_FRETE_PRODUTO       
  where uf_destino in (select db_cli_estado from ESTADO  )
	and cidade_destino in (select db_cli_cidade from CIDADE   )
	and ISNULL(marca, '') in (select marca_produ from TB_MARCA  )
