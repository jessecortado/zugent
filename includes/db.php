<?php
//require_once ("DB.php");
/*
 * We are (currently) trying to prevent just one trivial type of sql injection.
 * Namely, the one that attempts to end query with a ; and then add an extra query 
 * to the end. This is a common technique, and the one that is easiest to detect.
 *
 * First, we watch for unbalanced quotes. If any are found, the query is invalid anyway
 * and thus will not be allowed to run.
 *
 * Second, I can't think of a single valid use of a semicolon outside the literals 
 * enclosed into ''. Semicolons will be alloedd in those literals, but not outside.
 *
 * Single quotes that are in the literals and have been SQL_ESCAPE()'d are treated properly,
 * that is as a single character within the literal. So are the backslashed-escaped chars.
 *
 * Any other additions are welcome, but this is at least a good start.
 *
 */
function IS_SAFE_SQL_QUERY($q){
	$len = strlen($q);
	$inside = false; // inside a literal (enclosed by '')
	$ret = true; // query assumed good unless we can prove otherwise.
	for($i = 0; $i < $len; $i++){
		$more = ($i < ($len - 1)); // we have at least one more character
		switch($q[$i])
		{
		 case "\\":
			if($inside && $more)
			{
				$i++; // whatever follows MUST be an escaped character.
				continue;
			}
			break;

		 case "'":
			// we are inside the string and came up with a properly-escaped quote
			if($inside && $more && ($q[$i+1] == "'")) {
				$i++;
				continue;
			}
			$inside = !$inside;
			break;
			
		 case ";":
			// semicolons outside literals are not permitted.
			if(!$inside){
				$ret = "Semicolon is used to chain queries. Please, do not do that.";
				break 2;
			}

		}// switch()
	}
	if($inside) $ret = "Unbalanced single quotes";
	
	#print "Ret: [$ret]<br/>\n";
	return $ret;
}



/**
 * Make a connection to a mysql db.
 * @access 	public
 */
function BAK_SQL_CONNECT($server = 'localhost',$username = "root", $password = "root", $database="leads", $ssl_ca="", $ssl_cert="", $ssl_key="")
{
  $db = NULL;
  $dsn = array (
    'phptype' => 'mysqli',
    'username' => $username,
    'password' => $password,
    'hostspec' => $server,
    'database' => $database,
  );

  $method = "tcp";
  if ($server == 'localhost') {
    $method = "unix";
  }
  $options = array (
    'debug' => 2,
    'portability' => DB_PORTABILITY_ALL,
  );
  if ($ssl_cert && $ssl_key) {
    $options['ssl'] = true;
    $dsn['key'] = $ssl_key;
    $dsn['cert'] = $ssl_cert;
    $dsn['ca'] = $ssl_ca;
  }
  var_dump ($dsn);
  var_dump ($options);
  $db =& DB::connect ($dsn, $options);
  if (PEAR::isError ($db) ) {
    die ($db->getMessage () );
  }
  $GLOBALS['__DB_HANDLE'] = $db;
	return $GLOBALS['__DB_HANDLE'];
}

function SQL_CONNECT($server = "localhost" ,$username = "root", $password = "", $database="zugent", $ssl=FALSE, $mycnf_path="/etc/mysql/my.cnf", $mycnf_group="feeds")
{
  $db = mysqli_init ();
  mysqli_options ($db, MYSQLI_OPT_CONNECT_TIMEOUT, 10);
  mysqli_options ($db, MYSQLI_READ_DEFAULT_FILE, $mycnf_path);
  mysqli_options ($db, MYSQLI_READ_DEFAULT_GROUP, $mycnf_group);

  mysqli_real_connect ($db, $server, $username, $password, $database, 3306, NULL, MYSQLI_CLIENT_COMPRESS);
  if (mysqli_connect_errno () ) {
    return FALSE;
  }

  $GLOBALS['__DB_HANDLE'] = $db;
	return $GLOBALS['__DB_HANDLE'];
}

function SQL_SLAVE_CONNECT($server = 'localhost',$username = "root", $password = "root", $database="zugent", $ssl=FALSE, $mycnf_path="/etc/mysql/my.cnf", $mycnf_group="feeds")
{
  $db = mysqli_init ();
  mysqli_options ($db, MYSQLI_OPT_CONNECT_TIMEOUT, 10);
  mysqli_options ($db, MYSQLI_READ_DEFAULT_FILE, $mycnf_path);
  mysqli_options ($db, MYSQLI_READ_DEFAULT_GROUP, $mycnf_group);

  mysqli_real_connect ($db, $server, $username, $password, $database, 3306, NULL, MYSQLI_CLIENT_COMPRESS);

  if (mysqli_connect_errno () ) {
    return FALSE;
  }

  $GLOBALS['__DB_SLAVE_HANDLE'] = $db;
	return $GLOBALS['__DB_SLAVE_HANDLE'];
}

