AWS_DEFAULT_REGION := $(shell ./bin/get_setting AWS_DEFAULT_REGION)
TEMPLATE = file://./cfn.json

STACK_NAME := $(shell ./bin/get_setting MOVIE_STACK_NAME)
MOVIE_BUCKET := $(shell ./bin/get_setting MOVIE_BUCKET)
INCOMING_BUCKET := $(shell ./bin/get_setting INCOMING_BUCKET)

#POSTERS_LAMBDA := $(shell ./bin/get_stack_output $(POSTER_STACK_NAME) Lambda )
#
PARAMETERS  = "ParameterKey=MovieBucketName,ParameterValue=$(MOVIE_BUCKET)"
PARAMETERS += "ParameterKey=IncomingBucketName,ParameterValue=$(INCOMING_BUCKET)"
PARAMETERS += "ParameterKey=PostersLambdaArn,ParameterValue=$(POSTERS_LAMBDA)"

ACTION := $(shell ./bin/cloudformation_action)

deploy:
	aws cloudformation $(ACTION)-stack                \
	  --stack-name "$(STACK_NAME)"                    \
	  --template-body "$(TEMPLATE)"                   \
	  --parameters ${PARAMETERS}                      \
	  --capabilities CAPABILITY_IAM                   \
	  2>&1
	@aws cloudformation wait stack-$(ACTION)-complete \
	  --stack-name $(STACK_NAME)