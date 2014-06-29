[Joe Loughry](joe.loughry@stx.ox.ac.uk)
=============

Formatting a tactical résumé
----------------------------

*To make a short (two page) résumé, use `make`. To see the three-page CV including social
media and committee-ships, use `make longform`.*

### Concept

Trying something different here, let's make two files: a long-form CV with all the details and
a short-form résumé that just puts the exciting stuff on a single page.  Both are generated
from a single LaTeX source file.

It's not straightforward to pass parameters from the command line to TeX to accomplish something
like conditional compilation in C.  Here we use the most reliable technique, where the LaTeX source
file unconditionally `\input`s a file that is dynamically created by the `Makefile` just before
it's needed.

#### Résumé and filename

The résumé is a single page and not very full at that.  It shows the bare minimum information a
harried screener wants to see:

 - What positions, at what companies, has this person held?

 - Did he or she do anything interesting there?

 - Phone number and email address for the candidate.

To be nice to people trying to process files with automated tools that might not properly
handle non-ASCII characters in filenames, the file is called *resume*, not *résumé*.

#### CV

This file is about four pages long in PDF.  The first page is the résumé.  Keywords are
relegated to the last page where automated résumé filters will still find them, but they won't
distract human readers.  Keywords are separated by commas and formatting is deliberately kept
simple:

	Certification and Accreditation (C&A) of cross domain systems, Assessment and
	Authorization (A&A) for classified environments, Certification Test and Evaluation
	(CT&E), Security Test and Evaluation (ST&E), penetration testing, DIACAP, Common
	Criteria, DCID 6/3, programming in C and assembly language with a strong
	interest in Lisp derived languages, Compartmented Mode Workstation (CMW) programming,
	UNIX, Trusted Solaris versions 2.5-8, software development, R&D, principal
	investigator, U.S. citizen with TS/SCI clearance, technical writing, CISSP-ISSEP
	for DoD 8570.01 IAT, IAM, and IASAE Level III compliance required for software
	development that crosses multiple enclaves, experience living overseas, programming,
	publications, patents, public speaking, funding, research, and teaching experience.

Keywords are in no particular order, just arranged for even line length and colour when printed.  I
thought about making this section invisible, the way SEO companies put `meta` keywords in web pages
to get them indexed by search engines (and spammers use obfuscated text to evade mail filters) but
decided it would be dishonest, like malware in a PDF file.

#### Ligatures

Ligatures like *fi* and *ffl* look great on the printed page but they can be a barrier to
copy & paste.  Some PDF readers, notably Adobe Acrobat X, don't handle ligatures correctly when
pasting to plain text.  The word *Certification* comes out **Certi cation** and that
doesn't match a naïve regex.  The solution is to load the `cmap` package in LaTeX like this:

    \usepackage[resetfonts]{cmap}

The `resetfonts` option is required when used with the Computer Modern fonts which by default
are a little too clever with ligatures.  Remember, the goal here is to make things as easy
as possible for keyword filters used by Human Resources.  The same CMAP tables can do other
useful tricks like transforming curly quotation marks to straight ones upon copy to plain
text; &#8220;proper quotation marks&#8221; tend to paste into plain text as Unicode, and
that can also confuse a straightforward keyword search.  (It depends on the PDF reader; Adobe
Acrobat Reader X doesn't understand ligatures at all and pastes curly quotation marks as
unicode characters, but searches correctly across hyphens; in Mac OS X, the Preview programme
gets ligatures right and its search function correctly matches quotation marks whether curly
or straight.)

To make sure **grep** finds *all* my keywords, I altered the default CMAP table that gets compiled
into the PDF output, replacing every instance of `<201C>` (Unicode left double quotation mark)
and `<201D>` (Unicode right double quotation mark) with `<0022>` (ASCII double quote) and all
instances of `<2018>` (Unicode left single quotation mark) and `<2019>` (Unicode right single
quotation mark) with `<0027>` (ASCII single quotation mark).  This makes single and double
quotation marks in the PDF file copy and paste as straight quotes.  I further caused en dashes
to be replaced by a single hyphen and em dashes by two hyphens, to match traditional
typewriter usage.  The `ot1.cmap` file is written in PostScript; to override it, I simply made
a copy in the current directory and modified the copy:

	$ diff ot1.cmap.original ot1.cmap
	21c21
	< 8 beginbfrange
	---
	> 7 beginbfrange
	29d28
	< <7B> <7C> <2013>
	31c30
	< 40 beginbfchar
	---
	> 42 beginbfchar
	61,62c60,61
	< <22> <201D>
	< <27> <2019>
	---
	> <22> <0022>
	> <27> <0027>
	66c65
	< <5C> <201C>
	---
	> <5C> <0022>
	68c67,69
	< <60> <2018>
	---
	> <60> <0027>
	> <7B> <002D>
	> <7C> <002D002D>