/**
 * Save the SQL connection object to a global area
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_SAVE_CONN() {
    if(!isset($GLOBALS['__DB_HANDLES'])) {
        $GLOBALS['__DB_HANDLES'] = array();
    }

    array_push($GLOBALS['__DB_HANDLES'],$GLOBALS['__DB_HANDLE']);
}

/**
 * Reuse a stored connection
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_RESTORE_CONN($con=null) {
    if(is_null($con)) {
        $GLOBALS['__DB_HANDLE'] = array_pop($GLOBALS['__DB_HANDLES']);
    } else {
        $GLOBALS['__DB_HANDLE'] = $con;
    }
}

/**
 * Select a db
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_DB($dbname, $exit = true)
{
	if ( mysqli_select_db($GLOBALS['__DB_HANDLE'], $dbname) ) 
		return true;
	else 
	{
		if ($exit == true)
			exit("Could not connect to the '".$dbname."' Database.");
		else
			return false; //this is in case you want to do your own error handling.
	}
}

/**
* Outputs the SQL to /tmp/SQL_profile.txt in detail. 
* 
* profile SQL statements in varying detail levels.
*	Detail Levels:
*	 1 = m/d/y/ h:i:s
*	 2 = SQL timing
*	 3 = filename
*
* @access 	public
* @return 	boolean on success or failure.
* @param 	$sql The SQL query to be executed, this can be SELECT, INSERT, UPDATE or DELETE amongst others.
* @param 	$detail the detail level as an integer 1-3.
* @author 	Daevid Vincent [daevid@LockdownNetworks.com]
* @since 	3.11
* @version 	1.1
* @date    	05/11/05
*/
function SQL_PROFILE($sql, $detail = 3 )
{
	if ($detail == 0) return false;
	if (!isset($sql)) return false;
	
	if (!$handle = fopen("/tmp/SQL_profile.txt", 'a')) 
	{
		echo "unable to open file /tmp/SQL_profile.txt\n";
		return false;
	}

	//not really required, as they're handled inherently
	//if ($detail > 4) $detail = 4;
	//if ($detail < 1) $detail = 1;

	$text = date("[m/d/y h:i:s ");

	if ($detail >= 2) //start timer
	{
		list($usec, $sec) = explode(" ",microtime()); 
		$sql_start = ((float)$usec + (float)$sec);
	}

	$result = @mysqli_query($GLOBALS['__DB_HANDLE'], $sql);

	if ($detail >= 2) //end timer
	{
		list($usec, $sec) = explode(" ",microtime()); 
		$text .= number_format( (((float)$usec + (float)$sec) - $sql_start), 4 ).'s';
	}

	//we do this here so as not to upset the timer too much
	if ($detail >= 3)
	{
		$text .= ' '.$_SERVER['SCRIPT_FILENAME'];
		$traceArray = debug_backtrace();
		$text .= ' '.$traceArray[1]['file'].' ('.$traceArray[1]['line'].')';
		$text = str_replace('/lockdown/', '', $text);
	}

	$sql = str_replace("\n", ' ', $sql);
	$sql = preg_replace('/\s+/',' ', $sql);
	if (!fwrite($handle, $text.'] '.$sql."\n")) 
	{
		echo "unable to write to file /tmp/SQL_profile.txt\n";
		return false;
	}

	@fclose($handle);

	return $result;
} //SQL_PROFILE


