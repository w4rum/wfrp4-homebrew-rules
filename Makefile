DOC_NAME	:= homebrew-rules
LATEX_COMMON_FLAGS	:= -halt-on-error -shell-escape -pdf -g -f

default: doc
all: doc

prep:	svg uml lst

doc:	prep build/$(DOC_NAME).pdf

dev: CONT_FLAG = -pvc
dev: latex-force doc


svg: $(patsubst %.svg,build/%.pdf,$(wildcard images/*.svg))
uml: $(patsubst uml-source/%.plantuml,build/uml/%.png,$(wildcard uml-source/*.plantuml))
lst: $(patsubst %.tex,build/%.pdf,$(wildcard listings/*.tex))

build/images/%.pdf: images/%.svg
	mkdir -p build/images
	inkscape -D -z --file=$< --export-pdf=$@ --export-latex

build/uml/%.png: uml-source/%.plantuml
	mkdir -p build/uml
	plantuml $<
	mv $(patsubst build/uml/%.png,uml-source/%.png,$@) $@

build/%.pdf: %.tex
	cp wfrptex/wfrp* ./
	mkdir -p build
	latexmk $(CONT_FLAG) $(LATEX_COMMON_FLAGS) -auxdir=build -outdir=build $<
	rm $(patsubst wfrptex/%,%,$(wildcard wfrptex/wfrp*))

build/listings/%.pdf: listings/%.tex
	mkdir -p build/listings
	latexmk $(LATEX_COMMON_FLAGS) -auxdir=build/listings -outdir=build/listings $<

clean:
	rm -f *.tmp *.tui *.log *.tuc *.mp *.bbl *.blg *.fls *.idx *.aux *.out *.fdb_latexmk *.ilg *.ind
	rm -rf build

latex-force:
	rm -f build/$(DOC_NAME).pdf

cleandev:	clean dev