This avoids having to install any software in the filesystem; PDFLaTeX preferentially uses
the modified `ot1.cmap` file if it finds one in the current directory.

A similar trick is done with LaTeX's bulleted lists, which use the *math mode* `\bullet`
because bullets don't appear in TeX's OT1 font encoding.  The following modifications
to the `oms.cmap` file in the current directory cause bullets at all four levels of a
LaTeX itemised list in the PDF file to automatically turn into asterisks, hyphens, or
plus signs when copied and pasted to plain text.

	$ diff oms.cmap.original oms.cmap
	28c28
	< <01> <00B7>
	---
	> <01> <002B>
	42c42
	< <0F> <2219>
	---
	> <0F> <002A>

I had to modify the distribution version of `cmap.sty` to get it to work with the `11pt`
and `12pt` options to `\documentclass` as follows:

	$ diff cmap.sty.original cmap.sty
	18,21c18,21
	<     OT1/cmr/m/n/5,OT1/cmr/m/n/7,OT1/cmr/m/n/10,%
	<     OML/cmm/m/it/5,OML/cmm/m/it/7,OML/cmm/m/it/10,%
	<     OMS/cmsy/m/n/5,OMS/cmsy/m/n/7,OMS/cmsy/m/n/10,%
	<     OMX/cmex/m/n/10%
	---
	>     OT1/cmr/m/n/5,OT1/cmr/m/n/7,OT1/cmr/m/n/10,OT1/cmr/m/n/11,OT1/cmr/m/n/12,%
	>     OML/cmm/m/it/5,OML/cmm/m/it/7,OML/cmm/m/it/10,OML/cmm/m/it/11,OML/cmm/m/it/12,%
	>     OMS/cmsy/m/n/5,OMS/cmsy/m/n/7,OMS/cmsy/m/n/10,OMS/cmsy/m/n/11,OMS/cmsy/m/n/12,%
	>     OMX/cmex/m/n/10,OMX/cmex/m/n/11,OMX/cmex/m/n/12%

(The TeX font encodings are documented
[here](http://www.tex.ac.uk/ctan/macros/latex/doc/encguide.pdf).)
The resulting plain ASCII when pasted is 7-bit clean and displays correctly no matter what
international character set encoding is used on the recipient's machine.

For some reason this works at with the `10pt` and `12pt` options in LaTeX, but not `11pt`.
Diffing the log files doesn't suggest any obvious reason why that should happen.  For now,
I'm just going to rewrite the résumé to look good in 12pt type.  It's easier to read for
the hiring manager in that size anyway.

#### Embedded Fonts in PDF

Embedded fonts in PDF files can cause problems later if displayed on a system that doesn't
have the expected fonts installed. To me *sure* of embedded fonts in PDF files, do this
after building the file:

    ps_file = $(target).ps
    #
    # Now, make sure embedded fonts won't cause a problem for somebody else.
    #
    pdf2ps $(pdf_file)
    rm -f $(pdf_file)
    ps2pdf -dPDFSETTINGS=/prepress $(ps_file)
    chmod a-x,a+r $(pdf_file)

It makes the PDF file bigger, and seems to make TeX fonts lighter in weight visually,
and hyperlinks in the PDF file disappear, but the resulting PDF file will have all fonts
embedded. It breaks the metadata that I like to insert in PDF files: author, title, key
words, et cetera. Interestingly, the names of fonts are lost; when viewed in 'Properties'
in Adobe Acrobat Reader, the fonts in the PDF file have names like 'T3Font_154' (Type 3)
instead of 'CMBX12' (Type 1).

It seems impossible to turn off *all* the PDF security options; 'document assembly' is
always disallowed, although I wonder how many PDF display and manipulate programmes
actually follow it, like Mac OS X *preview* for example, because I've never had problems
inserting pages into PDF files because of it.

Not recommended to use it for those reasons. There is no point putting visible hyperlinks
in the PDF file only to disable them.

### Machine-Readable Formatting

PDF is basically PostScript under the covers and we can do some things to make the resulting
binary file easier to parse.  Side-by-side columns can be problematic for parsers; they tend
to interleave their text in a copy and paste to plain text, or a **grep**.  Small caps render
correctly from PDF into plain text, as mixed case, I have found.

### Build Instructions

Make targets include the default **all** to emit the short-form CV (two pages), **longform**
to emit the three-page version of the CV including social media logins and committee-ships,
**edit** to quickly edit
the source file, **resume** to emit the short form résumé, **clean** to remove temporary files
(before commit), **commit** to update the local Git repository, **sync** to push changes to
GitHub and merge any non-local changes, **allclean** to remove everything that can be
regenerated, **help** give a quick overview of options, and **spell** to check spelling
against a UK english dictionary.

### Example

    % make

For information contact the author: joe@call-with-current-continuation.com

