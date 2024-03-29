---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0001   25/05/2013  TIAGO           INCLUIDO CAMPO SALDO
-- 1.0002   24/06/2013  tiago           incluido campo aplica flex e filtro no where
-- 1.0003   15/08/2013  tiago           incluido campo aplica flex negativo
-- 1.0004   12/05/2014  tiago           incluido campo indicador
-- 1.0004   08/10/2013  tiago           novos filtros EXPORTAPEDIDOSALVAR e OBRIGATUESTOQUE
-- 1.0005   15/10/2013  tiago           retirado filtros EXPORTAPEDIDOSALVAR e OBRIGATUESTOQUE
-- 1.0006   13/12/2013  tiago           incluido campo grupo idiona
-- 1.0007   04/08/2014  tiago           alterado where incluido  REP.DB_TBREP_CODIGO     = Z.DB_EREG_REPRES
-- 1.0008   12/08/2014  tiago           incluido campo telefone e email
-- 1.0009   09/09/2014  tiago           incluido campos de embalagem
-- 1.0010   28/01/2015  tiago           incluido campo DB_TBREP_GRPPREV
-- 1.0011   20/04/2015  tiago           retirado campo sequencia para que traga os representantes vinculados caso eles existam e retorne todos os filhos do usuario passado
--                                      e adicionado o distinct, pois o mesmo registro vem no select das tabelas X e Y
-- 1.0012   17/06/2015  ricardo         incluido campo DB_TBREP_REGRACOM
-- 1.0013   01/09/2015  tiago           incluidocampos codigoCliente_REPRES e diasNotaBonificacao_REPRES
-- 1.0014   09/02/2016  tiago           retirado join com a tabela DB_ESTRUT_REGRA   Z1
-- 1.0015   15/03/2017  ricardo         incluido campo DB_TBREP_COLETOR 
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_REPRESENTANTES AS
    SELECT distinct DB_TBREP_CODIGO         CODIGO_REPRES,
            REP.DB_TBREP_NOME      NOME_REPRES,
			DB_TBREP_LIMFINANC     SALDOFLEX_REPRES,
			ISNULL((SELECT VALOR_NUM 
			         FROM DB_FILTRO_GRUPOUSU  GRUPO
			        WHERE GRUPO.ID_FILTRO         = 'FLEX'
		              AND GRUPO.CODIGO_GRUPO      = USU.GRUPO_USUARIO), 0)  APLICAFLEX_REPRES,
			ISNULL((SELECT VALOR_NUM
			          FROM DB_FILTRO_USUARIO
			         WHERE ID_FILTRO = 'FLEXNEGATIVO'
			           AND CODIGO_USUARIO = USU.CODIGO), 0)   APLICAFLEXNEGATIVO_REPRES,
			REP.DB_TBREP_PEDITENSI ITENSIGUAIS_REPRES,
			ISNULL((SELECT VALOR_NUM 
                     FROM DB_FILTRO_GRUPOUSU  GRUPO
                    WHERE GRUPO.ID_FILTRO         = 'INDICADOR'
                      AND GRUPO.CODIGO_GRUPO      = USU.GRUPO_USUARIO), 0)   EXIBEIMAGENSPRODUTO_REPRES,
			DB_TBREP_FONE       TELEFONE_REPRES,
			DB_TBREP_EMAIL      EMAIL_REPRES,
			DB_TBREP_QTDEF_VE   qtdforaembvenda_REPRES,
			DB_TBREP_QTDEF_BO   qtdforaembbonif_REPRES,
			DB_TBREP_QTDEF_OU   qtdforaemboutros_REPRES,
			DB_TBREP_QTDEF_TR   qtdforaembtransf_REPRES,
			DB_TBREP_GRPPREV    grupoEstoque_REPRES,
			DB_TBREP_REGRACOM   regraComissao_REPRES,
			DB_TBREP_COD_CLI    codigoCliente_REPRES,
            DB_TBREP_DIAS_NOTAB diasNotaBonificacao_REPRES,
			DB_TBREP_UNIDFV     forcavendas_REPRES,
			DB_TBREP_Coletor    coletor_REPRES,
			isnull((select top 1 RF3_PERCENT_BONI  from  MRF3 where RF3_UNIDADE_FV = REP.DB_TBREP_UNIDFV), 0)  percentBoniFVendas_REPRES,
			DB_TBREP_SIT_VENDA  SITUACAO_REPRES,
			isnull((select top 1 RF3_NOME from MRF3 where RF3_UNIDADE_FV = DB_TBREP_UNIDFV), '') nomeForcaVendas_REPRES,
			DB_TBREP_GRPPREV	grupoPrev_REPRES,
			isnull((select top 1 RF3_EMP_ITEM_SPLIT  from  MRF3 where RF3_UNIDADE_FV = REP.DB_TBREP_UNIDFV), 0)  empresaItem_REPRES,
			DB_TBREP_LSTDISTR   listaDistribuidores_REPRES,
			DB_TBREP_LATITUDE	latitude_REPRES,
			DB_TBREP_LONGITUDE	longitude_REPRES,
			DB_TBREP_CIDADE		cidade_REPRES,
			DB_TBREP_UF			estado_REPRES,
			isnull((select top 1 RF3_VALIDASALDOCC from MRF3 where RF3_UNIDADE_FV = REP.DB_TBREP_UNIDFV), 0)	validaSaldoContaCor_REPRES,
			isnull((select top 1 RF3_PERC_DESCC	from MRF3 where RF3_UNIDADE_FV = REP.DB_TBREP_UNIDFV), 0)	percDescContaCorrente_REPRES,
			DB_TBREP_AREAGEOGRAF areaGeografica_REPRES,
            USU.USUARIO
       FROM DB_REPRES_USUARIO,
	        DB_USUARIO     USU,
            DB_TB_REPRES   REP,
			DB_TB_REPRES1  REP1
      WHERE REP.DB_TBREP_CODIGO = DB_REPRES_USUARIO.REPRESENTANTE
	    AND USU.USUARIO = DB_REPRES_USUARIO.USUARIO
		AND REP1.DB_TBREP1_CODIGO = REP.DB_TBREP_CODIGO
