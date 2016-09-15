

all:
	bash make.sh

.PHONY: | all

clean:
	rm -rf out/

debug: | all
	bash make.sh debug
