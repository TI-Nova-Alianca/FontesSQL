
ALTER VIEW [dbo].[VA_VNOTAS_SAFRA_DEVOLVIDAS]
AS

-- Cooperativa Vinicola Nova Alianca Ltda
-- View para buscar dados de notas fiscais de devolucao de uva durante a safra.
-- Autor: Robert Koch
-- Data:  28/03/2016
-- Historico de alteracoes:
-- 20/03/2017 - Robert - Acrescentadas notas de 2017.
-- 29/07/2020 - Robert - Acrescentada NF 000015370 (devol. Vilson Da Campo em 2020)
-- 02/02/2023 - Robert - Acrescentada NF 000005736
--

-- Guarda como lista estatica porque a maioria das notas de devolucao nao tem vinculo com a nota de origem pelo campo D2_NFORI
SELECT '2013' AS SAFRA, '11' AS FILIAL, '000002670' AS DOC, '10 ' AS SERIE,  '003241' AS FORNECEDOR, '01' AS LOJA, '000003321' AS NF_DEVOLUCAO, '10 ' AS SERIE_DEVOLUCAO UNION ALL
SELECT '2013', '01', '000055722', '10 ', '003533', '01', '000056416','10 ' UNION ALL
SELECT '2013', '03', '000002408', '10 ', '002269', '01', '000002517','10 ' UNION ALL
SELECT '2013', '11', '000002843', '10 ', '002996', '01', '000003298','10 ' UNION ALL
SELECT '2015', '01', '000084871', '10 ', '003237', '01', '', '' UNION ALL
SELECT '2015', '01', '000086114', '10 ', '001322', '01', '', '' UNION ALL
SELECT '2015', '01', '000091971', '10 ', '002794', '01', '', '' UNION ALL
SELECT '2015', '01', '000091733', '10 ', '002825', '01', '', '' UNION ALL
SELECT '2015', '01', '000091788', '10 ', '002886', '01', '', '' UNION ALL
SELECT '2015', '01', '000091843', '10 ', '002945', '01', '', '' UNION ALL
SELECT '2015', '01', '000091559', '10 ', '004927', '01', '', '' UNION ALL
SELECT '2015', '01', '000093869', '10 ', '002794', '01', '', '' UNION ALL
SELECT '2015', '01', '000092001', '10 ', '002820', '01', '', '' UNION ALL
SELECT '2015', '01', '000093867', '10 ', '002825', '01', '', '' UNION ALL
SELECT '2015', '01', '000091781', '10 ', '002877', '01', '', '' UNION ALL
SELECT '2015', '01', '000093821', '10 ', '002886', '01', '', '' UNION ALL
SELECT '2015', '01', '000091813', '10 ', '002915', '01', '', '' UNION ALL
SELECT '2015', '01', '000093868', '10 ', '002945', '01', '', '' UNION ALL
SELECT '2015', '01', '000091623', '10 ', '003241', '01', '', '' UNION ALL
SELECT '2015', '01', '000091564', '10 ', '004925', '01', '', '' UNION ALL
SELECT '2015', '01', '000093866', '10 ', '004927', '01', '', '' UNION ALL
SELECT '2015', '07', '000011439', '10 ', '001132', '01', '', '' UNION ALL
SELECT '2015', '07', '000012409', '10 ', '003773', '01', '', '' UNION ALL
SELECT '2015', '07', '000013421', '10 ', '000265', '01', '', '' UNION ALL
SELECT '2015', '07', '000013425', '10 ', '001310', '01', '', '' UNION ALL
SELECT '2015', '07', '000013636', '10 ', '002385', '01', '', '' UNION ALL
SELECT '2015', '07', '000013636', '10 ', '002385', '01', '', '' UNION ALL
SELECT '2015', '07', '000013636', '10 ', '002385', '01', '', '' UNION ALL
SELECT '2015', '07', '000013638', '10 ', '002385', '02', '', '' UNION ALL
SELECT '2015', '07', '000013586', '10 ', '002386', '01', '', '' UNION ALL
SELECT '2015', '07', '000013586', '10 ', '002386', '01', '', '' UNION ALL
SELECT '2015', '07', '000013586', '10 ', '002386', '01', '', '' UNION ALL
SELECT '2015', '07', '000013570', '10 ', '002389', '01', '', '' UNION ALL
SELECT '2015', '07', '000013570', '10 ', '002389', '01', '', '' UNION ALL
SELECT '2015', '07', '000013570', '10 ', '002389', '01', '', '' UNION ALL
SELECT '2015', '07', '000013570', '10 ', '002389', '01', '', '' UNION ALL
SELECT '2015', '07', '000013445', '10 ', '002471', '01', '', '' UNION ALL
SELECT '2015', '07', '000013464', '10 ', '002473', '01', '', '' UNION ALL
SELECT '2015', '07', '000013464', '10 ', '002473', '01', '', '' UNION ALL
SELECT '2015', '07', '000013508', '10 ', '002484', '01', '', '' UNION ALL
SELECT '2015', '07', '000013508', '10 ', '002484', '01', '', '' UNION ALL
SELECT '2015', '07', '000013535', '10 ', '002487', '01', '', '' UNION ALL
SELECT '2015', '07', '000013531', '10 ', '002488', '01', '', '' UNION ALL
SELECT '2015', '07', '000013531', '10 ', '002488', '01', '', '' UNION ALL
SELECT '2015', '07', '000013539', '10 ', '002489', '01', '', '' UNION ALL
SELECT '2015', '07', '000013539', '10 ', '002489', '01', '', '' UNION ALL
SELECT '2015', '07', '000013549', '10 ', '002492', '01', '', '' UNION ALL
SELECT '2015', '07', '000013549', '10 ', '002492', '01', '', '' UNION ALL
SELECT '2015', '07', '000013549', '10 ', '002492', '01', '', '' UNION ALL
SELECT '2015', '07', '000013549', '10 ', '002492', '01', '', '' UNION ALL
SELECT '2015', '07', '000013567', '10 ', '002498', '01', '', '' UNION ALL
SELECT '2015', '07', '000013573', '10 ', '002500', '01', '', '' UNION ALL
SELECT '2015', '07', '000013573', '10 ', '002500', '01', '', '' UNION ALL
SELECT '2015', '07', '000013573', '10 ', '002500', '01', '', '' UNION ALL
SELECT '2015', '07', '000013580', '10 ', '002501', '01', '', '' UNION ALL
SELECT '2015', '07', '000013580', '10 ', '002501', '01', '', '' UNION ALL
SELECT '2015', '07', '000013615', '10 ', '002510', '01', '', '' UNION ALL
SELECT '2015', '07', '000013615', '10 ', '002510', '01', '', '' UNION ALL
SELECT '2015', '07', '000013615', '10 ', '002510', '01', '', '' UNION ALL
SELECT '2015', '07', '000013615', '10 ', '002510', '01', '', '' UNION ALL
SELECT '2015', '07', '000013615', '10 ', '002510', '01', '', '' UNION ALL
SELECT '2015', '07', '000013615', '10 ', '002510', '01', '', '' UNION ALL
SELECT '2015', '07', '000013627', '10 ', '002513', '01', '', '' UNION ALL
SELECT '2015', '07', '000013634', '10 ', '002514', '01', '', '' UNION ALL
SELECT '2015', '07', '000013634', '10 ', '002514', '01', '', '' UNION ALL
SELECT '2015', '07', '000013634', '10 ', '002514', '01', '', '' UNION ALL
SELECT '2015', '07', '000013647', '10 ', '002516', '01', '', '' UNION ALL
SELECT '2015', '07', '000013647', '10 ', '002516', '01', '', '' UNION ALL
SELECT '2015', '07', '000013650', '10 ', '002517', '01', '', '' UNION ALL
SELECT '2015', '07', '000013656', '10 ', '002519', '01', '', '' UNION ALL
SELECT '2015', '07', '000013656', '10 ', '002519', '01', '', '' UNION ALL
SELECT '2015', '07', '000013671', '10 ', '002521', '01', '', '' UNION ALL
SELECT '2015', '07', '000013671', '10 ', '002521', '01', '', '' UNION ALL
SELECT '2015', '07', '000013671', '10 ', '002521', '01', '', '' UNION ALL
SELECT '2015', '07', '000013674', '10 ', '002522', '01', '', '' UNION ALL
SELECT '2015', '07', '000013674', '10 ', '002522', '01', '', '' UNION ALL
SELECT '2015', '07', '000013674', '10 ', '002522', '01', '', '' UNION ALL
SELECT '2015', '07', '000013438', '10 ', '002635', '01', '', '' UNION ALL
SELECT '2015', '07', '000013440', '10 ', '002636', '01', '', '' UNION ALL
SELECT '2015', '07', '000013440', '10 ', '002636', '01', '', '' UNION ALL
SELECT '2015', '07', '000013440', '10 ', '002636', '01', '', '' UNION ALL
SELECT '2015', '07', '000013440', '10 ', '002636', '01', '', '' UNION ALL
SELECT '2015', '07', '000013442', '10 ', '002637', '01', '', '' UNION ALL
SELECT '2015', '07', '000013442', '10 ', '002637', '01', '', '' UNION ALL
SELECT '2015', '07', '000013442', '10 ', '002637', '01', '', '' UNION ALL
SELECT '2015', '07', '000013447', '10 ', '002639', '01', '', '' UNION ALL
SELECT '2015', '07', '000013451', '10 ', '002640', '01', '', '' UNION ALL
SELECT '2015', '07', '000013451', '10 ', '002640', '01', '', '' UNION ALL
SELECT '2015', '07', '000013451', '10 ', '002640', '01', '', '' UNION ALL
SELECT '2015', '07', '000013454', '10 ', '002642', '01', '', '' UNION ALL
SELECT '2015', '07', '000013457', '10 ', '002645', '01', '', '' UNION ALL
SELECT '2015', '07', '000013457', '10 ', '002645', '01', '', '' UNION ALL
SELECT '2015', '07', '000013457', '10 ', '002645', '01', '', '' UNION ALL
SELECT '2015', '07', '000013461', '10 ', '002648', '01', '', '' UNION ALL
SELECT '2015', '07', '000013467', '10 ', '002651', '01', '', '' UNION ALL
SELECT '2015', '07', '000013467', '10 ', '002651', '01', '', '' UNION ALL
SELECT '2015', '07', '000013502', '10 ', '002664', '01', '', '' UNION ALL
SELECT '2015', '07', '000013502', '10 ', '002664', '01', '', '' UNION ALL
SELECT '2015', '07', '000013502', '10 ', '002664', '01', '', '' UNION ALL
SELECT '2015', '07', '000013502', '10 ', '002664', '01', '', '' UNION ALL
SELECT '2015', '07', '000013502', '10 ', '002664', '01', '', '' UNION ALL
SELECT '2015', '07', '000013502', '10 ', '002664', '01', '', '' UNION ALL
SELECT '2015', '07', '000013502', '10 ', '002664', '01', '', '' UNION ALL
SELECT '2015', '07', '000013510', '10 ', '002666', '01', '', '' UNION ALL
SELECT '2015', '07', '000013510', '10 ', '002666', '01', '', '' UNION ALL
SELECT '2015', '07', '000013522', '10 ', '002671', '01', '', '' UNION ALL
SELECT '2015', '07', '000013522', '10 ', '002671', '01', '', '' UNION ALL
SELECT '2015', '07', '000013522', '10 ', '002671', '01', '', '' UNION ALL
SELECT '2015', '07', '000013533', '10 ', '002675', '01', '', '' UNION ALL
SELECT '2015', '07', '000013553', '10 ', '002679', '01', '', '' UNION ALL
SELECT '2015', '07', '000013553', '10 ', '002679', '01', '', '' UNION ALL
SELECT '2015', '07', '000013578', '10 ', '002687', '01', '', '' UNION ALL
SELECT '2015', '07', '000013578', '10 ', '002687', '01', '', '' UNION ALL
SELECT '2015', '07', '000013578', '10 ', '002687', '01', '', '' UNION ALL
SELECT '2015', '07', '000013583', '10 ', '002689', '01', '', '' UNION ALL
SELECT '2015', '07', '000013583', '10 ', '002689', '01', '', '' UNION ALL
SELECT '2015', '07', '000013589', '10 ', '002690', '01', '', '' UNION ALL
SELECT '2015', '07', '000013661', '10 ', '002710', '01', '', '' UNION ALL
SELECT '2015', '07', '000013661', '10 ', '002710', '01', '', '' UNION ALL
SELECT '2015', '07', '000013661', '10 ', '002710', '01', '', '' UNION ALL
SELECT '2015', '07', '000013661', '10 ', '002710', '01', '', '' UNION ALL
SELECT '2015', '07', '000013661', '10 ', '002710', '01', '', '' UNION ALL
SELECT '2015', '07', '000013661', '10 ', '002710', '01', '', '' UNION ALL
SELECT '2015', '07', '000013665', '10 ', '002712', '01', '', '' UNION ALL
SELECT '2015', '07', '000013665', '10 ', '002712', '01', '', '' UNION ALL
SELECT '2015', '07', '000013665', '10 ', '002712', '01', '', '' UNION ALL
SELECT '2015', '07', '000013667', '10 ', '002713', '01', '', '' UNION ALL
SELECT '2015', '07', '000013669', '10 ', '003024', '01', '', '' UNION ALL
SELECT '2015', '07', '000013669', '10 ', '003024', '01', '', '' UNION ALL
SELECT '2015', '07', '000013669', '10 ', '003024', '01', '', '' UNION ALL
SELECT '2015', '07', '000013595', '10 ', '003026', '01', '', '' UNION ALL
SELECT '2015', '07', '000013541', '10 ', '003029', '01', '', '' UNION ALL
SELECT '2015', '07', '000013541', '10 ', '003029', '01', '', '' UNION ALL
SELECT '2015', '07', '000013541', '10 ', '003029', '01', '', '' UNION ALL
SELECT '2015', '07', '000013541', '10 ', '003029', '01', '', '' UNION ALL
SELECT '2015', '07', '000013541', '10 ', '003029', '01', '', '' UNION ALL
SELECT '2015', '07', '000013541', '10 ', '003029', '01', '', '' UNION ALL
SELECT '2015', '07', '000013541', '10 ', '003029', '01', '', '' UNION ALL
SELECT '2015', '07', '000013512', '10 ', '003547', '01', '', '' UNION ALL
SELECT '2015', '07', '000013512', '10 ', '003547', '01', '', '' UNION ALL
SELECT '2015', '07', '000013512', '10 ', '003547', '01', '', '' UNION ALL
SELECT '2015', '07', '000013512', '10 ', '003547', '01', '', '' UNION ALL
SELECT '2015', '07', '000013512', '10 ', '003547', '01', '', '' UNION ALL
SELECT '2015', '07', '000013512', '10 ', '003547', '01', '', '' UNION ALL
SELECT '2015', '07', '000013681', '10 ', '003548', '01', '', '' UNION ALL
SELECT '2015', '07', '000013681', '10 ', '003548', '01', '', '' UNION ALL
SELECT '2015', '07', '000013632', '10 ', '003559', '01', '', '' UNION ALL
SELECT '2015', '07', '000013632', '10 ', '003559', '01', '', '' UNION ALL
SELECT '2015', '07', '000013632', '10 ', '003559', '01', '', '' UNION ALL
SELECT '2015', '07', '000013632', '10 ', '003559', '01', '', '' UNION ALL
SELECT '2015', '07', '000013617', '10 ', '003560', '01', '', '' UNION ALL
SELECT '2015', '07', '000013617', '10 ', '003560', '01', '', '' UNION ALL
SELECT '2015', '07', '000013471', '10 ', '003561', '01', '', '' UNION ALL
SELECT '2015', '07', '000013621', '10 ', '003568', '01', '', '' UNION ALL
SELECT '2015', '07', '000013505', '10 ', '003577', '01', '', '' UNION ALL
SELECT '2015', '07', '000013505', '10 ', '003577', '01', '', '' UNION ALL
SELECT '2015', '07', '000013505', '10 ', '003577', '01', '', '' UNION ALL
SELECT '2015', '07', '000013505', '10 ', '003577', '01', '', '' UNION ALL
SELECT '2015', '07', '000013505', '10 ', '003577', '01', '', '' UNION ALL
SELECT '2015', '07', '000013505', '10 ', '003577', '01', '', '' UNION ALL
SELECT '2015', '07', '000013505', '10 ', '003577', '01', '', '' UNION ALL
SELECT '2015', '07', '000013602', '10 ', '003587', '01', '', '' UNION ALL
SELECT '2015', '07', '000013602', '10 ', '003587', '01', '', '' UNION ALL
SELECT '2015', '07', '000013602', '10 ', '003587', '01', '', '' UNION ALL
SELECT '2015', '07', '000013602', '10 ', '003587', '01', '', '' UNION ALL
SELECT '2015', '07', '000013602', '10 ', '003587', '01', '', '' UNION ALL
SELECT '2015', '07', '000013602', '10 ', '003587', '01', '', '' UNION ALL
SELECT '2015', '07', '000013491', '10 ', '003927', '01', '', '' UNION ALL
SELECT '2015', '07', '000013729', '10 ', '004337', '01', '', '' UNION ALL
SELECT '2015', '07', '000013729', '10 ', '004337', '01', '', '' UNION ALL
SELECT '2015', '07', '000013758', '10 ', '004342', '01', '', '' UNION ALL
SELECT '2015', '07', '000013758', '10 ', '004342', '01', '', '' UNION ALL
SELECT '2015', '07', '000013758', '10 ', '004342', '01', '', '' UNION ALL
SELECT '2015', '07', '000013758', '10 ', '004342', '01', '', '' UNION ALL
SELECT '2015', '07', '000013758', '10 ', '004342', '01', '', '' UNION ALL
SELECT '2015', '07', '000013734', '10 ', '004345', '01', '', '' UNION ALL
SELECT '2015', '07', '000013734', '10 ', '004345', '01', '', '' UNION ALL
SELECT '2015', '07', '000013704', '10 ', '004346', '01', '', '' UNION ALL
SELECT '2015', '07', '000013704', '10 ', '004346', '01', '', '' UNION ALL
SELECT '2015', '07', '000013770', '10 ', '004349', '01', '', '' UNION ALL
SELECT '2015', '07', '000013718', '10 ', '004356', '01', '', '' UNION ALL
SELECT '2015', '07', '000013718', '10 ', '004356', '01', '', '' UNION ALL
SELECT '2015', '07', '000013710', '10 ', '004359', '01', '', '' UNION ALL
SELECT '2015', '07', '000013710', '10 ', '004359', '01', '', '' UNION ALL
SELECT '2015', '07', '000013710', '10 ', '004359', '01', '', '' UNION ALL
SELECT '2015', '07', '000013710', '10 ', '004359', '01', '', '' UNION ALL
SELECT '2015', '07', '000013710', '10 ', '004359', '01', '', '' UNION ALL
SELECT '2015', '07', '000013710', '10 ', '004359', '01', '', '' UNION ALL
SELECT '2015', '07', '000013710', '10 ', '004359', '01', '', '' UNION ALL
SELECT '2015', '07', '000013710', '10 ', '004359', '01', '', '' UNION ALL
SELECT '2015', '07', '000013695', '10 ', '004363', '01', '', '' UNION ALL
SELECT '2015', '07', '000013695', '10 ', '004363', '01', '', '' UNION ALL
SELECT '2015', '07', '000013695', '10 ', '004363', '01', '', '' UNION ALL
SELECT '2015', '07', '000013695', '10 ', '004363', '01', '', '' UNION ALL
SELECT '2015', '07', '000013687', '10 ', '004364', '01', '', '' UNION ALL
SELECT '2015', '07', '000013698', '10 ', '004366', '01', '', '' UNION ALL
SELECT '2015', '07', '000013698', '10 ', '004366', '01', '', '' UNION ALL
SELECT '2015', '07', '000013698', '10 ', '004366', '01', '', '' UNION ALL
SELECT '2015', '07', '000013698', '10 ', '004366', '01', '', '' UNION ALL
SELECT '2015', '07', '000013698', '10 ', '004366', '01', '', '' UNION ALL
SELECT '2015', '07', '000013716', '10 ', '004368', '01', '', '' UNION ALL
SELECT '2015', '07', '000013725', '10 ', '004369', '01', '', '' UNION ALL
SELECT '2015', '07', '000013725', '10 ', '004369', '01', '', '' UNION ALL
SELECT '2015', '07', '000013722', '10 ', '004370', '01', '', '' UNION ALL
SELECT '2015', '07', '000013722', '10 ', '004370', '01', '', '' UNION ALL
SELECT '2015', '07', '000013722', '10 ', '004370', '01', '', '' UNION ALL
SELECT '2015', '07', '000013722', '10 ', '004370', '01', '', '' UNION ALL
SELECT '2015', '07', '000013741', '10 ', '004374', '01', '', '' UNION ALL
SELECT '2015', '07', '000013741', '10 ', '004374', '01', '', '' UNION ALL
SELECT '2015', '07', '000013756', '10 ', '004376', '01', '', '' UNION ALL
SELECT '2015', '07', '000013762', '10 ', '004377', '01', '', '' UNION ALL
SELECT '2015', '07', '000013762', '10 ', '004377', '01', '', '' UNION ALL
SELECT '2015', '07', '000013762', '10 ', '004377', '01', '', '' UNION ALL
SELECT '2015', '07', '000013732', '10 ', '004380', '01', '', '' UNION ALL
SELECT '2015', '07', '000013732', '10 ', '004380', '01', '', '' UNION ALL
SELECT '2015', '07', '000013732', '10 ', '004380', '01', '', '' UNION ALL
SELECT '2015', '07', '000013732', '10 ', '004380', '01', '', '' UNION ALL
SELECT '2015', '07', '000013732', '10 ', '004380', '01', '', '' UNION ALL
SELECT '2015', '07', '000013732', '10 ', '004380', '01', '', '' UNION ALL
SELECT '2015', '07', '000013691', '10 ', '004381', '01', '', '' UNION ALL
SELECT '2015', '07', '000013691', '10 ', '004381', '01', '', '' UNION ALL
SELECT '2015', '07', '000013751', '10 ', '004384', '01', '', '' UNION ALL
SELECT '2015', '07', '000013751', '10 ', '004384', '01', '', '' UNION ALL
SELECT '2015', '07', '000013751', '10 ', '004384', '01', '', '' UNION ALL
SELECT '2015', '07', '000013754', '10 ', '004388', '01', '', '' UNION ALL
SELECT '2015', '07', '000013754', '10 ', '004388', '01', '', '' UNION ALL
SELECT '2015', '07', '000013754', '10 ', '004388', '01', '', '' UNION ALL
SELECT '2015', '07', '000013754', '10 ', '004388', '01', '', '' UNION ALL
SELECT '2015', '07', '000013754', '10 ', '004388', '01', '', '' UNION ALL
SELECT '2015', '07', '000013739', '10 ', '004394', '01', '', '' UNION ALL
SELECT '2015', '07', '000013739', '10 ', '004394', '01', '', '' UNION ALL
SELECT '2015', '07', '000013706', '10 ', '004400', '01', '', '' UNION ALL
SELECT '2015', '07', '000013706', '10 ', '004400', '01', '', '' UNION ALL
SELECT '2015', '07', '000013706', '10 ', '004400', '01', '', '' UNION ALL
SELECT '2015', '07', '000013706', '10 ', '004400', '01', '', '' UNION ALL
SELECT '2015', '07', '000013708', '10 ', '004401', '01', '', '' UNION ALL
SELECT '2015', '07', '000013708', '10 ', '004401', '01', '', '' UNION ALL
SELECT '2015', '07', '000013708', '10 ', '004401', '01', '', '' UNION ALL
SELECT '2015', '07', '000013708', '10 ', '004401', '01', '', '' UNION ALL
SELECT '2015', '07', '000013401', '10 ', '004423', '01', '', '' UNION ALL
SELECT '2015', '07', '000013401', '10 ', '004423', '01', '', '' UNION ALL
SELECT '2015', '07', '000013435', '10 ', '004824', '01', '', '' UNION ALL
SELECT '2015', '07', '000013435', '10 ', '004824', '01', '', '' UNION ALL
SELECT '2015', '07', '000013399', '10 ', '004916', '01', '', '' UNION ALL
SELECT '2015', '09', '000011128', '10 ', '002085', '01', '', '' UNION ALL
SELECT '2015', '09', '000011369', '10 ', '002085', '01', '', '' UNION ALL
SELECT '2015', '12', '000002922', '10 ', '004385', '01', '', '' UNION ALL
SELECT '2015', '12', '000003094', '10 ', '004383', '01', '', '' UNION ALL
SELECT '2015', '12', '000003268', '10 ', '002508', '01', '', '' UNION ALL
SELECT '2015', '12', '000003368', '10 ', '002671', '01', '', '' UNION ALL
SELECT '2015', '12', '000003430', '10 ', '004356', '01', '', '' UNION ALL
SELECT '2015', '12', '000003443', '10 ', '004379', '01', '', '' UNION ALL
SELECT '2015', '12', '000003617', '10 ', '004366', '01', '', '' UNION ALL
SELECT '2015', '12', '000003638', '10 ', '004380', '01', '', '' UNION ALL
SELECT '2015', '12', '000003552', '10 ', '002382', '01', '', '' UNION ALL
SELECT '2015', '12', '000003672', '10 ', '004366', '01', '', '' UNION ALL
SELECT '2015', '12', '000003673', '10 ', '004380', '01', '', '' UNION ALL
SELECT '2016', '01', '000001972', '30 ', '000275', '01', '000104006', '10 ' UNION ALL
SELECT '2016', '01', '000000440', '30 ', '002842', '01', '000103682', '10 ' UNION ALL
SELECT '2016', '01', '000001395', '30 ', '000289', '01', '000104457', '10 ' UNION ALL
SELECT '2016', '01', '000002076', '30 ', '002964', '01', '000104461', '10 ' UNION ALL
SELECT '2016', '03', '000000042', '30 ', '002288', '01', '000004328', '10 ' UNION ALL
SELECT '2016', '03', '000000045', '30 ', '002288', '01', '000004328', '10 ' UNION ALL
SELECT '2016', '01', '000002427', '30 ', '004831', '01', '000003702', '30 ' UNION ALL

