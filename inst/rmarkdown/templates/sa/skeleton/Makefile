FILE = _main.knit
TEMPLATE = c:/stockassessment/ss/sa4ss/inst/rmarkdown/templates/sa/resources/sadraft.tex
SHIT = c:/accpdf/common/tagged-template.latex
ENGINE = lualatex

pdf:
	pandoc -o $(FILE).pdf $(FILE).md --pdf-engine=$(ENGINE) --template=$(TEMPLATE) --lua-filter=tagged-filter.lua

tex:
	pandoc -o $(FILE).tex $(FILE).md --filter=pandoc-citeproc --lua-filter=tagged-filter.lua --template=$(TEMPLATE) --bibliography=sa4ss.bib

clean:
	rm -f $(FILE).aux $(FILE).log $(FILE).xmpdata pdfa.xmpi

pdfnb: tex
	sed -i '/^$$/d;/\\endfirsthead/,/\\endhead/c\\\endfirsthead' $(FILE).tex
	rm -f $(FILE).xmpdata
	$(ENGINE) $(FILE).tex
