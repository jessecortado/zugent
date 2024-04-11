<?php
/**
 * Smarty plugin
 *
 * @package    Smarty
 * @subpackage PluginsLinefeeds
 */

/**
 * Smarty truncate modifier plugin
 * Type:     modifier<br>
 * Name:     linefeeds<br>
 * Purpose:  Replace linefeeds with BR and other text cleanup
 *
 * @author Jason Granum <jason at zugent dot com>
 *
 * @param string  $string      input string
 *
 * @return string cleaned string
 */
function smarty_modifier_linefeeds($string)
{
	return str_replace("\n","<BR/>",$string);
}
