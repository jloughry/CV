CV = loughry_cv
references = references

CV_source = $(CV).tex
references_source = $(references).tex
distribution_filename = Joe.Loughry_information_security.pdf
references_distribution_filename = Joe.Loughry_references.pdf
documentation = README.md

latex_cmd = pdflatex
counter_file = build_counter.txt
stop_here_file = stop_here.tex

CV_pdf_file = $(CV).pdf

pdf_files = $(CV_pdf_file) $(distribution_filename) $(references_distribution_filename)

temporary_files = $(CV).log $(CV).aux .pdf $(CV).out $(stop_here_file) \
	$(references).aux $(references).log $(references).out texput.log

#
# Note: make requires that we set the value of a variable OUTSIDE any rules.
#

timestamp = `date +%Y%m%d.%H%M`

all: resume

commit:
	make clean
	git add .
	git commit -am "commit from Makefile $(timestamp)"
	make sync

sync:
	git pull --rebase
	git push

commit-only:
	make clean
	git add .
	git commit -am "commit from Makefile $(timestamp)"

increment_build_counter:
	@echo $$(($$(cat $(counter_file)) + 1)) > $(counter_file)

help:
	@echo "'make resume' makes a one-page resume"
	@echo "'make cv' makes full CV"

set_résumé_flag:
	@echo "\vfill" > $(stop_here_file)
	@echo "{\tiny \LaTeX\ build \input{build_counter.txt}}" >> $(stop_here_file)
	@echo "\end{document}" >> $(stop_here_file)

clear_résumé_flag:
	@echo > $(stop_here_file)

rename:
	mv $(CV_pdf_file) $(distribution_filename)
	chmod a-x,a+r $(distribution_filename)
	mv $(references).pdf Joe.Loughry_references.pdf
	chmod a-x,a+r Joe.Loughry_references.pdf

resume: $(CV_source) Makefile
	make set_résumé_flag
	make $(CV_pdf_file)

longform: cv

cv: $(CV_source) Makefile
	make clear_résumé_flag
	make $(CV_pdf_file)

references:
	vi $(references_source)

$(CV_pdf_file): $(CV_source)
	$(latex_cmd) $(CV_source)
	while ( \
		$(latex_cmd) $(CV) ; \
		grep "Rerun to get" $(CV).log > /dev/null \
	) do true ; done
	pdflatex $(references_source)
	pdflatex $(references)
	make rename
	make increment_build_counter
	@echo "Build `cat $(counter_file)`"

vi:
	vi $(CV_source)

edit:
	vi $(CV_source)

spell:
	aspell --lang=EN_GB check $(CV_source)
	aspell --lang=EN_GB check $(references_source)
	aspell --lang=EN_GB check $(documentation)

notes:
	(cd ../notes/ && make vi)

quotes:
	(cd ../notes/ && make quotes)

bibtex:
	(cd ../bibtex/ && make vi)

clean:
	rm -f $(temporary_files)

allclean: clean
	rm -f $(pdf_files)

