
REGCFLAGS = -gcflags "all=-N -l"

SRC_FOLDER := $(shell ls cmd)

testdir:
	@for dir in ${SRC_FOLDER}; do \
        echo bin/$$dir ; echo bin/$$dir ; \
    done

prepare:
	if [ ! -d "./bin/" ]; then \
    	mkdir bin; \
    fi

default:
	@for dir in ${SRC_FOLDER}; do \
        go build $(REGCFLAGS) -mod vendor -o bin/$$dir ./cmd/$$dir ;  \
    done

remote: prepare default

docker: remote
	@for dir in ${SRC_FOLDER}; do \
        docker build --build-arg BIN=$$dir -t docker4zc/$$dir . ;  docker push docker4zc/$$dir ; \
    done

docker-local: remote
	@for dir in ${SRC_FOLDER}; do \
        docker build --build-arg BIN=$$dir -t docker4zc/$$dir . ; \
    done

dirr = controller
forzctest:
	go build $(REGCFLAGS) -mod vendor -o bin/$(dirr) ./cmd/$(dirr)
	docker build --build-arg BIN=$(dirr) -t docker4zc/$(dirr) .

check:
	if [ ! -d "./cmd/${name}" ]; then \
       exit 1; \
    fi

# make single name=activator
single:
	if [ ! -d "./cmd/${name}" ]; then \
       exit 1; \
    fi
	go build $(REGCFLAGS) -mod vendor -o bin/${name} ./cmd/${name}
	echo "building ${name}"
	docker build --build-arg BIN=${name} -t docker4zc/${name} . ;  docker push docker4zc/${name} ;

# make single-pure name=activator
single-pure:
	go build $(REGCFLAGS) -mod vendor -o bin/${name} ./cmd/${name}
	echo "building ${name}"
	docker build -f Dockerfilepure --build-arg BIN=${name} -t docker4zc/${name}pure . ;  docker push docker4zc/${name}pure ;

testa:
	ifdef name \
      echo "eq" ; exit 1; \
    endif