/**
* Output the HTML debugging string in color coded glory for a sql query
* This is very nice for being able to see many SQL queries
* @access 	public
* @return 	void. prints HTML color coded string of the input $query.
* @param 	string $query The SQL query to be executed.
* @author 	Daevid Vincent [daevid@LockdownNetworks.com]
* @since 	4.0
* @version 	1.0
* @date    	04/05/05
* @todo 	highlight SQL functions.
*/
function SQL_DEBUG( $query )
{
	if( $query == '' ) return 0;

	global $SQL_INT;
	if( !isset($SQL_INT) ) $SQL_INT = 0;

	//TODO: [dv] I wonder if a better way to do this is to split the string into array chunks and examine them each individually?
	
	//TODO: [dv] I think we'd get better results if we normalize the $query string by stripping out any \n\r characters:
	$query = str_replace( array("\n", "\r", '  '), ' ', $query);
	
	//[dv] this has to come first or you will have goofy results later.
	//[dv] UGH this number one is causing me lots of grief... why can't i figure out the regex to use?
	//highlight numbers 
	//$query = preg_replace("/[\s=](\d+)\s/", "<FONT COLOR='#FF6600'>$1</FONT>", $query, -1);
	//highlight strings between quote marks
	$query = preg_replace("/['\"]([^'\"]*)['\"]/i", "'<FONT COLOR='#FF6600'>$1</FONT>'", $query, -1);
	//highlight functions
	$query = preg_replace("/(\w+)\s?\(/", "<FONT COLOR='#CC00FF'>$1</FONT>(", $query, -1);
	//highlight tables/databases
	$query = preg_replace("/(\w+)\./", "<U>$1</U>.", $query, -1);

	$query = str_replace(
							array (
									'*',
									'SELECT ',
									'UPDATE ',
									'DELETE ',
									'INSERT ',
									'INTO ',
									'VALUES ',
									'FROM ',
									'LEFT ',
									'JOIN ',
									'WHERE ',
									'LIMIT ',
									'ORDER BY ',
									'AND ',
									'OR ', //[dv] note the space. otherwise you match to 'colOR' ;-)
									' DESC',
									' ASC',
									'ON ',
									' AS '
								  ),
							array (
									"<FONT COLOR='#FF6600'><B>*</B></FONT>",
									"<FONT COLOR='#00AA00'><B>SELECT </B></FONT>",
									"<FONT COLOR='#00AA00'><B>UPDATE </B></FONT>",
									"<FONT COLOR='#00AA00'><B>DELETE </B></FONT>",
									"<FONT COLOR='#00AA00'><B>INSERT </B></FONT>",
									"<FONT COLOR='#00AA00'><B>INTO </B></FONT>",
									"<FONT COLOR='#00AA00'><B>VALUES </B></FONT>",
									"<FONT COLOR='#00AA00'><B>FROM </B></FONT>",
									"<FONT COLOR='#00CC00'><B>LEFT </B></FONT>",
									"<FONT COLOR='#00CC00'><B>JOIN </B></FONT>",
									"<FONT COLOR='#00AA00'><B>WHERE </B></FONT>",
									"<FONT COLOR='#00AA00'><B>LIMIT </B></FONT>",
									"<FONT COLOR='#00AA00'><B>ORDER BY</B> </FONT>",
									"<FONT COLOR='#0000AA'><B>AND</B> </FONT>",
									"<FONT COLOR='#0000AA'><B>OR</B> </FONT>",
									"<FONT COLOR='#0000AA'> <B>DESC</B></FONT>",
									"<FONT COLOR='#0000AA'> <B>ASC</B></FONT>",
									"<FONT COLOR='#00DD00'><B>ON</B> </FONT>",
									"<FONT COLOR='#0000AA'> <B>AS</B> </FONT>"
								  ),
							$query
						  );

	echo "<FONT COLOR='#0000FF'><B>SQL[".$SQL_INT."]:</B> ".$query."<FONT COLOR='#FF0000'>;</FONT></FONT><BR>\n";

	$SQL_INT++;

} //SQL_DEBUG


