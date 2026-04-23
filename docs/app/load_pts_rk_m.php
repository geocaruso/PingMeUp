<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$file = 'pts_rk_m.json';
if (!file_exists($file)) {
    echo json_encode(["error" => "pts_rk_m.json not found"]);
    exit;
}

echo file_get_contents($file);
