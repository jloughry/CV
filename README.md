[Joe Loughry] (joe.loughry@stx.ox.ac.uk)
============

Certification and Accrediation of Cross Domain Systems
------------------------------------------------------

### Concept
Trying something different here, let's put all the keywords up front where automated résumé filters
are sure to find them.  Keywords are separated by commas; formatting is kept to a minimum.

	Certification and Accreditation (C\&A) of cross domain systems, Assessment and
	Authorization (A\&A) for classified environments, Certification Test and Evaluation
	(CT\&E), Security Test and Evaluation (ST\&E), penetration testing, DIACAP, the
	Common Criteria, DCID 6/3, programming in C and assembly language with a strong
	interest in Lisp derived languages, Compartmented Mode Workstation (CMW) programming,
	UNIX, Trusted Solaris versions 2.5--8, software development, R\&D, principal
	investigator, U.S.\ citizen with TS/SCI clearance, technical writing, CISSP-ISSEP
	for DoD 8570.01 compliance, experience living overseas, programming, publications,
	patents, public speaking, funding, research, and teaching experience.

Keywords are in no particular order, just arranged for even line length and colour when printed.

#### Ligatures
Ligatures look great on the printed page but they can be a barrier to copy & paste.  *Certification*
comes out **Certi cation** in plain text and that doesn't match a naïve regex.  The solution is to
load the `cmap` package like this:

    \usepackage[resetfonts]{cmap}

The `resetfonts` option is required when used with CMR fonts which by default are a little too
clever with ligatures.  Remember, the goal here is to make things as easy as possible for keyword
filters used by HR.  CMAP tables can do other useful tricks like transforming curly quotation marks
to straight ones on copy to plain text.

### Machine-Readable Formatting
It's a PDF file, but PDF is basically PostScript and we can do some things to make the resulting
binary file easier to parse.

The contact information at the top needs to be formatted better, ideally in a way that parses
straightforwardly both for humans and regular expressions.  To encourage copy & paste, I was thinking
of something like this:

    6214 South Krameria Street, Centennial, CO 80111-4243, USA
    mailto:rjl@applied-math.org
    tel:(303) 221-4380
    
    St Cross College, St Giles, Oxford, Oxon, OX1 3LZ, UK
    mailto:joe.loughry@stx.ox.ac.uk
    tel:+44 (0)798 414 7430

The problem with multiple columns in a PDF is that copy and paste into plain text tends to
interleave the columns (a legacy of PDF's ancestry in the PostScript language).

Another problem with pasting into plain text is that &#8220;proper quotation marks&#8221;
sometimes paste as Unicode characters, and that can confuse a straightforward keyword search.
To make sure `grep` finds my keywords, I further altered the CMAP in
the `MiKTeX/2.9/tex/latex/cmap/ot1.cmap` file to replace all instances of `<201C>` (Unicode
left double quotation mark) and `<201D>` (Unicode right double quotation mark) with `<0022>`
(ASCII double quote) and all instances of `<2018>` (Unicode left single quotation mark) and
`<2019>` (Unicode right single quotation mark) with `<0027>` (ASCII single quotation mark).
This makes single and double quotation marks in the resulting PDF cut and paste as straight
quotes.  The result is 7-bit clean and displays correctly no matter what encoding is used
on the recipient's machine.

### Build Instructions
Make targets include the default to emit a PDF, **vi** to quickly edit the file, **clean** to remove
temporary files, **allclean** to remove everything that can be regenerated, and **spell** to check
spelling against a UK english dictionary.

### Example
    % make

For information contact the author: (joe.loughry@stx.ox.ac.uk)
