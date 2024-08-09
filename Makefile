init-%:
	echo "init $*"
	cd stacks/project-cs-101 && tofu init -var-file=../../vars/$*.tfvars
	cd stacks/vpc-cs-101 && tofu init -var-file=../../vars/$*.tfvars
	cd stacks/mysql-cs-101 && tofu init -var-file=../../vars/$*.tfvars
	cd stacks/app-cs-101 && tofu init -var-file=../../vars/$*.tfvars

plan-%: 
	echo plan $*
	#cd stacks/project-cs-101 && tofu plan -out=plan -concise -var-file=../../vars/$*.tfvars
	#cd stacks/vpc-cs-101 && tofu plan -out=plan -concise -var-file=../../vars/$*.tfvars
	#cd stacks/mysql-cs-101 && tofu plan -out=plan -concise -var-file=../../vars/$*.tfvars
	cd stacks/app-cs-101 && tofu plan -out=plan -concise -var-file=../../vars/$*.tfvars
	
apply-%: 
	echo apply $*
	#cd stacks/project-cs-101 && if [ -f "plan" ]; then tofu apply plan; rm plan; fi
	#cd stacks/vpc-cs-101 && if [ -f "plan" ]; then tofu apply plan; rm plan; fi
	#cd stacks/mysql-cs-101 && if [ -f "plan" ]; then tofu apply plan; rm plan; fi
	cd stacks/app-cs-101 && if [ -f "plan" ]; then tofu apply plan; rm plan; fi