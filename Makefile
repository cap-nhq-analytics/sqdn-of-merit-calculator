all: docs readme package

docs:
	Rscript -e "library(devtools); document()"

readme: docs
	Rscript -e "library(rmarkdown); render('./vignettes/som-calculation.Rmd', output_format = 'md_document')"
	mv ./vignettes/som-calculation.md ./README.md

package: docs readme
	Rscript -e "library(devtools); build()"
