target = loughry_cv

source = $(target).tex
latex_cmd = pdflatex
counter_file = build_counter.txt
pdf_file = $(target).pdf

temporary_files = $(target).log $(target).aux .pdf $(target).out

$(pdf_file): $(source) Makefile
	@echo $$(($$(cat $(counter_file)) + 1)) > $(counter_file)
	$(latex_cmd) $(source)
	while ( \
		$(latex_cmd) $(target) ; \
		grep "Rerun to get" $(target).log > /dev/null \
	) do true ; done
	@echo "Build `cat $(counter_file)`"
	chmod a-x,a+r $(pdf_file)

vi:
	vi $(source)

spell:
	aspell --lang=EN_GB check $(source)

clean:
	rm -f $(temporary_files)

allclean: clean
	rm -f $(pdf_file)

