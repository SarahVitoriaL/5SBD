--------------------------------------------------------------------------------------------- Tabela tempdata ---------------------------------------------------------------------------------------------------------

CREATE TABLE tempdata (
  
);

LOAD DATA INFILE 'C:/Users/sarah/Downloads/produtos.csv'
INTO TABLE tempdata
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-------------------------------------------------------------------------------------------- Tabela clientes --------------------------------------------------------------------------------------------

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigoComprador VARCHAR(50) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nomeComprador VARCHAR(255) NOT NULL,  
    endereco VARCHAR(255) NOT NULL,     
    CEP VARCHAR(10) NOT NULL,           
    UF CHAR(2) NOT NULL,               
    pais VARCHAR(100) NOT NULL 
);

INSERT INTO 5sdb . clientes (codigoComprador, nomeComprador, email, endereco, CEP, UF, pais)
SELECT DISTINCT codigoComprador, nomeComprador, email, endereco, CEP, UF, pais
FROM 5sdb . tempdata
GROUP BY codigoComprador;

--------------------------------------------------------------------------------------------- Tabela produtos ---------------------------------------------------------------------------------------------------------

CREATE TABLE produtos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  SKU VARCHAR (50) PRIMARY KEY,
  UPC VARCHAR (50) NOT NULL,
  nomeProduto VARCHAR (255) NOT NULL,
  valor DECIMAL (10,2) NOT NULL
);

INSERT INTO 5sdb . produtos (SKU, UPC, nomeProduto, valor)
SELECT DISTINCT SKU, UPC, nomeProduto, valor
FROM 5sdb . tempdata
GROUP BY SKU;

--------------------------------------------------------------------------------------------- Tabela itensPedido ---------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------- Tabela pedidos ---------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------- Tabela entregas ---------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------- Tabela compras ---------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------- Cursor ---------------------------------------------------------------------------------------------------------

-- 
