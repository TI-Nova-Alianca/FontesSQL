

CREATE    VIEW [dbo].[NW002_BI_INDICES_ECONOMICOS] 
AS
--Cooperativa Agroindustrial Nova Alianca Ltda
--View para buscar indices economico-financeiros no BI_ALIANCA e imprimir no NaWeb.
--Autor: Daiana Ribas
--Data:  25/09/2023
--Historico de alteracoes:
--11/10/2023 - Robert - Criada coluna NW002_BI_ACUM_ANO (GLPI 12323)
-- 
with c as (
	SELECT
		 indice as NW002_BI_INDICE 
		,descricao as NW002_BI_DESC
		,ano   as NW002_BI_ANO
		, sum (case when mes = '01' then valor else 0 end) as [NW002_BI_JAN]
		, sum (case when mes = '02' then valor else 0 end) as [NW002_BI_FEV]
		, sum (case when mes = '03' then valor else 0 end) as [NW002_BI_MAR]
		, sum (case when mes = '04' then valor else 0 end) as [NW002_BI_ABR]
		, sum (case when mes = '05' then valor else 0 end) as [NW002_BI_MAI]
		, sum (case when mes = '06' then valor else 0 end) as [NW002_BI_JUN]
		, sum (case when mes = '07' then valor else 0 end) as [NW002_BI_JUL]
		, sum (case when mes = '08' then valor else 0 end) as [NW002_BI_AGO]
		, sum (case when mes = '09' then valor else 0 end) as [NW002_BI_SET]
		, sum (case when mes = '10' then valor else 0 end) as [NW002_BI_OUT]
		, sum (case when mes = '11' then valor else 0 end) as [NW002_BI_NOV]
		, sum (case when mes = '12' then valor else 0 end) as [NW002_BI_DEZ]
	from BI_ALIANCA.dbo.indices_econ_financ
   -- group by indice, descricao, ano
	group by ano, indice, descricao
)
select c.*
	, case when NW002_BI_INDICE in ('05.02','06.02','07.01','07.02','07.04','07.06','07.07','09.01','09.02','09.03','09.04','09.06','09.07','10.01','10.02','10.03','10.04','10.05','10.06','10.07')
		then NW002_BI_JAN + NW002_BI_FEV + NW002_BI_MAR + NW002_BI_ABR + NW002_BI_MAI + NW002_BI_JUN + NW002_BI_JUL + NW002_BI_AGO + NW002_BI_SET + NW002_BI_OUT + NW002_BI_NOV + NW002_BI_DEZ
		else
			case when NW002_BI_INDICE in ('06.01','06.03','07.03','07.05','08.01','08.02','08.03','08.04','09.05','09.08','10.08')
			then (NW002_BI_JAN + NW002_BI_FEV + NW002_BI_MAR + NW002_BI_ABR + NW002_BI_MAI + NW002_BI_JUN + NW002_BI_JUL + NW002_BI_AGO + NW002_BI_SET + NW002_BI_OUT + NW002_BI_NOV + NW002_BI_DEZ)
				/ isnull ((select max (mes)
							from BI_ALIANCA.dbo.indices_econ_financ i2
							where i2.ano = c.NW002_BI_ANO), 1)
			else 0
			end
		end as NW002_BI_ACUM_ANO
from c


