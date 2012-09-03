[Joe Loughry] (joe.loughry@stx.ox.ac.uk)
============

Formatting a Tactical Résumé
----------------------------

### Concept
Trying something different here, let's put all the keywords up front where automated résumé filters
are sure to find them.  Keywords are separated by commas; formatting is kept to a minimum.

	Certification and Accreditation (C&A) of cross domain systems, Assessment and
	Authorization (A&A) for classified environments, Certification Test and Evaluation
	(CT&E), Security Test and Evaluation (ST&E), penetration testing, DIACAP, the
	Common Criteria, DCID 6/3, programming in C and assembly language with a strong
	interest in Lisp derived languages, Compartmented Mode Workstation (CMW) programming,
	UNIX, Trusted Solaris versions 2.5 to 8, software development, R&D, principal
	investigator, U.S. citizen with TS/SCI clearance, technical writing, CISSP-ISSEP
	for DoD 8570.01 compliance, experience living overseas, programming, publications,
	patents, public speaking, funding, research, and teaching experience.

Keywords are in no particular order, just arranged for even line length and colour when printed.

#### Ligatures
Ligatures look great on the printed page but they can be a barrier to copy & paste.  The word
*Certification* comes out **Certi cation** in plain text and that doesn't match a naïve regex.
The solution is to load the `cmap` package like this:

    \usepackage[resetfonts]{cmap}

The `resetfonts` option is required when used with CMR fonts which by default are a little too
clever with ligatures.  Remember, the goal here is to make things as easy as possible for keyword
filters used by HR.  CMAP tables can do other useful tricks like transforming curly quotation marks
to straight ones on copy to plain text.

Another problem with pasting into plain text is that &#8220;proper quotation marks&#8221; paste
into plain text as Unicode characters, and that can also confuse a straightforward keyword search.
(It depends on the PDF reader; Adobe Acrobat X doesn't understand ligatures at all but pastes
curly quotation marks as unicode characters, but on Mac OS X, the Preview programme gets ligatures
right when rendering into plain text.)

To make sure `grep` finds my keywords, I altered the default CMAP table that gets compiled
into the PDF output, replacing all instances of `<201C>` (Unicode left double quotation mark)
and `<201D>` (Unicode right double quotation mark) with `<0022>` (ASCII double quote) and all
instances of `<2018>` (Unicode left single quotation mark) and `<2019>` (Unicode right single
quotation mark) with `<0027>` (ASCII single quotation mark).  This makes single and double
quotation marks in the PDF file copy and paste as straight quotes.  I further caused en dashes
to be replaced by a single hyphen and em dashes by two hyphens, to match traditional
typewriter usage.  The `ot1.cmap` file is written in PostScript; to override it, I simply made
a copy of in the current directory and modified the copy:

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

PDFLaTeX preferentially uses the modified `ot1.cmap` file if it finds it in the current directory.

The only remaining difficulty was bulleted lists; the \verb,\textbullet, character doesn't appear
in TeX's OT1 font encoding and so we can't translate it the same way.  As a workaround, I changed
my bulleted lists to use asterisks instead.

The resulting plain ASCII text is 7-bit clean and displays correctly no matter what encoding
is used on the recipient's machine.

### Machine-Readable Formatting
It's a PDF file, but PDF is basically PostScript and we can do some things to make the resulting
binary file easier to parse.  Don't use side-by-side columns; they tend to interleave their text
in a copy and paste to plain text, or a `grep`.  Small caps render correctly from PDF into plain
text, I found.

### Build Instructions
Make targets include the default to emit a PDF, **vi** to quickly edit the file, **clean** to remove
temporary files, **allclean** to remove everything that can be regenerated, and **spell** to check
spelling against a UK english dictionary.

### Example
    % make

For information contact the author: (joe.loughry@stx.ox.ac.uk)