/**
* A wrapper around the mysql_query function. 
* 
* Handles the $db handle, errors and echoing of the SQL query itself
* and stores any errors in the global variable errorString;
*
* @access public
* @return 	result set handle pointer suitable for.
* @param 	$sql The SQL query to be executed, this can be SELECT, INSERT, UPDATE or DELETE amongst others.
* @param 	$showSQL output the $sql to the display (for debugging purposes usually). false by default.
* @param 	$showErrors output any errors encountered to the display (for debugging purposes usually). true by default.
* @param 	$execute useful for debuging when you don't want the SQL command to actually execute, but you may want to see the query passed i.e. SQL_QUERY($sql, true, true, false); true by default.
* @param 	$noHTML when using the function in console scripts to strip off HTML tags.
* @param 	$profile detail level to output the SQL to /tmp/SQL_profile.txt.
* @author 	Daevid Vincent [daevid@LockdownNetworks.com]
* @since 	3.0
* @version 	1.3
* @date    	06/01/05
*/
function SQL_QUERY($sql, $showSQL = false, $showErrors = true, $execute = true, $noHTML = false, $profile = 0)
{
    global $OPTION;
    global $user;
    if (preg_match("/^select/i",$sql)
      &&!preg_match("/SQL_CALC_FOUND_ROWS/ism",$sql)
      && !preg_match("/FOUND_ROWS/ism",$sql)
      && !preg_match("/arg/ism",$sql)
      && !preg_match("/nwmls/ism",$sql)
      && !preg_match("/ncmls/ism",$sql)
      && !preg_match("/rmls/ism",$sql)
      && !preg_match("/livechat/ism",$sql)
      && !preg_match("/wiki/ism",$sql)
      && !preg_match("/zygote/ism",$sql)
      && !preg_match("/assetblog/ism",$sql)
      && preg_match("/leads/ism",$sql)
      && $GLOBALS['__DB_SLAVE_HANDLE'])
      $db_handle = $GLOBALS['__DB_SLAVE_HANDLE'];
    else
      $db_handle = $GLOBALS['__DB_HANDLE'];
	
	if ($showSQL) 
	{
		//[dv] the preg_replace will magically strip out the spaces, newlines, tabs and other funky chars to make one nice string.
		$sql = preg_replace("/\s+/",' ', (preg_replace("/\s/",' ',$sql)) );
		
		if ($noHTML || $OPTION['noHTML'])
			echo "SQL: ".$sql."\n";
		else
			#echo "\n<FONT STYLE='color:blue;'><B>SQL:</B> ".$sql."</FONT><BR>\n";
			SQL_DEBUG( $sql );
	}
	
	if ($execute)
	{
		// execute query only if it appears to be safe.
		if ( ($error_str = IS_SAFE_SQL_QUERY($sql)) === TRUE )
		{
			if ($OPTION['profile'] > 0) $profile = $OPTION['profile'];
			
			if ($profile > 0)
				$result = SQL_PROFILE($sql, $profile);
			else
				$result = @mysqli_query($db_handle, $sql);
		} else {
			$error = "Malformed query (".$error_str."). Execution blocked.";
			$result = FALSE; // indicate that we failed
		}
		
		if (!$result) 
		{
			if(!isset($GLOBALS['SQL_ErrorString'])) $GLOBALS['SQL_ErrorString'] = "";
			
			// if error has not been set, then we have a 'regular' mysql error. Otherwise it is a potentially malicious query.
			if(!isset($error)){
				$error = mysqli_error($db_handle);
				$errno = mysqli_errno($db_handle);

				if (strstr($error, 'MySQL server has gone away')) {

					if (false && ($noHTML or $OPTION['noHTML']))
						echo strip_tags($GLOBALS['SQL_ErrorString'])."\n";
					elseif($user['dev'] == 'N' && (true || $OPTION['useLogger']))
						echo strip_tags($GLOBALS['SQL_ErrorString'])."\n";
					else
						echo "<PRE STYLE='text-align: left; border: thin solid Red; padding: 5px;'><FONT CLASS='error'>".$GLOBALS['SQL_ErrorString']."</FONT></PRE><BR>\n";

					exit;
				}

			}
			else $errno = 0; // not 'regular' mysql error? well, we need some error code anyway.
			
			// trim to size if necessary
			if(!$OPTION['fullQuery']) $error = substr($error,0,80)."...";
			
			$GLOBALS['SQL_ErrorString'] .= "<B><U>SQL ERROR</U> ::</B> ".$errno." <B>::</B> ".$error." <BR>\n<FONT SIZE='-3'><I>".$sql."</I></FONT>\n".backtrace(false);
			if ($showErrors) 
			{
				//TODO: [dv] is there a way to determine if we're in a CGI vs. Web page?
				if (false && ($noHTML or $OPTION['noHTML']))
					echo strip_tags($GLOBALS['SQL_ErrorString'])."\n";
				elseif($user['dev'] == 'N' && (true || $OPTION['useLogger']))
					logger( strip_tags($GLOBALS['SQL_ErrorString'])."\n");
				else
					echo "<PRE STYLE='text-align: left; border: thin solid Red; padding: 5px;'><FONT CLASS='error'>".$GLOBALS['SQL_ErrorString']."</FONT></PRE><BR>\n";
			} //if ($showErrors)
		} //if (!$result)
		
            //$temp = fopen('/tmp/mysql_error','a');
            //fwrite($temp, $sql."\n");
            //fwrite($temp, mysqli_error($db_handle));
            //fclose($temp);
    
		return $result;
	} 

	return true;
}

function logger($message) {
    	mail("jason@zugent.com", "SQL_ERROR on pipeline", $message );
	exit;
}

/**
 * @return	int	Number of rows in the result set
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_NUM_ROWS($rslt)
{
	if ($rslt)
		return @mysqli_num_rows($rslt);
	else
		return false;
}

/**
* A wrapper around the SQL_QUERY function to return an array of key/value pairs.
* 
* This is very useful for those tables that are simply a key/value and you'd like it in an array
* then you can just reference the array and save yourself a JOIN perhaps.
*
* @access public
* @return 	array of key/value pairs.
* @param 	$sql The SQL query to be executed, this can be SELECT, INSERT, UPDATE or DELETE amongst others.
* @param 	$showSQL output the $sql to the display (for debugging purposes usually). false by default.
* @param 	$showErrors output any errors encountered to the display (for debugging purposes usually). true by default.
* @param 	$execute useful for debuging when you don't want the SQL command to actually execute, but you may want to see the query passed i.e. SQL_QUERY($sql, true, true, false); true by default.
* @param 	$noHTML when using the function in console scripts to strip off HTML tags.
* @author 	Daevid Vincent [daevid@LockdownNetworks.com]
* @since 	3.0
* @version 	1.0
* @date    	07/29/04
*/
function SQL_QUERY_ARRAY_PAIR($sql, $showSQL = false, $showErrors = true, $execute = true, $noHTML = false)
{
	$rslt = SQL_QUERY($sql, $showSQL, $showErrors, $execute, $noHTML);
	if ($rslt)
	{
		while(list($key,$value) = SQL_ROW($rslt))
			$tmpArray[$key] = $value;
		return $tmpArray;
	}
	return false;
}

