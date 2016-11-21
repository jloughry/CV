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

#
# Useful targets:
#
# make resume (two pages)
# make longform (three pages)
#

CV = loughry_cv
references = references

CV_source = $(CV).tex
references_source = $(references).tex
distribution_filename = Joe_Loughry_cybersecurity.pdf
references_distribution_filename = Joe.Loughry_references.pdf

section_sources = section_clearance.tex section_header.tex \
    section_patents.tex section_conferences.tex \
    section_journals.tex section_preamble.tex \
    section_education.tex section_open_source.tex \
    section_leadership.tex section_experience.tex \
    section_other_published_reports.tex section_security_vulns.tex

section_education               = section_education.tex
section_clearance               = section_clearance.tex
section_header                  = section_header.tex
section_other_published_reports = section_other_published_reports.tex
section_conferences             = section_conferences.tex
section_journals                = section_journals.tex
section_patents                 = section_patents.tex
section_leadership              = section_leadership.tex
section_preamble                = section_preamble.tex
section_experience              = section_experience.tex
section_open_source             = section_open_source.tex
section_security_vulns          = section_security_vulns.tex

latex_cmd = pdflatex
counter_file = build_counter.txt
stop_here_file = stop_here.tex

CV_pdf_file = $(CV).pdf

pdf_files = $(CV_pdf_file) $(distribution_filename) $(references_distribution_filename)

temporary_files = $(CV).log $(CV).aux .pdf $(CV).out $(stop_here_file) \
	$(references).aux $(references).log $(references).out texput.log \
	$(CV_source).bak

all:: resume

increment_build_counter:
	@echo $$(($$(cat $(counter_file)) + 1)) > $(counter_file)

help:
	@echo "'make resume' makes a two-page resume"
	@echo "'make longform' makes full CV"

set_résumé_flag:
	@echo > $(stop_here_file)
	@echo "\vfill" >> $(stop_here_file)
	@echo "{\noindent\tiny \TeX\ build \input{build_counter.txt}}" >> $(stop_here_file)
	@echo "\hfill" >> $(stop_here_file)
	@echo "PGP key fingerprint: \href{http://cnadocs.com/Joe.Loughry.txt}%" \
		>> $(stop_here_file)
	@echo "{\texttt{2C3B 11A1 CE7C 5B1F 87BC  F5D0 299D 7116 EDC2 ABE5}} \\\\" >> $(stop_here_file)
	@echo "\end{document}" >> $(stop_here_file)

clear_résumé_flag:
	@echo > $(stop_here_file)

rename:
	mv $(CV_pdf_file) $(distribution_filename)
	chmod a-x,a+r $(distribution_filename)
	mv $(references).pdf Joe.Loughry_references.pdf
	chmod a-x,a+r Joe.Loughry_references.pdf

resume: $(CV_source) $(section_sources) Makefile
	make set_résumé_flag
	make $(CV_pdf_file)
	@echo
	@echo "If printing this on US-LETTER paper, be sure to set printer paper size!"

longform: $(CV_source) $(section_sources) Makefile
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

header:
	vi $(section_header)

preamble:
	vi $(section_preamble)

leadership:
	vi $(section_leadership)

patents:
	vi $(section_patents)

skills:
	vi $(section_experience)

experience:
	vi $(section_experience)

security_vulns:
	vi $(section_security_vulns)

open_source:
	vi $(section_open_source)

journals:
	vi $(section_journals)

conferences:
	vi $(section_conferences)

other_published_reports:
	vi $(section_other_published_reports)

clearance:
	vi $(section_clearance)

education:
	vi $(section_education)

#
# spell and clean have a double colon because the common makefile extends them.
#

spell::
	aspell --lang=EN_GB check $(CV_source)

	aspell --lang=EN_GB check $(section_education)
	aspell --lang=EN_GB check $(section_clearance)
	aspell --lang=EN_GB check $(section_header)
	aspell --lang=EN_GB check $(section_other_published_reports)
	aspell --lang=EN_GB check $(section_conferences)
	aspell --lang=EN_GB check $(section_journals)
	aspell --lang=EN_GB check $(section_patents)
	aspell --lang=EN_GB check $(section_leadership)
	aspell --lang=EN_GB check $(section_preamble)
	aspell --lang=EN_GB check $(section_experience)
	aspell --lang=EN_GB check $(section_open_source)
	aspell --lang=EN_GB check $(section_security_vulns)

	aspell --lang=EN_GB check $(references_source)

clean::
	@echo "This is \"clean\" in the local Makefile."
	rm -fv $(temporary_files)

allclean: clean
	rm -fv $(pdf_files)

include common.mk

