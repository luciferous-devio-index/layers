SHELL = /usr/bin/env bash -xeuo pipefail

stack_name:=luciferous-devio-index-layers

clean:
	find layers -type d -name python | xargs rm -rf
	find layers -type f -name requirements.txt | xargs rm -f

build:
	./build.sh --name base --arch arm64
	./build.sh --name feedparser --arch arm64

package:
	sam package \
		--s3-bucket ${SAM_ARTIFACT_BUCKET} \
		--s3-prefix layer \
		--template-file sam.yml \
		--output-template-file template.yml

deploy:
	sam deploy \
		--stack-name $(stack_name) \
		--template-file template.yml \
		--role-arn ${ROLE_ARN_CLOUDFORMATION_DEPLOY} \
		--no-fail-on-empty-changeset

.PHONY: \
	clean \
	build \
	package \
	deploy

