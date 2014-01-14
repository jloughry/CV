#
# TODO: regression test the following lines to defend against problems
# with embedded fonts in PDF files:
#

# ps_file = $(target).ps
#
# pdf2ps $(pdf_file)
# rm -f $(pdf_file)
# ps2pdf -dPDFSETTINGS=/prepress $(ps_file)
# chmod a-x,a+r $(pdf_file)


CV = loughry_cv
references = references

CV_source = $(CV).tex
references_source = $(references).tex
distribution_filename = Joe.Loughry_information_security.pdf
references_distribution_filename = Joe.Loughry_references.pdf

latex_cmd = pdflatex
counter_file = build_counter.txt
stop_here_file = stop_here.tex

CV_pdf_file = $(CV).pdf

pdf_files = $(CV_pdf_file) $(distribution_filename) $(references_distribution_filename)

temporary_files = $(CV).log $(CV).aux .pdf $(CV).out $(stop_here_file) \
	$(references).aux $(references).log $(references).out texput.log

all:: resume

increment_build_counter:
	@echo $$(($$(cat $(counter_file)) + 1)) > $(counter_file)

help:
	@echo "'make resume' makes a two-page resume"
	@echo "'make longform' makes full CV"

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

longform: $(CV_source) Makefile
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

#
# spell and clean have a double colon because the common makefile extends them.
#

spell::
	aspell --lang=EN_GB check $(CV_source)
	aspell --lang=EN_GB check $(references_source)

clean::
	rm -f $(temporary_files)

allclean: clean
	rm -f $(pdf_files)

include common.mk

