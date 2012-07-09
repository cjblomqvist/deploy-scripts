# Index file
INDEX_FILE = index.html

# Final names for css and js files
CSS_FINAL = css/all.css
JS_FINAL = js/all.js

# Tags used in INDEX_FILE (regexps)
START_CSS_TAG = <!--[ ]*CONCAT:CSS[ ]*-->
END_CSS_TAG = <!--[ ]*\/CONCAT:CSS[ ]*-->
START_JS_TAG = <!--[ ]*CONCAT:JS[ ]*-->
END_JS_TAG = <!--[ ]*\/CONCAT:JS[ ]*-->

# YUI variables
YUI = java -jar /opt/yuicompressor-2.4.7/build/yuicompressor-2.4.7.jar
YUI_FLAGS = --type css

# HTML compressor variables
HTML_MIN = java -jar /opt/htmlcompressor-1.5.3/htmlcompressor-1.5.3.jar 

# Temp file used to save INDEX_FILE while processing it
TEMP_FILE = tmp.tmp

## Grab all css files from INDEX_FILE

# sed explanation:
#	1: remove everything outside of START_PARENTHESIS and END_PARENTHESIS
#	2: remove the first line (the line with START_PARENTHESIS)
#	3: remove the the line with END_PARENTHESIS (the last line)
#	4: remove everything not insidesrc="" on each line
#	5: grab from INDEX_FILE 
#	6: replace new lines with space
CSS_FILES = $(shell sed \
	-e "/$(START_CSS_TAG)/,/$(END_CSS_TAG)/ !d" \
	-e "1,1 d" \
	-e "/$(END_CSS_TAG)/ d" \
	-e 's/.*href="\(.*\)".*/\1/' \
		< $(INDEX_FILE) | \
			tr "\n" " " \
				)

## Grab all js files from INDEX_FILE

JS_FILES = $(shell sed \
	-e "/$(START_JS_TAG)/,/$(END_JS_TAG)/ !d" \
	-e "1,1 d" \
	-e "/$(END_JS_TAG)/ d" \
	-e 's/.*src="\(.*\)".*/\1/' \
		< $(INDEX_FILE) | \
			tr "\n" " " \
				)

all: MODIFY_INDEX_CSS MODIFY_INDEX_JS MINIFY_INDEX

MODIFY_INDEX_CSS: CREATE_CSS
	sed \
		-e '/$(START_CSS_TAG)/,/$(END_CSS_TAG)/ {0,/href="\(.*\)"/ s|href="\(.*\)"|href="$(CSS_FINAL)"|}' \
		-e '/$(START_CSS_TAG)/,/$(END_CSS_TAG)/ {\|href="$(CSS_FINAL)"| !d}' \
			<$(INDEX_FILE) >$(TEMP_FILE)
	cat $(TEMP_FILE) > $(INDEX_FILE)
	rm $(TEMP_FILE)

MODIFY_INDEX_JS: CREATE_JS
	sed \
		-e '/$(START_JS_TAG)/,/$(END_JS_TAG)/ {0,/src="\(.*\)"/ s|src="\(.*\)"|src="$(JS_FINAL)"|}' \
		-e '/$(START_JS_TAG)/,/$(END_JS_TAG)/ {\|src="$(JS_FINAL)"| !d}' \
			<$(INDEX_FILE) >$(TEMP_FILE)
	cat $(TEMP_FILE) > $(INDEX_FILE)
	rm $(TEMP_FILE)

MINIFY_INDEX:
	$(HTML_MIN) -o $(INDEX_FILE) $(INDEX_FILE)

# Create CSS file only if CONCAT tag exists for CSS
CREATE_CSS:
ifneq ($(CSS_FILES),)
	cat $(CSS_FILES) | $(YUI) $(YUI_FLAGS) -o $(CSS_FINAL)
endif

# Create JS file only if CONCAT tag exists for JS
CREATE_JS:
ifneq ($(JS_FILES),)
	cat $(JS_FILES) | uglifyjs -o $(JS_FINAL)
endif