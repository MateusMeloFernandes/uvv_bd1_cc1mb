--Destruição do banco de dados uvv se já existe

DROP DATABASE IF EXISTS uvv;

-- Destruição do usuário mateus se já existe

DROP USER IF EXISTS mateus;

-- Destruição do esquema lojas se já existe

DROP SCHEMA IF EXISTS lojas CASCADE;

-- Criação do usuário mateus

CREATE USER mateus WITH CREATEDB INHERIT LOGIN PASSWORD '574842';

-- Criação do Banco de Dados uvv

CREATE DATABASE uvv
owner mateus
template template0
encoding 'UTF8'
lc_collate 'pt_BR.UTF-8'
lc_ctype 'pt_BR.UTF-8' 
allow_connections TRUE;

-- Troca de conexão

\c 'dbname=uvv user=mateus password=574842'

-- Criando e Definindo o esquema "lojas" como padrão

CREATE SCHEMA lojas AUTHORIZATION mateus;
ALTER USER mateus SET SEARCH_PATH TO lojas, "$user", public;
SET SEARCH_PATH TO lojas, "$user", public;
GRANT ALL PRIVILEGES ON SCHEMA lojas TO mateus;

-- Criação da tabela produtos

CREATE TABLE produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_id_pk PRIMARY KEY (produto_id)
);

-- Comentário da tabela produtos

COMMENT ON TABLE produtos IS 'tabela contendo as informações dos produtos';

-- Comentários das colunas da tabela produtos

COMMENT ON COLUMN produtos.produto_id 				 IS 'Código de Identificação único do produto';
COMMENT ON COLUMN produtos.nome 					 IS 'Nome do produto';
COMMENT ON COLUMN produtos.preco_unitario 			 IS 'Preço unitário do produto';
COMMENT ON COLUMN produtos.detalhes 				 IS 'Detalhes extras do produto';
COMMENT ON COLUMN produtos.imagem 					 IS 'Imagem do produto';
COMMENT ON COLUMN produtos.imagem_mime_type 		 IS 'Tipo MIME da imagem do produto';
COMMENT ON COLUMN produtos.imagem_arquivo 			 IS 'Arquivo da imagem do produto';
COMMENT ON COLUMN produtos.imagem_charset 			 IS 'Charset da imagem do produto';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 'Data de última atualização da imagem do produto';

ALTER TABLE produtos
ADD CONSTRAINT preco_nao_negativo
CHECK (preco_unitario >= 0);

-- Criação da tabela lojas

CREATE TABLE lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT loja_id_pk PRIMARY KEY (loja_id)
);

-- Comentário da tabela lojas

COMMENT ON TABLE lojas IS 'tabela contendo as informações das lojas';

-- Comentários das colunas da tabela lojas

COMMENT ON COLUMN lojas.loja_id         		IS 'Código de Identificação único da loja';
COMMENT ON COLUMN lojas.nome 					IS 'Nome da loja';
COMMENT ON COLUMN lojas.endereco_web 			IS 'Endereço web da loja';
COMMENT ON COLUMN lojas.endereco_fisico 		IS 'Endereço físico da loja';
COMMENT ON COLUMN lojas.latitude 				IS 'Latitude da localização da loja';
COMMENT ON COLUMN lojas.longitude 				IS 'Longitude da localização da loja';
COMMENT ON COLUMN lojas.logo 					IS 'Logo da loja';
COMMENT ON COLUMN lojas.logo_mime_type 			IS 'Tipo MIME do logo da loja';
COMMENT ON COLUMN lojas.logo_arquivo 			IS 'Arquivo do logo da loja';
COMMENT ON COLUMN lojas.logo_charset 			IS 'Charset do logo da loja';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS 'Data de última atualização do logo da loja';

ALTER TABLE lojas 
ADD CONSTRAINT endereco_web_ou_fisico 
CHECK (endereco_web IS not null OR endereco_fisico IS not null);

-- Criação da tabela estoques

CREATE TABLE estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoque_id_pk PRIMARY KEY (estoque_id)
);

-- Comentário da tabela estoques

COMMENT ON TABLE estoques IS 'tabela contendo informações dos estoques das lojas';

