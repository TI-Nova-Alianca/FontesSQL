---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	14/11/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   18/06/213   tiago           incluido union para trazer todos portadores casa nao exista nenhum representante
--                                      cadastrado, e filtro para trazer somente portadores do repres
-- 1.0003   19/09/2013  tiago           incluido campo de empresa
-- 1.0004   07/03/2016  tiago           alterado join com a mva_representantes
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PORTADORES AS
SELECT DB_TBPORT_COD     CODIGO_PORTA,
       DB_TBPORT_DESCR   DESCRICAO_PORTA,
       DB_TBPORT_REPRES  REPRESENTANTE,
       DB_TBPORT_EMPRESA EMPRESA,
       usu.USUARIO
  FROM DB_TB_PORT, db_usuario usu
 WHERE exists (select 1 from MVA_REPRESENTANTES where (dbo.MERCF_VALIDA_LISTA(CODIGO_REPRES, DB_TB_PORT.DB_TBPORT_REPRES, 0,',') = 1 OR isnull(DB_TBPORT_REPRES, '') = ''  ) and usu.usuario = usuario)
