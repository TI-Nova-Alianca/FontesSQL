---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0001   05/06/2013  TIAGO           INCLUIDO TABELA MAT03
-- 1.0002   19/12/2013  tiago           incluido campo nome interno
-- 1.0003   19/05/2015  tiago           incluido campo numero de deciamis
-- 1.0004   05/02/2016  ricardo         alteração coluna nome_atrib
-- Mudança realizada para enviar a informaçao quando o atributo é de visita
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_ATRIBUTOS AS
SELECT AT01_ATRIB      CODIGO_ATRIB,
       max(AT02_DESCRICAO)  NOME_ATRIB,
       max(AT01_PARAMNOME)  NOMEINTERNO_ATRIB,
       max(AT02_TPDADO)     tipoDado_ATRIB,
       max(AT02_APRESENTA)  apresenta_ATRIB,
       max(case when mat02.AT02_TPDADO = 0 then MAT02.AT02_NRODECIMAL else '' end) nroDecimais_ATRIB,
       max(AT02_OBRIG)      obrig_ATRIB,
       max(AT02_TABELA)     tabela_ATRIB,
       max(AT02_TAMANHO)    tamanho_ATRIB
  FROM MAT01,
       mat02
where MAT01.at01_atrib = mat02.at02_atrib
   and  not exists (select 1 from MAT01 m, mat02 m2 where m.at01_atrib = MAT01.AT01_ATRIB and m.at01_atrib = m2.at02_atrib and m2.AT02_TABELA = 21 )
  group by AT01_ATRIB
union all
SELECT AT01_ATRIB      CODIGO_ATRIB,
       AT02_DESCRICAO  NOME_ATRIB,
       AT01_PARAMNOME  NOMEINTERNO_ATRIB,
       AT02_TPDADO     tipoDado_ATRIB,
       AT02_APRESENTA  apresenta_ATRIB,
       case when mat02.AT02_TPDADO = 0 then MAT02.AT02_NRODECIMAL else '' end nroDecimais_ATRIB,
       AT02_OBRIG      obrig_ATRIB,
       AT02_TABELA     tabela_ATRIB,
       AT02_TAMANHO    tamanho_ATRIB
  FROM MAT01,
       mat02
where MAT01.at01_atrib = mat02.at02_atrib
   and AT02_TABELA = 21
