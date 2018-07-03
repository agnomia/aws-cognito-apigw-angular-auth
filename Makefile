.PHONY: clean default deploy package run summary unpack-sdk upload-s3

BUCKET=agnomia-aws-tutorial
TEMPLATE_FILE=sam/sam-output.yaml
LAMBDA_ZIP=lambda.zip

STACK_NAME=CognitoAPIGWDemo
USER_POOL_CLIENT_ID=71i15b61ia93atcdupbb4jaggs
REST_API=djep7lj9s1

APP_DIR=aws-cognito-apigw-angular
API_ZIP=apigwsdk.zip

default:

run:
	cd $(APP_DIR) && npm install && npm start

summary:
	aws cloudformation describe-stacks --query 'Stacks[0].[Outputs[].[OutputKey,OutputValue]]|[]' --output text --stack-name $(STACK_NAME)

deploy: upload-s3 package
	aws cloudformation deploy --template-file $(realpath $(TEMPLATE_FILE)) --stack-name $(STACK_NAME) --capabilities CAPABILITY_IAM

package:
	aws cloudformation package --template-file sam/sam.yaml --output-template-file $(TEMPLATE_FILE) --s3-bucket $(BUCKET)

s3/lambda.zip:
	cp sam/$(LAMBDA_ZIP) s3/$(LAMBDA_ZIP)

upload-s3: s3/$(LAMBDA_ZIP)
	aws s3 sync --delete s3 s3://$(BUCKET)

clean:
	rm s3/$(LAMBDA_ZIP)
	rm $(TEMPLATE_FILE)

create-user:
	aws cognito-idp sign-up --client-id $(USER_POOL_CLIENT_ID) --username bcaputo --password F00b@r0rd --region us-east-1 --user-attributes '[{"Name":"given_name","Value":"Bill"},{"Name":"family_name","Value":"Caputo"},{"Name":"email","Value":"bcaputo@agnomia.com"},{"Name":"gender","Value":"Male"},{"Name":"phone_number","Value":"+13125551213"}]'

$(APP_DIR)/$(API_ZIP):
	cd $(APP_DIR) && aws apigateway get-sdk --rest-api-id $(REST_API) --stage-name demo --sdk-type javascript $(API_ZIP)

$(APP_DIR)/apiGateway-js-sdk: $(APP_DIR)/$(API_ZIP)
	cd $(APP_DIR) && unzip $(API_ZIP)

unpack-sdk: $(APP_DIR)/apiGateway-js-sdk

#699136709706-0banke28fu67r1q1ggjpvolfa9ujkctu.apps.googleusercontent.com
#LpFb-2TJbk0jwmp9EyizwHEj