/**
 * @return array Single element assoc. array
 * @access public
 * @author Jason Granum [razmage@gmail.com]
 */
function SQL_FIRST_ARRAY($query)
{
	$sth = SQL_QUERY($query);
	if ($sth) return SQL_ASSOC_ARRAY($sth); else return false;
}

/**
 * @return	array	Single element assoc. array
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_ASSOC_ARRAY($rslt)
{
	if ($rslt)
		return @mysqli_fetch_assoc($rslt);
	else
		return false;
}



/**
 * @return	array	Single element array
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_ROW($rslt)
{
	if ($rslt)
		return @mysqli_fetch_row($rslt);
	else
		return false;
}

/**
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_RESULT($rslt, $row = 0)
{
	if ($rslt)
		return @mysql_result($rslt, $row);
	else
		return false;
}

/**
 * @return	int	Insert ID of last insert action 
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_INSERT_ID()
{
	return @mysqli_insert_id($GLOBALS['__DB_HANDLE']);
}

/**
 * @return	int	Number of affected rows
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_AFFECTED_ROWS()
{
	return @mysqli_affected_rows($GLOBALS['__DB_HANDLE']);
}

/**
 * Free up a mysql pointer
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_FREE($rslt)
{
	if ($rslt)
		return @mysqli_free_result($rslt);
	else
		return false;
}

/**
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_ESCAPE($s)
{ 
	//return str_replace("'", "''", $s); 
	return mysql_escape_string($s); 
}

/**
 * Seek the pointer
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_DATA_SEEK($rslt, $row)
{
	return mysqli_data_seek($rslt, $row);
}

/**
 * @return	int	MySQL error number
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_ERROR_NUM()
{
	return @mysqli_errno($GLOBALS['__DB_HANDLE']);
}

/**
 * @return	int	MySQL error message
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_ERROR()
{
	return @mysqli_error($GLOBALS['__DB_HANDLE']);
}

/**
 * Close out the connection to the SQL server
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_CLOSE()
{
	return @mysqli_close($GLOBALS['__DB_HANDLE']);
}

/**
 * This returns error 1007 if it exists already, SQL_ERROR supressed
 * @access 	public
 * @author 	Daevid Vincent [daevid@LockdownNetworks.com]
 */
function SQL_CREATE_DB($name)
{
	//[dv] depricated and not even included in our build of PHP!?
	//http://us2.php.net/manual/en/function.mysql-create-db.php
	//return mysql_create_db($name, $db);
	
	//[dv] this is not a good way to do this, as it doesn't tell you if it succeeded or not.
	//return SQL_QUERY("CREATE DATABASE IF NOT EXISTS ".$name);
	
	//this returns error 1007 if it exists already, SQL_ERROR supressed
	return SQL_QUERY("CREATE DATABASE ".$name, false, false);
}

/**
* Returns the value of the given field in the database.
* 
* it's annoying to have to do this to find out the username given their ID,
* or other tedious times when you simply need a quick value in a lookup table
*
* @access public
* @return 	the number of rows in the SELECT box.
* @param 	$id the record id for which to retrieve the data
* @param 	$pk the column to use the $id in. usually the primary key.
* @param 	$column the column name's value to retrieve.
* @param 	$dbtable which table (or db.table) does this reside in.
* @author 	Daevid Vincent [daevid@LockdownNetworks.com]
* @since 	3.0
* @version  1.0
* @date     07/12/04
*/
function SQL_getField($id, $pk, $column, $dbtable)
{
	$sth = SQL_QUERY('SELECT '.$column.' FROM '.$dbtable.' WHERE '.$pk.' = '.$id.' LIMIT 1');
	if ($sth) 
	{
		$r = SQL_ASSOC_ARRAY($sth);
		return $r[$column];
	}
	return false;
}

