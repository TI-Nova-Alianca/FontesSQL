---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0000	13/12/2013	TIAGO PRADELLA	CRIACAO
-- 1.0002   31/01/2014  tiago           incluido replace
-- 1.0003   24/02/2015  TIAGO           INCLUIDO CAMPO DATAALTERS
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_INSTITUCIONALCATTRADUCAO AS
SELECT 
		DB_INSTT_CODIGO	      CODIGO_INSTR,
		DB_INSTT_SEQUENCIA	  SEQUENCIA_INSTR,
		DB_INSTT_CHAVE	      CHAVE_INSTR,
		DB_INSTT_IDIOMA	      IDIOMA_INSTR,
		replace(replace(replace(replace(DB_INSTT_TRADUCAO, '.png', '.PNGM'), '.jpg','.PNGM'), '\', '/'), '.mp4', '.MP4M') TRADUCAO_INSTR,
		I.USUARIO,
		I.DATAALTER
FROM DB_INST_TRADUCAO, MVA_INSTITUCIONALCATALOGO I
WHERE I.CODIGO_INST = DB_INSTT_CODIGO
	  AND I.SEQUENCIA_INST = DB_INSTT_SEQUENCIA
