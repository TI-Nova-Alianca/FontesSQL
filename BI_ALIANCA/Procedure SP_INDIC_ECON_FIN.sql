
-- Descricao: Gera dados para indicadores financeiros (GLPI 12323)
-- Autor....: Robert Koch
-- Data.....: 14/09/2023
--
-- Historico de alteracoes:

CREATE procedure [dbo].[SP_INDIC_ECON_FIN]
(
	@in_ano varchar (4)
	,@in_mes varchar (2)
) as
begin

	if eomonth (@in_ano + @in_mes + '01') > eomonth (getdate ())
	begin
		raiserror ('Nao pode gerar data futura', 11, 1)
		return
	end

	-- Cria tabela para armazenamento dos indicadores
	if (not exists (select * from INFORMATION_SCHEMA.TABLES where table_name = 'indices_econ_financ'))
	begin
		print 'criando tabela'

		create table indices_econ_financ (
			ano        varchar (4)  not null
			,mes       varchar (2)  not null
			,indice    varchar (5)  not null
			,descricao varchar (50) not null
			,valor     float        default 0
		)
		create nonclustered index idx1 ON indices_econ_financ (ano, mes, indice)
	end

	-- Limpa todo o conteudo do ano/mes referencia para gerar novamente.
	delete indices_econ_financ
	where ano = @in_ano
	and mes = @in_mes

	-- Optei por gravar a descricao junto no arquivo. Apesar de ser nao normalizado,
	-- acho que com o tempo novos indices serao criados, e alguns substituidos, entao pode
	-- ser interessante manter um historico do que era cada um.
	-- Depois vou marcar a tabela para compressao no banco, entao essa repeticao de descricoes
	-- nao deverah ser um problema de tamanho de tabela.

	-- Gera tabela temporaria com saldos por conta, para uso nas queries posteriores.
	select CQ3_CONTA as conta
		, SUM (CQ3_DEBITO - CQ3_CREDIT) as valor
	into #saldos
	FROM protheus.dbo.CQ3010
	WHERE D_E_L_E_T_ = ''
	AND CQ3_DATA BETWEEN @in_ano + @in_mes + '01' AND @in_ano + @in_mes + '31'
	AND CQ3_TPSALD = '1'  -- REALIZADO
	AND CQ3_LP != 'Z' -- IGNORAR AS CONTAS DE ZERAMENTO (VIRADA DE EXERCICIO)
	GROUP BY CQ3_CONTA--, SUBSTRING (CQ3_DATA, 1, 6)
	create nonclustered index idx1 on #saldos (conta)


	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '01', 'Índices de liquidez', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '01.01', 'Liquidez Imediata', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '01.02', 'Liquidez Corrente', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '01.03', 'Liquidez Geral', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '01.04', 'Liquidez Seca', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '01.05', 'Grau de depêndencia de estoque', NULL)
	-------------------------------------------------------------------------
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '02', 'Índices de rentabilidade', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '02.01', 'Margem Bruta', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '02.02', 'Margem Operacional/Da Atividade', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '02.03', 'Margem Líquida', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '02.04', 'Margem EBTIDA %', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '02.05', 'Rentabilidade do Ativo (ROA)', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '02.06', 'Rentabilidade do PL (ROE)', NULL)
	-------------------------------------------------------------------------
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '03',   'Endividamento', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '03.01', 'Participação de Capitais Próprios', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '03.02', 'Endividamento Geral/Total', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '03.03', 'Endividamento Oneroso (Bancos)', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '03.04', 'Endividamento Curto Prazo', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '03.05', 'Composição do Endividamento/Perfil da dívida', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '03.06', 'Imobilização do PL', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '03.07', 'Imobilização de Recursos Permanentes', NULL)
	-------------------------------------------------------------------------
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '04',   'Análise Capital Giro', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '04.01', 'Necessidade de capital de Giro NCG (ACO - PCO)', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '04.02', 'Ciclo Financeiro', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '04.03', 'Capital Circulante Líquido', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '04.04', 'Saldo de Tesouraria = NCG- CCL', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '04.05', 'PME = (EST/RBV) x N', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '04.06', 'PMRV = (DB/RBV) x N', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '04.07', 'PMPF = (FORN/RBV) x N', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '04.08', 'CAPITAL DE GIRO DISPONÍVEL (PNC-ANC)', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '04.09', 'Saldo de Tesouraria (ACE-PCE)', NULL)
	-------------------------------------------------------------------------
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '05',   'Índices de Cobertura ', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '05.01', 'Índice de cobertura de Juros', NULL)

	insert into indices_econ_financ (ano, mes, indice, descricao, valor)
	values (@in_ano, @in_mes, '05.02', 'Despesas Financeiras'
		, (select sum (valor)
			from #saldos
			where conta like '406020101%') -- PRECISA DESTA CONTA PARA BATER COM DRE/ORCAMENTO or conta like '406020201099')
		)


	-------------------------------------------------------------------------
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '06', 'Folha de pagamento', NULL)

	declare @folha_numero_funcionarios int
	declare @folha_gastos_com_folha    float

	select @folha_numero_funcionarios = count (*)
	from LKSRV_SIRH.SIRH.dbo.VA_VFUNCIONARIOS
	where DATAADMISSAO <= eomonth (@in_ano + @in_mes + '01')
	and (DATARESCISAO is null or DATARESCISAO > eomonth (@in_ano + @in_mes + '01'))

	insert into indices_econ_financ (ano, mes, indice, descricao, valor)
	values (@in_ano, @in_mes, '06.01', 'Número funcionários', @folha_numero_funcionarios)

	select @folha_gastos_com_folha = sum (valor * case when conta in ('403010101002', '403010102004') then -1 else 1 end)
	from #saldos
	where  conta like '403010101%'
		or conta like '403010102%'
		or conta like '403010103%'
		or conta like '403010104%'
		or conta like '403010101002%'
		or conta like '403010102004%'
		or conta like '701010201%'
		or conta like '701010202%'
		or conta like '701010203%'
		or conta like '701010204%'

	insert into indices_econ_financ (ano, mes, indice, descricao, valor)
	values (@in_ano, @in_mes, '06.02', 'Gastos com folha', @folha_gastos_com_folha)

	insert into indices_econ_financ (ano, mes, indice, descricao, valor)
	values (@in_ano, @in_mes, '06.03', 'Gasto médio por funcionário', @folha_gastos_com_folha / @folha_numero_funcionarios)
	

	-------------------------------------------------------------------------
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '07', 'Produção', NULL)

	-- Manter consistencia com VA_XLS4 e BatPrDia do Protheus
	declare @litros_produzidos_op float
	declare @litros_envasados_op  float
	select @litros_produzidos_op = sum (case when B1_GRPEMB = '18' then D3_QUANT else 0 end)
		,  @litros_envasados_op  = sum (case when B1_TIPO in ('PI', 'PA') then D3_QUANT * B1_LITROS else 0 end)
			from protheus.dbo.SD3010 SD3
				,protheus.dbo.SB1010 SB1
			where SD3.D_E_L_E_T_ = ''
			and D3_EMISSAO between @in_ano + @in_mes + '01' AND @in_ano + @in_mes + '31'
			and D3_ESTORNO != 'S'
			and D3_CF like 'PR%'
			and SB1.D_E_L_E_T_ = ''
			and B1_FILIAL = '  '
			and B1_COD = D3_COD
			-- Somente OPs que consomem uva (mas, mesmo assim, ainda nao bate com rel.orig.da Sara)
			and exists (select * from protheus.dbo.SD3010 REQ
						-- Nao sei por que motivo o otimizador do SQL decidiu usar o indice 6,
						-- passando de 1 para 44 segundos o tempo desta query. Vou obrigar o
						-- uso do indice 1 ateh descobrir se talvez tenho estatisticas desatualizadas,
						-- sei lah. Robert, 13/10/2023.
						WITH (INDEX (SD30101))
						WHERE REQ.D_E_L_E_T_ = ''
						AND REQ.D3_FILIAL = SD3.D3_FILIAL
						AND REQ.D3_OP = SD3.D3_OP
						AND REQ.D3_ESTORNO != 'S'
						AND REQ.D3_CF LIKE 'RE%'
						AND REQ.D3_GRUPO = '0400')

	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '07.01', 'Litros Produzidos em OP', @litros_produzidos_op)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '07.02', 'Litros Envasados em OP', @litros_envasados_op)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '07.03', '% Envase /Litros totais', @litros_envasados_op * 100 / @litros_produzidos_op)

	insert into indices_econ_financ (ano, mes, indice, descricao, valor)
	values (@in_ano, @in_mes, '07.04', 'GGF R$'
		, (select sum (valor)
			from #saldos
			where  conta like '701010301%'
				or conta like '701010101%')
		)

	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '07.05', 'GGF/Litro produzido'
		, (select valor from indices_econ_financ where ano = @in_ano and mes = @in_mes and indice = '07.04')
		/ isnull ((select valor from indices_econ_financ where ano = @in_ano and mes = @in_mes and indice = '07.01'), 1)
		)

	insert into indices_econ_financ (ano, mes, indice, descricao, valor)
	values (@in_ano, @in_mes, '07.06', 'Depreciação'
		, (select sum (valor * case when conta in ('403010101002', '403010102004') then -1 else 1 end)
			from #saldos
			where  conta like '403010201039%'
				or conta like '403010201040%'
				or conta like '701010301014%'
				or conta like '701010301015%')
		)


	insert into indices_econ_financ (ano, mes, indice, descricao, valor)
	values (@in_ano, @in_mes, '07.07', 'Manutenção'
		, (select sum (valor)
			from #saldos
			where  conta like '701010301010%'
				or conta like '701010301011%')
		)
		
	
	-------------------------------------------------------------------------
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '08', 'Estoque - litros', NULL)

	-- Busca dados de estoque no ultimo dia do periodo
	-- Manter consistencia com a consulta wpnestoquelitros do NaWeb
	declare @estq_litros_granel   float;
	declare @estq_litros_envasado float;
	declare @estq_litros_total    float;
	declare @custo_estq_envasado  float;
	SELECT @estq_litros_granel  = sum (ESTQ_LITROS_GRANEL)
		, @estq_litros_envasado = sum (ESTQ_LITROS_ENVASADO)
		, @estq_litros_total    = sum (ESTQ_LITROS_TOTAL)
		, @custo_estq_envasado  = sum (CUSTO_MEDIO_ENVASADO)
	FROM protheus.[dbo].[VA_FESTOQUES_LITROS] (format (eomonth (@in_ano + @in_mes + '01'), 'yyyyMMdd'), '', 'zz')
	
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '08.01', 'Total em Litros', @estq_litros_total)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '08.02', 'Granel', @estq_litros_granel)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '08.03', 'Valor estoque pronto - Litros', @custo_estq_envasado)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '08.04', 'Custo médio R$ / Litro', @custo_estq_envasado / @estq_litros_envasado)

	-------------------------------------------------------------------------
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '09', 'Faturamento', NULL)

	-- Busca dados de faturamento no mes.
	-- Manter consistencia com 'exporta dados' e PowerBI
	declare @fat_litros_vendidos_total  float;
	declare @fat_litros_vendidos_granel float;
	declare @fat_litros_bonificados     float;
	declare @fat_valor_faturado         float;
	declare @fat_indl_litros            float;
	declare @fat_indl_valor_faturado    float;
	select @fat_litros_vendidos_total  = sum (case when F4_MARGEM = '1' then QTLITROS else 0 end)
		,  @fat_litros_vendidos_granel = sum (case when F4_MARGEM = '1' and GRPEMB = '18' then QTLITROS else 0 end)
		,  @fat_litros_bonificados     = sum (case when F4_MARGEM = '3' then QTLITROS else 0 end)
		,  @fat_valor_faturado         = sum (case when F4_MARGEM = '1' then VALBRUT else 0 end)
		,  @fat_indl_litros            = sum (case when F4_MARGEM = '1' and CODLINHA = '21' then QTLITROS else 0 end)
		,  @fat_indl_valor_faturado    = sum (case when F4_MARGEM = '1' and CODLINHA = '21' then VALBRUT else 0 end)
	from VA_FATDADOS
	where EMPRESA = '01'
	and EMISSAO like @in_ano + @in_mes + '%'

	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '09.01', 'Litros vendidos', @fat_litros_vendidos_total)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '09.02', 'Litros bonificados', @fat_litros_bonificados)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '09.03', 'Litros granel', @fat_litros_vendidos_granel)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '09.04', 'Valor faturado', @fat_valor_faturado)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '09.05', 'Valor médio venda R$ / Litro', @fat_valor_faturado / @fat_litros_vendidos_total)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '09.06', 'Industrialização LITROS', @fat_indl_litros)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '09.07', 'Faturamento Industrialização', @fat_indl_valor_faturado)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '09.08', 'Valor médio ind R$ / Litro'
		, case when @fat_indl_litros > 0
			then @fat_indl_valor_faturado / @fat_indl_litros
			else 0
			end)

	-------------------------------------------------------------------------
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '10', 'Despesas s/faturamento líquido', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '10.01', 'Comerciais', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '10.02', 'Administrativas', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '10.03', 'Tributárias', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '10.04', 'Financeiras', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '10.05', 'Gastos Gerais Fabricação', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '10.06', 'CPV', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '10.07', 'Folha Total', NULL)
	insert into indices_econ_financ (ano, mes, indice, descricao, valor) values (@in_ano, @in_mes, '10.08', 'Faturamento Líq. p/ Funcionário', NULL)

end


