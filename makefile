POSTS_DIR = posts
TEMPLATE_DIR = ${POSTS_DIR}/templates
TEMPLATE_HTML5 = ${TEMPLATE_DIR}/template.html5
METADATA = ${TEMPLATE_DIR}/metadata.yaml
CSS = "../static/style.css"
FLAG = --data-dir . --template $(TEMPLATE_HTML5) --standalone --toc --toc-depth=2 --mathjax --metadata last_modified="`date +%FT%TZ`"
SRC = ${POSTS_DIR}/src
RSS = atom.xml
SITEMAP = sitemap.xml

MD = $(shell ls ${SRC} | grep \.md)
HTML = ${MD:%.md=${POSTS_DIR}/%.html}

all: ${HTML}

${POSTS_DIR}/%.html: ${SRC}/%.md ${METADATA}
	@echo Converting $< to $@
	@pandoc ${METADATA} $< -f markdown --css ${CSS} -t html ${FLAG} -o $@

rss: rss_generator.py all
	@rm -f $(RSS)
	@echo Generating RSS feed...
	python3 ./rss_generator.py
	@echo Done!

sitemap: sitemap_generator.py all
	@rm -f ${SITEMAP}
	@echo Generating sitemap...
	python3 ./sitemap_generator.py
	@echo done

sync: all
	@rsync -cavz ./ root@144.202.35.37:/var/www/html --delete

clean:
	@rm $(HTML)