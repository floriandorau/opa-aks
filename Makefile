init:
	cd ./terraform; terraform init
plan: 
	cd ./terraform; terraform plan --var-file=env.tfvars --out env.tfplan
apply: 	
	cd ./terraform; terraform apply "env.tfplan"
destroy: 	
	cd ./terraform; terraform destroy --var-file=env.tfvars