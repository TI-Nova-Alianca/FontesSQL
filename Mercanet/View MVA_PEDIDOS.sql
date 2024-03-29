---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   14/11/2012  TIAGO PRADELLA  INCLUIDO CAMPO DIAS VENCIMENTO, PORTADOR
-- 1.0003   14/12/2012  TIAGO PRAQDELLA INCLUIDO CAMPO CLIENTE ENTREGA
-- 1.0004   10/01/2013  TIAGO PRADELLA  INCLUIDO CAMPO DE SEQUANCIDA DE ENTREGA
-- 1.0005   06/02/2013  tiago pradella  incluido campo data propaganda
-- 1.0006   06/09/2016  tiago           adicionado todos os campo do mobile e novas validacoes
-- 1.0007   15/09/2016  tiago           alterado validacao da situacao do pedido
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PEDIDOS AS
with situacao as (
					select substring(replace(db_prms_valor, ',', ''), 1,1) sit from DB_PARAM_SISTEMA where db_prms_id = 'MOB_SITUACAOPEDRETORNO' and  isnull(substring(replace(db_prms_valor, ',', ''), 1,1), '') <> ''
					union all
					select substring(replace(db_prms_valor, ',', ''), 2,1) sit from DB_PARAM_SISTEMA where db_prms_id = 'MOB_SITUACAOPEDRETORNO' and  isnull(substring(replace(db_prms_valor, ',', ''), 2,1), '') <> ''
					union all
					select substring(replace(db_prms_valor, ',', ''), 3,1) sit from DB_PARAM_SISTEMA where db_prms_id = 'MOB_SITUACAOPEDRETORNO' and  isnull(substring(replace(db_prms_valor, ',', ''), 3,1), '') <> ''
					union all
					select substring(replace(db_prms_valor, ',', ''), 4,1) sit from DB_PARAM_SISTEMA where db_prms_id = 'MOB_SITUACAOPEDRETORNO' and  isnull(substring(replace(db_prms_valor, ',', ''), 4,1), '') <> ''
					union all
					select substring(replace(db_prms_valor, ',', ''), 5,1) sit from DB_PARAM_SISTEMA where db_prms_id = 'MOB_SITUACAOPEDRETORNO' and  isnull(substring(replace(db_prms_valor, ',', ''), 5,1), '') <> ''
), filtros as (select  CODIGO_USUARIO, VALOR_NUM, ID_FILTRO
					  from DB_FILTRO_USUARIO
					 where DB_FILTRO_USUARIO.ID_FILTRO = 'ACESSOVENDAS' or ID_FILTRO = 'CLIENTESUSUARIO'
)
 select	db_ped_nro	            codigo_PEDID,
		db_ped_cliente			cliente_PEDID,
		db_ped_empresa			empresa_PEDID,
		db_ped_repres			representante_PEDID,
		db_ped_tipo				tipo_PEDID,
		db_ped_operacao			operacaoVenda_PEDID,
		db_ped_cond_pgto		condicaoPagamento_PEDID,
		db_ped_tipo_frete		tipoFrete_PEDID,
		db_ped_lista_preco		listaPreco_PEDID,
		db_ped_dt_emissao		dataEmissao_PEDID,
		db_ped_dt_PREVENT		dataPrevisaoEntrega_PEDID,
		db_ped_ord_compra		ordemCompra_PEDID,
		db_ped_cod_transp		transportador_PEDID,
		DB_PED_REDESPACHO		redespacho_PEDID,
		DB_PED_OBSERV			observacoes_PEDID,
		DB_PED_TEXTO			textoNotaFiscal_PEDID,
		db_ped_situacao			situacao_PEDID,
		DB_PED_ENT_ENDER		enderecoEntrega_PEDID,
		DB_PED_ENT_BAIRRO		bairroEntrega_PEDID,
		DB_PED_ENT_CEP			cepEntrega_PEDID,
		DB_PED_ENT_UF			estadoEntrega_PEDID,
		DB_PED_ENT_CIDADE		cidadeEntrega_PEDID,
		DB_Ped_Ent_Razao		razaoSocialEntrega_PEDID,
		DB_Ped_Ent_CGCMF		cnpjEntrega_PEDID,
		DB_Ped_Ent_CGCTE		inscricaoEstadualEntrega_PEDID,
		DB_PED_FATUR			tipoFaturamento_PEDID,
		DB_PEDC_PREV_FAT		dataPrevisaoFaturamento_PEDID,
		DB_PED_COMISI			comissaoInformada_PEDID,
		DB_PED_COMISO			comissaoCalculada_PEDID,
		case when DB_PEDC_VERSAODIG <> 9 then 8 else 0 end	sincronizacao_PEDID,
		DB_PEDC_DTDIGI			dataDigitacaoInicio_PEDID,
		DB_PEDC_DTDIGF			dataDigitacaoFim_PEDID,
		DB_PEDC_VERSAODIG		versaoDigitacao_PEDID,
		DB_PED_MOTIVO_BLOQ		motivosBloqueio_PEDID,
		DB_PED_portador			portador_PEDID,
		DB_PEDC_MOTIVREP		motivoReposicao_PEDID,
		DB_PEDC_DIAS_VCTO		dataFirme_PEDID,
		DB_PEDC_EMP_ENT			clienteEntrega_PEDID,
		DB_PEDC_LATITUDE		latitude_PEDID,
		DB_PEDC_LONGITUDE		longitude_PEDID,
		DB_PED_SEQ_ENTREGA		sequenciaEnderecoEntrega_PEDID,
		DB_PEDC_DIAS_VCTO		dataProgramada_PEDID,
		DB_PEDC_FORMA_PGTO		formaPagamento_PEDID,
		1						status_PEDID,
		DB_PEDC_DTCONTRI		validadeInicial_PEDID,
		DB_PEDC_DTCONTRF		validadeFinal_PEDID,
		DB_PEDC_OBSTRANSP		observacoesLog_PEDID,
		--DB_PED_	newSequenciaEnderecoEntrega_PEDID,
		DB_PEDC_REDESP2			redespachoII_PEDID,
		DB_PED_REDESPACHO		redespachoTXT_PEDID,
		DB_PED_PERC_FRETE		taxaEntrega_PEDID,
		--DB_PED_	valorLancamentoCC_PEDID,
		DB_PEDC_TP_FRETE1		tipoFreteRedespacho_PEDID,
		DB_PedC_Vendor			vendor_PEDID,
		DB_PEDC_TAXA_FIN		taxaFinanceira_PEDID,
		DB_PedC_CPgto_Vend		condicaoPagamentoVendor_PEDID,
		DB_PEDC_USU_CRIA		usuarioDigitacao_PEDID,
		--DB_PED_	dataPrevisaoEntregaCalculada_PEDID,
		DB_PEDC_PBM				acaoLoja_PEDID,
		DB_PEDC_ROTA			rota_PEDID,
		DB_PED_NUTIPBONI		naoUtilizaListaBoni_PEDID,
		DB_PEDC_MIX_VENDA		mix_PEDID,
		DB_PEDC_OPC_FATUR		opcaoFaturamento_PEDID,
		DB_PEDC_VOLTROCA		volumeTroca_PEDID,
		DB_PED_DESCTO_VLR		descontoPromocional_PEDID,
		--DB_PED_	condicaoFreteAplicadaKey_PEDID,
		DB_Ped_Vlr_Frete		valorTotalFrete_PEDID,
		DB_PEDC_PERC_MLUCR		percentualLucratividade_PEDID,
		DB_PEDC_CIDADE_REDESP	cidadeRedesp_PEDID,
		DB_PEDC_UF_REDESP		ufRedesp_PEDID,
		DB_PedC_Mod_Comis		modoComissao_PEDID,
		DB_PEDC_STATUSPED       statusPedido_PEDID,
		case when isnull(DB_PED_DATA_ALTER, '') = '' then cast(DB_PED_DT_EMISSAO + '23:59:59' AS DATETIME)  else DB_PED_DATA_ALTER end  dataalter,
		getdate()               dataRecebimento_PEDID,
		case when isnull(DB_PEDC_DTDIGF, '') = '' then getdate() else DB_PEDC_DTDIGF end dataEnvio_PEDID,
		DB_PED_ENT_COMPL		complementoEntrega_PEDID,
		DB_PED_ENT_PONTOREFER   pontoReferenciaEntrega_PEDID,
		DB_PED_ENT_CXPOSTAL     caixaPostalEntrega_PEDID,
		DB_PED_ENT_PAIS			paisEntrega_PEDID,
		DB_PED_ENT_TELEFONE		telefoneEntrega_PEDID,
		DB_PED_ENT_RAMAL		ramalEntrega_PEDID,
		DB_PEDC_LOC_EMBARQ		locEmbarque_PEDID,
		DB_PEDC_COND_FRETE      condicaoFrete_PEDID,
		DB_PEDC_NVALIDA_CPGTO   naovalidaCPGTO_PEDID,
		DB_PEDC_DIASPARC1		DIASPARC1_PEDID,
		DB_PEDC_DIASPARC2		DIASPARC2_PEDID,
		DB_PEDC_DIASPARC3		DIASPARC3_PEDID,
		DB_PEDC_DIASPARC4		DIASPARC4_PEDID,
		DB_PEDC_DIASPARC5		DIASPARC5_PEDID,
		DB_PEDC_DIASPARC6		DIASPARC6_PEDID,
		DB_PEDC_DIASPARC7		DIASPARC7_PEDID,
		DB_PEDC_DIASPARC8		DIASPARC8_PEDID,
		DB_PEDC_DIASPARC9		DIASPARC9_PEDID,
		DB_PEDC_DIASPARC10		DIASPARC10_PEDID,
		DB_PEDC_DIASPARC11		DIASPARC11_PEDID,
		DB_PEDC_DIASPARC12		DIASPARC12_PEDID,
		DB_PED_DESCTO_CAMPANHA  descontoCampanha_PEDID,
		DB_PEDC_TIPOTAXAFRETE   tipoTaxaFrete_PEDID,
		DB_PEDC_FATOR_TAXAFRETE fatorTaxaFrete_PEDID,
		DB_PEDC_PERC_FRETE_CALC valorTotFreteCalc_PEDID,
		DB_PED_DATAHORA			dataHoraEmissao_PEDID,
		DB_PEDC_CENTROCUSTO		centroCusto_PEDID,
		DB_PEDC_PED_ORIGEM		pedidoOrigem_PEDID,
		DB_PED_SITCORP			situacaoCorp_PEDID,
		DB_PEDC_TV_CONTATO		contato_PEDID,
		DB_PEDC_TV_TELEFONE		telefone_PEDID,
		DB_PEDC_TV_RAMAL		ramal_PEDID,
		DB_PEDC_TV_EMAIL		email_PEDID,
		DB_PEDC_LSTDISTR		listaDistribuidores_PEDID,
		DB_PEDC_RASCUNHO		pedSugerido_PEDID,
		DB_PEDC_PREV_FAT_HORA   horaPrevisaoFaturamento_PEDID,
		DB_PEDC_VLRSEG			valorSeguro_PEDID,
		DB_PED_LIB_MOTS			motivosLib_PEDID,
		DB_PED_MOT_DESC			motivoDesconto_PEDID,
		DB_PEDC_GERADO_AUTOMATICO	geradoAutomatico_PEDID,
		DB_PEDC_PERCRESERVATEC	percReservaTecnica_PEDID,
		DB_PEDC_VLRDESCFINANC 	valorDescFinanceiro_PEDID,
		DB_PED_NUMERO_OC		numeroOC_PEDID,
		DB_PED_NRO_ORIG			numeroOriginal_PEDID,
		DB_PEDC_TEMPODIG		tempoDig_PEDID,
		DB_PED_CANCELANDO		cancelando_PEDID,
		MVA_CLIENTE.usuario
   from db_pedido, db_pedido_compl, mva_cliente, db_usuario
  where db_ped_nro = DB_PEDC_NRO
    and DB_USUARIO.USUARIO = MVA_CLIENTE.usuario
    and MVA_CLIENTE.CODIGO_CLIEN = db_ped_cliente
	and db_ped_situacao in (select sit from situacao)	
	and cast(DB_PED_DT_EMISSAO as date) >= (select  cast(getdate() -  cast(db_prms_valor as int) as date) from DB_PARAM_SISTEMA where db_prms_id = 'MOB_NUMERODIASRETPEDIDO')
	AND DB_PED_REPRES IN (SELECT CODIGO_REPRES FROM MVA_REPRESENTANTES WHERE MVA_REPRESENTANTES.USUARIO = MVA_CLIENTE.USUARIO)
	and (case (select VALOR_NUM from filtros where filtros.id_filtro = 'CLIENTESUSUARIO' and filtros.CODIGO_USUARIO = DB_USUARIO.CODIGO)
			when 2 then
			  ( case (select VALOR_NUM from filtros where filtros.id_filtro = 'ACESSOVENDAS' and filtros.CODIGO_USUARIO = DB_USUARIO.CODIGO)
					when 3 then (case when DB_PEDC_USU_CRIA = db_usuario.USUARIO then 1 else 0 end)
					when 0 then ( case when ( select top 1 1
										 from DB_CARTEIRAS car, DB_CARTEIRAS_CLIENTES carcli, DB_CARTEIRAS_USUARIOS carusu
										 where car.ID = carcli.CARTEIRA
										 and car.ID = carusu.CARTEIRA
										 and carusu.USUARIO = db_usuario.usuario
										 and cast(DB_PED_DT_EMISSAO as date) >= cast(carcli.DATA_INICIAL as date)) = 1 then 1 else 0 end)
					when 1 then ( case when ( (select top 1 1
										 from DB_CARTEIRAS car, DB_CARTEIRAS_CLIENTES carcli, DB_CARTEIRAS_USUARIOS carusu
										 where car.ID = carcli.CARTEIRA
										 and car.ID = carusu.CARTEIRA
										 and carusu.USUARIO = db_usuario.usuario
										 and cast(DB_PED_DT_EMISSAO as date) >= cast(carcli.DATA_INICIAL as date)) = 1 and DB_PEDC_USU_CRIA = db_usuario.USUARIO)   then 1 else 0 end)
					else 1 end)
			else 1 end	
	    ) = 1
