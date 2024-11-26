<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;

class Tripulante extends User
{

    protected $fillable = [
        'usuario_id',
        'cargo',
        'licenca',
        'validade_licenca',
        'status',
        'companhia_aerea'
    ];

    protected $casts = [
        'validade_licenca' => 'date',
    ];

    public function setValidadeLicencaAttribute($value)
    {
        $this->attributes['validade_licenca'] = Carbon::parse($value);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
