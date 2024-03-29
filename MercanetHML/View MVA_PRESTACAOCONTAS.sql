---------------------------------------------------------------------------------------------------
-- VERSAO   DATA	    AUTOR		       ALTERACAO
-- 1.0001   02/09/2014	TIAGO PRADELLA	   CRIACAO
-- 1.0002   07/03/2016  tiago              alterado join com a mva_representantes
-- 1.0003   15/03/2017  ricardo            incluido campo MANIFESTO_PCONTA
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_PRESTACAOCONTAS  AS
SELECT	DB_PC_NRO           NUMERO_PCONTA,
		DB_PC_REPRES		REPRESENTANTE_PCONTA,
		DB_PC_DT_GERADA		DATAGERACAO_PCONTA,
		DB_PC_DT_ABERTURA	DATAABERTURA_PCONTA,
		DB_PC_DT_FECHADA	DATAFECHAMENTO_PCONTA,
		DB_PC_DT_ENCERRADA  DATAENCERRAMENTO_PCONTA,
		DB_PC_SITUACAO		SITUACAO_PCONTA,
		DB_PC_TEXTO_NOTA	TEXTONOTAFISCAL_PCONTA,
		DB_PC_PLACA_VEIC	NUMEROPLACAVEICULO_PCONTA,
		DB_PC_SIGLA_PLACA	UFPLACAVEICULO_PCONTA,
		DB_PC_OBS_CANC		OBSERVACAOCANCELAMENTO_PCONTA,
		DB_PC_EMPRESA		EMPRESA_PCONTA,
		DB_PC_USU_GEROU		USUARIOGEROU_PCONTA,
		DB_PC_USU_ENCERROU  USUARIOENCERROU_PCONTA,
		DB_PC_USU_CANCELOU  USUARIOCANCELOU_PCONTA,
		DB_PC_CONFERENTE	USUARIOCONFERENTE_PCONTA,
		DB_PC_DATA_CONFERE  DATACONFERENCIA_PCONTA,
		DB_PC_DATA_EXP_ERP  DATAEXPORTACAOERP_PCONTA,
		(select cast(db_romd_nota as varchar)  + '-' + cast(db_romd_serie as varchar)
			from DB_PREST_ROMANEIO, DB_romaneio_doc
			where db_pcr_nro = DB_PC_NRO 
			and db_pcr_romaneio = db_romd_romaneio
			and db_pcr_complemento = 0 ) MANIFESTO_PCONTA,
		usu.USUARIO
   FROM DB_PREST_CONTAS, db_usuario usu
  WHERE DB_PC_SITUACAO <= 1
	and exists (select 1 from MVA_REPRESENTANTES where DB_PC_REPRES = CODIGO_REPRES and usu.usuario = MVA_REPRESENTANTES.usuario)
