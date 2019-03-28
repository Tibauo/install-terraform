?user=test
?path_home_user=/home/test
test-unit:
	@echo "Start test"
	tar -cvzf install.tar.gz install scripts
	mv install.tar.gz test
	cd test && make test user=$(user) path_home_user=$(path_home_user)

deploy:
	@echo "Start install"
	cd install && bash install.sh $(user) $(path_home_user)


clean:
	@echo "Start clean" 
	rm test/install.tar.gz
	docker rm $$(docker ps -a -q) -f 
	docker rmi $$(docker images -a -q) -f
