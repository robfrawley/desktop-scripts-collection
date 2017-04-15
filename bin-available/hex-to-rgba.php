<?php

function hexToRgb($colorHex)
{
    $colorHex = preg_replace('{[^a-f0-9]}i', '', $colorHex);

    if (strlen($colorHex) !== 3 && strlen($colorHex) !== 6) {
        throw new \InvalidArgumentException('Invalid hex color string provided: '.$colorHex);
    }

    if (strlen($colorHex) === 3) {
        foreach (str_split($colorHex, 1) as $i => $c) {
            if ($i === 0) {
                $colorHex = '';
            }

            $colorHex .= str_repeat($c, 2);
        }
    }

    return array_map('hexdec', str_split($colorHex, 2));
}

function makeRgbaCss($r, $g, $b, $a = 1)
{
    return sprintf("rgba(%'.03d, %'.03d, %'.03d, %02.2f)", $r, $g, $b, $a);
}

function readFileContents($filePath)
{
    if (!file_exists($filePath)) {
        throw new \InvalidArgumentException('Invalid file path provided: '.$filePath);
    }

    return file_get_contents($filePath);
}

function convertHex($contents)
{
    preg_match_all('{#([a-f0-9]+)}i', $contents, $matches);

    if (count($matches[0]) === 0) {
        return;
    }

    $replacements = [];
    foreach ($matches[0] as $hex) {
        $rgb = hexToRgb($hex);

        echo "Replacement: ".str_pad($hex, 7, ' ', STR_PAD_LEFT)." => ".makeRgbaCss(...$rgb) . PHP_EOL;
        $contents = str_replace($hex, makeRgbaCss(...$rgb), $contents);
    }

    return $contents;
}

function convertRgba($contents)
{
    preg_match_all('{rgba\(\s?([0-9]+),\s?([0-9]+),\s?([0-9]+),\s?([0-9\.]+)\s?\)}i', $contents, $matches, PREG_SET_ORDER);

    foreach ($matches as $m) {
        $rgb = [$m[1], $m[2], $m[3], $m[4]];
        echo "Replacement: ".str_replace(' ', '', $m[0])." => ".makeRgbaCss(...$rgb) . PHP_EOL;
        $contents = str_replace($m[0], makeRgbaCss(...$rgb), $contents);
    }

    return $contents;
}

function convertRgb($contents)
{
    preg_match_all('{rgba\(\s?([0-9]+),\s?([0-9]+),\s?([0-9]+)\s?\)}i', $contents, $matches, PREG_SET_ORDER);

    return $contents;
}

function main($filePath, $writeFile = 0, $verbosity = 0)
{
    $writeFile = (bool) $writeFile;
    $verbosity = (bool) $verbosity;
    $fContents = readFileContents($filePath);

    $fContents = convertRgba($fContents);
    $fContents = convertRgb($fContents);
    $fContents = convertHex($fContents);

    if ($writeFile !== true) {
        echo "Exiting without writing input file with replacements...".PHP_EOL;
        exit(0);
    }

    echo "Writing backup file to: /tmp/".basename($filePath).PHP_EOL;

    copy($filePath, '/tmp/'.basename($filePath));

    echo "Writing file with replacements to: ".$filePath.PHP_EOL;

    file_put_contents($filePath, $fContents);

    echo "Exiting...".PHP_EOL;
}

array_shift($argv);

main(...$argv);