-- Comentários das colunas da tabela estoques

COMMENT ON COLUMN estoques.estoque_id IS 'Código de Identificação único do estoque';
COMMENT ON COLUMN estoques.loja_id 	  IS 'Código de Identificação único da loja referente ao estoque';
COMMENT ON COLUMN estoques.produto_id IS 'Código de Identificação único do produto referente ao estoque';
COMMENT ON COLUMN estoques.quantidade IS 'Quantidade de produtos no estoque';

-- Criação da tabela clientes

CREATE TABLE clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT cliente_id_pk PRIMARY KEY (cliente_id)
);

-- Comentário da tabela clientes

COMMENT ON TABLE clientes IS 'tabela contendo as informações dos clientes';

-- Comentários das colunas da tabela clientes
COMMENT ON COLUMN clientes.cliente_id IS 'Código de Identificação único do cliente';
COMMENT ON COLUMN clientes.email 	  IS 'Email do cliente';
COMMENT ON COLUMN clientes.nome 	  IS 'Nome do cliente';
COMMENT ON COLUMN clientes.telefone1  IS 'Telefone 1 do cliente';
COMMENT ON COLUMN clientes.telefone2  IS 'Telefone 2 do cliente';
COMMENT ON COLUMN clientes.telefone3  IS 'Telefone 3 do cliente';

-- Criação da tabela envios

CREATE TABLE envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envio_id_pk PRIMARY KEY (envio_id)
);

-- Comentário da tabela envios

COMMENT ON TABLE envios IS 'tabela contendo informações de todos os envios entre as lojas e clientes';

-- Comentário das colunas da tabela envios

COMMENT ON COLUMN envios.envio_id 		  IS 'Código de Identificação único do envio';
COMMENT ON COLUMN envios.loja_id 		  IS 'Código de Identificação único da loja referente ao envio';
COMMENT ON COLUMN envios.cliente_id 	  IS 'Código de Identificação único do cliente referente ao destino do envio';
COMMENT ON COLUMN envios.endereco_entrega IS 'Endereço de entrega do envio';
COMMENT ON COLUMN envios.status 		  IS 'Status do envio';

ALTER TABLE envios
ADD CONSTRAINT status_do_envio
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE')
);

--Criação da tabela pedidos

CREATE TABLE pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT pedido_id_pk PRIMARY KEY (pedido_id)
);

-- Comentário da tabela pedidos

COMMENT ON TABLE pedidos IS 'tabela contendo os pedidos feitos nas lojas';

-- Comentário das colunas tabela pedidos

COMMENT ON COLUMN pedidos.pedido_id  IS 'Código de Identificação único do pedido';
COMMENT ON COLUMN pedidos.data_hora  IS 'Data e hora do pedido';
COMMENT ON COLUMN pedidos.cliente_id IS 'Código de Identificação único do cliente que fez o pedido';
COMMENT ON COLUMN pedidos.status 	 IS 'Status do pedido';

-- Criação da tabela pedidos_itens

CREATE TABLE pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                CONSTRAINT pedido_id_pk_e_produto_id PRIMARY KEY (pedido_id, produto_id)
);

-- Comentário da tabela pedidos_itens

COMMENT ON TABLE pedidos_itens IS 'tabela contendo informações de todos os itens pedidos';

-- Comentários das colunas da tabela pedidos_itens

COMMENT ON COLUMN pedidos_itens.pedido_id 		IS 'Código de Identificação único do pedido referente ao item';
COMMENT ON COLUMN pedidos_itens.produto_id 		IS 'Código do produto referente ao item';
COMMENT ON COLUMN pedidos_itens.numero_da_linha IS 'Número da linha do item referente ao pedido';
COMMENT ON COLUMN pedidos_itens.preco_unitario  IS 'Preço unitário do item referente ao pedido';
COMMENT ON COLUMN pedidos_itens.quantidade 		IS 'Quantidade de itens referente ao pedido';
COMMENT ON COLUMN pedidos_itens.envio_id 		IS 'Código de Identificação único do envio do item referente ao pedido';

ALTER TABLE pedidos
ADD CONSTRAINT status_do_pedido
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO')
);


-- Criação dos relacionamento entre as tabelas

ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
