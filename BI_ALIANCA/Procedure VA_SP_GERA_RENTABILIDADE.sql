SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
-- Descricao: Gera tabela VA_RENTABILIDADE. A tabela eh usada em diversas consultas comerciais (GLPI 12377)
--            Criada com base no programa BATMARGEM.PRW (Protheus) de Claudia Lionco.
-- Autor....: Robert Koch
-- Data.....: 15/08/2022
--
-- Historico de alteracoes:
--

-- INFORMAR NUMERO DE DIAS RETROATIVOS PARA GERACAO DA TABELA.
-- DEFAULT 60 DIAS RETROATIVOS PARA GERAR A NOITE
-- AGENDAMENTOS INCREMENTAIs DURANTE O DIA SUGESTAO DEIXAR 0 (ZERO)
ALTER PROCEDURE [dbo].[VA_SP_GERA_RENTABILIDADE]
(
	@DIAS_RETROATIVOS INT
) AS
BEGIN
	DECLARE @MAIOR_DATA_TABELA VARCHAR (8);
	DECLARE @DATAINI           VARCHAR (8);

	-- NAO VEJO NECESSIDADE DE FICAR COM ESTE PROCESSO PARADO ALGUARDANDO
	-- FINALIZAR ALGUMA TRANSACAO, ATEH MESMO POR QUE O PROPRIO PROTHEUS
	-- TRABALHA USANDO 'READ UNCOMMITED'.
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- SE RECEBER ZERO DIAS, BUSCA DESDE A ULTIMA DATA ENCONTRADA NA TABELA ATEH 
	-- HOJE (DIGAMOS QUE TENHA FICADO PARADO POR 1 OU 2 DIAS POR ALGUM MOTIVO)
	-- ASSIM PRETENDE-SE NUNCA FICAR COM LACUNA NOS DADOS.
	IF (@DIAS_RETROATIVOS = 0)
	BEGIN
		PRINT 'PARAMETRO DE DIAS ZERADO. VOU BUSCAR ULTIMA DATA EXISTENTE NA TABELA'
		SET @MAIOR_DATA_TABELA = (SELECT MAX (EMISSAO)
									FROM BI_ALIANCA.dbo.VA_RENTABILIDADE)

		IF (@MAIOR_DATA_TABELA IS NULL)
		BEGIN
			PRINT 'MAIOR DATA DA TABELA RETORNOU NULL. ASSUMINDO A DATA DE HOJE.'
			SET @DATAINI = FORMAT (CURRENT_TIMESTAMP, 'yyyyMMdd')
		END
		ELSE
		BEGIN
			PRINT 'ASSUMINDO INICIO COMO A MAIOR DATA DA TABELA'
			SET @DATAINI = @MAIOR_DATA_TABELA
		END
	END
	ELSE
	BEGIN
		PRINT 'CALCULANDO DATA DE INICIO CFE. PARAMETRO DE DIAS RETROATIVOS'
		SET @DATAINI = FORMAT (DATEADD (DAY, -1 * @DIAS_RETROATIVOS, CURRENT_TIMESTAMP), 'yyyyMMdd')
	END

	IF (@DATAINI IS NOT NULL AND @DATAINI != '')
	BEGIN
		PRINT 'DATA DE INICIO: ' + @DATAINI
		
		-- ELIMINA OS REGISTROS A PARTIR DESTA DATA E GERA NOVAMENTE.
		DELETE BI_ALIANCA.dbo.VA_RENTABILIDADE
			WHERE EMISSAO >= @DATAINI
	
		-- Insere dados de diversas origens, usando UNIONs.
		INSERT INTO BI_ALIANCA.dbo.VA_RENTABILIDADE (
			TIPO                -- 1
			,FILIAL             -- 2
			,CLIENTE            -- 3
			,LOJA               -- 4
			, C_BASE            -- 5
			, L_BASE            -- 6
			, NOTA              -- 7
			, SERIE             -- 8
			, EMISSAO           -- 9
			, ESTADO            -- 10
			, VENDEDOR          -- 11
			, LINHA             -- 12
			, PRODUTO           -- 13
			, CUSTO_PREV        -- 14
			, CUSTO_REAL        -- 15
			, NF_QUANT          -- 16
			, NF_VLRUNIT        -- 17
			, NF_VLRPROD        -- 18
			, NF_VALIPI         -- 19
			, NF_ICMSRET        -- 20
			, NF_VLR_BRT        -- 21
			, NF_ICMS           -- 22
			, NF_COFINS         -- 23
			, NF_PIS            -- 24
			, VLR_COMIS_PREV    -- 25
			, VLR_COMIS_REAL    -- 26
			, TOTPROD_NF        -- 27
			, FRETE_PREVISTO    -- 28
			, FRETE_REALIZADO   -- 29
			, RAPEL_PREVISTO    -- 30
			, RAPEL_REALIZADO   -- 31
			, SUPER             -- 32
			, VERBAS_UTIL       -- 33
			, VERBAS_LIB        -- 34
			, CODMUN            -- 35
			, PROMOTOR          -- 36
			, NF_LITROS         -- 37
			, NF_QTCAIXAS)      -- 38

		-- Notas de 'faturamento': baseia-se no campo F4_MARGEM para gerar o 'tipo de registro'
		SELECT
			SF4.F4_MARGEM AS TIPO                                      -- 1
			,SD2.D2_FILIAL AS FILIAL                                   -- 2
			,SD2.D2_CLIENTE AS CLIENTE                                 -- 3
			,SD2.D2_LOJA AS LOJA                                       -- 4
			,SA1.A1_VACBASE AS C_BASE                                  -- 5
			,SA1.A1_VALBASE AS L_BASE                                  -- 6
			,SD2.D2_DOC AS NOTA                                        -- 7
			,SD2.D2_SERIE AS SERIE                                     -- 8
			,SD2.D2_EMISSAO AS EMISSAO                                 -- 9
			,SD2.D2_EST AS ESTADO                                      -- 10
			,SF2.F2_VEND1 AS VENDEDOR                                  -- 11
			,SB1.B1_CODLIN AS LINHA                                    -- 12
			,SD2.D2_COD AS PRODUTO                                     -- 13
			,SUM(ROUND(D2_VACUSTD * SD2.D2_QUANT, 2)) AS CUSTO_PREV    -- 14
			,SUM(ROUND(D2_CUSTO1, 2)) AS CUSTO_REAL                    -- 15
			,SUM(SD2.D2_QUANT) AS NF_QUANT                             -- 16
			,SUM(SD2.D2_PRUNIT) AS NF_VLRUNIT                          -- 17
			,SUM(SD2.D2_PRCVEN * D2_QUANT) AS NF_VLRPROD               -- 18
			,SUM(SD2.D2_VALIPI) AS NF_VALIPI                           -- 19
			,SUM(SD2.D2_ICMSRET) AS NF_ICMSRET                         -- 20
			,SUM(SD2.D2_VALBRUT) AS NF_VLR_BRT                         -- 21
			,CASE SF4.F4_MARGEM
					WHEN '1' THEN SUM(SD2.D2_VALICM)
				END AS NF_ICMS                                         -- 22
			,SUM(SD2.D2_VALIMP5) AS NF_COFINS                          -- 23
			,SUM(SD2.D2_VALIMP6) AS NF_PIS                             -- 24
			,SUM(SD2.D2_TOTAL * SD2.D2_COMIS1 / 100) AS VLR_COMIS_PREV -- 25
			,ISNULL(((SELECT
						SUM(SE3.E3_COMIS)
					FROM protheus.dbo.SE3010 SE3
					WHERE SE3.D_E_L_E_T_ = ''
					AND SE3.E3_FILIAL = SD2.D2_FILIAL
					AND SE3.E3_NUM = SD2.D2_DOC
					AND SE3.E3_EMISSAO >= SD2.D2_EMISSAO
					AND SE3.E3_CODCLI = SD2.D2_CLIENTE)
				* SD2.D2_TOTAL / SF2.F2_VALMERC), '0') AS VLR_COMIS_REAL  -- 26
			,SF2.F2_VALMERC AS TOTPROD_NF                                 -- 27
			,ISNULL(CASE SF2.F2_PBRUTO
					WHEN 0 THEN 0
					ELSE ROUND(SC5.C5_MVFRE * (SB1.B1_PESBRU * SD2.D2_QUANT) / SF2.F2_PBRUTO, 2)
				END, 0) AS FRETE_PREVISTO                                 -- 28
			,ISNULL((SELECT
						SUM(SZH.ZH_RATEIO)
					FROM protheus.dbo.SZH010 SZH
					WHERE SZH.D_E_L_E_T_ = ''
					AND SZH.ZH_FILIAL = SD2.D2_FILIAL
					AND SZH.ZH_TPFRE = 'S'
					AND SZH.ZH_NFSAIDA = SD2.D2_DOC
					AND SZH.ZH_SERNFS = SD2.D2_SERIE
					AND SZH.ZH_ITNFS = SD2.D2_ITEM)
				, '0') AS FRETE_REALIZADO                                 -- 29
			,SUM(ROUND(SD2.D2_VRAPEL, 2)) AS RAPEL_PREVISTO               -- 30
			,ISNULL(((SELECT
						SUM(SE5.E5_VARAPEL)
					FROM protheus.dbo.SE5010 SE5
					WHERE SE5.D_E_L_E_T_ = ''
					AND SE5.E5_FILIAL = SD2.D2_FILIAL
					AND SE5.E5_NUMERO = SD2.D2_DOC
					AND SE5.E5_DATA >= SD2.D2_EMISSAO
					AND SE5.E5_RECPAG = 'R'
					AND SE5.E5_CLIENTE = SD2.D2_CLIENTE
					AND SE5.E5_LOJA = SD2.D2_LOJA
					AND SE5.E5_TIPODOC = 'DC'
					AND SE5.E5_SITUACA = ''
					AND SE5.E5_VARAPEL > 0)
				* SD2.D2_TOTAL / SF2.F2_VALMERC), '') AS RAPEL_REALIZADO  -- 31
			,SA3.A3_VAGEREN AS SUPER                                      -- 32
			,0 AS VERBAS_UTIL                                             -- 33
			,0 AS VERBAS_LIB                                              -- 34
			,SA1.A1_COD_MUN AS CODMUN                                     -- 35
			,SA1.A1_VAPROMO AS PROMOTOR                                   -- 36
			,SUM(CASE
					WHEN SD2.D2_TP IN ('PA', 'PI', 'VD') THEN SD2.D2_QUANT * SB1.B1_LITROS
					ELSE 0
				END) AS NF_LITROS                                         -- 37
			,protheus.dbo.VA_FQtCx(SD2.D2_COD, SUM(SD2.D2_QUANT)) AS NF_QTCAIXAS   -- 38
		FROM protheus.dbo.SD2010 SD2
		INNER JOIN protheus.dbo.SF2010 SF2
			ON (SF2.D_E_L_E_T_ = ''
			AND SF2.F2_FILIAL = SD2.D2_FILIAL
			AND SF2.F2_DOC = SD2.D2_DOC
			AND SF2.F2_SERIE = SD2.D2_SERIE
			AND SF2.F2_CLIENTE = SD2.D2_CLIENTE
			AND SF2.F2_LOJA = SD2.D2_LOJA
			AND SF2.F2_EMISSAO = SD2.D2_EMISSAO)
		INNER JOIN protheus.dbo.SA1010 SA1
			ON (SA1.D_E_L_E_T_ = ''
			AND SA1.A1_COD = SD2.D2_CLIENTE
			AND SA1.A1_LOJA = SD2.D2_LOJA)
		INNER JOIN protheus.dbo.SA3010 SA3
			ON (SA3.D_E_L_E_T_ = ''
			AND SA3.A3_COD = SF2.F2_VEND1)
		INNER JOIN protheus.dbo.SF4010 SF4
			ON (SF4.D_E_L_E_T_ = ''
			AND SF4.F4_MARGEM IN ('1')
			AND SF4.F4_CODIGO = SD2.D2_TES)
		INNER JOIN protheus.dbo.SB1010 SB1
			ON (SB1.D_E_L_E_T_ = ''
			AND SB1.B1_COD = SD2.D2_COD)
		LEFT JOIN protheus.dbo.SC5010 SC5
			ON (SC5.D_E_L_E_T_ = ''
			AND SC5.C5_NUM = SD2.D2_PEDIDO
			AND SC5.C5_FILIAL = SD2.D2_FILIAL)
		WHERE SD2.D_E_L_E_T_ = ''
		AND SD2.D2_EMISSAO >= @DATAINI
		GROUP BY SF4.F4_MARGEM
				,SD2.D2_FILIAL
				,SD2.D2_CLIENTE
				,SA1.A1_VACBASE
				,SA1.A1_VALBASE
				,SD2.D2_DOC
				,SD2.D2_SERIE
				,SD2.D2_EMISSAO
				,SD2.D2_TOTAL
				,SF2.F2_VALMERC
				,SD2.D2_LOJA
				,SD2.D2_EST
				,SF2.F2_VEND1
				,SD2.D2_ITEM
				,SA3.A3_VAGEREN
				,SB1.B1_CODLIN
				,SD2.D2_COD
				,SF2.F2_PBRUTO
				,SC5.C5_MVFRE
				,SB1.B1_PESBRU
				,SD2.D2_QUANT
				,SF2.F2_PBRUTO
				,SA1.A1_COD_MUN
				,SA1.A1_VAPROMO
				,SD2.D2_TP

		UNION ALL 

		-- Notas de 'devolucao': baseia-se no campo F4_MARGEM para gerar o 'tipo de registro'
		SELECT
			SF4.F4_MARGEM AS TIPO                                                        -- 1
			,SD1.D1_FILIAL AS FILIAL                                                     -- 2
			,SD1.D1_FORNECE AS CLIENTE                                                   -- 3
			,SD1.D1_LOJA AS LOJA                                                         -- 4
			,SA1.A1_VACBASE AS C_BASE                                                    -- 5
			,SA1.A1_VALBASE AS L_BASE                                                    -- 6
			,SD1.D1_DOC AS NOTA                                                          -- 7
			,SD1.D1_SERIE AS SERIE                                                       -- 8
			,SD1.D1_DTDIGIT AS DIGITACAO                                                 -- 9
			,SF1.F1_EST AS ESTADO                                                        -- 10
			,SE1.E1_VEND1 AS VENDEDOR                                                    -- 11
			,SB1.B1_CODLIN AS LINHA                                                      -- 12
			,SD1.D1_COD AS PRODUTO                                                       -- 13
			,ISNULL(SUM(ROUND(SD2.D2_VACUSTD * SD1.D1_QUANT, 2)) * -1, 0) AS CUSTO_PREV  -- 14
			,ISNULL(SUM(ROUND(SD1.D1_CUSTO, 2)) * -1, 0) AS CUSTO_REAL                   -- 15
			,SUM(SD1.D1_QUANT) * -1 AS NF_QUANT                                          -- 16
			,ISNULL(SUM(SD1.D1_VUNIT) * -1, 0) AS NF_VLRUNIT                             -- 17
			,ISNULL(SUM(SD1.D1_VUNIT * D1_QUANT) * -1, 0) AS NF_VLRPROD                  -- 18
			,SUM(SD1.D1_VALIPI) * -1 AS NF_VALIPI                                        -- 19
			,SUM(SD1.D1_ICMSRET) * -1 AS NF_ICMSRET                                      -- 20
			,SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_ICMSRET) * -1 AS NF_VLR_BRT       -- 21
			,CASE SF4.F4_MARGEM
					WHEN '2' THEN SUM(SD1.D1_VALICM) * -1
				END AS NF_ICMS                                                           -- 22
			,SUM(SD1.D1_VALIMP5) * -1 AS NF_COFINS                                       -- 23
			,SUM(SD1.D1_VALIMP6) * -1 AS NF_PIS                                          -- 24
			,SUM((SD2.D2_TOTAL * SD2.D2_COMIS1 / 100) * SD1.D1_QUANT / SD2.D2_QUANT) * -1 AS VLR_COMIS_PREV  -- 25
			,0 AS VLR_COMIS_REAL                                                         -- 26
			,SD1.D1_TOTAL * -1 AS TOTPROD_NF                                             -- 27
			,0 AS FRETE_PREVISTO                                                         -- 28
			,ISNULL(SUM(SZH.ZH_RATEIO), 0) AS FRETE_REALIZADO                            -- 29
			,ISNULL(SUM(SD2.D2_VRAPEL * SD1.D1_QUANT / SD2.D2_QUANT) * -1, 0) AS RAPEL_PREVISTO  --30
			,0 AS RAPEL_REALIZADO                                                        -- 31
			,SA3.A3_VAGEREN AS SUPER                                                     -- 32
			,0 AS VERBAS_UTIL                                                            -- 33
			,0 AS VERBAS_LIB                                                             -- 34
			,SA1.A1_COD_MUN AS CODMUN                                                    -- 35
			,SA1.A1_VAPROMO AS PROMOTOR                                                  -- 36
			,SUM(CASE
					WHEN SD1.D1_TP IN ('PA', 'PI', 'VD') THEN SD1.D1_QUANT * SB1.B1_LITROS
					ELSE 0
				END) AS NF_LITROS                                                        -- 37
			,protheus.dbo.VA_FQtCx(SD1.D1_COD, SUM(SD1.D1_QUANT)) AS NF_QTCAIXAS                  -- 38
			FROM protheus.dbo.SD1010 SD1
			INNER JOIN protheus.dbo.SF1010 SF1
				ON (SF1.D_E_L_E_T_ = ''
				AND SF1.F1_FILIAL = SD1.D1_FILIAL
				AND SF1.F1_DOC = SD1.D1_DOC
				AND SF1.F1_SERIE = SD1.D1_SERIE
				AND SF1.F1_FORNECE = SD1.D1_FORNECE
				AND SF1.F1_LOJA = SD1.D1_LOJA
				AND SF1.F1_EMISSAO = SD1.D1_EMISSAO)
			INNER JOIN protheus.dbo.SF4010 SF4
				ON (SF4.D_E_L_E_T_ = ''
				AND SF4.F4_CODIGO = SD1.D1_TES
				AND SF4.F4_MARGEM = '2')
			INNER JOIN protheus.dbo.SB1010 SB1
				ON (SB1.D_E_L_E_T_ = ''
				AND SB1.B1_COD = SD1.D1_COD)
			LEFT JOIN protheus.dbo.SF2010 SF2
				ON (SF2.F2_DOC = SD1.D1_NFORI
				AND SF2.F2_SERIE = SD1.D1_SERIORI
				AND SF2.D_E_L_E_T_ <> '*'
				AND SF2.F2_FILIAL = SD1.D1_FILIAL)
			LEFT JOIN protheus.dbo.SA1010 SA1
				ON (SA1.D_E_L_E_T_ = ''
				AND SA1.A1_COD = SD1.D1_FORNECE
				AND SA1.A1_LOJA = SD1.D1_LOJA)
			LEFT JOIN protheus.dbo.SD2010 SD2
				ON (SD2.D2_DOC = SD1.D1_NFORI
				AND SD2.D2_SERIE = SD1.D1_SERIORI
				AND SD2.D2_ITEM = SD1.D1_ITEMORI
				AND SD2.D_E_L_E_T_ <> '*'
				AND SD2.D2_FILIAL = SD1.D1_FILIAL)
			LEFT JOIN protheus.dbo.SE1010 SE1
				ON (SE1.D_E_L_E_T_ = ''
				AND SE1.E1_FILIAL = SD1.D1_FILIAL
				AND SE1.E1_NUM = SD1.D1_DOC
				AND SE1.E1_PREFIXO = SD1.D1_SERIE
				AND SE1.E1_CLIENTE = SD1.D1_FORNECE
				AND SE1.E1_LOJA = SD1.D1_LOJA)
			INNER JOIN protheus.dbo.SA3010 SA3
				ON (SA3.D_E_L_E_T_ = ''
				AND SA3.A3_COD = SE1.E1_VEND1)
			LEFT JOIN protheus.dbo.SZH010 SZH
				ON (SZH.D_E_L_E_T_ = ''
				AND SZH.ZH_FILIAL = SD1.D1_FILIAL
				AND SZH.ZH_TPFRE = 'E'
				AND SZH.ZH_NFENTR = SD1.D1_DOC
				AND SZH.ZH_SRNFENT = SD1.D1_SERIE
				AND SZH.ZH_FORNECE = SD1.D1_FORNECE
				AND SZH.ZH_LOJA = SD1.D1_LOJA
				AND SZH.ZH_ITNFE = SUBSTRING(SD1.D1_ITEM, 3, 2))
			WHERE SD1.D_E_L_E_T_ = ''
			AND SD1.D1_EMISSAO >= @DATAINI
			GROUP BY SF4.F4_MARGEM
					,SD1.D1_FILIAL
					,SD1.D1_FORNECE
					,SA1.A1_VACBASE
					,SA1.A1_VALBASE
					,SD1.D1_COD
					,SD1.D1_SERIE
					,SD1.D1_DTDIGIT
					,SD1.D1_LOJA
					,SF1.F1_EST
					,SA3.A3_VAGEREN
					,SE1.E1_VEND1
					,SB1.B1_CODLIN
					,SD1.D1_COD
					,SD1.D1_TOTAL
					,SD1.D1_DOC
					,SD1.D1_FORNECE
					,SD1.D1_LOJA
					,SA1.A1_COD_MUN
					,SA1.A1_VAPROMO
					,SD1.D1_TP

		UNION ALL

		-- Notas de 'bonificacao': baseia-se no campo F4_MARGEM para gerar o 'tipo de registro'
		SELECT
			SF4.F4_MARGEM AS TIPO                                    -- 1
			,SD2.D2_FILIAL AS FILIAL                                 -- 2
			,SD2.D2_CLIENTE AS CLIENTE                               -- 3
			,SD2.D2_LOJA AS LOJA                                     -- 4
			,SA1.A1_VACBASE AS C_BASE                                -- 5
			,SA1.A1_VALBASE AS L_BASE                                -- 6
			,SD2.D2_DOC AS NOTA                                      -- 7
			,SD2.D2_SERIE AS SERIE                                   -- 8
			,SD2.D2_EMISSAO AS DIGITACAO                             -- 9
			,SD2.D2_EST AS ESTADO                                    -- 10
			,SF2.F2_VEND1 AS VENDEDOR                                -- 11
			,SB1.B1_CODLIN AS LINHA                                  -- 12
			,SD2.D2_COD AS PRODUTO                                   -- 13
			,SUM(ROUND(D2_VACUSTD * SD2.D2_QUANT, 2)) AS CUSTO_PREV  -- 14
			,SUM(ROUND(D2_CUSTO1, 2)) AS CUSTO_REAL                  -- 15
			,SUM(SD2.D2_QUANT) AS NF_QUANT                           -- 16
			,SUM(SD2.D2_PRUNIT) AS NF_VLRUNIT                        -- 17
			,SUM(SD2.D2_PRCVEN * D2_QUANT) AS NF_VLRPROD             -- 18
			,SUM(SD2.D2_VALIPI) AS NF_VALIPI                         -- 19
			,SUM(SD2.D2_ICMSRET) AS NF_ICMSRET                       -- 20
			,SUM(SD2.D2_VALBRUT) AS NF_VLR_BRT                       -- 21
			,SUM(SD2.D2_VALICM) AS NF_ICMS                           -- 22
			,SUM(SD2.D2_VALIMP5) AS NF_COFINS                        -- 23
			,SUM(SD2.D2_VALIMP6) AS NF_PIS                           -- 24
			,0 AS VLR_COMIS_PREV                                     -- 25
			,0 AS VLR_COMIS_REAL                                     -- 26
			,SF2.F2_VALMERC AS TOTPROD_NF                            -- 27
			,ISNULL(CASE SF2.F2_PBRUTO
					WHEN 0 THEN 0
					ELSE ROUND(SC5.C5_MVFRE * (SB1.B1_PESBRU * SD2.D2_QUANT) / SF2.F2_PBRUTO, 2)
				END, 0) AS FRETE_PREVISTO                            -- 28
			,(SELECT
						SUM(SZH.ZH_RATEIO)
					FROM protheus.dbo.SZH010 SZH
					WHERE SZH.D_E_L_E_T_ = ''
					AND SZH.ZH_FILIAL = SD2.D2_FILIAL
					AND SZH.ZH_TPFRE = 'S'
					AND SZH.ZH_NFSAIDA = SD2.D2_DOC
					AND SZH.ZH_SERNFS = SD2.D2_SERIE
					AND SZH.ZH_ITNFS = SD2.D2_ITEM)
				AS FRETE_REALIZADO                                       -- 29
			,0 AS RAPEL_PREVISTO                                         -- 30
			,0 AS RAPEL_REALIZADO                                        -- 31
			,SA3.A3_VAGEREN AS SUPER                                     -- 32
			,0 AS VERBAS_UTIL                                            -- 33
			,0 AS VERBAS_LIB                                             -- 34
			,SA1.A1_COD_MUN AS CODMUN                                    -- 35
			,SA1.A1_VAPROMO AS PROMOTOR                                  -- 36
			,SUM(CASE
					WHEN SD2.D2_TP IN ('PA', 'PI', 'VD') THEN SD2.D2_QUANT * SB1.B1_LITROS
					ELSE 0
				END) AS NF_LITROS                                        -- 37
			,protheus.dbo.VA_FQtCx(SD2.D2_COD, SUM(SD2.D2_QUANT)) AS NF_QTCAIXAS  -- 38
			FROM protheus.dbo.SD2010 SD2
			INNER JOIN protheus.dbo.SF2010 SF2
				ON (SF2.D_E_L_E_T_ = ''
				AND SF2.F2_FILIAL = SD2.D2_FILIAL
				AND SF2.F2_DOC = SD2.D2_DOC
				AND SF2.F2_SERIE = SD2.D2_SERIE
				AND SF2.F2_CLIENTE = SD2.D2_CLIENTE
				AND SF2.F2_LOJA = SD2.D2_LOJA
				AND SF2.F2_EMISSAO = SD2.D2_EMISSAO)
			INNER JOIN protheus.dbo.SA1010 SA1
				ON (SA1.D_E_L_E_T_ = ''
				AND SA1.A1_COD = SD2.D2_CLIENTE
				AND SA1.A1_LOJA = SD2.D2_LOJA)
			INNER JOIN protheus.dbo.SA3010 SA3
				ON (SA3.D_E_L_E_T_ = ''
				AND SA3.A3_COD = SF2.F2_VEND1)
			INNER JOIN protheus.dbo.SF4010 SF4
				ON (SF4.D_E_L_E_T_ = ''
				AND SF4.F4_MARGEM IN ('3')
				AND SF4.F4_CODIGO = SD2.D2_TES)
			INNER JOIN protheus.dbo.SB1010 SB1
				ON (SB1.D_E_L_E_T_ = ''
				AND SB1.B1_COD = SD2.D2_COD)
			INNER JOIN protheus.dbo.SC5010 SC5
				ON (SC5.D_E_L_E_T_ = ''
				AND SC5.C5_NUM = SD2.D2_PEDIDO
				AND SC5.C5_FILIAL = SD2.D2_FILIAL)
			WHERE SD2.D_E_L_E_T_ = ''
			AND SD2.D2_EMISSAO >= @DATAINI
			GROUP BY SF4.F4_MARGEM
					,SD2.D2_CLIENTE
					,SD2.D2_LOJA
					,SA1.A1_VACBASE
					,SA1.A1_VALBASE
					,SD2.D2_DOC
					,SD2.D2_SERIE
					,SD2.D2_DTDIGIT
					,SD2.D2_EST
					,SA3.A3_VAGEREN
					,SF2.F2_VEND1
					,SB1.B1_CODLIN
					,SD2.D2_COD
					,SF2.F2_VALMERC
					,SD2.D2_FILIAL
					,SD2.D2_DOC
					,SD2.D2_EMISSAO
					,SD2.D2_TOTAL
					,SD2.D2_SERIE
					,SD2.D2_ITEM
					,SD2.D2_CLIENTE
					,SD2.D2_LOJA
					,SF2.F2_PBRUTO
					,SC5.C5_MVFRE
					,SB1.B1_PESBRU
					,SD2.D2_QUANT
					,SA1.A1_COD_MUN
					,SA1.A1_VAPROMO
					,SD2.D2_TP 

		UNION ALL

		-- Movimentacao de verbas
		SELECT
			'6' AS TIPO                       -- 1
			,ZA5.ZA5_FILIAL AS FILIAL         -- 2
			,ZA5.ZA5_CLI AS CLIENTE           -- 3
			,ZA5.ZA5_LOJA AS LOJA             -- 4
			,SA1.A1_VACBASE AS C_BASE         -- 5
			,SA1.A1_VALBASE AS L_BASE         -- 6
			,ZA5.ZA5_DOC AS NOTA              -- 7
			,ZA5.ZA5_SERIE AS SERIE           -- 8
			,ZA5.ZA5_DTA AS EMISSAO           -- 9
			,SA1.A1_EST AS ESTADO             -- 10
			,ZA5.ZA5_VENVER AS VENDEDOR       -- 11
			,'' AS LINHA                      -- 12
			,'VERBA' AS PRODUTO               -- 13
			,0 AS CUSTO_PREV                  -- 14
			,0 AS CUSTO_REAL                  -- 15
			,0 AS NF_QUANT                    -- 16
			,0 AS NF_VLRUNIT                  -- 17
			,0 AS NF_VLRPROD                  -- 18
			,0 AS NF_VALIPI                   -- 19
			,0 AS NF_ICMSRET                  -- 20
			,0 AS NF_VLR_BRT                  -- 21
			,0 AS NF_ICMS                     -- 22
			,0 AS NF_COFINS                   -- 23
			,0 AS NF_PIS                      -- 24
			,0 AS VLR_COMIS_PREV              -- 25
			,0 AS VLR_COMIS_REAL              -- 26
			,0 AS TOTPROD_NF                  -- 27
			,0 AS FRETE_PREVISTO              -- 28
			,0 AS FRETE_REALIZADO             -- 29
			,0 AS RAPEL_PREVISTO              -- 30
			,0 AS RAPEL_REALIZADO             -- 31
			,SA3T.A3_VAGEREN AS SUPER         -- 32
			,SUM(ZA5.ZA5_VLR) AS VERBAS_UTIL  -- 33
			,0 AS VERBAS_LIB                  -- 34
			,SA1.A1_COD_MUN AS CODMUN         -- 35
			,SA1.A1_VAPROMO AS PROMOTOR       -- 36
			,0 AS NF_LITROS                   -- 37
			,0 AS NF_QTCAIXAS                 -- 38
			FROM protheus.dbo.ZA5010 ZA5
			INNER JOIN protheus.dbo.SA1010 SA1
				ON (SA1.D_E_L_E_T_ = ''
				AND SA1.A1_COD = ZA5.ZA5_CLI
				AND SA1.A1_LOJA = ZA5.ZA5_LOJA)
			LEFT JOIN protheus.dbo.SF2010 SF2
				ON (SF2.D_E_L_E_T_ = ''
				AND SF2.F2_DOC = ZA5.ZA5_DOC
				AND SF2.F2_SERIE = '10'
				AND SF2.F2_CLIENTE = ZA5.ZA5_CLI
				AND SF2.F2_LOJA = ZA5.ZA5_LOJA)
			LEFT JOIN protheus.dbo.SE1010 SE1
				ON (SE1.D_E_L_E_T_ = ''
				AND SE1.E1_NUM = ZA5.ZA5_DOC
				AND SE1.E1_CLIENTE = ZA5.ZA5_CLI
				AND SE1.E1_PARCELA = ZA5.ZA5_PARC
				AND SE1.E1_LOJA = ZA5.ZA5_LOJA)
			LEFT JOIN protheus.dbo.SA3010 SA3T
				ON (SA3T.D_E_L_E_T_ = ''
				AND SA3T.A3_COD = ZA5.ZA5_VENVER)
			WHERE ZA5.D_E_L_E_T_ = ''
			AND ZA5.ZA5_DTA >= @DATAINI
			AND ZA5.ZA5_TLIB NOT IN ('1', '9')
			GROUP BY ZA5.ZA5_CLI
					,ZA5.ZA5_FILIAL
					,ZA5.ZA5_DOC
					,SA1.A1_VACBASE
					,SA1.A1_VALBASE
					,ZA5.ZA5_SERIE
					,ZA5.ZA5_DTA
					,ZA5.ZA5_LOJA
					,SA1.A1_EST
					,SA3T.A3_VAGEREN
					,SE1.E1_VEND1
					,SA1.A1_VEND
					,ZA5.ZA5_VENVER
					,SA1.A1_COD_MUN
					,SA1.A1_VAPROMO

		UNION ALL

		SELECT
			'A' AS TIPO                          -- 1
			,ZA4.ZA4_FILIAL AS FILIAL            -- 2
			,ZA4.ZA4_CLI AS CLIENTE              -- 3
			,ZA4.ZA4_LOJA AS LOJA                -- 4
			,SA1.A1_VACBASE AS C_BASE            -- 5
			,SA1.A1_VALBASE AS L_BASE            -- 6
			,'' AS NOTA                          -- 7
			,'' AS SERIE                         -- 8
			,ZA4.ZA4_DLIB AS EMISSAO             -- 9
			,SA1.A1_EST AS ESTADO                -- 10
			,ZA4_VEND AS VENDEDOR                -- 11
			,'' AS LINHA                         -- 12
			,'VERBA_LIB' AS PRODUTO              -- 13
			,0 AS CUSTO_PREV                     -- 14
			,0 AS CUSTO_REAL                     -- 15
			,0 AS NF_QUANT                       -- 16
			,0 AS NF_VLRUNIT                     -- 17
			,0 AS NF_VLRPROD                     -- 18
			,0 AS NF_VALIPI                      -- 19
			,0 AS NF_ICMSRET                     -- 20
			,0 AS NF_VLR_BRT                     -- 21
			,0 AS NF_ICMS                        -- 22
			,0 AS NF_COFINS                      -- 23
			,0 AS NF_PIS                         -- 24
			,0 AS VLR_COMIS_PREV                 -- 25
			,0 AS VLR_COMIS_REAL                 -- 26
			,0 AS TOTPROD_NF                     -- 27
			,0 AS FRETE_PREVISTO                 -- 28
			,0 AS FRETE_REALIZADO                -- 29
			,0 AS RAPEL_PREVISTO                 -- 30
			,0 AS RAPEL_REALIZADO                -- 31
			,SA3.A3_VAGEREN AS SUPER             -- 32
			,0 AS VERBAS_UTIL                    -- 33
			,SUM(ZA4.ZA4_VLR) AS VERBAS_LIB      -- 34
			,SA1.A1_COD_MUN AS CODMUN            -- 35
			,SA1.A1_VAPROMO AS PROMOTOR          -- 36
			,0 AS NF_LITROS                      -- 37
			,0 AS NF_QTCAIXAS                    -- 38
			FROM protheus.dbo.ZA4010 ZA4
			INNER JOIN protheus.dbo.SA1010 SA1
				ON (SA1.D_E_L_E_T_ = ''
				AND SA1.A1_COD = ZA4.ZA4_CLI
				AND SA1.A1_LOJA = ZA4.ZA4_LOJA)
			INNER JOIN protheus.dbo.SA3010 SA3
				ON (SA3.D_E_L_E_T_ = ''
				AND SA3.A3_COD = SA1.A1_VEND)
			WHERE ZA4.D_E_L_E_T_ = ''
			AND ZA4.ZA4_TLIB != '1'
			AND ZA4.ZA4_DGER >= @DATAINI
			GROUP BY ZA4.ZA4_FILIAL
					,ZA4.ZA4_CLI
					,ZA4.ZA4_LOJA
					,ZA4.ZA4_DLIB
					,SA1.A1_VACBASE
					,SA1.A1_VALBASE
					,SA1.A1_EST
					,SA1.A1_VEND
					,SA3.A3_VAGEREN
					,ZA4_VEND
					,SA1.A1_COD_MUN
					,SA1.A1_VAPROMO

	END
	ELSE
	BEGIN
		PRINT 'DATA DE INICIO NAO DEFINIDA!'
	END

END
GO
