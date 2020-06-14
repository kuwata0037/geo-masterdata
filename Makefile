OUT := output

#
# Public task
#
.PHONY: all
all: help

.PHONY: mesh2r
mesh2r: shape2csv-mesh2r ## Create secondary mesh date from shapefile
	@cat $(OUT)/$@.tsv \
	| awk 'BEGIN { FS="\t"; OFS="\t" } { print $$2, $$1 }' \
	> $(OUT)/tmp.tsv
	@mv $(OUT)/tmp.tsv $(OUT)/$@.tsv

.PHONY: mesh3r
mesh3r: shape2csv-mesh3r ## Create 3rd mesh date from shapefile
	@cat $(OUT)/$@.tsv \
	| awk 'BEGIN { FS="\t"; OFS="\t" } { print $$2, $$1 }' \
	> $(OUT)/tmp.tsv
	@mv $(OUT)/tmp.tsv $(OUT)/$@.tsv

.PHONY: clean
clean: ## Remove output files
	@rm -fr $(OUT)

.PHONY: help
help: ## Show self-documented Makefile
	@echo 'Usage: make [target] [SHAPE=/path/to/shapefile.shp]'
	@echo ''
	@echo 'Targets:'
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "...\033[36m%-10s\033[0m %s\n", $$1, $$2}'


#
# Private task
#
.PHONY: shape2csv
shape2csv-%: guard-SHAPE
	@mkdir -p $(OUT)
	@docker-compose run --rm gdal ogr2ogr -f CSV -lco SEPARATOR=TAB -lco GEOMETRY=AS_WKT -oo ENCODING=CP932 -t_srs EPSG:4326 -overwrite -progress $(OUT)/${*}.csv $(SHAPE)
	@sed -e '1d' $(OUT)/${*}.csv \
	| sed -e 's/\(POINT\)/SRID=4326;\1/g' -e 's/\(LINESTRING\)/SRID=4326;\1/g' -e 's/\(POLYGON\)/SRID=4326;\1/g' \
	> $(OUT)/${*}.tsv
	@rm $(OUT)/${*}.csv

.PHONY: gurad-%
guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable '$*' not set"; \
		exit 1; \
	fi
