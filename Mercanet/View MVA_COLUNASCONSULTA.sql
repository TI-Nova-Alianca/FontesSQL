ALTER VIEW MVA_COLUNASCONSULTA AS
SELECT CONSULTA          CONSULTA_COLCO,
       INDICE            INDICE_COLCO,
       TITULO            TITULO_COLCO,
       ALINHAMENTO_TIULO ALINHAMENTOTITULO_COLCO,
       ALINHAMENTO_VALOR ALINHAMENTOVALOR_COLCO,
       TAMANHO_MAXIMO    TAMANHOMAXIMO_COLCO,
       VISIVEL           VISIVEL_COLCO,
       FILTRAVEL         FILTRAVEL_COLCO,
       TIPO_FILTRO       TIPOFILTRO_COLCO,
       TIPO_VALOR        TIPOVALOR_COLCO,
       TIPO_TOTALIZADOR  TIPOTOTALIZADOR_COLCO,
       (select top 1 acao from DB_CONS_COLUNAS_ACOES where DB_CONS_COLUNAS_ACOES.consulta = C.CONSULTA   and DB_CONS_COLUNAS_ACOES.indice = C.INDICE  and acao_consulta <> 0 and acao_consulta is not null )       ACAO_COLCO,
       (select  top 1 PARAMETRO_ACAO from DB_CONS_COLUNAS_ACOES where DB_CONS_COLUNAS_ACOES.consulta = C.CONSULTA   and DB_CONS_COLUNAS_ACOES.indice = C.INDICE and acao_consulta <> 0 and acao_consulta is not null)   PARAMETROACAO_COLCO,
       (select  top 1 ACAO_CONSULTA from DB_CONS_COLUNAS_ACOES where DB_CONS_COLUNAS_ACOES.consulta = C.CONSULTA   and DB_CONS_COLUNAS_ACOES.indice = C.INDICE and acao_consulta <> 0 and acao_consulta is not null)  ACAOCONSULTA_COLCO,
       AGRUPA_COLUNA    AGRUPACOLUNAS_COLCO,
       SEPARADOR_MILHAR  SEPARADORMILHAR_COLCO,
	   FIXA			     fixa_COLCO,
	   AGRUPADA          agrupada_COLCO,
	   TIPO				 tipo_COLCO,
	   FORMULA			 formula_COLCO,
	   ID_FILTRO         idFiltro_COLCO,
	   isnull((select top 1 1 from DB_CONS_COLUNASPIVOT where  DB_CONS_COLUNASPIVOT.CONSULTA = C.CONSULTA), 0) pivot_COLCO,
	   TIPO_PADRAO_FILTRO  tipoPadraoFiltro_COLCO,
       VALOR_PADRAO_FILTRO valorPadraoFiltro_COLCO,
       USU.USUARIO
  FROM DB_CONS_COLUNAS C, DB_USUARIO USU
 where CONSULTA in (select CODIGO_CONSU from MVA_CONSULTAS where usuario = usu.usuario)
