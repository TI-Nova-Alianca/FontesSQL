ALTER VIEW  MVA_CONVERSA AS
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR		ALTERACAO
-- 1.0000	03/04/2013	TIAGO PRADELLA	CRIACAO
-- 1.0001       15/05/2013      bruno           alteracoes
---------------------------------------------------------------------------------------------------
SELECT CON.CODIGO 		 		CODIGO_CONVE,
		CON.PARTICIPANTE		PARTICIPANTE_CONVE,
		CON.DATA_LEITURA		DATALEITURA_CONVE,
		CON.DATA_SAIDA			DATASAIDA_CONVE,
		CON.CRIADOR				CRIADOR_CONVE,
		CON.EXCLUIDO			excluido_CONVE,
		CON.DATA_ATUALIZACAO	DATAALTER,
                GETDATE() dataEnvio_CONVE,
		1 sincronizacao_CONVE,
		USU.USUARIO
   FROM DB_CONVERSA CON, DB_USUARIO  USU
  WHERE exists (select 1 from DB_CONVERSA inter where inter.PARTICIPANTE = usu.usuario and inter.CODIGO = con.codigo )
