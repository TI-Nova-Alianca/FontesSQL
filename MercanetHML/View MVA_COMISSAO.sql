---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	26/11/2012	TIAGO PRADELLA	CRIACAO
-- 1.0001   29/11/2012  TIAGO PRADELLA  INCLUIDO CAMPO USUARIO E CONDICAO DE REPRES
-- 1.0002   22/04/2014  TIAGO           INCLUIDO CAMPO DE TIPO DE DESCONTO 
-- 1.0003   04/07/2014  tiago           incluido campo comissao padrao
-- 1.0004   07/03/2016  tiago           alterado join com a mva_representantes para nao duplicar registros
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_COMISSAO AS
SELECT CO10_REGRACOM    REGRA_COMIS,
       CO10_VIGENCIA    VIGENCIA_COMIS,
       CO10_DTVALI      DATAINICIAL_COMIS,
       CO10_DTVALF      DATAFINAL_COMIS,
	   CO10_TPDESCTO	TIPODESCONTO_COMIS,
	   CO10_PCOMIS      COMISSAOPADRAO_COMIS,
	   CO10_BASECALCULO baseCalculo_COMIS,
	   CO10_PCOMMAX     comissaoMaxima_COMIS,
	   CO10_PCOMMIN     comissaoMinima_COMIS,
	   CO10_TpComis     tipoComissao_COMIS,
	   CO10_PENALIZACAO tipoPenalizacao_COMIS,
       usuario 
  FROM MCO10,       
       db_usuario usu
 WHERE CO10_DTVALF >= getdate() 
   and exists (select 1
                 from mva_representantes, db_tb_repres
               where DB_TBREP_CODIGO =codigo_REPRES
                 and  DB_TBREP_RegraCom = CO10_REGRACOM
                 and mva_representantes.usuario = usu.usuario)
