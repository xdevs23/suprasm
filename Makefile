
all:
	bash make.sh

.PHONY: | all

clean:
	rm -rf out/

debug: | all
	@bash -c "echo -e \"Starting debug...\n\""
	@out/bin/main
	@bash -c "echo -e \"\n\n-------------------\nDebug end\""
