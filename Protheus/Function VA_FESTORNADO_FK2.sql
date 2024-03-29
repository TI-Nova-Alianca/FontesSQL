--
-- Descricao: Retorna 1 se o movimento estiver estornado na tabela FK2.
-- Autor....: Robert Koch
-- Data.....: 06/07/2020
--
-- Historico de alteracoes:
-- 31/03/2023 - Robert - Alterados alguns comentarios.
--

ALTER FUNCTION [dbo].[VA_FESTORNADO_FK2]
(
	@FILIAL VARCHAR (2),
	@ID_FK2 VARCHAR (32)
)
RETURNS BIT
AS

BEGIN

	-- Pelo que entendi das tabelas FK, cada movimento gera um 'processo' na tabela FKA.
	-- Caso o movimento seja estornado, cria-se novo registro na FKA com o mesmo processo
	-- amarrando ao movimento de estorno.
	DECLARE @RET BIT = 0;
	IF EXISTS (SELECT *
	FROM FKA010 AS FKA
		,FKA010 AS FKA2
		,FK2010 AS FK2_ESTORNO
	WHERE FKA.D_E_L_E_T_ = ''
	AND FKA.FKA_FILIAL = @FILIAL
	AND FKA.FKA_IDORIG = @ID_FK2
	AND FKA.FKA_TABORI = 'FK2'
	AND FKA2.D_E_L_E_T_ = ''
	AND FKA2.FKA_FILIAL = FKA.FKA_FILIAL
	AND FKA2.FKA_IDPROC = FKA.FKA_IDPROC
	AND FKA2.FKA_TABORI = FKA.FKA_TABORI
	AND FKA2.FKA_IDFKA != FKA.FKA_IDFKA
	AND FK2_ESTORNO.D_E_L_E_T_ = ''
	AND FK2_ESTORNO.FK2_FILIAL = FKA2.FKA_FILIAL
	AND FK2_ESTORNO.FK2_IDFK2 = FKA2.FKA_IDORIG
	AND FK2_ESTORNO.FK2_TPDOC = 'ES')
	BEGIN
		SET @RET = 1;
	END
RETURN @RET;
END

