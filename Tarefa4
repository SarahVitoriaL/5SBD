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
    INNER JOIN itenspedido ip ON ip.codigoPedido = p.codigoPedido
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
            INSERT INTO compras (SKU, qtd)
            VALUES (aSKU, aqtd);  
            
            UPDATE pedidos
            SET status = 'pendente'
            WHERE codigoPedido = acodigoPedido;  

            SELECT CONCAT('Estoque insuficiente para SKU: ', aSKU, '. Necessário comprar: ', aqtd) AS mensagem;
        END IF;

    END LOOP;

    CLOSE pedidosCursor;

END //
DELIMITER ;
