[Joe Loughry] (joe.loughry@stx.ox.ac.uk)
============

Certification and Accrediation of Cross Domain Systems
------------------------------------------------------

### Concept
Trying something different here, let's put all the keywords up front where automated résumé filters
are sure to find them.  Keywords are separated by commas; formatting is kept to a minimum.

    Certification and Accreditation (C&A) of cross domain systems, Certification Test & Evaluation (CT&E),
    Security Test and Evaluation (ST&E), Assessment and Authorization (A&A) in classified environments,
    penetration testing, Common Criteria, DIACAP, DCID 6/3, Compartmented Mode Workstation (CMW)
    programming, UNIX, Trusted Solaris v2.5--8, software development, R&D, principal investigator, technical
    writing, U.S. citizen, TS/SCI clearance, DoD 8570.01 certified CISSP-ISSEP, lived overseas, publications,
    patents, public speaking, funding, and teaching experience.

Keywords are in no particular order, just arranged for even line length and colour when printed.

#### Ligatures
Ligatures look great on the printed page but they can be a barrier to copy & paste.  *Certification*
comes out **Certi cation** in plain text and that doesn't match a naïve regex.

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

### Build Instructions
Make targets include the default to emit a PDF, **vi** to quickly edit the file, **clean** to remove
temporary files, **allclean** to remove everything that can be regenerated, and **spell** to check
spelling against a UK english dictionary.

### Example
    % make

For information contact the author: (joe.loughry@stx.ox.ac.uk)
