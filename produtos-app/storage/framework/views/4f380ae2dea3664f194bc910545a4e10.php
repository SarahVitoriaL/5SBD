<!DOCTYPE html>
<html>
<head>
    <title>Produtos</title>
</head>
<body>
    <h1>Lista de Produtos</h1>
    <a href="<?php echo e(route('produtos.create')); ?>">Adicionar Produto</a>
    <ul>
        <?php $__currentLoopData = $produtos; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $produto): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <li>
                <?php echo e($produto->nome); ?> - R$ <?php echo e($produto->valor); ?>

                <a href="<?php echo e(route('produtos.edit', $produto)); ?>">Editar</a>
                <form action="<?php echo e(route('produtos.destroy', $produto)); ?>" method="POST" style="display:inline;">
                    <?php echo csrf_field(); ?>
                    <?php echo method_field('DELETE'); ?>
                    <button type="submit">Excluir</button>
                </form>
            </li>
        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
    </ul>
</body>
</html>
<?php /**PATH C:\Users\sarah\Desktop\SBD\crud_orm\produtos-app\resources\views/produtos/index.blade.php ENDPATH**/ ?>