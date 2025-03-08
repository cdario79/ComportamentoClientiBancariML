/*
 * 
 * CREAZIONE TABELLA TEMPORANEA PER: 
 * - Età
 *
 */  
CREATE TEMPORARY TABLE banca.tmp_cliente_eta
	SELECT 
		cli.id_cliente, 
        TIMESTAMPDIFF(YEAR, cli.data_nascita, CURDATE()) AS eta 
    FROM 
		banca.cliente AS cli;
 
 
 /*
 * 
 * CREAZIONE TABELLA TEMPORANEA PER: 
 * - Numero di transazioni in uscita su tutti i conti
 *
 */        
CREATE TEMPORARY TABLE banca.tmp_cliente_transazioni_uscita
	SELECT 
		cli.id_cliente,
		SUM(CASE WHEN tip_tran.segno = '-' THEN 1 ELSE 0 END) AS num_trans_uscita
	FROM 
		banca.cliente AS cli
	LEFT JOIN 
		banca.conto AS con 
		ON cli.id_cliente = con.id_cliente
	LEFT JOIN 
		banca.transazioni AS tran 
		ON con.id_conto = tran.id_conto
	LEFT JOIN
		banca.tipo_transazione AS tip_tran
		ON tran.id_tipo_trans = tip_tran.id_tipo_transazione
	GROUP BY 1;


/*
 * 
 * CREAZIONE TABELLA TEMPORANEA PER: 
 * - Numero di transazioni in entrata su tutti i conti
 *
 */        
CREATE TEMPORARY TABLE banca.tmp_cliente_transazioni_entrata
	SELECT 
		cli.id_cliente,
        SUM(CASE WHEN tip_tran.segno = '+' THEN 1 ELSE 0 END) AS num_trans_entrata
	FROM 
		banca.cliente AS cli
	LEFT JOIN 
		banca.conto AS con 
		ON cli.id_cliente = con.id_cliente
	LEFT JOIN 
		banca.transazioni AS tran 
		ON con.id_conto = tran.id_conto
	LEFT JOIN
		banca.tipo_transazione AS tip_tran
		ON tran.id_tipo_trans = tip_tran.id_tipo_transazione
	GROUP BY 1;


/*
 * 
 * CREAZIONE TABELLA TEMPORANEA PER: 
 * - Importo transato in uscita su tutti i conti
 *
 */        
CREATE TEMPORARY TABLE banca.tmp_cliente_importo_uscita
	SELECT 
		cli.id_cliente,
        SUM(CASE WHEN tip_tran.segno = '-' THEN tran.importo ELSE 0 END) AS tot_trans_uscita
	FROM 
		banca.cliente AS cli
	LEFT JOIN 
		banca.conto AS con 
		ON cli.id_cliente = con.id_cliente
	LEFT JOIN 
		banca.transazioni AS tran 
		ON con.id_conto = tran.id_conto
	LEFT JOIN
		banca.tipo_transazione AS tip_tran
		ON tran.id_tipo_trans = tip_tran.id_tipo_transazione
	GROUP BY 1;
 
 
/*
 * 
 * CREAZIONE TABELLA TEMPORANEA PER: 
 * - Importo transato in entrata su tutti i conti
 *
 */        
CREATE TEMPORARY TABLE banca.tmp_cliente_importo_entrata
	SELECT 
		cli.id_cliente,
        SUM(CASE WHEN tip_tran.segno = '+' THEN tran.importo ELSE 0 END) AS tot_trans_entrata
	FROM 
		banca.cliente AS cli
	LEFT JOIN 
		banca.conto AS con 
		ON cli.id_cliente = con.id_cliente
	LEFT JOIN 
		banca.transazioni AS tran 
		ON con.id_conto = tran.id_conto
	LEFT JOIN
		banca.tipo_transazione AS tip_tran
		ON tran.id_tipo_trans = tip_tran.id_tipo_transazione
	GROUP BY 1;


