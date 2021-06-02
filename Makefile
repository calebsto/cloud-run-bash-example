PROJECT_ID=$(shell gcloud config get-value core/project)
all:
	@echo "build  - Build the docker image"
	@echo "deploy - Deploy the image to Cloud Run"
	@echo "clean  - Clean resoruces created in this test"
	@echo "call   - Call the Cloud Run service"

deploy:
	gcloud run deploy bash \
		--image gcr.io/$(PROJECT_ID)/bash \
		--min-instances 1000 \
		--max-instances 1000 \
		--cpu 4 \
		--memory 8Gi \
		--platform managed \
		--region us-central1 \
		--allow-unauthenticated \
		--timeout 10m

build:
	gcloud builds submit --tag gcr.io/$(PROJECT_ID)/bash

clean:
	-gcloud container images delete gcr.io/$(PROJECT_ID)/cloud-run-exec-python --quiet
	-gcloud run services delete cloud-run-exec-python \
		--platform managed \
		--region us-central1 \
		--quiet
