deploy-scripts
==============

# Makefile

Concatenates, minifies and renames for optimal caching CSS and JS files specified in HTML source. Also minifies HTML.

#### Usage
Makefile uses two tags in your file with HTML (can be raw HTML, ASP, PHP or any other file which contains HTML), to denote where and which CSS and JS files to concatenate and minify. By default, these are regular HTML comments with 'CONCAT:XXX' where XXX is either JS or CSS, but these can be easily modified. An example

##### Your index.html pre make

```html
<html>

...


<!-- Below stylesheet will not be minified and concatenated -->
<!-- Also, below would have broken the script because no root slash is allow at the moment (or, it will most likely end up doing some weird stuff if a root slash is included) -->
<link rel="stylesheet" href="/css/no_minify_and_concat.css">

<!-- Below stylesheets will however -->
<!-- CONCAT:CSS -->
<link rel="stylesheet" href="css/stylesheet1.css">
<link rel="stylesheet" href="css/stylesheet2.css">
<link rel="stylesheet" href="css/stylesheet3.css">
<!-- /CONCAT:CSS -->


...


<!-- Below two scripts will not be minified and concatenated -->
<!-- Also, below would have broken the makefile script because only local files are allowed -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>

<!-- Below scripts will however -->
<!-- CONCAT:JS -->
<script src="js/script1.js"></script>
<script src="js/script1.js"></script>
<script src="js/script1.js"></script>
<!-- /CONCAT:JS -->


...

</html>
```

##### Your index.html post make 
Note: Comments are kept just in order for clarity of what is actually modified
Note2: <md5hash> in the filenames of the concatenated and minified files is the md5hash of the file. This is done in order to optimize caching.

```html
<html>

...


<!-- Below stylesheet will not be minified and concatenated -->
<!-- Also, below would have broken the script because no root slash is allow at the moment (or, it will most likely end up doing some weird stuff if a root slash is included) -->
<link rel="stylesheet" href="/css/no_minify_and_concat.css">

<!-- Below stylesheets will however -->
<link rel="stylesheet" href="css/all.<md5hash>.css">


...


<!-- Below script will not be minified and concatenated -->
<!-- Also, below would have broken the makefile script because only local files are allowed -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>

<!-- Below scripts will however -->
<script src="js/all.<md5hash>.js"></script>


...

</html>
```

#### Requirements
You need to specify a library for HTML, CSS and JS optimization/minification. Default is:

* HTML: HTML Compressor - http://code.google.com/p/htmlcompressor/
* CSS: YUI Compressor - http://developer.yahoo.com/yui/compressor/
* JS: UglifyJS - https://github.com/mishoo/UglifyJS/

This can easily be modified for your own use. Note that you need to specify the location of the CLIs of respective optimizer/minifcator in the Makefile before using it.


# ftp_upload_script.sh
Shell script for uploading folder to FTP using ncftp. Usage:

```
sh /your/place/of/the/script/ftp_upload_script.sh <host> <user> <password> <destination folder on ftp> <source folder on local>
```