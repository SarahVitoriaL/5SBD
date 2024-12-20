<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('tripulantes', function (Blueprint $table) {
            $table->id();
            $table->string('cargo');
            $table->string('licenca')->unique();
            $table->string('validade_licenca');
            $table->string('status');
            $table->string('companhia_aerea');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tripulantes');
    }
};
