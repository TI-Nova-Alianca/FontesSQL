---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   20/03/2013	TIAGO           INCLUSAO CAMPO DO REPRES
-- 1.0003   24/04/2013  tiago           incluidos novos campos
-- 1.0004   12/11/2014  tiago           alterado para melhorar performance
-- 1.0005   28/04/2016  tiago           passa a filtrar pela view de representantes
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ROTAS AS
with valida_rota as (SELECT isnull(DB_PRMS_VALOR, 0) VALOR FROM DB_PARAM_SISTEMA WHERE DB_PARAM_SISTEMA.DB_PRMS_ID = 'AGENDA_FORMATOVISROTA')
SELECT distinct DB_ROTA_CODIGO         CODIGO_ROTA,
       DB_ROTA_DESCRICAO      DESCRICAO_ROTA,
       DB_ROTA_DATAI          DATAINICIAL_ROTA, 
       DB_ROTA_DATAF          DATAFINAL_ROTA,
       DB_ROTA_REPRES         REPRESENTANTE_ROTA,
       DB_ROTA_OBSDIA         OBSDIA_ROTA,
       DB_ROTA_OBSSEG         OBSSEG_ROTA,
       DB_ROTA_OBSTER         OBSTER_ROTA,
       DB_ROTA_OBSQUA         OBSQUA_ROTA,
       DB_ROTA_OBSQUI         OBSQUI_ROTA,
       DB_ROTA_OBSSEX         OBSSEX_ROTA,
       DB_ROTA_OBSSAB         OBSSAB_ROTA,
       DB_ROTA_OBSDOM         OBSDOM_ROTA,
	   getdate()              DATAENVIO_ROTA,
       MVA_REPRESENTANTES.USUARIO
  FROM DB_ROTAS, MVA_REPRESENTANTES, DB_USUARIO usu
 where DB_ROTA_REPRES = CODIGO_REPRES
  and usu.USUARIO = MVA_REPRESENTANTES.USUARIO
  and ( (isnull((SELECT VALOR_NUM VALOR FROM DB_FILTRO_GRUPOUSU WHERE DB_FILTRO_GRUPOUSU.ID_FILTRO = 'FORMATOVISROTA' and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = usu.GRUPO_USUARIO), 0) = 0 and (select valor from valida_rota) = 0 )
  or isnull((SELECT VALOR_NUM VALOR FROM DB_FILTRO_GRUPOUSU WHERE DB_FILTRO_GRUPOUSU.ID_FILTRO = 'FORMATOVISROTA' and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = usu.GRUPO_USUARIO), 0) = 1)
