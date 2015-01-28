<?php

/** YouTube Downloader Server

Your own youtube downloading server.

Enter URLs

These get written to a working file after sanitizing

A script gets kicked off to pass these to youtube-dl
*/


?>
<html>
<head> <title>YouTube Downloader</title>
</head>
<body>

<form method="POST" action="ytdl.php">

<p id="url_input">
<label for="yturls" id="url_label">YouTube URLs</label><br />
<textarea id="yturls" name="yturls"></textarea>
</p>

<p id="buttons"><input type="submit" id="submitbutton" value="Download!" /></p>

</form>

</body>
