<?php

namespace App\Http\Controllers;


/**
 * @OA\Info(
 *     title="API de Tripulantes",
 *     version="1.0.0",
 *     description="Esta API permite gerenciar tripulantes e suas informações.",
 *     @OA\Contact(
 *         email="suporte@companhiaaerea.com"
 *     ),
 *     @OA\License(
 *         name="MIT",
 *         url="https://opensource.org/licenses/MIT"
 *     )
 * )
 */
use App\Models\Tripulante;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

/**
 * @OA\Tag(
 *     name="Tripulantes",
 *     description="Gerenciamento de tripulantes"
 * )
 */

/**
 * @OA\PathItem(
 *     path="/api/tripulantes",
 *     operations={
 *         @OA\Get(
 *             summary="Lista todos os tripulantes",
 *             @OA\Response(
 *                 response=200,
 *                 description="Retorna todos os tripulantes",
 *                 @OA\JsonContent(type="array", @OA\Items(ref="#/components/schemas/Tripulante"))
 *             )
 *         ),
 *         @OA\Post(
 *             summary="Cria um novo tripulante",
 *             @OA\RequestBody(
 *                 required=true,
 *                 @OA\JsonContent(ref="#/components/schemas/Tripulante")
 *             ),
 *             @OA\Response(
 *                 response=201,
 *                 description="Tripulante criado com sucesso",
 *                 @OA\JsonContent(ref="#/components/schemas/Tripulante")
 *             )
 *         )
 *     }
 * )
 */

/**
 * @OA\Schema(
 *     schema="Tripulante",
 *     type="object",
 *     @OA\Property(property="id", type="integer"),
 *     @OA\Property(property="nome", type="string"),
 *     @OA\Property(property="email", type="string"),
 *     @OA\Property(property="password", type="string"),
 *     @OA\Property(property="password_confirmation", type="string"),
 *     @OA\Property(property="cargo", type="string"),
 *     @OA\Property(property="nacionalidade", type="string"),
 *     @OA\Property(property="data_nascimento", type="string", format="date"),
 *     @OA\Property(property="sexo", type="string"),
 *     @OA\Property(property="documento_identidade", type="string"),
 *     @OA\Property(property="licenca", type="string"),
 *     @OA\Property(property="validade_licenca", type="string", format="date"),
 *     @OA\Property(property="status", type="string"),
 *     @OA\Property(property="telefone_contato", type="string"),
 *     @OA\Property(property="companhia_aerea", type="string")
 * )
 */

class TripulanteController extends Controller
{
    /**
     * @OA\Get(
     *     path="/api/tripulantes",
     *     summary="Lista todos os tripulantes",
     *     tags={"Tripulantes"},
     *     @OA\Response(
     *         response=200,
     *         description="Retorna todos os tripulantes",
     *         @OA\JsonContent(type="array", @OA\Items(ref="#/components/schemas/Tripulante"))
     *     )
     * )
     */

    public function index()
    {
        return Tripulante::all();
    }

