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
	, sum (case when tipo = '2' then r.vlr_bruto_sem_ipi else 0 end) as [Devoluções]
	, sum (case when tipo = '1' then r.vlr_custo_previsto else 0 end) as [Custo Produtos Faturamento]
	, sum (case when tipo = '2' then r.vlr_custo_previsto else 0 end) as [Custo Produtos Devolução]
	, sum (case when tipo = '3' then r.vlr_custo_previsto else 0 end) as [Custo Produtos Bonificação]
	, sum (case when tipo = '1' then r.vlr_ipi else 0 end)    as [IPI Faturamento]
	, sum (case when tipo = '2' then r.vlr_ipi else 0 end)    as [IPI Devolução]
	, sum (case when tipo = '3' then r.vlr_ipi else 0 end)    as [IPI Bonificação]
	, sum (case when tipo = '1' then r.vlr_icmsst else 0 end) as [ICMS ST Faturamento]
	, sum (case when tipo = '2' then r.vlr_icmsst else 0 end) as [ICMS ST Devolução]
	, sum (case when tipo = '3' then r.vlr_icmsst else 0 end) as [ICMS ST Bonificação]
	, sum (case when tipo = '1' then r.vlr_pis else 0 end)    as [PIS Faturamento]
	, sum (case when tipo = '2' then r.vlr_pis else 0 end)    as [PIS Devolução]
	, sum (case when tipo = '3' then r.vlr_pis else 0 end)    as [PIS Bonificação]
	, sum (case when tipo = '1' then r.vlr_cofins else 0 end) as [Cofins Faturamento]
	, sum (case when tipo = '2' then r.vlr_cofins else 0 end) as [Cofins Devolução] 
	, sum (case when tipo = '3' then r.vlr_cofins else 0 end) as [Cofins Bonificação]
	, sum (case when tipo = '1' then r.vlr_icms else 0 end)   as [ICMS Faturamento]
	, sum (case when tipo = '2' then r.vlr_icms else 0 end)   as [ICMS Devolução]
	, sum (case when tipo = '3' then r.vlr_icms else 0 end)   as [ICMS Bonificação]
	, sum (case when tipo = '1' then r.vlr_comissao_previsto else 0 end) as [Comissão faturamento]
	, sum (case when tipo = '2' then r.vlr_comissao_previsto else 0 end) as [Comissão Devoluções]
	, sum (case when tipo = '1' then r.vlr_frete_previsto else 0 end) as [Frete Faturamento]
	, sum (case when tipo = '3' then r.vlr_frete_previsto else 0 end) as [Frete Bonificação]
	, sum (case when tipo = '1' then r.vlr_rapel_previsto else 0 end) as [Rapel Faturamento]
	, sum (case when tipo = '2' then r.vlr_rapel_previsto else 0 end) as [Rapel Devolucoes]
	, sum (case when tipo = '3' then r.vlr_bruto_sem_ipi else 0 end) as [Bonificações]
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
	, [Faturamento Bruto] + [Devoluções] as [Faturamento bruto sem devolucoes]
	, [Custo Produtos Faturamento] + [Custo Produtos Devolução] as [Custo produtos]
	, [IPI Faturamento] + [ICMS ST Faturamento] + [IPI Devolução] + [ICMS ST Devolução] as [Impostos destacados NF fatur e devol]
	, [ICMS Faturamento] + [PIS Faturamento] + [Cofins Faturamento] + [ICMS Devolução] + [PIS Devolução] + [Cofins Devolução] as [Impostos sobre faturamento]
	, [Comissão faturamento] + [Comissão Devoluções] as [Comissoes]
	, [Rapel Faturamento] + [Rapel Devolucoes] as [Rapel faturamento e devolucao]
	, [IPI Bonificação] + [ICMS ST Bonificação] as [Impostos destacados NF Bonificação]
	, [ICMS Bonificação] + [PIS Bonificação] + [Cofins Bonificação] as [Impostos sobre Bonificação]
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
		- [Custo Produtos Bonificação]
		- [Impostos destacados NF Bonificação]
		- [Impostos sobre Bonificação]
		- [Frete Bonificação]
		- [Verba Utilizada] as [Valor margem]