/**
* Dynamically generates a select box from a SQL query. 
* 
* The SELECT must return between one and three items. 
* <SELECT><OPTTION VALUE=''></SELECT> form element prefilled in
*
* @access 	public
* @return 	the number of rows in the SELECT box or false.
* @param 	$size usually 1, but the select box can be any height.
* @param 	$name the NAME='$name' parameter of a SELECT tag.
* @param 	$sql The actual SQL SELECT query that returns between 1 and 3 columns.
* @param 	$blank add the extra 'empty' <OPTION VALUE=''>.
* @param 	$auto onChange will cause a form submit if true.
* @param 	$MatchToThis sometimes it is useful to match $name to something like $_GET['name'] instead. it is array safe too!
* @param 	$extratags Any extra CLASS='' or MULTIPLE or whatever to put in the <SELECT ...> tag.
* @author 	Daevid Vincent [daevid@LockdownNetworks.com]
* @since 	3.0
* @version 	1.3
* @date     10/01/04
*/
function SelectBoxSQL($size, $name, $sql, $blank = false, $auto = false, $MatchToThis = false, $extratags = false) 
{
	global $$name;
	$items = 0;
	if (intval($size) < 1) $size = 1;
	if ($MatchToThis === false) $MatchToThis = $$name;
	if ( $qry = SQL_QUERY($sql) )
	{
		echo "\n<SELECT SIZE='".$size."' NAME=\"".$name."\" ID=\"".$name."\"";
		if ($auto) echo " onChange=\"this.form.submit(); return true;\"";
		if ($extratags) echo " ".$extratags;
		echo ">\n";

		if (SQL_NUM_ROWS($qry) > 0)
		{
			if ($blank && is_bool($blank) ) { echo "<OPTION VALUE=''></OPTION>\n"; }
			elseif ($blank && is_string($blank)) { echo "<OPTION VALUE=''>".$blank."</OPTION>\n"; }
			while (list($key, $text, $description) = SQL_ROW($qry))
			{
				$items++;

				// Check for selectbox sub-headings.
				if ( 0 == strncmp( $text, "---", 3 ) )
				{
					echo "<OPTION VALUE='' DISABLED CLASS='selectbox-ghosted'>".stripslashes( $text );
				}
				else
				{
					echo "\t<OPTION VALUE='".$key."'";
					if (!SELECTED_IfInArray($MatchToThis, $key))
						if ($key == $MatchToThis) echo " SELECTED";
					echo ">";
					echo stripslashes($text);
					if ($description) echo " (".stripslashes($description).")";
					echo "</OPTION>\n";
				}
			}
		}

		echo "\t</SELECT>\n";

		SQL_FREE($qry);
		return $items;
	}
	else echo "select box cannot be built because of an invalid SQL query.\n";
	
	SQL_FREE($qry);
	return false;
} // end SelectBoxSQL

/**
* returns a string that can be appended to an SQL statement to form the ORDER BY portion.
*
* if you want to sort by 'service' in descending order, then simply use 'service_DESC',
* conversely, 'service_ASC' would sort in ascending order. The order of the elements in the array
* will determine the order they are appended together.
*
* @access 	public
* @return 	string of the form ' ORDER BY element[1], element[2], element[3]'...
* @param 	$orderBy false, string, or array of elements like so: [sort_by] => Array ( [1] => service_DESC [2] => protocol [3] => port ) 
* @param 	$default a string to use as the default ORDER BY column
* @since 	Alcatraz
* @version 	1.1
* @date    	01/18/05
*/
function parseOrderByArray($orderBy = false, $default = false)
{
	$sql = ' ORDER BY ';
	
	if (!is_array($orderBy))
	{
		//[dv] is_string() is not enough, as empty values are coming across as strings according to var_dump()
		if (strlen($orderBy) > 1) 
			return $sql.$orderBy;
		elseif (is_string($default))
			return $sql.$default;
		else 
			return false;
	}
	
	foreach ($orderBy as $o)
		$tmp[] = str_replace('_', ' ', $o);
	
	return $sql.implode(', ',$tmp);
}

/**
* Generates an HTML formatted backtrace to pinpoint exactly where code STB. 
* 
* taken from the PHP user supplied functions as adodb_backtrace()
* shows the functions, file:// and line #
* this is not database specific, i only include it here for convenience as this is included on every page,
* and more often than not, your SQL is what barfs, moreso than any other function...
*
* @access public
* @return 	an HTML formatted string complete with file, function and line that barfed
* @param 	$print defaults to true, but can be false if you just want the returned string.
* @author 	[jlim@natsoft.com.my]
* @since 	3.0
* @version 	1.1
* @date    	09/15/04
*/
function backtrace($print = true)
{
	$s = '';
	$MAXSTRLEN = 64;
	$s = "\n<pre align=left CLASS='error'><B><U>BACKTRACE</U></B> ::\n";
	$traceArr = debug_backtrace();
	array_shift($traceArr);
	$tabs = sizeof($traceArr)-1;
	foreach ($traceArr as $arr) 
	{
		for ($i=0; $i < $tabs; $i++) $s .= ' &nbsp; ';
		$tabs -= 1;
		//$s .= "<FONT CLASS='error'>";
		if (isset($arr['class'])) $s .= $arr['class'].'.';
		if (isset($arr['args']) && is_array($arr['args']))
			foreach($arr['args'] as $v) 
			{
				if (is_null($v)) $args[] = 'null';
				else if (is_array($v)) $args[] = 'Array['.sizeof($v).']';
				else if (is_object($v)) $args[] = 'Object:'.get_class($v);
				else if (is_bool($v)) $args[] = $v ? 'true' : 'false';
				else { 
					$v = (string) @$v;
					$str = htmlspecialchars(substr($v,0,$MAXSTRLEN));
					if (strlen($v) > $MAXSTRLEN) $str .= '...';
					$args[] = $str;
				}
			}
		
		if (isset($arr['args']) && is_array($args))
			$s .= '<B>'.$arr['function'].'(</B>'.implode(', ',$args).'<B>)</B>';
		//$s .= '</FONT>';
		$s .= sprintf("<FONT COLOR='#808080' SIZE='-3'> :: line #%d,"." file: <a href=\"file:/%s\">%s</a></font>",$arr['line'],$arr['file'],$arr['file']);
		$s .= "\n";
	} 
	$s .= "</pre>\n";
	if ($print) print $s;
	return $s;
} //backtrace()

