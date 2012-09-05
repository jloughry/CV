CV = loughry_cv
résumé = loughry_résumé

CV_source = $(CV).tex
résumé_source = $(résumé).tex

latex_cmd = pdflatex
counter_file = build_counter.txt

CV_pdf = $(CV).pdf
résumé_pdf = $(résumé).pdf
pdf_files = $(CV_pdf) $(résumé_pdf)

temporary_files = $(CV).log $(résumé).log $(CV).aux $(résumé).aux .pdf $(CV).out $(résumé).out

all: $(CV_pdf) $(résumé_pdf)

$(CV_pdf): $(CV_source) Makefile
	@echo $$(($$(cat $(counter_file)) + 1)) > $(counter_file)
	$(latex_cmd) $(CV_source)
	while ( \
		$(latex_cmd) $(CV) ; \
		grep "Rerun to get" $(CV).log > /dev/null \
	) do true ; done
	@echo "Build `cat $(counter_file)`"
	chmod a-x,a+r $(CV_pdf)

$(résumé_pdf): $(résumé_source) Makefile
	@echo $$(($$(cat $(counter_file)) + 1)) > $(counter_file)
	$(latex_cmd) $(résumé_source)
	while ( \
		$(latex_cmd) $(résumé) ; \
		grep "Rerun to get" $(résumé).log > /dev/null \
	) do true ; done
	@echo "Build `cat $(counter_file)`"
	chmod a-x,a+r $(résumé_pdf)

vir:
	vi $(résumé_source)

vic:
	vi $(CV_source)

spell:
	aspell --lang=EN_GB check $(CV_source)
	aspell --lang=EN_GB check $(résumé_source)

notes:
	(cd ~/Documents/thesis/tex/dissertation && make notes)

bibtex:
	(cd ../bibtex && make vi)

clean:
	rm -f $(temporary_files)

allclean: clean
	rm -f $(pdf_files)

