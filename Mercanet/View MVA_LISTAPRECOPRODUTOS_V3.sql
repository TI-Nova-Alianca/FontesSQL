
---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	15/10/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   07/11/2012  TIAGO PRADELLA  INCLUIDO CAMPO DATA DEW ALTERACAO
-- 1.003    20/02/2013  tiago           incluido funcao MERCF_PIECE validando o campo valor_string,
--                                      pegando somente a parte da lista que corresponde ao grupo
-- 1.004    21/02/2013  tiago           condicao para trazer familias que pertencam ao grupo cadastrado para o usuario
-- 1.005    10/06/2013  tiago           incluido campo uf
-- 1..06    08/10/2013  tiago           incluido campo de empresa faturamento
-- 1.007    16/02/2014  tiago           converte para varchar a sequencia
-- 1.008    05/06/2014  tiago           incluido campo preco minimo
-- 1.009    08/06/2015  tiago           valida parametro MOB_SITUACAOPRODUTO, para a situacao do produto
-- 1.010    24/09/2015  tiago           retirado filtro de repres, esta sende realizado na view de produtos
---------------------------------------------------------------------------------------------------

ALTER VIEW MVA_LISTAPRECOPRODUTOS_V3 AS

WITH
SITPROD as (  select substrING(db_prms_valor,1,1)  valor from DB_PARAM_SISTEMA where db_prms_id = 'MOB_SITUACAOPRODUTO'
                union all select substrING(db_prms_valor,3,1)  valor from DB_PARAM_SISTEMA where db_prms_id = 'MOB_SITUACAOPRODUTO'
                union all select substrING(db_prms_valor,5,1)  valor from DB_PARAM_SISTEMA where db_prms_id = 'MOB_SITUACAOPRODUTO')
                
      ,
      LISTAPRECO  AS (SELECT MVA_LISTAPRECO.CODIGO_LIPRE CODIGO, USUARIO
                     FROM MVA_LISTAPRECO
                    WHERE USUARIO in ( select TOP 1 usuario
                                         from DB_USUARIO_SESSIONID
                                        where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID) ) ) 

, USU_SESSION  AS (select TOP 1 usuario
						from DB_USUARIO_SESSIONID
					   where session_id in (select session_id from sys.dm_exec_sessions where session_id = @@SPID))


