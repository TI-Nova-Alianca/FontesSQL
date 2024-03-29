ALTER VIEW MVA_CRITERIOS_TRANSICOES AS
 select CODIGO_FLUXO	fluxo_CRTRA,
		CODIGO_TRANSICAO	transicao_CRTRA,
		SEQUENCIA	sequencia_CRTRA,
		NOME	nome_CRTRA,
		TIPO	tipo_CRTRA,
		CODIGO_ATIVIDADE	codigoAtividade_CRTRA,
		ABA	aba_CRTRA,
		AREA	area_CRTRA,
		CAMPO	campo_CRTRA,
		OPERADOR	operador_CRTRA,
		VALOR	valor_CRTRA,
		TOTALIZADOR	totalizador_CRTRA,
		CONSULTA	consulta_CRTRA,
		CONSULTA_MOBILE	consultaMobile_CRTRA,
		MVA_TRANSICOES.usuario
   from DB_FLU_TRA_CRITERIOS, MVA_TRANSICOES
  where fluxo_TRA = CODIGO_FLUXO
	and transicao_TRA = CODIGO_TRANSICAO
	and formatoTransicao_TRA = 1
