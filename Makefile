CV = loughry_cv

CV_source = $(CV).tex
distribution_filename = Joe.Loughry_information_security.pdf

latex_cmd = pdflatex
counter_file = build_counter.txt
stop_here_file = stop_here.tex

CV_pdf_file = $(CV).pdf

pdf_files = $(CV_pdf_file) $(distribution_filename)

temporary_files = $(CV).log $(CV).aux .pdf $(CV).out $(stop_here_file)

all: cv

help:
	@echo "'make resume' makes a one-page resume"
	@echo "'make cv' makes full CV"

increment_build_counter:
	@echo $$(($$(cat $(counter_file)) + 1)) > $(counter_file)

set_résumé_flag:
	@echo "\end{document}" > $(stop_here_file)

clear_résumé_flag:
	@echo > $(stop_here_file)

rename:
	mv $(CV_pdf_file) $(distribution_filename)
	chmod a-x,a+r $(distribution_filename)

resume: $(CV_source) Makefile
	make set_résumé_flag
	make $(CV_pdf_file)

cv: $(CV_source) Makefile
	make clear_résumé_flag
	make $(CV_pdf_file)

$(CV_pdf_file): $(CV_source)
	make increment_build_counter
	$(latex_cmd) $(CV_source)
	while ( \
		$(latex_cmd) $(CV) ; \
		grep "Rerun to get" $(CV).log > /dev/null \
	) do true ; done
	make rename
	@echo "Build `cat $(counter_file)`"

vi:
	vi $(CV_source)

edit:
	vi $(CV_source)

spell:
	aspell --lang=EN_GB check $(CV_source)

notes:
	(cd ../notes/ && make notes)

bibtex:
	(cd ../bibtex/ && make vi)

clean:
	rm -f $(temporary_files)

allclean: clean
	rm -f $(pdf_files)

