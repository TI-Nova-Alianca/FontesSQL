---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   24/05/2017	TIAGO PRADELLA	   CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRESTACAOCOMPLCARGA  AS
select db_pcr_nro		numeroPrestacaoContas_PCOMP
      ,db_pcr_romaneio	romaneio_PCOMP
      ,db_pcr_senha		senha_PCOMP
	  ,p.USUARIO
  from db_prest_romaneio
      ,MVA_PRESTACAOCONTAS p
 where db_pcr_complemento = 1 
   and isnull(db_pcr_data_aceite, '') = ''
   and db_pcr_nro = p.NUMERO_PCONTA
