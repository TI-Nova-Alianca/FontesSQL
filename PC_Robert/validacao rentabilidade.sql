-- executar no database DW (Azure)
/*
select cod_rede, loja_rede, tipo, sum (vlr_produtos)
from f_rentabilidade
where cod_rede in ('000117', '025428', '008577', '006975')
and datepart (year, data_emissao) = 2024
group by cod_rede, loja_rede, tipo

-- select * from d_cliente where nome_cliente like '%ZAFFARI%'
select * from d_cliente where cod_rede in ('025428', '008577', '006975')
*/

with c as (
SELECT
	sum (case when tipo = '1' then r.vlr_bruto_sem_ipi else 0 end) as [Faturamento Bruto]
	, sum (case when tipo = '2' then r.vlr_bruto_sem_ipi else 0 end) as [Devolu��es]
	, sum (case when tipo = '1' then r.vlr_custo_previsto else 0 end) as [Custo Produtos Faturamento]
	, sum (case when tipo = '2' then r.vlr_custo_previsto else 0 end) as [Custo Produtos Devolu��o]
	, sum (case when tipo = '3' then r.vlr_custo_previsto else 0 end) as [Custo Produtos Bonifica��o]
	, sum (case when tipo = '1' then r.vlr_ipi else 0 end)    as [IPI Faturamento]
	, sum (case when tipo = '2' then r.vlr_ipi else 0 end)    as [IPI Devolu��o]
	, sum (case when tipo = '3' then r.vlr_ipi else 0 end)    as [IPI Bonifica��o]
	, sum (case when tipo = '1' then r.vlr_icmsst else 0 end) as [ICMS ST Faturamento]
	, sum (case when tipo = '2' then r.vlr_icmsst else 0 end) as [ICMS ST Devolu��o]
	, sum (case when tipo = '3' then r.vlr_icmsst else 0 end) as [ICMS ST Bonifica��o]
	, sum (case when tipo = '1' then r.vlr_pis else 0 end)    as [PIS Faturamento]
	, sum (case when tipo = '2' then r.vlr_pis else 0 end)    as [PIS Devolu��o]
	, sum (case when tipo = '3' then r.vlr_pis else 0 end)    as [PIS Bonifica��o]
	, sum (case when tipo = '1' then r.vlr_cofins else 0 end) as [Cofins Faturamento]
	, sum (case when tipo = '2' then r.vlr_cofins else 0 end) as [Cofins Devolu��o] 
	, sum (case when tipo = '3' then r.vlr_cofins else 0 end) as [Cofins Bonifica��o]
	, sum (case when tipo = '1' then r.vlr_icms else 0 end)   as [ICMS Faturamento]
	, sum (case when tipo = '2' then r.vlr_icms else 0 end)   as [ICMS Devolu��o]
	, sum (case when tipo = '3' then r.vlr_icms else 0 end)   as [ICMS Bonifica��o]
	, sum (case when tipo = '1' then r.vlr_comissao_previsto else 0 end) as [Comiss�o faturamento]
	, sum (case when tipo = '2' then r.vlr_comissao_previsto else 0 end) as [Comiss�o Devolu��es]
	, sum (case when tipo = '1' then r.vlr_frete_previsto else 0 end) as [Frete Faturamento]
	, sum (case when tipo = '3' then r.vlr_frete_previsto else 0 end) as [Frete Bonifica��o]
	, sum (case when tipo = '1' then r.vlr_rapel_previsto else 0 end) as [Rapel Faturamento]
	, sum (case when tipo = '2' then r.vlr_rapel_previsto else 0 end) as [Rapel Devolucoes]
	, sum (case when tipo = '3' then r.vlr_bruto_sem_ipi else 0 end) as [Bonifica��es]
	, sum (case when tipo = 'A' then r.vlr_verba_liberada else 0 end) as [Verba Liberada]
	, sum (case when tipo = '6' then r.vlr_verba_utilizada else 0 end) as [Verba Utilizada]
from f_rentabilidade r
where datepart (year, data_emissao) = 2023
--and datepart (month, data_emissao) = 1
and cod_rede = '000117'
--and cod_rede = '025428'
--and cod_rede = '008577'
--and cod_rede = '006975'
)
, d as (
select c.*
	, [Faturamento Bruto] + [Devolu��es] as [Faturamento bruto sem devolucoes]
	, [Custo Produtos Faturamento] + [Custo Produtos Devolu��o] as [Custo produtos]
	, [IPI Faturamento] + [ICMS ST Faturamento] + [IPI Devolu��o] + [ICMS ST Devolu��o] as [Impostos destacados NF fatur e devol]
	, [ICMS Faturamento] + [PIS Faturamento] + [Cofins Faturamento] + [ICMS Devolu��o] + [PIS Devolu��o] + [Cofins Devolu��o] as [Impostos sobre faturamento]
	, [Comiss�o faturamento] + [Comiss�o Devolu��es] as [Comissoes]
	, [Rapel Faturamento] + [Rapel Devolucoes] as [Rapel faturamento e devolucao]
	, [IPI Bonifica��o] + [ICMS ST Bonifica��o] as [Impostos destacados NF Bonifica��o]
	, [ICMS Bonifica��o] + [PIS Bonifica��o] + [Cofins Bonifica��o] as [Impostos sobre Bonifica��o]
from c
), e as (
select d.*
	, [Faturamento bruto sem devolucoes]
		- [Custo produtos]
		- [Impostos destacados NF fatur e devol]
		- [Impostos sobre faturamento]
		- [Comissoes]
		- [Frete Faturamento]
		- [Rapel faturamento e devolucao]
		- [Custo Produtos Bonifica��o]
		- [Impostos destacados NF Bonifica��o]
		- [Impostos sobre Bonifica��o]
		- [Frete Bonifica��o]
		- [Verba Utilizada] as [Valor margem]
from d
), f as (
select *
	, round ([Valor margem] / [Faturamento bruto sem devolucoes] * 100, 2) as [% margem]
from e
)
	          select 1 as nivel, 'Faturamento bruto sem devolucoes'     as titulo, sum ([Faturamento bruto sem devolucoes])     as valor from f
	union all select 2 as nivel, 'Faturamento Bruto'                    as titulo, sum ([Faturamento Bruto])                    as valor from f
	union all select 2 as nivel, 'Devolu��es'                           as titulo, sum ([Devolu��es])                           as valor from f
	union all select 1 as nivel, 'Custo produtos'                       as titulo, sum ([Custo produtos])                       as valor from f
	union all select 2 as nivel, 'Custo Produtos Faturamento'           as titulo, sum ([Custo Produtos Faturamento])           as valor from f
	union all select 2 as nivel, 'Custo Produtos Devolu��o'             as titulo, sum ([Custo Produtos Devolu��o])             as valor from f
	union all select 1 as nivel, 'Impostos destacados NF fatur e devol' as titulo, sum ([Impostos destacados NF fatur e devol]) as valor from f
	union all select 2 as nivel, 'IPI Faturamento'                      as titulo, sum ([IPI Faturamento])                      as valor from f
	union all select 2 as nivel, 'ICMS ST Faturamento'                  as titulo, sum ([ICMS ST Faturamento])                  as valor from f
	union all select 2 as nivel, 'IPI Devolu��o'                        as titulo, sum ([IPI Devolu��o])                        as valor from f
	union all select 2 as nivel, 'ICMS ST Devolu��o'                    as titulo, sum ([ICMS ST Devolu��o])                    as valor from f
	union all select 1 as nivel, 'Impostos sobre faturamento'           as titulo, sum ([Impostos sobre faturamento])           as valor from f
	union all select 2 as nivel, 'ICMS Faturamento'                     as titulo, sum ([ICMS Faturamento])                     as valor from f
	union all select 2 as nivel, 'PIS Faturamento'                      as titulo, sum ([PIS Faturamento])                      as valor from f
	union all select 2 as nivel, 'Cofins Faturamento'                   as titulo, sum ([Cofins Faturamento])                   as valor from f
	union all select 2 as nivel, 'ICMS Devolu��o'                       as titulo, sum ([ICMS Devolu��o])                       as valor from f
	union all select 2 as nivel, 'PIS Devolu��o'                        as titulo, sum ([PIS Devolu��o])                        as valor from f
	union all select 2 as nivel, 'Cofins Devolu��o'                     as titulo, sum ([Cofins Devolu��o])                     as valor from f
	union all select 1 as nivel, 'Comissoes'                            as titulo, sum ([Comissoes])                            as valor from f
	union all select 2 as nivel, 'Comissao faturamento'                 as titulo, sum ([Comiss�o faturamento])                 as valor from f
	union all select 2 as nivel, 'Comissao devolucoes'                  as titulo, sum ([Comiss�o Devolu��es])                  as valor from f
	union all select 1 as nivel, 'Frete Faturamento'                    as titulo, sum ([Frete Faturamento])                    as valor from f
	union all select 1 as nivel, 'Rapel faturamento e devolucao'        as titulo, sum ([Rapel faturamento e devolucao])        as valor from f
	union all select 2 as nivel, 'Rapel Faturamento'                    as titulo, sum ([Rapel Faturamento])                    as valor from f
	union all select 2 as nivel, 'Rapel Devolucoes'                     as titulo, sum ([Rapel Devolucoes])                     as valor from f
	union all select 2 as nivel, 'Bonifica��es'                         as titulo, sum ([Bonifica��es])                         as valor from f
	union all select 1 as nivel, 'Custo Produtos Bonifica��o'           as titulo, sum ([Custo Produtos Bonifica��o])           as valor from f
	union all select 1 as nivel, 'Impostos destacados NF Bonifica��o'   as titulo, sum ([Impostos destacados NF Bonifica��o])   as valor from f
	union all select 2 as nivel, 'IPI Bonifica��o'                      as titulo, sum ([IPI Bonifica��o])                      as valor from f
	union all select 2 as nivel, 'ICMS ST Bonifica��o'                  as titulo, sum ([ICMS ST Bonifica��o])                  as valor from f
	union all select 1 as nivel, 'Impostos sobre Bonifica��o'           as titulo, sum ([Impostos sobre Bonifica��o])           as valor from f
	union all select 2 as nivel, 'ICMS Bonifica��o'                     as titulo, sum ([ICMS Bonifica��o])                     as valor from f
	union all select 2 as nivel, 'PIS Bonifica��o'                      as titulo, sum ([PIS Bonifica��o])                      as valor from f
	union all select 2 as nivel, 'Cofins Bonifica��o'                   as titulo, sum ([Cofins Bonifica��o])                   as valor from f
	union all select 1 as nivel, 'Frete Bonifica��o'                    as titulo, sum ([Frete Bonifica��o])                    as valor from f
	union all select 2 as nivel, 'Verba Liberada'                       as titulo, sum ([Verba Liberada])                       as valor from f
	union all select 1 as nivel, 'Verba Utilizada'                      as titulo, sum ([Verba Utilizada])                      as valor from f
	union all select 1 as nivel, 'Valor margem'                         as titulo, sum ([Valor margem])                         as valor from f
	union all select 1 as nivel, 'Percent margem/fat'                   as titulo, sum ([% margem])                             as valor from f
