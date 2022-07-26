SELECT 
atp.IDPROPOSTA 	AS id_proposta
,prp.CODPROPOSTA 	AS cd_proposta,prp.DIGPROPOSTA 	AS dg_proposta
,prp.ENMTIPOPROPOSTA 	AS tp_cota
,prp.ENMSTATUSPROPOSTA AS st_cota --- é a mesma coisa que st_proposta

,atc.IDCOTA AS id_cota
,atc.CODCOTA 		AS cd_cota
,atc.DIGCOTA 		AS dg_cota
,atc.COTREPOSICAO 	AS nr_cota_reposicao----- AJUSTE EM 31/03
,CASE
WHEN prp.ENMTIPOPROPOSTA  =  '001'
	THEN 'NOVA'
	ELSE
		CASE
		WHEN prp.ENMTIPOPROPOSTA = '002'
		THEN 'REPOSICAO'
		ELSE NULL
		END
	END AS tp_cota --- (ou tipo proposta)

,CASE
 WHEN PRP.ENMSTATUSPROPOSTA IN ('NM','PK','PR','OR','RO','PC','CP','CS','PL','QP','OP','PO','OC','CO','QO','FB','PD','VD','SB','VP','AF')
  THEN 'ATIVO'
  ELSE
	CASE
	 WHEN PRP.ENMSTATUSPROPOSTA IN ('DG','KG','PX','CX','RJ','RA','KC','DC')
	 THEN 'CANCELADO'
	 ELSE
		CASE
		 WHEN PRP.ENMSTATUSPROPOSTA IN ('CR','DT','LD','ED','CD')
		 THEN 'EM CADASTRO'
 	 END
  END
 END  AS st_cota_agrupado
,CASE
 WHEN PRP.ENMSTATUSPROPOSTA IN ('NM','PK','PR','OR','RO')
  THEN 'A CONTEMPLAR'
  ELSE
	CASE
	WHEN PRP.ENMSTATUSPROPOSTA IN ('PC','CP','CS','PL','QP','OP','PO','OC','CO','QO')
	 THEN 'CONTEMPLADO'
	 ELSE
	 	CASE
	 	WHEN PRP.ENMSTATUSPROPOSTA IN ('DG','KG','PX','CX','RJ','RA','KC','DC')
	 	 THEN 'CANCELADO'	
	 	 ELSE
	 		CASE
	 		WHEN PRP.ENMSTATUSPROPOSTA IN ('CR','DT','LD','ED','CD') 
	 		 THEN 'EM CADASTRO'
	 		 ELSE
	 		  	CASE
	 		  	WHEN PRP.ENMSTATUSPROPOSTA IN ('FB','PD','VD','SB','VP','AF') 
	 		  	 THEN 'CADASTRADO'
	 		  	 ELSE NULL
	 		  	 END
	 		END
	 	END
	 END
  END AS st_cota_agrupado_carteira
,atp.PERAMORTIZADO 	AS pc_amortizado
,atp.PERPAGOMENSAL 	AS pc_pago_mensal
,atp.PERATRASO 		AS pc_atraso
,atp.idmodelo 		AS id_modelo
,mdl.CODMODELO 		AS cd_modelo
,mdl.DSCMODELO 		AS ds_modelo
,mdl.ENMESPECIE 	AS nm_segmento
,mdh.ENMESPECIE		AS nm_segmento_original
,plv.CODPLANO 		AS cd_plano
,CASE
WHEN plv.ENMTIPOPLANO 	= 'P'
THEN 'POOL'
ELSE 'EXCLUSIVO'END AS tp_plano
,UPPER(prd.DSCPRODUTO) AS ds_plano_consorcio
,tpr.CODPRAZO 		AS cd_prazo
,atg.DIAVECTO 		AS di_vencimento
,atg.CODGRUPO 		AS cd_grupo
,atg.IDGRUPO 		AS id_grupo
,atg.DTAFRMGRUPO 	AS dt_formacao_grupo
,atg.NUMASSSLIP 	AS nr_assembleia_atual
,(tpr.CODPRAZO - atg.NUMASSSLIP + 1) AS qt_assembleia_faltante
,atp.NUMASSINICIAL 	AS NR_ASSEMBLEIA_INICIAL
,ATP.ENMFONTEPROPOSTAPROCESSADA AS DS_CANAL_ORIGEM
,atp.DTAVENDA       AS dt_venda

FROM avd.tbl_proposta prp
INNER JOIN avd.tbl_propostaprocessada atp ON atp.IDPROPOSTA = prp.IDPROPOSTA
INNER JOIN avd.tbl_cota atc               ON atc.idproposta = atp.idproposta
INNER JOIN avd.tbl_grupo atg              ON atg.IDGRUPO = atc.IDGRUPO AND atg.CODEMPRESAHONDA = atc.CODEMPRESAHONDA
LEFT    JOIN avd.tbl_modelo mdl           ON atp.IDMODELO = mdl.idmodelo
INNER   JOIN avd.tbl_modelohonda mdh      ON mdl.IDMODELOHONDA = mdh.IDMODELOHONDA
INNER   JOIN avd.tbl_planovendas plv      ON atp.IDPLANOVENDAS = plv.IDPLANOVENDAS
INNER   JOIN avd.tbl_produto prd          ON plv.IDPRODUTO = prd.IDPRODUTO
INNER   JOIN avd.tbl_prazo tpr            ON plv.IDPRAZO = tpr.IDPRAZO

WHERE atp.IDPROPOSTA  IN (26918117,26918112,26910085,26891259,26901175,18848951,20086775,20231929,22294230,
23340739,23646786,24423175,26209625,26322996,26322997,26372652,26414780,26468842,26485074,26489766,26525876,
26562250,26581675,26613360,26614879,26640764,26640954,
26641491,26648917,26672208,26679728,26681172,26681320)
ORDER BY atp.DTAVENDA DESC

