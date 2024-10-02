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
  valorPedido DECIMAL(9,2) NOT NULL  
);

INSERT INTO 5sdb . pedidos (codigoPedido, codigoComprador, dataPedido, valorPedido)
SELECT codigoPedido, codigoComprador, dataPedido, SUM (qtd * valor) AS valorPedido
FROM 5sdb . tempdata
GROUP BY codigoPedido;

--------------------------------------------------------------------------------------------- Tabela itensPedido ---------------------------------------------------------------------------------------------------------

CREATE TABLE itensPedido (
  id INT AUTO_INCREMENT PRIMARY KEY,
  idPedido INT NOT NULL,
  codigoPedido VARCHAR(50) NOT NULL,
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
  idPedido INT NOT NULL,
  valor DECIMAL(9,2) NOT NULL
);

INSERT INTO 5sdb . entregas (idPedido, valor)
SELECT id, valorPedido 
FROM 5sdb . pedidos;

--------------------------------------------------------------------------------------------- Tabela compras ---------------------------------------------------------------------------------------------------------

CREATE TABLE compras (
  id INT AUTO_INCREMENT PRIMARY KEY,
  idProduto INT NOT NULL,
  SKU VARCHAR (50) PRIMARY KEY,
  UPC VARCHAR (50) NOT NULL,
  qtd INT NOT NULL,
  codigoLoja VARCHAR (50) NOT NULL
);

--------------------------------------------------------------------------------------------- Tabela estoque ---------------------------------------------------------------------------------------------------------

CREATE TABLE estoque (
  idProduto INT NOT NULL,
  qtd INT NOT NULL
);

LOAD DATA INFILE 'C:/Users/sarah/Downloads/estoque.csv'
INTO TABLE estoque
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

--------------------------------------------------------------------------------------------- Cursor ---------------------------------------------------------------------------------------------------------
 
DECLARE @id INT, @total DECIMAL(9,2), @status INT, @upc VARCHAR(50), @nome VARCHAR(50), @qtd INT;
DECLARE @estoqueQtd INT;

DECLARE pedidosCursor CURSOR FOR
SELECT p.id, p.total, p.status, ip.sku, ip.nome, ip.qtd  
FROM [pedidos] p
INNER JOIN itensPedido ip ON ip.idPedido = p.id
ORDER BY p.total DESC;

OPEN pedidosCursor;
FETCH NEXT FROM pedidosCursor INTO @id, @total, @status, @sku, @nome, @qtd;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Verificar a quantidade disponível no estoque
    SELECT @estoqueQuantidade = e.qtd
    FROM estoque e
    WHERE e.sku = @sku;

    IF @estoqueQuantidade >= @qtd
    BEGIN
        -- Se houver estoque suficiente, diminui a quantidade
        UPDATE estoque
        SET qtd = qtd - @qtd
        WHERE sku = @sku;

        PRINT('Estoque atualizado para SKU: ' + @sku);
    END
    ELSE
    BEGIN
        -- Se não houver estoque suficiente, registrar na tabela de compras
        INSERT INTO compras (sku, quantidadeNecessaria)
        VALUES (@sku, @qtd - @estoqueQuantidade);

        PRINT('Estoque insuficiente para SKU: ' + @sku + '. Necessário comprar: ' + CONVERT(VARCHAR, @qtd - @estoqueQuantidade));
    END

    FETCH NEXT FROM pedidosCursor INTO @id, @total, @status, @sku, @nome, @qtd;
END

CLOSE pedidosCursor;
DEALLOCATE pedidosCursor;
