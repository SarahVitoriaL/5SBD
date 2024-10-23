<!DOCTYPE html>
<html>
<head>
    <title>Editar Produto</title>
</head>
<body>
    <h1>Editar Produto</h1>
    <form action="{{ route('produtos.update', $produto) }}" method="POST">
        @csrf
        @method('PUT')
        <label for="nome">Nome:</label>
        <input type="text" name="nome" value="{{ $produto->nome }}" required>
        <br>
        <label for="valor">Valor:</label>
        <input type="number" name="valor" step="0.01" value="{{ $produto->valor }}" required>
        <br>
        <label for="descricao">Descrição:</label>
        <textarea name="descricao">{{ $produto->descricao }}</textarea>
        <br>
        <button type="submit">Atualizar</button>
    </form>
    <a href="{{ route('produtos.index') }}">Voltar</a>
</body>
</html>
