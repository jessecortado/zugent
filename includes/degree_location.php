<?php
// Compute Distance between two points and get the angle

function getDegreeLocation($x,$y) {
	if($x == 0 AND $y == 0){ return 0; } // ...or return 360
	return ($x < 0) ? rad2deg(atan2($x,$y))+360 : rad2deg(atan2($x,$y));
}

function convertToDirection($radians) {
    $coordNames = array (
    	"N"   => "0",
    	"NNE" => "22.5",
    	"NE"  => "45",
    	"ENE" => "67.5",
    	"E"   => "90",
    	"ESE" => "112.5",
    	"SE"  => "135",
    	"SSE" => "157.5",
    	"S"   => "180",
    	"SSW" => "202.5",
    	"SW"  => "225",
    	"WSW" => "247.5",
    	"W"   => "270",
    	"WNW" => "292.5",
    	"NW"  => "315",
    	"NNW" => "337.5",
    	"N"   => "360"
    );

	foreach ($coordNames as $key => $value) {
	 	if ($key == "N") {
	 		if( (-11.25) < $radians && $radians <= 11.25 ||
	 			348.75 < $radians && $radians <= 372.25 ) {
				return $key;
			}
	 	}
	 	else {
			if( ($value-11.25) < $radians && $radians <= ($value + 11.25)) {
				return $key;
			}
		}
	}
}

?>