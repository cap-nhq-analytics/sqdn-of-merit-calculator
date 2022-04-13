all: docs readme manual package

docs:
	Rscript -e "library(devtools); document()"

readme: docs
	Rscript -e "library(rmarkdown); render('./vignettes/som-calculation.Rmd', output_format = 'md_document')"
	mv ./vignettes/som-calculation.md ./README.md

manual: docs
	Rscript -e "library(devtools); build_manual()"

package: docs readme manual
	Rscript -e "library(devtools); build()"
