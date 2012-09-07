CV = loughry_cv
resume = loughry_resume

CV_source = $(CV).tex
resume_source = $(resume).tex

latex_cmd = pdflatex
counter_file = build_counter.txt

CV_pdf = $(CV).pdf
resume_pdf = $(resume).pdf
pdf_files = $(CV_pdf) $(resume_pdf)

temporary_files = $(CV).log $(resume).log $(CV).aux $(resume).aux .pdf $(CV).out $(resume).out

all: $(CV_pdf) $(resume_pdf)

$(CV_pdf): $(CV_source) Makefile
	@echo $$(($$(cat $(counter_file)) + 1)) > $(counter_file)
	$(latex_cmd) $(CV_source)
	while ( \
		$(latex_cmd) $(CV) ; \
		grep "Rerun to get" $(CV).log > /dev/null \
	) do true ; done
	@echo "Build `cat $(counter_file)`"
	chmod a-x,a+r $(CV_pdf)

$(resume_pdf): $(resume_source) Makefile
	@echo $$(($$(cat $(counter_file)) + 1)) > $(counter_file)
	$(latex_cmd) $(resume_source)
	while ( \
		$(latex_cmd) $(resume) ; \
		grep "Rerun to get" $(resume).log > /dev/null \
	) do true ; done
	@echo "Build `cat $(counter_file)`"
	chmod a-x,a+r $(resume_pdf)

vir:
	vi $(resume_source)

vic:
	vi $(CV_source)

spell:
	aspell --lang=EN_GB check $(CV_source)
	aspell --lang=EN_GB check $(resume_source)

notes:
	(cd ~/Documents/thesis/tex/dissertation && make notes)

bibtex:
	(cd ../bibtex && make vi)

clean:
	rm -f $(temporary_files)

allclean: clean
	rm -f $(pdf_files)

