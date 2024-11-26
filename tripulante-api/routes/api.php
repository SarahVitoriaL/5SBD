<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TripulanteController;
use App\Http\Controllers\UserController;

Route::get('tripulantes', [TripulanteController::class, 'index']);
Route::get('tripulantes/{id}', [TripulanteController::class, 'show']);
Route::post('tripulantes', [TripulanteController::class, 'store']);
Route::put('tripulantes/{id}', [TripulanteController::class, 'update']);
Route::delete('tripulantes/{id}', [TripulanteController::class, 'destroy']);
Route::get('/api-docs', function () { return view('swagger-ui'); });