###################################################################################################################
###################################################################################################################
###################################################################################################################

/**
* Adds the checkmark to the checkbox in a form element.
*
* used in a checkbox form element like so:
* <INPUT TYPE="checkbox" NAME="whitelist[]" VALUE="2" CLASS="blackborder" <?=CHECKED_IfInArray($_GET['whitelist'], '2')>
*
* @access 	public
* @return 	"CHECKED".
* @param 	$formArray the array that contains the checkbox items.
* @param 	$string the &string in the formArray we're looking for.
* @author 	Daevid Vincent [daevid@LockdownNetworks.com]
* @since 	3.0
* @version  1.1
* @date    	07/16/04
*/
function CHECKED_IfInArray($formArray, $string)
{
	if ( !is_array($formArray) ) return false;
	if ( in_array($string, $formArray) ) echo " CHECKED";
}

/**
* Adds the SELECTED to the checkbox in a form element.
*
* used in a checkbox form element like so:
* <OPTION <?=SELECTED_IfInArray($_GET['whitelist'], '2')>
*
* @access 	public
* @return 	"SELECTED".
* @param 	$formArray the array that contains the selected items, pass by &reference.
* @param 	$string the &string in the formArray we're looking for.
* @author 	Daevid Vincent [daevid@LockdownNetworks.com]
* @since 	3.0
* @version 	1.0
* @date    	06/16/04
*/
function SELECTED_IfInArray($formArray, $string)
{
	if ( !is_array($formArray) ) return false;
	if ( in_array($string, $formArray) ) echo " SELECTED";
}

/**
* Clear out the vars in $_POST
* @param	bool	$debug	Turn debugging on/off
* @access	public
* @author Daevid Vincent [daevid@LockdownNetworks.com]
* @since 3.0
* @version 1.0
* @date    06/23/04
*/
function clearPostVars($debug = false)
{
	foreach ($_POST as $key => $value) {
	    if ($debug) echo "clearing _POST['$key'] = $value<br>\n";
		unset($_POST[$key]);
	}
}

/**
* Clear out the vars in $_GET
* @param	bool	$debug	Turn debugging on/off
* @access	public
* @author Daevid Vincent [daevid@LockdownNetworks.com]
* @since 3.0
* @version 1.0
* @date    06/23/04
*/
function clearGetVars($debug = false)
{
	foreach ($_GET as $key => $value) {
	    if ($debug) echo "clearing _POST['$key'] = $value<br>\n";
		unset($_GET[$key]);
	}
}

/**
* Clear out all of the global vars based on a prefix
* @param	string	$prefix	Prefix to use on global vars
* @param	bool	$debug	Turn debugging on/off
* @access	public
* @author Daevid Vincent [daevid@LockdownNetworks.com]
* @since 3.0
* @version 1.0
* @date    06/23/04
 */
function clearGlobalVars($prefix, $debug = false)
{
	$length = strlen($prefix);
	foreach ($GLOBALS as $key => $value) {
		if ( substr($key,0,$length) == $prefix ) {
		  if ($debug) echo "clearing GLOBALS[".$key."] = ".$value."<br>\n";
		  unset($GLOBALS[$key]);
		}
	}
	clearPostVars();
}

/**
* Print out everything in the $_GET/$_POST vars
* @access	public
* @author Daevid Vincent [daevid@LockdownNetworks.com]
* @since 3.0
* @version 1.0
* @date    06/23/04
*/
function printGetPost()
{
	foreach($_GET as $k => $v)
	{
		if (is_array($v))
		{
			print '_GET['.$k.'] => ';
			print_r($v);
			print '<BR>';
		}
		else
			print '_GET['.$k.'] => '.$v.'<BR>';
	}
	print '<P>';
	foreach($_POST as $k => $v)
	{
		if (is_array($v))
		{
			print '_POST['.$k.'] => ';
			print_r($v);
			print '<BR>';
		}
		else
			print '_POST['.$k.'] => '.$v.'<BR>';
	}
}

