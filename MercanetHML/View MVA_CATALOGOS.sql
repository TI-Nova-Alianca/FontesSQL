---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001   04/02/2014  tiago           incluido campo 'padrao'
-- 1.0002   14/08/2015  tiago           incluido campo exibe capa visao item
-- 1.0003   28/08/2015  tiago           incluido campo agrupador
-- 1.0004   21/09/2015  tiago           incluido campo templates
-- 1.0005   25/11/2015  tiago           incluido campo miniatura_CAT
-- 1.0006   10/03/2016  tiago           alterado modo de envio do campo dataalter
-- 1.0007   30/03/2016  tiago           incluido campo ordem e grupo
-- 1.0008   04/08/2016  tiago           incluido campo coluna imagem resumo
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CATALOGOS AS
 SELECT DB_CAT_CODIGO	          CODIGO_CAT,
		DB_CAT_DESCRICAO          DESCRICAO_CAT,
		DB_CAT_SITUACAO	          SITUACAO_CAT,
		DB_CAT_TEMA	              TEMA_CAT,
		DB_CAT_TIMER	          TIMER_CAT,
		DB_CAT_LOGOTIPO	          LOGOTIPO_CAT,
		DB_CAT_CONSULTA	          CONSULTA_CAT,
		DB_CAT_COLPRODUTO		  COLUNAPRODUTO_CAT,
		DB_CAT_COLDESCRPROD	      COLUNADESCPRODUTO_CAT,
		DB_CAT_COLDESCRPRODCOMPL  COLUNADESCPRODUTOCOMPL_CAT,
		DB_CAT_COLDESTAQUE	      COLUNADESTAQUE_CAT,
		DB_CAT_COLAGRUPAPROD	  COLUNAAGRUPAPRODUTO_CAT,
		DB_CAT_AJUDA	          AJUDA_CAT,
		DB_CAT_TOUR	              TOUR_CAT,
		DB_CAT_INSTITUCIONAL	  INSTITUCIONAL_CAT,
		P.PADRAO_PERMC            PADRAO_CAT,
		DB_CAT_EXIBECAPAVISAOITEM    EXIBECAPAVISAOITEM_CAT,
		DB_CAT_AGRUPADOR          agrupador_CAT,
		DB_CAT_TEMPLATES          templates_CAT,
		DB_CAT_MINIATURACAPA      miniatura_CAT,
		P.USUARIO,
		DB_CAT_ORDEMEXIBE         ordemExibicao_CAT,
        DB_CAT_GRUPO              grupo_CAT,
		DB_CAT_COLIMAGEMRESUMO    colunaImagemResumo_CAT,
		case when isnull(DB_CAT_ULT_ALTER, 0) > isnull(p.DATA_PERMC, 0) then   DB_CAT_ULT_ALTER else   p.DATA_PERMC end      DATAALTER
   FROM DB_CATALOGO, MVA_PERMISSOESCATALOGO P 
  WHERE DB_CAT_SITUACAO = 0
    AND P.CATALOGO_PERMC = DB_CAT_CODIGO
