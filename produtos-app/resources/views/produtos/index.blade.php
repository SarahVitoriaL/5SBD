<!DOCTYPE html>
<html>
<head>
    <title>Produtos</title>
</head>
<body>
    <h1>Lista de Produtos</h1>
    <a href="{{ route('produtos.create') }}">Adicionar Produto</a>
    <ul>
        @foreach ($produtos as $produto)
            <li>
                {{ $produto->nome }} - R$ {{ $produto->valor }}
                <a href="{{ route('produtos.edit', $produto) }}">Editar</a>
                <form action="{{ route('produtos.destroy', $produto) }}" method="POST" style="display:inline;">
                    @csrf
                    @method('DELETE')
                    <button type="submit">Excluir</button>
                </form>
            </li>
        @endforeach
    </ul>
</body>
</html>
