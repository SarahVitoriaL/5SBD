LOAD DATA INFILE 'C:/Users/sarah/Downloads/dados.csv'
INTO TABLE tempdata
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

------------------------------------------------------------------------ Tabela cliente -----------------------------------------------------------------------------------------

CREATE TABLE cliente (
    codigoComprador VARCHAR(50) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nomeComprador VARCHAR(255) NOT NULL,  
    endereco VARCHAR(255) NOT NULL,     
    CEP VARCHAR(10) NOT NULL,           
    UF CHAR(2) NOT NULL,               
    pais VARCHAR(100) NOT NULL         
);

CREATE UNIQUE INDEX idx_email ON cliente(email);

INSERT INTO 5sdb . cliente (codigoComprador, nomeComprador, email, endereco, CEP, UF, pais)
SELECT DISTINCT codigoComprador, nomeComprador, email, endereco, CEP, UF, pais
FROM 5sdb . tempdata
GROUP BY codigoComprador;

------------------------------------------------------------------------ Tabela produto -----------------------------------------------------------------------------------------

CREATE TABLE produto (
    SKU VARCHAR (50) PRIMARY KEY,
    UPC VARCHAR (50) NOT NULL,
    nomeProduto VARCHAR (255) NOT NULL,
    valor DECIMAL (10,2) NOT NULL
);

CREATE UNIQUE INDEX idx_upc ON produto(UPC);

INSERT INTO 5sdb . produto (SKU, UPC, nomeProduto, valor)
SELECT DISTINCT SKU, UPC, nomeProduto, valor
FROM 5sdb . tempdata
GROUP BY SKU;

------------------------------------------------------------------------ Tabela estoque --------------------------------------------------------------------------------------------

CREATE TABLE estoque (
    SKU VARCHAR(50) PRIMARY KEY,
    UPC VARCHAR(50) NOT NULL,
    qtd INT NOT NULL,
);

------------------------------------------------------------------------ Tabela itemPedido -----------------------------------------------------------------------------------------

CREATE TABLE itemPedido (
    codigoPedido INT NOT NULL,
    SKU VARCHAR(50) NOT NULL,
    UPC VARCHAR(50) NOT NULL,
    qtd INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (codigoPedido) REFERENCES pedido(codigoPedido)
);

INSERT INTO 5sdb . itemPedido (codigoPedido, SKU, UPC, qtd, valor)
SELECT codigoPedido, SKU, UPC, qtd, valor
FROM 5sdb . tempdata;

------------------------------------------------------------------------ Tabela pedido -----------------------------------------------------------------------------------------

CREATE TABLE pedido (
    codigoPedido INT PRIMARY KEY, 
    codigoComprador INT NOT NULL, 
    dataPedido DATE NOT NULL, 
    valorPedido DECIMAL(10,2) NOT NULL
    FOREIGN KEY (codigoComprador) REFERENCES cliente (codigoComprador)
);

INSERT INTO 5sdb . pedido (codigoPedido, codigoComprador, dataPedido, valorPedido)
SELECT codigoPedido, codigoComprador, dataPedido, SUM (qtd * valor) AS valorPedido
FROM 5sdb . tempdata
GROUP BY codigoPedido;

------------------------------------------------------------------------ Tabela compra -----------------------------------------------------------------------------------------

CREATE TABLE compra (
    codigoPedido VARCHAR(50) PRIMARY KEY,
    valorCompra DECIMAL (10,2) NOT NULL,
    fretePedido DECIMAL (10,2) NOT NULL
);

INSERT INTO 5sdb . compra (codigoPedido, valorCompra, fretePedido)
SELECT codigoPedido, SUM (qtd * valor) AS valorCompra, SUM(`frete`) AS fretePedido
FROM `5sdb`.`tempdata`
GROUP BY `codigoPedido`;

------------------------------------------------------------------------ Tabela entrega -----------------------------------------------------------------------------------------

CREATE TABLE entrega (
    codigoPedido VARCHAR(50) PRIMARY KEY,
    endereco VARCHAR(255) NOT NULL,     
    CEP VARCHAR(10) NOT NULL,           
    UF CHAR(2) NOT NULL,               
    pais VARCHAR(100) NOT NULL 
);

INSERT INTO 5sdb . entrega (codigoPedido, endereco, CEP, UF, pais)
SELECT DISTINCT codigoPedido, endereco, CEP, UF, pais
FROM 5sdb . tempdata;
