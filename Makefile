builder:
	docker build -t ig-builder .

check-syntax:
	docker run --rm \
		-v ./input:/app/input \
		-v ./sushi-config.yaml:/app/sushi-config.yaml \
		-v ./build-cache/fhir-packages:/root/.fhir/packages \
		ig-builder sushi .

ig-novalidate:
	docker run --rm --name=ig-builder \
		-v ./input:/app/input \
		-v ./output:/app/output \
		-v ./ig.ini:/app/ig.ini \
		-v ./sushi-config.yaml:/app/sushi-config.yaml \
		-v ./build-cache:/app/input-cache \
		-v ./build-cache/fhir-packages:/root/.fhir/packages \
		ig-builder bash -c "cp -n /app/publisher.jar /app/input-cache/publisher.jar 2>/dev/null; bash _genonce.sh -tx n/a"

ig:
	docker run --rm --name=ig-builder \
		-v ./input:/app/input \
		-v ./output:/app/output \
		-v ./ig.ini:/app/ig.ini \
		-v ./sushi-config.yaml:/app/sushi-config.yaml \
		-v ./build-cache:/app/input-cache \
		-v ./build-cache/fhir-packages:/root/.fhir/packages \
		ig-builder
