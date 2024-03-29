---------------------------------------------------------------------------------------------------
-- VERSAO	DATA		AUTOR			ALTERACAO
-- 1.0001	11/12/2012	TIAGO PRADELLA	CRIACAO
-- 1.0002   14/12/2012  ALENCAR         INCLUSAO DO CAMPO USUARIO
-- 1.0003   15/03/2013  TIAGO           INCLUSAO DE NOVOS CAMPOS (PRECON)
-- 1.0004   21/03/2013  tiago           inclusao campo caixa postal
-- 1.0005   08/04/2013	tiago			incluido campo mobile
-- 1.0006   10/07/2013  tiago           incluido novos campos
-- 1.0007   08/08/2013  tiago           retirado calculo nos campos de latitute
-- 1.0008   07/05/2014  tiago           incluido campo: DB_CLIENT_EMPRESA
-- 1.0009   24/04/2017  tiago           incluido campo DB_CLIENT_CELULAR
---------------------------------------------------------------------------------------------------
ALTER VIEW MVA_CLIENTEENDERECOS AS
SELECT
		 DB_CLIENT_CODIGO      CLIENTE_CLENT,
		 DB_CLIENT_SEQ         SEQUENCIA_CLENT,
		 DB_CLIENT_ENDERECO    ENDERECO_CLENT,
		 DB_CLIENT_ENDNRO      NUMERO_CLENT,
		 DB_CLIENT_BAIRRO      BAIRRO_CLENT,
		 DB_CLIENT_CEP         CEP_CLENT,
		 DB_CLIENT_ESTADO      ESTADO_CLENT,
		 DB_CLIENT_CIDADE      CIDADE_CLENT,
		 USUARIO,
         DATAALTER,		 
		 DB_CLIENT_ENDCOMPL    COMPLEMENTO_CLENT,
		 DB_CLIENT_PONTOREF    REFERENCIA_CLENT,
		 DB_CLIENT_PAIS        PAIS_CLENT,
		 DB_CLIENT_TELEFONE    TELEFONE_CLENT,
		 DB_CLIENT_RAMAL       RAMAL_CLENT,
		 DB_CLIENT_RAZAO       RAZAOSOCIAL_CLENT,
		 DB_CLIENT_CGCMF       CNPJ_CLENT,
		 DB_CLIENT_CGCTE       INSCRICAOESTADUAL_CLENT,
		 DB_CLIENT_CX_POS      CAIXAPOSTAL_CLENT,
		 0                     MOBILE_CLENT ,
		 DB_CLIENT_FAX         FAX_CLENT,
		 DB_CLIENT_LATITUD     LATITUDE_CLENT,
		 DB_CLIENT_LONGITUD    LONGITUDE_CLENT,
		 DB_CLIENT_LOGRAD      LOGRADOURO_CLENT,
	 	 DB_CLIENT_CODCLI      CLIENTEENTREGA_CLENT,
		 DB_CLIENT_EMPRESA     EMPRESA_CLENT,
		 DB_CLIENT_CELULAR     celular_CLENT
 FROM DB_CLIENTE_ENT, MVA_CLIENTE
WHERE CODIGO_CLIEN = DB_CLIENT_CODIGO
