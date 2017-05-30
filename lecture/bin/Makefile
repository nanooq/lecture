TEX=xelatex
TEXOPTS=-halt-on-error
FILES=$(wildcard Lecture_*.tex)
TEXDEP=${FILES:.tex=.dep}
PDF=${FILES:.tex=.pdf}
XDEPS=$(wildcard ${TEXDEP})
SHELL=/bin/bash
TITLE=!!!TITLE!!!
SEMESTER=!!!TERM!!!


.PHONY: clean all depend cleanall help update

# TODO: apply makeindex if needed


all: ${TEXDEP} $(PDF)

publish: $(TITLE)_Lecture_Notes_$(SEMESTER).pdf $(TITLE)_Lecture_Slides_$(SEMESTER).pdf
# if any publishing script exists...

notes: Lecture_Notes.pdf
	cp $< "$(TITLE)-Book-${SEMESTER}.pdf"

slides: Lecture_Slides.pdf
	cp $< "$(TITLE)-Slides-${SEMESTER}.pdf"

ifneq (${XDEPS},) 
    include ${XDEPS} 
endif 

%.dep:  %.tex 
	@echo " [DEP] $@ " 
	@./makedepend $< > $@

%.pdf: %.tex %.dep body.dep
	@echo " [TEX] $< "
	@$(TEX) $(TEXOPTS) $< 2>&1 1> $<.log || ( cat $<.log && die "Error!" )


nosuchfile:
	@bib=0; \
	 while [ "X`cat $<.log | grep -o 'Rerun to'`" != "X" ]; do\
	   if [ "X`cat $<.log | grep -o 'Citation'`" != "X" -a $$bib -eq 0 ]; then \
	     echo " [BibTeX] $< "; \
	     find . -name "*.aux" | grep -v "`basename $< .tex`.aux" | xargs -n 1 bibtex ; \
	     bib=1; \
	   fi;\
	   echo " [TEX] $<"; \
	   $(TEX) $(TEXOPTS) $< 2>&1 1>$<.log || ( cat $<.log && die "Error!" ) ; \
	 done

clean: 	
	rm -rf *.dep
	rm -rf *~
	find . -name "*.aux" | xargs rm -f 
	find . -name "*.bbl" | xargs rm -f 
	find . -name "*.blg" | xargs rm -f 
	find . -name "*.backup" | xargs rm -f 
	find . -name "*.log" | xargs rm -f 
	find . -name "*.maf" | xargs rm -f 
	find . -name "*.mtc" | xargs rm -f 
	find . -name "*.mtc?" | xargs rm -f 
	find . -name "*.nav" | xargs rm -f 
	find . -name "*.out" | xargs rm -f 
	find . -name "*.rel" | xargs rm -f 
	find . -name "*.synctex.gz" | xargs rm -f 
	find . -name "*.snm" | xargs rm -f 
	find . -name "*.thm" | xargs rm -f 
	find . -name "*.toc" | xargs rm -f 
	find . -name "*.vrb" | xargs rm -f 

cleanall: clean
	rm -rf $(PDF)

help:
	@echo "Makefile to generate Lecture notes" 
	@echo ""
	@echo "Allowed targets are:"
	@echo " clean     - removes latex intermediate output and *.dep files"
	@echo " cleanall  - clean + remove output pdfs"
	@echo " help      - this screen"
	@echo " all       - build the lecture notes"

update: 
	rm -f Lecture_*.pdf
	$(MAKE) all
