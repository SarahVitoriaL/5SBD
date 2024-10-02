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
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

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
  dataPedido DATE NOT NULL, 
  valorPedido DECIMAL(9,2) NOT NULL,
  status VARCHAR(20) NOT NULL
);

INSERT INTO 5sdb . pedidos (codigoPedido, codigoComprador, dataPedido, valorPedido, status)
SELECT codigoPedido, codigoComprador, dataPedido, SUM(qtd * valor) AS valorPedido, 'pendente'
FROM 5sdb . tempdata
GROUP BY codigoPedido;

--------------------------------------------------------------------------------------------- Tabela itensPedido ---------------------------------------------------------------------------------------------------------

CREATE TABLE itensPedido (
  id INT AUTO_INCREMENT PRIMARY KEY,
  idPedido INT NOT NULL,
  codPedido VARCHAR(50) NOT NULL,
  SKU VARCHAR(50) NOT NULL,
  UPC VARCHAR(50) NOT NULL,
  qtd INT NOT NULL,
  valor DECIMAL(9,2) NOT NULL
);

INSERT INTO 5sdb . itensPedido (codPedido, SKU, UPC, qtd, valor)
SELECT codigoPedido, SKU, UPC, qtd, valor
FROM 5sdb . tempdata;

--------------------------------------------------------------------------------------------- Tabela entregas ---------------------------------------------------------------------------------------------------------

CREATE TABLE entregas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  idPedido INT NOT NULL,
  valor DECIMAL(9,2) NOT NULL
);

INSERT INTO 5sdb . entregas (idPedido, valor)
SELECT id, valorPedido 
FROM 5sdb . pedidos;

--------------------------------------------------------------------------------------------- Tabela compras ---------------------------------------------------------------------------------------------------------

CREATE TABLE compras (
  id INT AUTO_INCREMENT PRIMARY KEY,
  SKU VARCHAR (50) NOT NULL,
  qtd INT NOT NULL,
);

--------------------------------------------------------------------------------------------- Tabela estoque ---------------------------------------------------------------------------------------------------------

CREATE TABLE estoque (
  idProduto INT NOT NULL,
  codigoProduto VARCHAR(20) NOT NULL,
  qtd INT NOT NULL
);

LOAD DATA INFILE 'C:/Users/sarah/Downloads/estoque.csv'
INTO TABLE estoque
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

--------------------------------------------------------------------------------------------- Cursor ---------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE cursor_pedidos ()

BEGIN
    DECLARE codigoPedido VARCHAR(20);
    DECLARE valorPedido DECIMAL(9,2);  
    DECLARE status VARCHAR(20); 
    DECLARE SKU VARCHAR(50);
    DECLARE qtd INT;
    DECLARE estoqueQtd INT;
    DECLARE done INT DEFAULT 0;

    DECLARE pedidosCursor CURSOR FOR
    SELECT p.codigoPedido, p.valorPedido, p.status, ip.SKU, ip.qtd  
    FROM pedidos p
    INNER JOIN itensPedido ip ON ip.codPedido = p.codigoPedido  
    WHERE p.status = 'pendente'
    ORDER BY p.valorPedido DESC;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN pedidosCursor;

    read_loop: LOOP
        FETCH pedidosCursor INTO codigoPedido, valorPedido, status, SKU, qtd;

        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Verificar a quantidade disponível no estoque
        SELECT e.qtd INTO estoqueQtd
        FROM estoque e
        WHERE e.SKU = sku;

        IF estoqueQtd >= qtd THEN
            -- Se houver estoque suficiente
            UPDATE estoque
            SET qtd = estoqueQtd - qtd
            WHERE SKU = sku;  

            -- Atualiza o status do pedido para 'ok'
            UPDATE pedidos
            SET status = 'ok'
            WHERE codigoPedido = codigoPedido;

            -- Insere na tabela de entregas
            INSERT INTO entregas (codigoPedido, valor)
            VALUES (codigoPedido, valorPedido);

            SELECT CONCAT('Estoque atualizado para SKU: ', SKU, ', pedido alterado para status: ok e registrado na tabela de entregas.') AS mensagem;
        ELSE
            -- Se não houver estoque suficiente, registrar na tabela de compras
            INSERT INTO compras (SKU, quant)
            VALUES (SKU, GREATEST(qtd - estoqueQtd, 0));  -- Garantir que não será negativo

            SELECT CONCAT('Estoque insuficiente para SKU: ', SKU, '. Necessário comprar: ', qtd - estoqueQtd) AS mensagem;
        END IF;

    END LOOP;

    CLOSE pedidosCursor;

END //
DELIMITER;