//TODO: comment this out later when done debugging.
function printGlobalVars($prefix)
{
	echo "Printing GLOBALS[".$prefix."]<BR>";
	$length = strlen($prefix);
	foreach ($GLOBALS as $key => $value) {
		if ( substr($key,0,$length) == $prefix )
		  echo "GLOBALS[".$key."] = ".$value."<br>\n";
	}
}

/**
* Dynamically generates a select box from a $key => $value array or SQL query
*
* this is just a wrapper function around SelectBoxSQL and SelectBoxArray
* the array can be generated on the fly or stored.
* the key is the OPTION value and the $value is the name shown in the box.
* very useful for boolean type listboxes too.
* also useful to save DB queries for supporting tables.
*
* @access public
* @return 	<SELECT><OPTTION VALUE=''></SELECT> form element prefilled in.
* @param 	$size usually 1, but the select box can be any height.
* @param 	$name the NAME='$name' parameter of a SELECT tag.
* @param 	$DATA either an array or SQL query.
* @param 	$blank add the extra 'empty' <OPTION VALUE=''>.
* @param 	$auto onChange will cause a form submit if true.
* @param 	$MatchToThis sometimes it is useful to match $name to something like $_GET['name'] instead
* @param 	$extratags Any extra CLASS='' or MULTIPLE or whatever to put in the <SELECT ...> tag.
* @author Daevid Vincent [daevid@LockdownNetworks.com]
* @since 3.0
* @version 1.0
* @date    06/23/04
*/
function SelectBox($size, $name, $DATA, $blank = false, $auto = false, $MatchToThis = false, $extratags = false)
{
	if (is_array($DATA))
		$result = SelectBoxArray($size, $name, $DATA, $blank, $auto, $MatchToThis, $extratags);
	else
		$result = SelectBoxSQL($size, $name, $DATA, $blank, $auto, $MatchToThis, $extratags);

	return $result;
} //SelectBox

/**
* Dynamically generates a select box from a $key => $value array.
*
* the array can be generated on the fly or stored.
* the key is the OPTION value and the $value is the name shown in the box.
* very useful for boolean type listboxes too.
* also useful to save DB queries for supporting tables.
*
* @access 	public
* @return 	# of elements in select box or false.
* @param 	$size usually 1, but the select box can be any height.
* @param 	$name the NAME='$name' parameter of a SELECT tag.
* @param 	$listArray The actual key => value formatted array.
* @param 	$blank add the extra 'empty' <OPTION VALUE=''>.
* @param 	$auto onChange will cause a form submit if true.
* @param 	$MatchToThis sometimes it is useful to match $name to something like $_GET['name'] instead. it is array safe too!
* @param 	$extratags Any extra CLASS='' or MULTIPLE or whatever to put in the <SELECT ...> tag.
* @author 	Daevid Vincent [daevid@LockdownNetworks.com]
* @since 	3.0
* @version 	1.2
* @date    	10/01/04
*/
function SelectBoxArray($size, $name, $listArray, $blank = false, $auto = false, $MatchToThis = false, $extratags = false)
{
	global $$name;
	$items = 0;
	if (intval($size) < 1) $size = 1;
	if ($MatchToThis === false) $MatchToThis = $$name;

	echo "\n<SELECT SIZE='".$size."' NAME=\"".$name."\" ID=\"".$name."\"";
	if ($auto) echo " onChange=\"this.form.submit(); return true;\"";
	if ($extratags) echo " ".$extratags;
	echo ">\n";

	if (count($listArray) > 0)
	{
		if ($blank && is_bool($blank) ) { echo "\n<OPTION VALUE=''></OPTION>\n"; }
		elseif ($blank && is_string($blank)) { echo "\n<OPTION VALUE=''>".$blank."</OPTION>\n"; }
		foreach($listArray as $key => $val)
		{
			// Check for selectbox sub-headings.
			if ( 0 == strncmp( $val, "---", 3 ) )
			{
				echo "<OPTION VALUE='' DISABLED CLASS='selectbox-ghosted'>".stripslashes($val)."</OPTION>\n";
			}
			else
			{
				echo "\t<OPTION VALUE='".$key."'";
				if (!SELECTED_IfInArray($MatchToThis, $key))
					if ($key == $MatchToThis) echo " SELECTED";
				echo ">";
				echo stripslashes($val);
				echo "</OPTION>\n";
			}
		} //foreach
	} //if count(listArray)

	echo "</SELECT>\n";

	return ( count( $listArray ) );
}
function SQL_CLEAN ($s) {
  if (!isset($s) || $s == '' || is_array($s)) return $s;
  return mysqli_real_escape_string ($GLOBALS['__DB_HANDLE'], $s);
} // end SQL_CLEAN

?>
