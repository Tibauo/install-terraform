createcontainer:
	@echo "Create Container"
	docker build . -t test-terraform

test: createcontainer 
	@echo "Execute test"
	./test.sh
