--------------------------------------------------------------------------------------------- Tabela tempdata ---------------------------------------------------------------------------------------------------------

CREATE TABLE tempdata (
  codigoPedido, 
  dataPedido, 
  SKU, 
  UPC, 
  nomeProduto, 
  qtd, 
  valor, 
  frete, 
  email, 
  codigoComprador, 
  nomeComprador, 
  endereco, 
  CEP, 
  UF, 
  pais
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

--------------------------------------------------------------------------------------------- Tabela pedidos ---------------------------------------------------------------------------------------------------------

CREATE TABLE pedidos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigoPedido INT PRIMARY KEY, 
  codigoComprador INT NOT NULL, 
  dataPedido DATE NOT NULL, 
  valorPedido DECIMAL(10,2) NOT NULL  
);

--------------------------------------------------------------------------------------------- Tabela itensPedido ---------------------------------------------------------------------------------------------------------

CREATE TABLE itensPedido (
  id INT AUTO_INCREMENT PRIMARY KEY,
  idPedido INT NOT NULL,
  
);
--------------------------------------------------------------------------------------------- Tabela entregas ---------------------------------------------------------------------------------------------------------

CREATE TABLE entregas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  
);

--------------------------------------------------------------------------------------------- Tabela compras ---------------------------------------------------------------------------------------------------------

CREATE TABLE compras (
  id INT AUTO_INCREMENT PRIMARY KEY,
  idProduto INT NOT NULL,
  SKU VARCHAR (50) PRIMARY KEY,
  UPC VARCHAR (50) NOT NULL,
  qtd INT NOT NULL,
  loja
);

--------------------------------------------------------------------------------------------- Tabela estoque ---------------------------------------------------------------------------------------------------------

CREATE TABLE estoque (
  idProduto INT NOT NULL,
  qtd INT NOT NULL
);

--------------------------------------------------------------------------------------------- Cursor ---------------------------------------------------------------------------------------------------------

