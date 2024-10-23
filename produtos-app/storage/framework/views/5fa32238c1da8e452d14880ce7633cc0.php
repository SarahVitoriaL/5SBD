<!DOCTYPE html>
<html>
<head>
    <title>Criar Produto</title>
</head>
<body>
    <h1>Criar Produto</h1>
    <form action="<?php echo e(route('produtos.store')); ?>" method="POST">
        <?php echo csrf_field(); ?>
        <label for="nome">Nome:</label>
        <input type="text" name="nome" required>
        <br>
        <label for="valor">Valor:</label>
        <input type="number" name="valor" step="0.01" required>
        <br>
        <label for="descricao">Descrição:</label>
        <textarea name="descricao"></textarea>
        <br>
        <button type="submit">Salvar</button>
    </form>
    <a href="<?php echo e(route('produtos.index')); ?>">Voltar</a>
</body>
</html>
<?php /**PATH C:\Users\sarah\Desktop\SBD\crud_orm\produtos-app\resources\views/produtos/create.blade.php ENDPATH**/ ?>