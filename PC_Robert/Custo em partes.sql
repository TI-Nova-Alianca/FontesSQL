SELECT D3_CP0101, D3_CP0201, D3_CP0301, D3_CP0401, D3_CP0501, D3_CP0601, D3_CUSTO1, * FROM SD3010
WHERE D3_FILIAL = '01'
AND ROUND (D3_CP0101 + D3_CP0201 + D3_CP0301 + D3_CP0401 + D3_CP0501 + D3_CP0601, 1) != ROUND (D3_CUSTO1, 1)
AND D3_EMISSAO BETWEEN '20240301' and '20240331'

SELECT * FROM SB9010 WHERE D_E_L_E_T_ = '' AND B9_FILIAL = '01' AND B9_COD = '9918'
AND B9_DATA = '20240229'

-- deve-se gerar saldo inicial das partes, cfe descrito em https://centraldeatendimento.totvs.com/hc/pt-br/articles/4416690411159-Cross-Segmento-Backoffice-Linha-Protheus-SIGAEST-Configuração-do-Custo-em-Partes-sem-procedures
-- aberto chamado 19709868 questionando sobre as procedures
