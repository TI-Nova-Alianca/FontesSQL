use BI_ALIANCA
set NOCOUNT ON
exec SP_INDIC_ECON_FIN '2023', '01'
--exec SP_INDIC_ECON_FIN '2023', '02'
--exec SP_INDIC_ECON_FIN '2023', '03'
--exec SP_INDIC_ECON_FIN '2023', '04'
--exec SP_INDIC_ECON_FIN '2023', '05'
exec SP_INDIC_ECON_FIN '2023', '06'
--exec SP_INDIC_ECON_FIN '2023', '07'
--exec SP_INDIC_ECON_FIN '2023', '08'
--exec SP_INDIC_ECON_FIN '2023', '09'
--exec SP_INDIC_ECON_FIN '2023', '10'
--exec SP_INDIC_ECON_FIN '2023', '11'
--exec SP_INDIC_ECON_FIN '2023', '12'

select indice, descricao
	, sum (case when mes = '01' then valor else 0 end) as [jan]
	, sum (case when mes = '02' then valor else 0 end) as [fev]
	, sum (case when mes = '03' then valor else 0 end) as [mar]
	, sum (case when mes = '04' then valor else 0 end) as [abr]
	, sum (case when mes = '05' then valor else 0 end) as [mai]
	, sum (case when mes = '06' then valor else 0 end) as [jul]
	, sum (case when mes = '07' then valor else 0 end) as [jul]
	, sum (case when mes = '08' then valor else 0 end) as [ago]
	, sum (case when mes = '09' then valor else 0 end) as [set]
	, sum (case when mes = '10' then valor else 0 end) as [out]
	, sum (case when mes = '11' then valor else 0 end) as [nov]
	, sum (case when mes = '12' then valor else 0 end) as [dez]
	from indices_econ_financ
	where ano = '2023'
	group by indice, descricao
	order by indice

--delete indices_econ_financ where mes > '09'
--drop table indices_econ_financ
