---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	08/09/2016	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_MOTIVOSCANCELAMENTO AS
 select DB_TBMCA_CODIGO   codigo_MOTCANC,
		DB_TBMCA_DESCR    descricao_MOTCANC,
		DB_TBMCA_TIPO	  tipo_MOTCANC,
		usuario
   from DB_TB_MOTCANC
      , DB_FILTRO_GRUPOUSU
      , db_usuario
  where DB_TBMCA_TIPO IN (0,1) 
    and DB_TBMCA_INATIVO = 0
	and ID_FILTRO = 'MOTIVOCANCEL'
	and VALOR_STRING = DB_TBMCA_CODIGO
	and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = db_usuario.GRUPO_USUARIO
	union all
 select DB_TBMCA_CODIGO   codigo_MOTCANC,
		DB_TBMCA_DESCR    descricao_MOTCANC,
		DB_TBMCA_TIPO	  tipo_MOTCANC,
		usuario
   from DB_TB_MOTCANC
      , db_usuario
  where DB_TBMCA_TIPO IN (0,1) 
    and DB_TBMCA_INATIVO = 0
	and not exists (select 1
	                  from DB_FILTRO_GRUPOUSU
					 where ID_FILTRO = 'MOTIVOCANCEL'
					   and DB_FILTRO_GRUPOUSU.CODIGO_GRUPO = db_usuario.GRUPO_USUARIO)