/*
 * 
 * CREAZIONE TABELLA TEMPORANEA PER: 
 * - Numero totale di conti posseduti
 *
 */          
CREATE TEMPORARY TABLE banca.tmp_cliente_conti
	SELECT 
		cli.id_cliente,
        COUNT(con.id_conto) AS tot_conti
	FROM 
		banca.cliente AS cli
	LEFT JOIN 
		banca.conto AS con 
		ON cli.id_cliente = con.id_cliente
    GROUP BY 1;


/*
 * 
 * CREAZIONE TABELLA TEMPORANEA PER: 
 * - Numero di conti posseduti per tipologia (un indicatore per tipo)
 *
 */   
CREATE TEMPORARY TABLE banca.tmp_cliente_tipo_conti
	SELECT 
		cli.id_cliente,
        SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Base' THEN 1 ELSE 0 END) AS num_conti_base,
        SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Business' THEN 1 ELSE 0 END) AS num_conti_business,
        SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Privati' THEN 1 ELSE 0 END) AS num_conti_privati,
        SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Famiglie' THEN 1 ELSE 0 END) AS num_conti_famiglie
	FROM 
		banca.cliente AS cli
	LEFT JOIN 
		banca.conto AS con 
		ON cli.id_cliente = con.id_cliente
    LEFT JOIN
		banca.tipo_conto AS tip_con
        ON con.id_tipo_conto = tip_con.id_tipo_conto
    GROUP BY 1;


/*
 * 
 * CREAZIONE TABELLA TEMPORANEA PER: 
 * - Numero di transazioni in uscita per tipologia (un indicatore per tipo)
 *
 */   
CREATE TEMPORARY TABLE banca.tmp_cliente_tipo_transazioni_uscita
	SELECT 
		cli.id_cliente,
        SUM(CASE WHEN tip_tran.desc_tipo_trans = 'Acquisto su Amazon' THEN 1 ELSE 0 END) AS num_trans_uscita_amazon,
        SUM(CASE WHEN tip_tran.desc_tipo_trans = 'Rata mutuo' THEN 1 ELSE 0 END) AS num_trans_uscita_mutuo,
        SUM(CASE WHEN tip_tran.desc_tipo_trans = 'Hotel' THEN 1 ELSE 0 END) AS num_trans_uscita_hotel,
        SUM(CASE WHEN tip_tran.desc_tipo_trans = 'Biglietto aereo' THEN 1 ELSE 0 END) AS num_trans_uscita_aereo,
        SUM(CASE WHEN tip_tran.desc_tipo_trans = 'Supermercato' THEN 1 ELSE 0 END) AS num_trans_uscita_supermercato
	FROM 
		banca.cliente AS cli
	LEFT JOIN 
		banca.conto AS con 
		ON cli.id_cliente = con.id_cliente
	LEFT JOIN 
		banca.transazioni AS tran 
		ON con.id_conto = tran.id_conto
	LEFT JOIN
		banca.tipo_transazione AS tip_tran
		ON tran.id_tipo_trans = tip_tran.id_tipo_transazione
	GROUP BY 1;


/*
 * 
 * CREAZIONE TABELLA TEMPORANEA PER: 
 * - Numero di transazioni in entrata per tipologia (un indicatore per tipo)
 *
 */   
CREATE TEMPORARY TABLE banca.tmp_cliente_tipo_transazioni_entrata
	SELECT 
		cli.id_cliente,
        SUM(CASE WHEN tip_tran.desc_tipo_trans = 'Stipendio' THEN 1 ELSE 0 END) AS num_trans_entrata_stipendio,
        SUM(CASE WHEN tip_tran.desc_tipo_trans = 'Pensione' THEN 1 ELSE 0 END) AS num_trans_entrata_pensione,
        SUM(CASE WHEN tip_tran.desc_tipo_trans = 'Dividendi' THEN 1 ELSE 0 END) AS num_trans_entrata_dividendi
	FROM 
		banca.cliente AS cli
	LEFT JOIN 
		banca.conto AS con 
		ON cli.id_cliente = con.id_cliente
	LEFT JOIN 
		banca.transazioni AS tran 
		ON con.id_conto = tran.id_conto
	LEFT JOIN
		banca.tipo_transazione AS tip_tran
		ON tran.id_tipo_trans = tip_tran.id_tipo_transazione
	GROUP BY 1;