SELECT DB_PRECOP_CODIGO   LISTAPRECO_LIPRP,
       DB_PRECOP_PRODUTO  PRODUTO_LIPRP,
       DB_PRECOP_VALOR    PRECO_LIPRP,
  	   cast(DB_PRECOP_SEQ as varchar)      SEQUENCIA_LIPRP,
  	   DB_PRECOP_DTVALI   DATAINICIAL_LIPRP,
  	   DB_PRECOP_DTVALF   DATAFINAL_LIPRP,  	   
	   CASE  WHEN isnull(DB_PRECOP_DTALTER, 0) > isnull(DB_PRECOP_ALT_CORP, 0) THEN DB_PRECOP_DTALTER ELSE DB_PRECOP_ALT_CORP END DATAALTER,
	   DB_PRECOP_DESCTO   DESCONTO_LIPRP,
	   DB_PRECOP_ESTADO   UF_LIPRP,
	   DB_PRECOP_EMPFAT   EMPRESAFATURAMENTO_LIPRP,
	   DB_PRECOP_VLRMIN   PRECOMINIMO_LIPRP,
	   isnull(DB_PRECOP_INFCOMIS, 0)	informaComissao_LIPRP,
	   DB_PRECOP_PERCCOMIS			percentualComissao_LIPRP,
	   isnull(DB_PRECOP_DESCMAX, 0) descontoMaximo_LIPRP,
  	   USU.USUARIO
  FROM DB_PRECO_PROD PRECO,
       DB_USUARIO USU,
  	   DB_PRODUTO     P,	   
	   USU_SESSION,
	   SITPROD
 WHERE DB_PRECOP_DTVALF >= cast(getdate() as date)   
   and DB_PROD_SITUACAO = SITPROD.valor

   AND USU_SESSION.usuario = USU.USUARIO

   and (case (case when (charindex('A', SITPROD.valor )  > 0 ) then 1 else 0 end)
          when  0 then 1
       else
          case when ( DB_PRECOP_SITUACAO = 'A')
               then 1 else 0 end
       end) = 1

   AND DB_PRECOP_PRODUTO = P.DB_PROD_CODIGO  
   AND DB_PRECOP_PRODUTO             = P.DB_PROD_CODIGO

   AND DB_PRECOP_CODIGO IN (SELECT  LISTAPRECO.CODIGO FROM LISTAPRECO)
			--REPLICA DA VIEW TIPO PRODUTO COM CONDICOES
	AND EXISTS 
				(SELECT 1
 				   FROM DB_GRUPO_USUARIOS    GRUPO_USU,
					      DB_GRUPO_USU_TPROD   GRUPO_TPPROD,
					      DB_TB_TPPROD         TIPOPROD
				 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
				   AND GRUPO_TPPROD.GRUPO_USUARIO = GRUPO_USU.CODIGO
				   AND TIPOPROD.DB_TBTPR_CODIGO   = GRUPO_TPPROD.TIPO_PRODUTO
				   AND P.DB_PROD_TPPROD           = TIPOPROD.DB_TBTPR_CODIGO
				UNION
				 SELECT 1
				   FROM DB_GRUPO_USUARIOS    GRUPO_USU,
   						DB_TB_TPPROD         TIPOPROD
				  WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
					  AND NOT EXISTS (SELECT 1
        									  FROM DB_GRUPO_USU_TPROD   GRUPO_TPPROD
        									 WHERE GRUPO_TPPROD.GRUPO_USUARIO  = USU.GRUPO_USUARIO)
				    AND P.DB_PROD_TPPROD = TIPOPROD.DB_TBTPR_CODIGO)



			--REPLICA DA VIEW MARCAS PRODUTO COM CONDICOES
	AND EXISTS
			   (SELECT 1
				  FROM DB_GRUPO_USUARIOS   GRUPO_USU,
					     DB_TB_REPRES        REP,
					     DB_FILTRO_GRUPOUSU  FILTRO,
					     DB_TB_MARCA         MARCA
				 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
				   AND FILTRO.CODIGO_GRUPO        = USU.GRUPO_USUARIO
				   AND FILTRO.ID_FILTRO           = 'MARCAPROD'
				   AND FILTRO.VALOR_STRING        = MARCA.DB_TBMAR_CODIGO
				   AND P.DB_PROD_MARCA            = MARCA.DB_TBMAR_CODIGO
				UNION
				SELECT 1
				  FROM DB_GRUPO_USUARIOS   GRUPO_USU,
					   DB_TB_REPRES        REP,
					   DB_TB_MARCA         MARCA
				 WHERE GRUPO_USU.CODIGO             = USU.GRUPO_USUARIO
				   AND NOT EXISTS ( SELECT 1 FROM DB_FILTRO_GRUPOUSU  FILTRO
									  WHERE FILTRO.CODIGO_GRUPO  = USU.GRUPO_USUARIO
										AND UPPER(FILTRO.ID_FILTRO)    = 'MARCAPROD')
				   AND P.DB_PROD_MARCA = MARCA.DB_TBMAR_CODIGO)
           

		--REPLICA VIEW FAMILIAS PRODUTO COM CONDICOES
	AND EXISTS
			   (SELECT 1
				  FROM DB_GRUPO_USUARIOS   GRUPO_USU,
					     DB_FILTRO_GRUPOUSU  FILTRO,
					     DB_TB_FAMILIA       FAMILIA
				 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
				   AND FILTRO.CODIGO_GRUPO        = USU.GRUPO_USUARIO
				   AND UPPER(FILTRO.ID_FILTRO)    = 'FAMILIAPROD' -- FAMILIA PRODUTO
				   AND FILTRO.VALOR_STRING        = FAMILIA.DB_TBFAM_CODIGO
				   AND P.DB_PROD_FAMILIA          = FAMILIA.DB_TBFAM_CODIGO
				
												
				UNION
				SELECT 1
				  FROM DB_GRUPO_USUARIOS   GRUPO_USU,
					     DB_TB_FAMILIA       FAMILIA
				 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
				   AND NOT EXISTS ( SELECT 1 FROM DB_FILTRO_GRUPOUSU  FILTRO
									  WHERE FILTRO.CODIGO_GRUPO      = USU.GRUPO_USUARIO
										 AND UPPER(FILTRO.ID_FILTRO) = 'FAMILIAPROD')
				   AND P.DB_PROD_FAMILIA = FAMILIA.DB_TBFAM_CODIGO)

 

	--REPLICA DA VIEW GRUPOPRODUTOS

	AND EXISTS
			   (SELECT 1
				  FROM DB_GRUPO_USUARIOS   GRUPO_USU,
					   DB_FILTRO_GRUPOUSU  FILTRO,
					   DB_TB_GRUPO         GRUPO
				 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
				   AND FILTRO.CODIGO_GRUPO        = USU.GRUPO_USUARIO
				   AND FILTRO.ID_FILTRO           = 'GRUPOPROD' -- GRUPO PRODUTO
				   and GRUPO.DB_GRUPO_COD = substrING(FILTRO.VALOR_STRING, 1, CHARINDEX(',', FILTRO.VALOR_STRING) - 1)
                  and GRUPO.DB_GRUPO_FAMILIA = substrING(FILTRO.VALOR_STRING, CHARINDEX(',', FILTRO.VALOR_STRING) + 1, len(FILTRO.VALOR_STRING))
				   AND P.DB_PROD_GRUPO = GRUPO.DB_GRUPO_COD
				   and p.DB_PROD_FAMILIA = GRUPO.DB_GRUPO_FAMILIA
				   
				UNION
				SELECT 1
				  FROM DB_GRUPO_USUARIOS   GRUPO_USU ,
					   DB_TB_GRUPO         GRUPO
				 WHERE GRUPO_USU.CODIGO           = USU.GRUPO_USUARIO
				   AND NOT EXISTS ( SELECT 1 FROM DB_FILTRO_GRUPOUSU  FILTRO
									  WHERE FILTRO.CODIGO_GRUPO     = USU.GRUPO_USUARIO
										 AND FILTRO.ID_FILTRO        = 'GRUPOPROD')
				   AND P.DB_PROD_GRUPO = GRUPO.DB_GRUPO_COD
				   and p.DB_PROD_FAMILIA = GRUPO.DB_GRUPO_FAMILIA)

