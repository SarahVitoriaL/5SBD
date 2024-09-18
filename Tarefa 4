DECLARE @idPedido INT, @quantidadeNecessaria INT, @quantidadeEstoque INT;
DECLARE @todosEmEstoque BIT;

-- Cursor para iterar sobre os pedidos
DECLARE pedidoCursor CURSOR
FOR
SELECT DISTINCT p.id
FROM Pedidos p;

OPEN pedidoCursor;
FETCH NEXT FROM pedidoCursor INTO @idPedido;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @todosEmEstoque = 1; -- Inicializa como verdadeiro

    -- Cursor para iterar sobre os itens do pedido atual
    DECLARE itemCursor CURSOR
    FOR
    SELECT pp.quantidade
    FROM PedidosItens pp
    WHERE pp.idPedido = @idPedido;

    OPEN itemCursor;
    FETCH NEXT FROM itemCursor INTO @quantidadeNecessaria;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Verificar a quantidade em estoque
        SELECT @quantidadeEstoque = quantidade
        FROM Estoque
        WHERE idItem = pp.idItem; -- Assuma que há uma coluna idItem em PedidosItens

        -- Verificar se há quantidade suficiente em estoque
        IF @quantidadeEstoque < @quantidadeNecessaria
        BEGIN
            SET @todosEmEstoque = 0; -- Marcar como falso se faltar algum item
            BREAK; -- Sai do loop se não tiver estoque suficiente
        END

        FETCH NEXT FROM itemCursor INTO @quantidadeNecessaria;
    END

    CLOSE itemCursor;
    DEALLOCATE itemCursor;

    -- Se todos os itens estiverem em estoque, debitar e atualizar
    IF @todosEmEstoque = 1
    BEGIN
        -- Atualizar o estoque para cada item do pedido
        DECLARE itemCursor2 CURSOR
        FOR
        SELECT pp.idItem, pp.quantidade
        FROM PedidosItens pp
        WHERE pp.idPedido = @idPedido;

        OPEN itemCursor2;
        FETCH NEXT FROM itemCursor2 INTO @idItem, @quantidadeNecessaria;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Debitar do estoque
            UPDATE Estoque
            SET quantidade = quantidade - @quantidadeNecessaria
            WHERE idItem = @idItem;

            FETCH NEXT FROM itemCursor2 INTO @idItem, @quantidadeNecessaria;
        END

        CLOSE itemCursor2;
        DEALLOCATE itemCursor2;

        -- Atualizar o status da entrega
        UPDATE Entrega
        SET status = 'ok'
        WHERE idPedido = @idPedido;
    END

    FETCH NEXT FROM pedidoCursor INTO @idPedido;
END

CLOSE pedidoCursor;
DEALLOCATE pedidoCursor;
