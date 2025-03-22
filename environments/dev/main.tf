// environments/dev/main.tf 내용

// modules/vpc/main.tf
module "vpc" {
  source = "../../modules/vpc"

  name                = "my-vpc-dev"
  vpc_cidr            = "10.0.0.0/16"
  azs                 = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
  private_db_subnets  = ["10.0.21.0/24", "10.0.22.0/24"]
}

// modules/security/alb/main.tf
module "alb_sg" {
  source = "../../modules/security/alb"

  name   = "alb-sg"
  vpc_id = module.vpc.vpc_id
}

// modules/alb/main.tf
module "alb" {
  source             = "../../modules/alb"

  name               = "web-alb"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnets_ids
  target_port        = 80
  security_group_id  = module.alb_sg.alb_sg_id
}