/*
 * 
 * CREAZIONE TABELLA TEMPORANEA PER: 
 * - Importo transato in uscita per tipologia di conto (un indicatore per tipo)
 *
 */    
CREATE TEMPORARY TABLE banca.tmp_cliente_importi_conti_uscita
	SELECT 
		cli.id_cliente,
		SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Base' AND tip_tran.segno = '-' THEN tran.importo ELSE 0 END) AS tot_trans_uscita_conti_base,
		SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Business' AND tip_tran.segno = '-' THEN tran.importo ELSE 0 END) AS tot_trans_uscita_conti_business,
		SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Privati' AND tip_tran.segno = '-' THEN tran.importo ELSE 0 END) AS tot_trans_uscita_conti_privati,
		SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Famiglie' AND tip_tran.segno = '-' THEN tran.importo ELSE 0 END) AS tot_trans_uscita_conti_famiglie
	FROM 
		banca.cliente AS cli
	LEFT JOIN 
		banca.conto AS con 
		ON cli.id_cliente = con.id_cliente
	LEFT JOIN  
		banca.tipo_conto AS tip_con 
		ON con.id_tipo_conto = tip_con.id_tipo_conto
	LEFT JOIN 
		banca.transazioni AS tran 
		ON con.id_conto = tran.id_conto
	LEFT JOIN
		banca.tipo_transazione AS tip_tran
		ON tran.id_tipo_trans = tip_tran.id_tipo_transazione
	GROUP BY 1;


/*
 * 
 * CREAZIONE TABELLA TEMPORANEA PER: 
 * - Importo transato in entrata per tipologia di conto (un indicatore per tipo)
 *
 */    
CREATE TEMPORARY TABLE banca.tmp_cliente_importi_conti_entrata
	SELECT 
		cli.id_cliente,
		SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Base' AND tip_tran.segno = '+' THEN tran.importo ELSE 0 END) AS tot_trans_entrata_conti_base,
		SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Business' AND tip_tran.segno = '+' THEN tran.importo ELSE 0 END) AS tot_trans_entrata_conti_business,
		SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Privati' AND tip_tran.segno = '+' THEN tran.importo ELSE 0 END) AS tot_trans_entrata_conti_privati,
		SUM(CASE WHEN tip_con.desc_tipo_conto = 'Conto Famiglie' AND tip_tran.segno = '+' THEN tran.importo ELSE 0 END) AS tot_trans_entrata_conti_famiglie
	FROM 
		banca.cliente AS cli
	LEFT JOIN 
		banca.conto AS con 
		ON cli.id_cliente = con.id_cliente
	LEFT JOIN  
		banca.tipo_conto AS tip_con 
		ON con.id_tipo_conto = tip_con.id_tipo_conto
	LEFT JOIN 
		banca.transazioni AS tran 
		ON con.id_conto = tran.id_conto
	LEFT JOIN
		banca.tipo_transazione AS tip_tran
		ON tran.id_tipo_trans = tip_tran.id_tipo_transazione
	GROUP BY 1;


/*
 * 
 * CREAZIONE TABELLA FINALE 
 *
 */ 