-- SAFRA, FILIAL, DOC, SERIE, FORN, LOJA, NF_DEVOLVIDA, SERIE_DEVOL
SELECT '2017', '01', '000005164', '30 ', '003549', '01', '000119200', '10 ' UNION ALL
SELECT '2017', '01', '000005259', '30 ', '000255', '01', '000118396', '10 ' UNION ALL
SELECT '2017', '01', '000004004', '30 ', '001106', '01', '000117831', '10 ' UNION ALL
SELECT '2017', '01', '000004606', '30 ', '004852', '01', '000117884', '10 ' UNION ALL  -- DUVIDOSA POR CAUSA DO TES
SELECT '2017', '07', '000002539', '30 ', '000326', '01', '000004121', '30 ' UNION ALL
SELECT '2017', '07', '000003536', '30 ', '002659', '01', '000015208', '10 ' union all

-- SAFRA, FILIAL, DOC, SERIE, FORN, LOJA, NF_DEVOLVIDA, SERIE_DEVOL
SELECT '2019', '07', '000008601', '30 ', '004848', '01', '000009612', '30 ' union all

-- SAFRA, FILIAL, DOC, SERIE, FORN, LOJA, NF_DEVOLUCAO, SERIE_DEVOLUCAO
SELECT '2020', '07'  , '000014804' , '30 ', '003024', '01', '000015370',  '30 '

union all
SELECT '2023', '03'  , '000000950' , '30 ', '001369', '02', '000005736',  '10 '


