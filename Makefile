test-unit:
	@echo "Start test"
	tar -cvzf install.tar.gz install scripts
	mv install.tar.gz test
	cd test && make test

deploy:
	@echo "Start install"
	cd install && bash install.sh


clean:
	@echo "Start clean" 
	rm test/install.tar.gz
	docker rm $$(docker ps -a -q) -f 
	docker rmi $$(docker images -a -q) -f
