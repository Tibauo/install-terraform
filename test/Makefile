?user=test
?path_home_user=/home/test
createcontainer:
	@echo "Create Container"
	docker build . -t test-terraform

test: createcontainer 
	@echo "Execute test"
	./test.sh $(user) $(path_home_user)
