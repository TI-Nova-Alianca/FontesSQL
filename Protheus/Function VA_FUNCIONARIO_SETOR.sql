
-- ===================================================================
-- Author:		Claudia Lionço
-- Create date: 30/09/2021
-- Description:	Retorna dados do setor do funcionário ativo indicado
--
-- Historico de alterações:
--
-- ===================================================================
ALTER FUNCTION [dbo].[VA_FUNCIONARIO_SETOR]
-- PARAMETROS DE CHAMADA
(
	@ID_PROTHEUS AS VARCHAR(6)
)
RETURNS TABLE 
AS
RETURN (SELECT
		USR_ID AS ID
	   ,NOME 
	   ,CPF 
	   ,SETOR 
	   ,DESC_SETOR 
	   ,CARGO
	   ,DESC_CARGO
	   ,FUNCAO
	   ,DESC_FUNCAO
	FROM LKSRV_SIRH.SIRH.dbo.VA_VFUNCIONARIOS
	INNER JOIN SYS_USR
		ON (D_E_L_E_T_ = ''
		AND USR_MSBLQL = '2'
		AND USR_CARGO LIKE '%' + CAST(PESSOA AS VARCHAR) + '%'
		AND USR_ID = @ID_PROTHEUS)
	WHERE SITUACAO = '1')