DROP TABLE IF EXISTS banca.indicatori_clienti;
CREATE TABLE banca.indicatori_clienti
	SELECT 
		cli.id_cliente,
		cli_eta.eta,
		cli_tran_usc.num_trans_uscita,
		cli_tran_ent.num_trans_entrata,
		ROUND(cli_imp_usc.tot_trans_uscita,2) AS tot_trans_uscita,
		ROUND(cli_imp_ent.tot_trans_entrata,2) AS tot_trans_entrata,
        cli_con.tot_conti,
        cli_tip_con.num_conti_base,
        cli_tip_con.num_conti_business,
        cli_tip_con.num_conti_privati,
        cli_tip_con.num_conti_famiglie,
        cli_tip_tran_ent.num_trans_entrata_stipendio,
        cli_tip_tran_ent.num_trans_entrata_pensione,
        cli_tip_tran_ent.num_trans_entrata_dividendi,
        cli_tip_tran_usc.num_trans_uscita_amazon,
        cli_tip_tran_usc.num_trans_uscita_mutuo,
        cli_tip_tran_usc.num_trans_uscita_hotel,
        cli_tip_tran_usc.num_trans_uscita_aereo,
        cli_tip_tran_usc.num_trans_uscita_supermercato,
        ROUND(cli_imp_con_usc.tot_trans_uscita_conti_base,2) AS tot_trans_uscita_conti_base,
        ROUND(cli_imp_con_usc.tot_trans_uscita_conti_business,2) AS tot_trans_uscita_conti_business,
        ROUND(cli_imp_con_usc.tot_trans_uscita_conti_privati,2) AS tot_trans_uscita_conti_privati,
        ROUND(cli_imp_con_usc.tot_trans_uscita_conti_famiglie,2) AS tot_trans_uscita_conti_famiglie,
        ROUND(cli_imp_con_ent.tot_trans_entrata_conti_base,2) AS tot_trans_entrata_conti_base,
        ROUND(cli_imp_con_ent.tot_trans_entrata_conti_business,2) AS tot_trans_entrata_conti_business,
        ROUND(cli_imp_con_ent.tot_trans_entrata_conti_privati,2) AS tot_trans_entrata_conti_privati,
        ROUND(cli_imp_con_ent.tot_trans_entrata_conti_famiglie,2) AS tot_trans_entrata_conti_famiglie
	FROM
		banca.cliente AS cli
	LEFT JOIN 
		banca.tmp_cliente_eta AS cli_eta
		ON cli.id_cliente = cli_eta.id_cliente
	LEFT JOIN 
		banca.tmp_cliente_transazioni_uscita AS cli_tran_usc
		ON cli.id_cliente = cli_tran_usc.id_cliente
    LEFT JOIN 
		banca.tmp_cliente_transazioni_entrata AS cli_tran_ent
		ON cli.id_cliente = cli_tran_ent.id_cliente    
    LEFT JOIN 
		banca.tmp_cliente_importo_uscita AS cli_imp_usc
		ON cli.id_cliente = cli_imp_usc.id_cliente 
    LEFT JOIN 
		banca.tmp_cliente_importo_entrata AS cli_imp_ent
		ON cli.id_cliente = cli_imp_ent.id_cliente    
    LEFT JOIN 
		banca.tmp_cliente_conti AS cli_con
		ON cli.id_cliente = cli_con.id_cliente   
    LEFT JOIN 
		banca.tmp_cliente_tipo_conti AS cli_tip_con
		ON cli.id_cliente = cli_tip_con.id_cliente   
    LEFT JOIN 
		banca.tmp_cliente_tipo_transazioni_uscita AS cli_tip_tran_usc
		ON cli.id_cliente = cli_tip_tran_usc.id_cliente     
    LEFT JOIN 
		banca.tmp_cliente_tipo_transazioni_entrata AS cli_tip_tran_ent
		ON cli.id_cliente = cli_tip_tran_ent.id_cliente         
    LEFT JOIN 
		banca.tmp_cliente_importi_conti_uscita AS cli_imp_con_usc
		ON cli.id_cliente = cli_imp_con_usc.id_cliente    
    LEFT JOIN 
		banca.tmp_cliente_importi_conti_entrata AS cli_imp_con_ent
		ON cli.id_cliente = cli_imp_con_ent.id_cliente    
    ORDER BY cli.id_cliente ASC    
    