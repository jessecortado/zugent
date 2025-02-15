<?php
/**
 * Smarty plugin
 *
 * @package    Smarty
 * @subpackage PluginsLinefeeds
 */

/**
 * Smarty time ago plugin
 * Type:     modifier<br>
 * Name:     time_ago<br>
 * Purpose:  Show the relative time from when the post was made in a "x days ago" style return.
 * Source: https://www.sitepoint.com/counting-the-ago-time-how-to-keep-publish-dates-fresh/
 *
 * @author Jason Granum <jason at zugent dot com>
 *
 * @param string  $string      input string
 *
 * @return string cleaned string
 */

define( TIMEBEFORE_NOW,			'now' );
define( TIMEBEFORE_MINUTE,      '{num} minute ago' );
define( TIMEBEFORE_MINUTES,     '{num} minutes ago' );
define( TIMEBEFORE_HOUR,        '{num} hour ago' );
define( TIMEBEFORE_HOURS,       '{num} hours ago' );
define( TIMEBEFORE_YESTERDAY,   'yesterday' );
define( TIMEBEFORE_FORMAT,      '%e %b' );
define( TIMEBEFORE_FORMAT_YEAR, '%e %b, %Y' );

function smarty_modifier_time_ago($time)
{
	$out    = ''; // what we will print out
	$now    = time(); // current time
	$diff   = $now - $time; // difference between the current and the provided dates
	
	if( $diff < 60 ) return TIMEBEFORE_NOW; // It happened now
	
	elseif( $diff < 3600 ) // it happened X minutes ago
	return str_replace( '{num}', ( $out = round( $diff / 60 ) ), $out == 1 ? TIMEBEFORE_MINUTE : TIMEBEFORE_MINUTES );
	
	elseif( $diff < 3600 * 24 ) // it happened X hours ago
	return str_replace( '{num}', ( $out = round( $diff / 3600 ) ), $out == 1 ? TIMEBEFORE_HOUR : TIMEBEFORE_HOURS );
	
	elseif( $diff < 3600 * 24 * 2 ) // it happened yesterday
	return TIMEBEFORE_YESTERDAY;
	
	else // falling back on a usual date format as it happened later than yesterday
	return strftime( date( 'Y', $time ) == date( 'Y' ) ? TIMEBEFORE_FORMAT : TIMEBEFORE_FORMAT_YEAR, $time );
}
