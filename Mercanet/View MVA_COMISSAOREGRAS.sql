---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	26/11/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   14/01/2013  tiago pradella  incluido campo de reducao
-- 1.0003   03/09/2015  tiago           incluido campo lrepres e filtra a empresa e repres
-- 1.0004   23/02/2016  tiago           passa a enviar em branco quando compo e null(prazo e desconto)
-- 1.0005   08/03/2016  tiago           incluido no where CO11_VIGENCIA = VIGENCIA_COMIS
-- 1.0006   31/03/2016  tiago           utiliza filtro de versao
-- 1.0007   13/04/2016  tiago           alterado na validacao da versao, passando null onde era ''
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_COMISSAOREGRAS AS
 SELECT CO11_REGRACOM                       REGRA_COMRE,
		CO11_VIGENCIA                       VIGENCIA_COMRE,
		CO11_SEQ                            PRIORIDADE_COMRE,
		CO11_PCOMIS                         PERCENTUALCOMISSAO_COMRE,
		CO11_PRMEN							reducaoMenor_COMRE,
        CO11_PRMAI							reducaoMaior_COMRE,
		CO11_DESCSEMPENAL					descontoSemPenalizacao_COMRE,
		CO11_MAXPENAL						maximoPenalizacao_COMRE,
		------
		CO11_LCLIENTE                       CLIENTE,
		CO11_LRAMOATV                       RAMOATIVIDADE,
		CO11_LCLASCLI                       CLASSICOMERCIAL,
		CO11_LESTADO                        ESTADO,
		CO11_LEMPRESA                       EMPRESA,
		CO11_LLSTPRE                        LISTAPRECO,
		CO11_LCONDPGT                       CONDICAOPAGAMENTO,
		case when (SELECT 1 
					 FROM DB_USUARIO_MOBILE
				    WHERE SUBSTRING(VERSAO_UTILIZADA, 1, 4) >= '2016'
					  AND DB_USUARIO_MOBILE.CODIGO = usu.CODIGO) = 1 then cast(isnull(CO11_PRZPGTOI,null) as varchar) 
					                                                 else cast(isnull(CO11_PRZPGTOI, 0) as varchar) end    PRAZOMEDIOINI,        
        case when (SELECT 1 
					 FROM DB_USUARIO_MOBILE
				    WHERE SUBSTRING(VERSAO_UTILIZADA, 1, 4) >= '2016'
					  AND DB_USUARIO_MOBILE.CODIGO = usu.CODIGO) = 1 then cast(isnull(CO11_PRZPGTOF,null) as varchar) 
					                                                 else cast(isnull(CO11_PRZPGTOF, 0) as varchar) end PRAZOMEDIOFIM,
        case when (SELECT 1 
					 FROM DB_USUARIO_MOBILE
				    WHERE SUBSTRING(VERSAO_UTILIZADA, 1, 4) >= '2016'
					  AND DB_USUARIO_MOBILE.CODIGO = usu.CODIGO) = 1 then cast(isnull(CO11_PDESTOI,null) as varchar) 
					                                                 else cast(isnull(CO11_PDESTOI, 0) as varchar) end  DESCONTOINI,
        case when (SELECT 1 
					 FROM DB_USUARIO_MOBILE
				    WHERE SUBSTRING(VERSAO_UTILIZADA, 1, 4) >= '2016'
					  AND DB_USUARIO_MOBILE.CODIGO = usu.CODIGO) = 1 then cast(isnull(CO11_PDESTOF,null) as varchar) 
					                                                 else cast(isnull(CO11_PDESTOF, 0) as varchar) end DESCONTOFIM,
		CO11_LTIPPRD                        TIPOPRODUTO,
		CO11_LMARPRD                        MARCA,
		CO11_LFAMPRD                        FAMILIA,
		CO11_LGRPPRD                        GRUPOPRODUTO,
		CO11_LCLAPRD                        CLASSIPRODUTO,
		CO11_LPRODUTO                       PRODUTO,
		co11_lrepres                        REPRESENTANTE,
		CO11_LRAMOATVII                     RAMOATIVII,
		CO11_LAREAATU						AREAATUACAO,
		CO11_LTIPODOCTO                     TIPOPED,		
		CO11_MINMARGEM						margemMinima_COMRE,
		CO11_MAXMARGEM						margemMaxima_COMRE,
		USU.USUARIO
   FROM MCO11, MVA_COMISSAO, DB_USUARIO USU
  WHERE CO11_REGRACOM = REGRA_COMIS
    and CO11_VIGENCIA = VIGENCIA_COMIS
	AND USU.USUARIO = MVA_COMISSAO.usuario
	 and (case when co11_lrepres  is not null
      then         
        case when 1 in (select 1 from mva_representantes r where r.usuario = MVA_COMISSAO.usuario and dbo.MERCF_VALIDA_LISTA (r.CODIGO_REPRES, replace(co11_lrepres, ';', ','), 0, ',') = 1)
           then 1
           else 0 end                
      else 1 end )
       = 1
	 and (case when CO11_LEMPRESA  is not null
      then         
        case when 1 in (select 1 from mva_empresas r where r.usuario = MVA_COMISSAO.usuario and dbo.MERCF_VALIDA_LISTA (r.CODIGO_EMPRE, replace(CO11_LEMPRESA, ';', ','), 0, ',') = 1)
           then 1
           else 0 end                
      else 1 end )
       = 1