from d
), f as (
select *
	, round ([Valor margem] / [Faturamento bruto sem devolucoes] * 100, 2) as [% margem]
from e
)
	          select 1 as nivel, 'Faturamento bruto sem devolucoes'     as titulo, sum ([Faturamento bruto sem devolucoes])     as valor from f
	union all select 2 as nivel, 'Faturamento Bruto'                    as titulo, sum ([Faturamento Bruto])                    as valor from f
	union all select 2 as nivel, 'Devoluções'                           as titulo, sum ([Devoluções])                           as valor from f
	union all select 1 as nivel, 'Custo produtos'                       as titulo, sum ([Custo produtos])                       as valor from f
	union all select 2 as nivel, 'Custo Produtos Faturamento'           as titulo, sum ([Custo Produtos Faturamento])           as valor from f
	union all select 2 as nivel, 'Custo Produtos Devolução'             as titulo, sum ([Custo Produtos Devolução])             as valor from f
	union all select 1 as nivel, 'Impostos destacados NF fatur e devol' as titulo, sum ([Impostos destacados NF fatur e devol]) as valor from f
	union all select 2 as nivel, 'IPI Faturamento'                      as titulo, sum ([IPI Faturamento])                      as valor from f
	union all select 2 as nivel, 'ICMS ST Faturamento'                  as titulo, sum ([ICMS ST Faturamento])                  as valor from f
	union all select 2 as nivel, 'IPI Devolução'                        as titulo, sum ([IPI Devolução])                        as valor from f
	union all select 2 as nivel, 'ICMS ST Devolução'                    as titulo, sum ([ICMS ST Devolução])                    as valor from f
	union all select 1 as nivel, 'Impostos sobre faturamento'           as titulo, sum ([Impostos sobre faturamento])           as valor from f
	union all select 2 as nivel, 'ICMS Faturamento'                     as titulo, sum ([ICMS Faturamento])                     as valor from f
	union all select 2 as nivel, 'PIS Faturamento'                      as titulo, sum ([PIS Faturamento])                      as valor from f
	union all select 2 as nivel, 'Cofins Faturamento'                   as titulo, sum ([Cofins Faturamento])                   as valor from f
	union all select 2 as nivel, 'ICMS Devolução'                       as titulo, sum ([ICMS Devolução])                       as valor from f
	union all select 2 as nivel, 'PIS Devolução'                        as titulo, sum ([PIS Devolução])                        as valor from f
	union all select 2 as nivel, 'Cofins Devolução'                     as titulo, sum ([Cofins Devolução])                     as valor from f
	union all select 1 as nivel, 'Comissoes'                            as titulo, sum ([Comissoes])                            as valor from f
	union all select 2 as nivel, 'Comissao faturamento'                 as titulo, sum ([Comissão faturamento])                 as valor from f
	union all select 2 as nivel, 'Comissao devolucoes'                  as titulo, sum ([Comissão Devoluções])                  as valor from f
	union all select 1 as nivel, 'Frete Faturamento'                    as titulo, sum ([Frete Faturamento])                    as valor from f
	union all select 1 as nivel, 'Rapel faturamento e devolucao'        as titulo, sum ([Rapel faturamento e devolucao])        as valor from f
	union all select 2 as nivel, 'Rapel Faturamento'                    as titulo, sum ([Rapel Faturamento])                    as valor from f
	union all select 2 as nivel, 'Rapel Devolucoes'                     as titulo, sum ([Rapel Devolucoes])                     as valor from f
	union all select 2 as nivel, 'Bonificações'                         as titulo, sum ([Bonificações])                         as valor from f
	union all select 1 as nivel, 'Custo Produtos Bonificação'           as titulo, sum ([Custo Produtos Bonificação])           as valor from f
	union all select 1 as nivel, 'Impostos destacados NF Bonificação'   as titulo, sum ([Impostos destacados NF Bonificação])   as valor from f
	union all select 2 as nivel, 'IPI Bonificação'                      as titulo, sum ([IPI Bonificação])                      as valor from f
	union all select 2 as nivel, 'ICMS ST Bonificação'                  as titulo, sum ([ICMS ST Bonificação])                  as valor from f
	union all select 1 as nivel, 'Impostos sobre Bonificação'           as titulo, sum ([Impostos sobre Bonificação])           as valor from f
	union all select 2 as nivel, 'ICMS Bonificação'                     as titulo, sum ([ICMS Bonificação])                     as valor from f
	union all select 2 as nivel, 'PIS Bonificação'                      as titulo, sum ([PIS Bonificação])                      as valor from f
	union all select 2 as nivel, 'Cofins Bonificação'                   as titulo, sum ([Cofins Bonificação])                   as valor from f
	union all select 1 as nivel, 'Frete Bonificação'                    as titulo, sum ([Frete Bonificação])                    as valor from f
	union all select 2 as nivel, 'Verba Liberada'                       as titulo, sum ([Verba Liberada])                       as valor from f
	union all select 1 as nivel, 'Verba Utilizada'                      as titulo, sum ([Verba Utilizada])                      as valor from f
	union all select 1 as nivel, 'Valor margem'                         as titulo, sum ([Valor margem])                         as valor from f
	union all select 1 as nivel, 'Percent margem/fat'                   as titulo, sum ([% margem])                             as valor from f
