--------------------------------------------------------------------------------------------- Tabela tempdata ---------------------------------------------------------------------------------------------------------

CREATE TABLE tempdata (
  codigoPedido VARCHAR(50) NOT NULL, 
  dataPedido DATE NOT NULL, 
  SKU VARCHAR (50) NOT NULL, 
  UPC VARCHAR (50) NOT NULL, 
  nomeProduto VARCHAR (255) NOT NULL, 
  qtd INT NOT NULL, 
  valor DECIMAL (9,2) NOT NULL, 
  frete DECIMAL (9,2) NOT NULL, 
  email VARCHAR(255) NOT NULL, 
  codigoComprador VARCHAR(50) NOT NULL, 
  nomeComprador VARCHAR(255) NOT NULL, 
  endereco VARCHAR(255) NOT NULL, 
  CEP VARCHAR(10) NOT NULL, 
  UF CHAR(2) NOT NULL, 
  pais VARCHAR(100) NOT NULL
);

LOAD DATA INFILE 'C:/Users/sarah/Downloads/produtos.csv'
INTO TABLE tempdata
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-------------------------------------------------------------------------------------------- Tabela clientes --------------------------------------------------------------------------------------------

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigoComprador VARCHAR(50) NOT NULL,
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
  SKU VARCHAR (50) NOT NULL,
  UPC VARCHAR (50) NOT NULL,
  nomeProduto VARCHAR (255) NOT NULL,
  valor DECIMAL (9,2) NOT NULL
);

INSERT INTO 5sdb . produtos (SKU, UPC, nomeProduto, valor)
SELECT DISTINCT SKU, UPC, nomeProduto, valor
FROM 5sdb . tempdata
GROUP BY SKU;

--------------------------------------------------------------------------------------------- Tabela pedidos ---------------------------------------------------------------------------------------------------------

CREATE TABLE pedidos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigoPedido VARCHAR(50) NOT NULL, 
  codigoComprador VARCHAR(50) NOT NULL, 
  valorPedido DECIMAL(9,2) NOT NULL,
  status VARCHAR(20) NOT NULL
);

INSERT INTO 5sdb . pedidos (codigoPedido, codigoComprador, valorPedido, status)
SELECT codigoPedido, codigoComprador, SUM(qtd * valor) AS valorPedido, 'pendente'
FROM 5sdb . tempdata
GROUP BY codigoPedido;

--------------------------------------------------------------------------------------------- Tabela itensPedido ---------------------------------------------------------------------------------------------------------

CREATE TABLE itensPedido (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codPedido VARCHAR(50) NOT NULL,
  SKU VARCHAR(50) NOT NULL,
  UPC VARCHAR(50) NOT NULL,
  qtd INT NOT NULL,
  valor DECIMAL(9,2) NOT NULL
);

INSERT INTO 5sdb . itensPedido (codigoPedido, SKU, UPC, qtd, valor)
SELECT codigoPedido, SKU, UPC, qtd, valor
FROM 5sdb . tempdata;

--------------------------------------------------------------------------------------------- Tabela entregas ---------------------------------------------------------------------------------------------------------

CREATE TABLE entregas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigoPedido INT NOT NULL,
  valor DECIMAL(9,2) NOT NULL
);

INSERT INTO 5sdb . entregas (codigoPedido, valor)
SELECT codigoPedido, valorPedido 
FROM 5sdb . pedidos;

--------------------------------------------------------------------------------------------- Tabela compras ---------------------------------------------------------------------------------------------------------

CREATE TABLE compras (
  id INT AUTO_INCREMENT PRIMARY KEY,
  SKU VARCHAR (50) NOT NULL,
  qtd INT NOT NULL,
);

--------------------------------------------------------------------------------------------- Tabela estoque ---------------------------------------------------------------------------------------------------------

CREATE TABLE estoque (
  id INT AUTO_INCREMENT PRIMARY KEY,
  SKU VARCHAR (50) NOT NULL,
  qtd INT NOT NULL
);

LOAD DATA INFILE 'C:/Users/sarah/Downloads/estoque.csv'
INTO TABLE estoque
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

--------------------------------------------------------------------------------------------- Cursor ---------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE cursor_pedidos ()

BEGIN
    DECLARE acodigoPedido VARCHAR(20);
    DECLARE avalorPedido DECIMAL(9,2);  
    DECLARE aSKU VARCHAR(50);
    DECLARE aqtd INT;
    DECLARE pronto INT DEFAULT 0;

    DECLARE pedidosCursor CURSOR FOR
    SELECT p.codigoPedido, p.valorPedido, ip.SKU, ip.qtd  
    FROM pedidos p
    INNER JOIN itenspedido ip ON ip.codPedido = p.codigoPedido
    WHERE p.status = 'pendente'
    ORDER BY p.valorPedido DESC;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET pronto = 1;

    OPEN pedidosCursor;

    read_loop: LOOP
        FETCH pedidosCursor INTO acodigoPedido, avalorPedido, aSKU, aqtd;

        IF pronto THEN
            LEAVE read_loop;
        END IF;

        IF (SELECT qtd FROM estoque WHERE SKU = aSKU LIMIT 1) >= aqtd THEN

            -- Se houver estoque suficiente, diminui a quantidade
            UPDATE estoque
            SET qtd = qtd - aqtd
            WHERE SKU = aSKU; 

            -- Atualiza o status do pedido para 'ok'
            UPDATE pedidos
            SET status = 'ok'
            WHERE codigoPedido = acodigoPedido;  

            -- Insere na tabela de entregas
            INSERT INTO entregas (codigoPedido, valor)
            VALUES (acodigoPedido, avalorPedido);

            SELECT CONCAT('Estoque atualizado para SKU: ', aSKU, ', pedido alterado para status: ok e registrado na tabela de entregas.') AS mensagem;

        ELSE
            -- Se não houver estoque suficiente, registrar na tabela de compras
            INSERT INTO compras (SKU, quant)
            VALUES (aSKU, aqtd);  
            
            UPDATE pedidos
            SET status = 'pendente'
            WHERE codigoPedido = acodigoPedido;  

            SELECT CONCAT('Estoque insuficiente para SKU: ', aSKU, '. Necessário comprar: ', aqtd) AS mensagem;
        END IF;

    END LOOP;

    CLOSE pedidosCursor;

END //
DELIMITER;
