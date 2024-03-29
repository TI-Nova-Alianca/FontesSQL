---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	09/01/2017	TIAGO PRADELLA	CRIACAO
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_LUCRA_FATOR AS
 select codigo						codigo_LUCFAT,
		descricao					descricao_LUCFAT,
		data_inicial				dataInicial_LUCFAT,
		data_final					dataFinal_LUCFAT,
		CLIENTE_CODIGO				CLIENTECODIGO,
		CLIENTE_REDE				CLIENTEREDE,
		CLIENTE_CNPJ				CLIENTECNPJ,
		RAMO_ATIVIDADE_I			RAMOATIVIDADEI,
		RAMO_ATIVIDADE_II			RAMOATIVIDADEII,
		CLASSIFICACAO_COMERCIAL		CLASSIFICACAOCOMERCIAL,
		REGIAO_COMERCIAL			REGIAOCOMERCIAL,
		AREA_ATUACAO				AREAATUACAO,
		UF							UF,
		EMPRESA						EMPRESA
   from DB_LUC_FATOR
  where situacao = 1
    and cast(DATA_FINAL as date) >= cast(getdate() as date)
