
CREATE view [dbo].[GX0064_LIB_GERENC_PEDIDOS]

AS
SELECT 
	 SC5.R_E_C_N_O_ as GX0064_LIB_CHAVE
    ,C5_FILIAL   AS GX0064_LIB_C5_FILIAL
    ,C5_NUM      AS GX0064_LIB_C5_NUM
    ,C5_EMISSAO  AS GX0064_LIB_C5_EMISSAO
    ,C5_CLIENTE  AS GX0064_LIB_C5_CLIENTE
    ,C5_LOJACLI  AS GX0064_LIB_C5_LOJACLI
    ,A1_NOME 	 AS GX0064_LIB_A1_NOME
    ,A1_EST 	 AS GX0064_LIB_A1_EST
    ,C5_VAVLFAT  AS GX0064_LIB_C5_VAVLFAT
    ,C5_VAMCONT  AS GX0064_LIB_C5_VAMCONT
    ,C5_VAPRPED  AS GX0064_LIB_C5_VAPRPED
    ,C5_STATUS 	 AS GX0064_LIB_C5_STATUS
    ,C5_VABLOQ 	 AS GX0064_LIB_C5_VABLOQ
    ,C5_VEND1 +'- '+ SA3.A3_NOME AS GX0064_LIB_C5_VENDEDOR
    ,C5_VAUSER 	 AS GX0064_LIB_C5_VAUSER
    ,C5_TIPO 	 AS GX0064_LIB_C5_TIPO
    ,C5_TPFRETE  AS GX0064_LIB_C5_TPFRETE
    ,C5_PEDCLI 	 AS GX0064_LIB_C5_PEDCLI
	,CASE WHEN C5_VABLOQ     like '%X%' THEN 'Liberacao negada'
		  WHEN C5_VABLOQ not like '%X%' and C5_VABLOQ like '%M%' and C5_VABLOQ like '%P%' THEN  'Bloq.por margem e preco'
		  WHEN C5_VABLOQ not like '%X%' and C5_VABLOQ like '%F%' THEN 'Bonif.sem faturamento'
		  WHEN C5_VABLOQ not like '%X%' and C5_VABLOQ like '%P%' THEN 'Bloq.por preco'
		  WHEN C5_VABLOQ not like '%X%' and C5_VABLOQ like '%M%' THEN 'Bloq.por margem'
		  WHEN C5_VABLOQ not like '%X%' and C5_VABLOQ like '%A%' THEN 'Bloq. % reajuste'
		  WHEN C5_VABLOQ not like '%X%' and C5_VABLOQ like '%B%' THEN 'Bloq.bonificação' 
		  WHEN C5_VABLOQ not like '%X%' and C5_VABLOQ like '%S%' THEN 'Bloq.sucos' 
    END AS GX0064_LIB_DESC_BLOQUEIO

    FROM  SC5010  SC5 
    INNER JOIN  SA1010  SA1 
        ON SA1.D_E_L_E_T_ = '' 
			AND SA1.A1_FILIAL = '  '
            AND A1_COD = C5_CLIENTE 
            AND A1_LOJA = C5_LOJACLI 
    INNER JOIN  SA3010  SA3 
	    ON SA3.D_E_L_E_T_ = ''
			AND SA3.A3_FILIAL = '  '
            AND SA3.A3_COD = SC5.C5_VEND1 
    WHERE SC5.D_E_L_E_T_   = '' 
    AND C5_VABLOQ  != ''        -- Pedido com bloqueio
    AND C5_LIBEROK != ''        -- Pedido com 'liberacao comercial (SC9 gerado)
    AND C5_NOTA != 'XXXXXXXXX'  -- Residuo eliminado (nao sei por que as vezes grava com 9 posicoes)
    AND C5_NOTA != 'XXXXXX'     -- Residuo eliminado (nao sei por que as vezes grava com 6 posicoes)

