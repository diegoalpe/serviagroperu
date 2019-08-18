<?php

require_once '../negocio/Tipo_fertilizante.clase.php';
require_once '../util/funciones/Funciones.clase.php';

try {
    $objTipoFer = new Tipo_fertilizante();
    $resultado = $objTipoFer->listarTipoFertilizante();
    Funciones::imprimeJSON(200, "", $resultado);
} catch (Exception $exc) {
    Funciones::imprimeJSON(500, $exc->getMessage(), "");
}