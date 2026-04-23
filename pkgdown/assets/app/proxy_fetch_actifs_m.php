<?php
header('Access-Control-Allow-Origin: *');
$html = file_get_contents('https://data.aftt.be/tools/index.php');
preg_match('/<h5[^>]*>.*?Joueurs actifs \(Messieurs\).*?<\/h5>\s*<h3[^>]*>(.*?)<\/h3>/si', $html, $matches);
$val = trim($matches[1] ?? 'N/A');
echo preg_replace('/[^0-9]/', '', $val);