    /**
     * @OA\Post(
     *     path="/api/tripulantes",
     *     summary="Cria um novo tripulante",
     *     tags={"Tripulantes"},
     *     @OA\RequestBody(
     *         description="Dados para criação de um novo tripulante",
     *         required=true,
     *         @OA\JsonContent(
     *              @OA\Property(property="id", type="integer", example=0),
     *              @OA\Property(property="nome", type="string", example="João Silva"),
     *              @OA\Property(property="email", type="string", example="joao.silva@example.com"),
     *              @OA\Property(property="password", type="string", example="SenhaSegura123"),
     *              @OA\Property(property="password_confirmation", type="string", example="SenhaSegura123"),
     *              @OA\Property(property="cargo", type="string", example="Piloto"),
     *              @OA\Property(property="nacionalidade", type="string", example="Brasileiro"),
     *              @OA\Property(property="data_nascimento", type="string", format="date", example="1994-11-24"),
     *              @OA\Property(property="sexo", type="string", example="M"),
     *              @OA\Property(property="documento_identidade", type="string", example="12345678910"),
     *              @OA\Property(property="licenca", type="string", example="ABC1234"),
     *              @OA\Property(property="validade_licenca", type="string", format="date", example="2026-11-24"),
     *              @OA\Property(property="status", type="string", example="ativo"),
     *              @OA\Property(property="telefone_contato", type="string", example="21999999999"),
     *              @OA\Property(property="companhia_aerea", type="string", example="LATAM")
     *          )
     *      ),
     *     @OA\Response(
     *         response=201,
     *         description="Tripulante criado com sucesso",
     *         @OA\JsonContent(
     *              @OA\Property(property="message", type="string", example="Tripulante criado com sucesso!"),
     *              @OA\Property(property="tripulante", type="object",
     *                  @OA\Property(property="id", type="integer", example=1),
     *                  @OA\Property(property="nome", type="string", example="João Silva"),
     *                  @OA\Property(property="email", type="string", example="joao.silva@example.com"),
     *                  @OA\Property(property="password", type="string", example="SenhaSegura123"),
     *                  @OA\Property(property="password_confirmation", type="string", example="SenhaSegura123"),
     *                  @OA\Property(property="cargo", type="string", example="Piloto"),
     *                  @OA\Property(property="nacionalidade", type="string", example="Brasileiro"),
     *                  @OA\Property(property="data_nascimento", type="string", format="date", example="1994-11-24"),
     *                  @OA\Property(property="sexo", type="string", example="M"),
     *                  @OA\Property(property="documento_identidade", type="string", example="12345678910"),
     *                  @OA\Property(property="licenca", type="string", example="ABC1234"),
     *                  @OA\Property(property="validade_licenca", type="string", format="date", example="2026-11-24"),
     *                  @OA\Property(property="status", type="string", example="ativo"),
     *                  @OA\Property(property="telefone_contato", type="string", example="21999999999"),
     *                  @OA\Property(property="companhia_aerea", type="string", example="LATAM")
     *              )
     *          )
     *     ),
     *      @OA\Response(
     *          response=400,
     *          description="Erro na solicitação"
     *      )
     *  )
     *
     */
    public function store(Request $request)
    {
        // Validar os dados de entrada
        $validatedData = $request->validate([
            'id' => 'sometimes|integer',
            'nome' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'cargo' => 'required|string|max:255',
            'nacionalidade' => 'required|max:255',
            'data_nascimento' => 'required|date',
            'sexo' => 'required|in:M,F',
            'documento_identidade' => 'required|max:255',
            'licenca' => 'required|string|max:255',
            'validade_licenca' => 'required|date',
            'status' => 'required|string|max:255',
            'telefone_contato' => 'nullable|max:255',
            'companhia_aerea' => 'required|string|max:255',
        ]);

        // Criar um novo usuário
        $user = User::create([
            'nome' => $validatedData['nome'],
            'email' => $validatedData['email'],
            'password' => Hash::make($validatedData['password']),
            'nacionalidade' => $validatedData['nacionalidade'],
            'data_nascimento' => $validatedData['data_nascimento'],
            'sexo' => $validatedData['sexo'],
            'documento_identidade' => $validatedData['documento_identidade'],
            'telefone_contato' => $validatedData['telefone_contato'],
        ]);


        // Criar um novo tripulante
        $tripulante = Tripulante::create([
            'id' => $user->id,
            'cargo' => $validatedData['cargo'],
            'licenca' => $validatedData['licenca'],
            'validade_licenca' => $validatedData['validade_licenca'],
            'status' => $validatedData['status'],
            'companhia_aerea' => $validatedData['companhia_aerea'],
        ]);


        return response()->json([
            'message' => 'Tripulante criado com sucesso!',
            'user' => $user,
            'tripulante' => $tripulante, ], 201);
    }

    /**
     * @OA\Get(
     *     path="/api/tripulantes/{id}",
     *     summary="Exibe um tripulante específico",
     *     tags={"Tripulantes"},
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         description="ID do tripulante",
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Retorna o tripulante encontrado",
     *         @OA\JsonContent(ref="#/components/schemas/Tripulante")
     *     ),
     *     @OA\Response(
     *         response=404,
     *         description="Tripulante não encontrado"
     *     )
     * )
     */
    public function show($id)
    {
        return Tripulante::findOrFail($id);
    }

    /**
     * @OA\Put(
     *     path="/api/tripulantes/{id}",
     *     summary="Atualiza um tripulante existente",
     *     tags={"Tripulantes"},
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         description="ID do tripulante",
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(ref="#/components/schemas/Tripulante")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Tripulante atualizado com sucesso",
     *         @OA\JsonContent(ref="#/components/schemas/Tripulante")
     *     )
     * )
     */
    public function update(Request $request, $id)
    {
        $tripulante = Tripulante::findOrFail($id);
        $validated = $request->validate([
            'id' => 'sometimes|integer',
            'nome' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'cargo' => 'required|string|max:255',
            'nacionalidade' => 'required|max:255',
            'data_nascimento' => 'required|date',
            'sexo' => 'required|in:M,F',
            'documento_identidade' => 'required|max:255',
            'licenca' => 'required|string|max:255',
            'validade_licenca' => 'required|date',
            'status' => 'required|string|max:255',
            'telefone_contato' => 'nullable|max:255',
            'companhia_aerea' => 'required|string|max:255',
        ]);

        $tripulante->update($validated);
        return response()->json($tripulante);
    }

    /**
     * @OA\Delete(
     *     path="/api/tripulantes/{id}",
     *     summary="Deleta um tripulante",
     *     tags={"Tripulantes"},
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         description="ID do tripulante",
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Tripulante deletado com sucesso"
     *     )
     * )
     */
    public function destroy($id)
    {
        Tripulante::destroy($id);
        return response()->json(['message' => 'Tripulante deletado']);
    }
}
