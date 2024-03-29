---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   18/102012   TIAGO PRADELLA  COLOCADA CONDICAO DE 'OR' PARA TRAZER TODAS OPERACOES DE VENDA
-- 1.0003   25/10/2012  TIAGO PRADELLA  INCLUIDO CAMPOS DE RESTICAO
-- 1.0004   06/02/2013  tiago pradella  incluido campo de ordem venda
-- 1.0005   22/04/2013  TIAGO           condicoes para pegar operacoes por referencia
-- 1.0006   06/06/2013  tiago           ajustado sub que busca condicoes de referencia
-- 1.0007   03/09/2013  tiago           incluido novos campo DB_TBOPS_EXIMOTTRO, DB_TBOPS_EXIMOTTRO, DB_TBOPS_CONJIR
-- 1.0008   08/08/2014  tiago           traz operacoes do usuario quando nao esta informada no campo DB_TBOPSR_Operacao e eh valida pra ele
-- 1.0009   14/08/2014  tiago           incluido campo tipo calculo ipi
-- 1.0010   20/11/2014  tiago           incluido campo de brinde
-- 1.0011   13/04/2015  tiago           alterado where das operacoes de referencia
-- 1.0012   11/08/2015  tiago           incluido campo remessa
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_OPERACOESVENDA AS
with TEMP_GRUPO_OPERACAO as (select distinct CODIGO_GRUPO, OPERACAO
                                from (
										  select CODIGO_GRUPO AS CODIGO_GRUPO, VALOR_STRING AS OPERACAO
											  FROM DB_FILTRO_GRUPOUSU FILTRO
											  WHERE  FILTRO.ID_FILTRO = 'OPERACAO'  
										  union all 
										  select GRUPO_USU.CODIGO AS CODIGO_GRUPO, OPERS.DB_TBOPS_COD AS OPERACAO
											 from DB_GRUPO_USUARIOS GRUPO_USU, DB_TB_OPERS OPERS
											 where (OPERS.DB_TBOPS_SITUACAO = 'A' 
												     and not exists(select 1 from DB_FILTRO_GRUPOUSU FILTRO 
																	   where FILTRO.CODIGO_GRUPO = GRUPO_USU.CODIGO
																		  AND FILTRO.ID_FILTRO = 'OPERACAO'  ))
											    OR (exists(select 1  from DB_TB_OPERS_REFER 
																		  where DB_TBOPSR_OPER_REF = OPERS.DB_TBOPS_COD
								                                            and (DB_TBOPSR_Operacao = '0' 
																				  Or isnull(DB_TBOPSR_Operacao, '') = ''
																				  Or exists(select 1 FROM DB_FILTRO_GRUPOUSU FILTRO
											                                                     WHERE FILTRO.CODIGO_GRUPO =  GRUPO_USU.CODIGO
																								   and FILTRO.ID_FILTRO = 'OPERACAO'   
																								   and FILTRO.VALOR_STRING  = DB_TBOPSR_Operacao)
																				  or exists(select 1 from DB_TB_OPERS op1 
																				                  where  op1.DB_TBOPS_COD = DB_TBOPSR_Operacao 
																								     and op1.DB_TBOPS_SITUACAO = 'A' 
																									 and not exists(select 1 from DB_FILTRO_GRUPOUSU FILTRO 
																	                                                        where FILTRO.CODIGO_GRUPO = GRUPO_USU.CODIGO
																		                                                      AND FILTRO.ID_FILTRO = 'OPERACAO'  )))))			
									) tab
			)
SELECT OPER.DB_TBOPS_COD          codigo_OPERV,
       OPER.DB_TBOPS_DESCR        descricao_OPERV,
       OPER.DB_TBOPS_BLQPEDIDO    bloquearpedido_OPERV,
       OPER.DB_TBOPS_FAT          tipooperacao_OPERV,
       OPER.DB_TBOPS_MVALBPED     valormaximobonificacao_OPERV,
       OPER.DB_TBOPS_BLOQPEDC     avaliacaocredito_OPERV,
       OPER.DB_TBOPS_CONSUMO      consumo_OPERV,
       OPER.DB_TBOPS_SITUACAO     situacao_OPERV,
       OPER.DB_TBOPS_STRIBUT      calculast_OPERV,
       OPER.DB_TBOPS_TRIB_ICMS    calculaicms_OPERV,
       OPER.DB_TBOPS_ICMSSIPI     incideicmssobreipi_OPERV,
       OPER.DB_TBOPS_TRIB_IPI     calculaipi_OPERV,
       DB_TBOPS_GERAFAT           GERAFATURAMENTO_OPERV,
       DB_TBOPS_VDA_ORD           VENDAORDEM_OPERV,
	   DB_TBOPS_EXIMOTTRO         exigeMotivoTroca_OPERV,
       DB_TBOPS_GIRAMAIS		  giraMais_OPERV,
       DB_TBOPS_CONJIR            conjuntoIrrigacao_OPERV,
	   DB_TBOPS_TP_CALC           tipoCalculoIPI_OPERV,
	   isnull(DB_TBOPS_BRINDE, 0) BRINDE_OPERV,
	   isnull(DB_TBOPS_REMESSAPE, 0)  remessa_OPERV,
	   isnull(DB_TBOPS_GRPPED, '')  GRPPED_OPERV,
       --utilizados para as restricoes
       DB_TBOPS_TP_COND           EXCETOCONDICAO,
       DB_TBOPS_EMPRESAS          EMPRESA,
       DB_TBOPS_TIPO_PED          TIPOPEDIDO,
       DB_TBOPS_COND_PGTO         CONDICAOPAGAMENTO,
       dbo.MERCF_RETORNA_LISTA (0, 'UF', ',', OPER.DB_TBOPS_COD)      UF,
       dbo.MERCF_RETORNA_LISTA (0, 'CIDADE', ',', OPER.DB_TBOPS_COD)  CIDADE,
       DB_TBOPS_RAMOS             RAMOATIVIDADE,
       rtrim(isnull(DB_TBOPS_CLIENTES, ''))  + rtrim(isnull(DB_TBOPS_CLIENTES1, ''))  + 
	   rtrim(isnull(DB_TBOPS_CLIENTES2, ''))  + rtrim(isnull(DB_TBOPS_CLIENTES3, ''))  CLIENTE,
       DB_TBOPS_TIPO_PESS             TIPOPESSOA,
       DB_TBOPS_CONTRIBUINTE_ICMS     CONTRIBUINTEICMS,
       USUARIO
  FROM DB_USUARIO USU,
       TEMP_GRUPO_OPERACAO GRUPO_USU,
       DB_TB_OPERS OPER
  WHERE GRUPO_USU.CODIGO_GRUPO = USU.GRUPO_USUARIO
     and GRUPO_USU.OPERACAO = OPER.DB_TBOPS_COD
