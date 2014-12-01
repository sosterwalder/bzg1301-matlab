filename = documentation

all: clean build clean-temp

build:
	pdflatex $(filename).tex
	bibtex $(filename).aux
	pdflatex $(filename)
	makeglossaries $(filename).glo
	pdflatex $(filename)

clean: clean-temp
	@rm -f *.pdf

clean-temp:
	@rm -f *.fdb_latexmk
	@rm -f *.latexmain
	@rm -f *.aux
	@rm -f *.idx
	@rm -f *.glo
	@rm -f *.fls
	@rm -f *.ist
	@rm -f *.ilg
	@rm -f *.ind
	@rm -f *.lof
	@rm -f *.log
	@rm -f *.lot
	@rm -f *.out
	@rm -f *.toc
	@rm -f *.bbl
	@rm -f *.blg
	@rm -f *.glg
	@rm -f *.gls
	@rm -f *.tcp
	@rm -f chapters/*.aux
	@rm -f lead/*.aux
	@rm -f db/*.aux
