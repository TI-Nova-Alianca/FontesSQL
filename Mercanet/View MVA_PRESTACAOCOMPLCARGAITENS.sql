---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   24/05/2017	TIAGO PRADELLA	   CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRESTACAOCOMPLCARGAITENS   AS
select db_romd_romaneio		romaneio_PCIT
     , db_notap_empresa		empresa_PCIT
	 , db_notap_serie		serie_PCIT
	 , db_notap_nro			nota_PCIT
	 , db_notap_produto		produto_PCIT
	 , db_notap_qtde		quantidade_PCIT
	 , DB_NOTAP_SEQ         sequencia_PCIT
	 , p.usuario
  from db_romaneio_doc
      ,db_nota_prod
	  ,MVA_PRESTACAOCOMPLCARGA p
where db_romd_empresa = db_notap_empresa
and db_romd_serie = db_notap_serie
and db_romd_nota = db_notap_nro
and p.romaneio_PCOMP = db_romd_romaneio
