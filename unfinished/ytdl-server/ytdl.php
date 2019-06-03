<?php

/** YouTube Downloader Server

Your own youtube downloading server.

Enter URLs

These get written to a working file after sanitizing

A script gets kicked off to pass these to youtube-dl
*/

$YTDLBIN='/home/tai/bin/youtube-dl';


if ( array_key_exists('yturls',$_POST) ) {
	$allurls = explode('\n|\r|\n\r|\s',$_POST['yturls']);
	foreach( $allurls as $yturl ) {
		preg_match('/(\?|&)v=([a-zA-Z0-9_-]+)&?/',$yturl,$regres);
		$ytvid=$regres[2]; 
		if($ytvid==''){continue;}
		# print( "<p>[ $ytvid FROM $yturl ]</p>" );
		print("bash -c \"$YTDLBIN -x --audio-format vorbis 'http://youtube.com/watch?v=$ytvid'\"");#,$ytdloutput);
		print_r($ytdloutput);
		exec("ls | grep '$ytvid'",$fileres);
		print_r($fileres);
		#$resfile=$fileres[0];
		#$newresfile=preg_replace('/[^a-zA-Z0-9_.-]+/','_',$resfile);
		#exec("mv '$resfile' files/$newresfile");
		?><p><a href="<?= "files/$newresfile" ?>">Download <?= $resfile ?></a></p><?php
	}
}

?>
<html>
<head><title>YouTube Downloader</title>
</head>
<body>

<form method="POST" action="ytdl.php">

<p id="url_input">
<label for="yturls" id="url_label">YouTube URLs (one per line)</label><br />
<textarea id="yturls" name="yturls"></textarea>
</p>

<p id="buttons"><input type="submit" id="submitbutton" value="Download!" /></p>

</form>

</body>
