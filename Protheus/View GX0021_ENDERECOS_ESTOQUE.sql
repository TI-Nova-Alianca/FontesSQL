
CREATE view [dbo].[GX0021_ENDERECOS_ESTOQUE]
AS

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar os enderecos de estoque.
-- Autor: Robert Koch
-- Data:  28/07/2018
-- Historico de alteracoes:
--

select 
	BE_FILIAL  as GX0021_FILIAL_CODIGO,
	BE_LOCAL   as GX0021_ALMOX_CODIGO,
	BE_LOCALIZ as GX0021_ENDERECO_CODIGO,
	BE_DESCRIC as GX0021_ENDERECO_DESCRICAO
from SBE010
WHERE D_E_L_E_T_ = ''

