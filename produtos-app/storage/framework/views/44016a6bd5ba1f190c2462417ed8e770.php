<!DOCTYPE html>
<html>
<head>
    <title>Editar Produto</title>
</head>
<body>
    <h1>Editar Produto</h1>
    <form action="<?php echo e(route('produtos.update', $produto)); ?>" method="POST">
        <?php echo csrf_field(); ?>
        <?php echo method_field('PUT'); ?>
        <label for="nome">Nome:</label>
        <input type="text" name="nome" value="<?php echo e($produto->nome); ?>" required>
        <br>
        <label for="valor">Valor:</label>
        <input type="number" name="valor" step="0.01" value="<?php echo e($produto->valor); ?>" required>
        <br>
        <label for="descricao">Descrição:</label>
        <textarea name="descricao"><?php echo e($produto->descricao); ?></textarea>
        <br>
        <button type="submit">Atualizar</button>
    </form>
    <a href="<?php echo e(route('produtos.index')); ?>">Voltar</a>
</body>
</html>
<?php /**PATH C:\Users\sarah\Desktop\SBD\crud_orm\produtos-app\resources\views/produtos/edit.blade.php ENDPATH**/ ?>