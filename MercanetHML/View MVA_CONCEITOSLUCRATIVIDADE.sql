---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	22/01/2015	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CONCEITOSLUCRATIVIDADE AS
 SELECT DB_CONL_CODIGO     CODIGO_CONLUC,
		DB_CONL_DTINI      DATAINICIAL_CONLUC,
		DB_CONL_DTFIN      DATAFINAL_CONLUC,
		DB_CONL_AVAL       TIPO_CONLUC,
		DB_CONL_PESO       PESO_CONLUC,
		DB_CONL_LPRECO     LISTAPRECO,
		DB_CONL_LEMPRESA   EMPRESA,
		DB_CONL_LCLIENTE   CLIENTE,
		DB_CONL_AVALACUM   avaliaAcumulado_CONLUC,
		DB_CONL_REGRABLOQ  regraBloqueio_CONLUC,
		DB_CONL_LREPRES    REPRES,
		DB_CONL_LTPPEDIDO  TIPOPED,
		DB_CONL_LESTADO    ESTADO,
		DB_CONL_LRAMO	   RAMO,
		DB_CONL_LRAMO2	   RAMO2,
		usu.usuario
   FROM DB_CONC_LUCRAT, db_usuario usu
  WHERE DB_CONL_DTFIN >= GETDATE()
     AND (isnull(DB_CONL_LPRECO, '') = '' 
	      or NOT EXISTS (SELECT 1 FROM DB_FILTRO_GRUPOUSU FILTRO WHERE FILTRO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND FILTRO.ID_FILTRO = 'LISTAPRECO') 
	      or ( exists (SELECT 1 FROM DB_FILTRO_GRUPOUSU FILTRO WHERE FILTRO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND FILTRO.ID_FILTRO = 'LISTAPRECO' and ',' + DB_CONL_LPRECO + ',' like  '%,' + FILTRO.VALOR_STRING + ',%') ))
     AND (isnull(DB_CONL_LESTADO, '') = '' 
	      or NOT EXISTS (SELECT 1 FROM DB_FILTRO_GRUPOUSU FILTRO WHERE FILTRO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND FILTRO.ID_FILTRO = 'UF') 
	      or ( exists (SELECT 1 FROM DB_FILTRO_GRUPOUSU FILTRO WHERE FILTRO.CODIGO_GRUPO = USU.GRUPO_USUARIO AND FILTRO.ID_FILTRO = 'UF' and ',' + DB_CONL_LESTADO + ',' like  '%,' + FILTRO.VALOR_STRING + ',%') ))
	and (isnull(DB_CONL_LCLIENTE, '') = ''  or exists (select 1 from MVA_CLIENTE where MVA_CLIENTE.USUARIO = usu.usuario and ',' + DB_CONL_LCLIENTE + ',' like  '%,' + cast(MVA_CLIENTE.CODIGO_CLIEN as varchar) + ',%'))
	and (isnull(DB_CONL_LREPRES, '') = ''  or exists (select 1 from MVA_REPRESENTANTES where MVA_REPRESENTANTES.USUARIO = usu.usuario and ',' + DB_CONL_LREPRES + ',' like  '%,' + cast(MVA_REPRESENTANTES.CODIGO_REPRES as varchar) + ',%'))
	and (isnull(DB_CONL_LRAMO, '') = ''  or exists (select 1 from MVA_RAMOSATIVIDADES where MVA_RAMOSATIVIDADES.USUARIO = usu.usuario and ',' + DB_CONL_LRAMO + ',' like  '%,' + cast(MVA_RAMOSATIVIDADES.CODIGO_RAMO as varchar) + ',%'))
