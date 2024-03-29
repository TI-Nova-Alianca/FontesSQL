


CREATE view [dbo].[GX0004_PRODUTOS]
AS

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar os Produtos do Protheus.
-- Autor: Julio Pedroni
-- Data:  23/05/2017
-- Historico de alteracoes:
-- 14/02/2022 - Robert - Acrescentados filtros por filial nas tabelas ZAZ, SH1 e SB1
--                     - Desconsiderava itens com B1_DESC vazio (nao sei o motivo)

select 
	B1_COD	   AS GX0004_PRODUTO_CODIGO,
	B1_DESC	   AS GX0004_PRODUTO_DESCRICAO,
	B1_TIPO	   AS GX0004_PRODUTO_TIPO,
	B1_MSBLQL  AS GX0004_PRODUTO_SITUACAO,
	B1_VAMARCM AS GX0004_PRODUTO_MARCA,
	ZX52.ZX5_40DESC AS GX0004_PRODUTO_MARCA_DESC,
	B1_VALINEN AS GX0004_B1_VALINEN,
	SH1010.H1_DESCRI AS GX0004_B1_DESCVALINEN, 
	B1_CODLIN  AS GX0004_B1_CODLIN,
	ZX5010.ZX5_39DESC AS GX0004_B1_DESCLIN,
	B1_GRPEMB  AS GX0004_B1_GRPEMB,
	B1_UM      AS GX0004_B1_UM,
	(B1_LITROS / NULLIF(B1_QTDEMB,0)) as GX0004_LITRO_UN,
	ZAZ010.ZAZ_NLINF AS GX0004_B1_CLINF,
	B1_QTDEMB AS GX0004_B1_QTDEMB, 
	B1_LITROS AS GX0004_B1_LITROS,
	B1_VACOR AS GX0004_B1_VACOR,
	B1_VAORGAN AS GX0004_B1_VAORGAN,
	B1_VARUVA AS GX0004_B1_VARUVA,
	B1_RASTRO AS GX0004_B1_RASTRO,
	B1_LOCALIZ AS GX0004_B1_LOCALIZ,
	B1_GRUPO as  GX0004_B1_GRUPO

from SB1010
left join ZX5010		 on (SB1010.B1_CODLIN  = ZX5010.ZX5_39COD AND ZX5010.D_E_L_E_T_ = '' AND ZX5010.ZX5_TABELA = '39' AND ZX5010.ZX5_FILIAL = '')
left join ZX5010 as ZX52 on (SB1010.B1_VAMARCM = ZX52.ZX5_40COD   AND ZX52.D_E_L_E_T_ = '' AND ZX52.ZX5_TABELA = '40' AND ZX52.ZX5_FILIAL = '')
left join ZAZ010		 on (SB1010.B1_CLINF   = ZAZ010.ZAZ_CLINF AND ZAZ010.D_E_L_E_T_ = '' AND ZAZ_FILIAL = '  ')
left join SH1010		 on (SB1010.B1_VALINEN = SH1010.H1_CODIGO AND SH1010.D_E_L_E_T_ = '' AND H1_FILIAL = '  ')
WHERE --B1_DESC <> '' and 
SB1010.D_E_L_E_T_ = ''
AND B1_FILIAL = '  '


