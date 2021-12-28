<?php

namespace App\Http\Controllers;

use Laravel\Lumen\Routing\Controller as BaseController;

class ApiController extends BaseController
{
    /**
     * Handler for /api/hello/{name}
     * @param string $name
     * @return array
     */
    public function hello(string $name) {
        return [
            "hello" => $name
        ];
    }
}
