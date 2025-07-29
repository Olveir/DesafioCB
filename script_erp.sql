CREATE SCHEMA IF NOT EXISTS erp_star;

USE erp_star;

CREATE TABLE IF NOT EXISTS dim_local (
	id_local int primary key,
    ref_loc VARCHAR(50) not null unique,
    dh_geracao TIMESTAMP not null
);

CREATE TABLE IF NOT EXISTS dim_data_comercio (
	id_data_comercio int primary key,
    dt_abertura_comercial DATE NOT NULL,
    dt_fechamento_comercial DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_comanda (
	num_comanda int primary key,
    dh_abertura_comanda_utc DATETIME(6) NOT NULL,
    dh_abertura_comanda_lcl DATETIME(6) NOT NULL,
    dh_fechamento_comanda_utc DATETIME(6),
    dh_fechamento_comanda_lcl DATETIME(6),
	status_comanda BOOLEAN NOT NULL,
	num_tipo_pedido INT NOT NULL,
    num_categoria_pedido INT,
    num_rodadas_servico INT NOT NULL,
    qtd_comanda_impressa INT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_taxas (
	id_taxa INT PRIMARY KEY,
    ttl_item DECIMAL(10,2),
    ttl_imposto DECIMAL(10,2),
    alqt_imposto INT,
    tipo INT
);

CREATE TABLE IF NOT EXISTS dim_valores (
	id_valores int primary key,
    sub_ttl DECIMAL(10,2) NOT NULL,
    ttl_vendas_sem_imposto DECIMAL(10,2),
    ttl_desconto DECIMAL(10,2),
    id_taxa int not null,
	FOREIGN KEY (id_taxa) REFERENCES dim_taxas(id_taxa)
);


CREATE TABLE IF NOT EXISTS dim_mesas (
	num_mesa int primary key,
    nome_mesa VARCHAR(20) NOT NULL,
	num_assentos INT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_funcionario (
	num_funcionario int primary key
);

CREATE TABLE IF NOT EXISTS fato_comandas (
    id_comanda INT PRIMARY KEY,
    id_local int NOT NULL,
    num_comanda INT NOT NULL,
    id_data_comercio int not null,
    dh_ultima_transacao_utc DATETIME(6),
    dh_ultima_transacao_lcl DATETIME(6),
    dh_atu_comanda_utc DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    dh_atu_comanda_lcl DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    qtd_clientes INT NOT NULL,
    id_valores int not null,
    ttl_comanda DECIMAL(10,2) NOT NULL,
    ttl_pago DECIMAL(10,2),
    ttl_devedor DECIMAL(10,2),
    num_centro_receita INT NOT NULL,
    num_mesa INT NOT NULL,
    num_funcionario INT NOT NULL,
    valor_servico decimal(10,2),
    forma_pagamento varchar(100),
    FOREIGN KEY (id_local) REFERENCES dim_local(id_local),
	FOREIGN KEY (num_comanda) REFERENCES dim_comanda(num_comanda),
    FOREIGN KEY (num_mesa) REFERENCES dim_mesas(num_mesa),
    FOREIGN KEY (id_valores) REFERENCES dim_valores(id_valores),
    FOREIGN KEY (id_data_comercio) REFERENCES dim_data_comercio(id_data_comercio),
    FOREIGN KEY (num_funcionario) REFERENCES dim_funcionario(num_funcionario)
);

CREATE TABLE IF NOT EXISTS dim_detalhe_item (
	id_dtl int primary key,
    num_dtl_tipo_item INT NOT NULL,
    num_dtl_categoria_item INT NOT NULL,
    dh_atu_dtl_utc DATETIME(6) NOT NULL,
    dh_atu_dtl_lcl DATETIME(6) NOT NULL,
	num_rodada_servico_pedido INT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_funcionario_item (
	id_funcionario int primary key,
    num_funcionario INT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_item_menu (
    id_item_menu INT PRIMARY KEY,
    modificado BOOLEAN NOT NULL,
    taxas_ativas int,
    categoria_preco INT NOT NULL,
    FOREIGN KEY (taxas_ativas) REFERENCES dim_taxas(id_taxa)
);

CREATE TABLE IF NOT EXISTS fato_item (
    id_item INT PRIMARY KEY,
    id_comanda INT NOT NULL,
	id_funcionario INT NOT NULL,
    id_item_menu int not null,
    num_centro_receita INT NOT NULL,
    id_dtl INT NOT NULL,
    dh_atu_utc DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    dh_atu_lcl DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    num_estacao_trabalho INT NOT NULL,
    ttl_item_exib DECIMAL(10,2) NOT NULL,
    qtd_item_exib INT NOT NULL,
    ttl_item_agg DECIMAL(10,2) NOT NULL,
    qtd_item_agg  INT NOT NULL,
    desconto decimal(10,2),
    codigo_erro varchar(50),
    FOREIGN KEY (id_comanda) REFERENCES fato_comandas(id_comanda),
    FOREIGN KEY (id_funcionario) REFERENCES dim_funcionario_item(id_funcionario),
    FOREIGN KEY (id_item_menu) REFERENCES dim_item_menu(id_item_menu),
    FOREIGN KEY (id_dtl) REFERENCES dim_detalhe_item(id_dtl)
);