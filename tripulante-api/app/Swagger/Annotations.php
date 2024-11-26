<?php

namespace App\Swagger;

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


/**
  * @OA\Schema(
  *     schema="Tripulante",
  *     type="object",
  *     @OA\Property(property="id", type="integer"),
  *     @OA\Property(property="nome", type="string"),
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

/**
 * @OA\PathItem(
 *     path="/api/tripulantes",
 *     operations={
 *         @OA\Get(
 *             summary="Lista todos os tripulantes",
 *             description="Retorna uma lista de tripulantes",
 *             @OA\Response(
 *                 response=200,
 *                 description="Lista de tripulantes",
 *                 @OA\JsonContent(type="array", @OA\Items(ref="#/components/schemas/Tripulante"))
 *             )
 *         ),
 *         @OA\Post(
 *             summary="Cria um novo tripulante",
 *             description="Cria um novo tripulante na base de dados",
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
