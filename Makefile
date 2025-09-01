MF=Makefile

INSTALLDIR=${HOME}/share/texmf/tex/latex

SRC=\
talk.cls \
talk-sidebars.sty \
talk-simple.sty \
talkdoc.tex


OTHER=\
README \
sidebars-example.tex \
simple-example.tex

DOC=\
talkdoc.pdf

TAR=talk.tar.gz

all: $(DOC)

$(DOC): talkdoc.tex
	pdflatex talkdoc.tex && pdflatex talkdoc.tex

backup: $(MF) $(SRC) $(DOC) $(OTHER)
	rm -f $(TAR)
	tar zcvf $(TAR) $(MF) $(SRC) $(DOC) $(OTHER)

install: talk.cls talk-sidebars.sty talk-simple.sty
	install talk.cls $(INSTALLDIR)/talk.cls
	install talk-sidebars.sty $(INSTALLDIR)/talk-sidebars.sty
	install talk-simple.sty $(INSTALLDIR)/talk-simple.sty
