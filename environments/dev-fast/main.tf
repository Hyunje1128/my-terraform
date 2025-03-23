// environments/dev-fast/main.tf
// 빠르게 테스트하기 위한 환경 구성
// vpc, alb, ec2 모듈을 사용하여 구성

module "vpc" {
  source                   = "../../modules/vpc"

  name                     = "my-vpc-dev-fast"
  vpc_cidr                 = "10.0.0.0/16"
  azs                      = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
  private_db_subnets  = ["10.0.21.0/24", "10.0.22.0/24"]
}

module "alb_sg" {
  source  = "../../modules/security/alb"

  name    = "alb-sg-fast"
  vpc_id  = module.vpc.vpc_id
}

module "alb" {
  source             = "../../modules/alb"

  name               = "web-alb-fast"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  target_port        = 80
  security_group_id  = module.alb_sg.alb_sg_id
}

module "ec2_sg" {
  source          = "../../modules/security/ec2"
  name            = "ec2-sg-fast"
  vpc_id          = module.vpc.vpc_id
  alb_sg_id       = module.alb_sg.alb_sg_id
  ssh_cidr_blocks = ["203.0.113.0/24"]
}

module "ec2" {
  source = "../../modules/ec2"

  name               = "app-asg-fast"
  ami_id             = "ami-0fa377108253bf620"
  instance_type      = "t3.micro"
  key_name           = "my-terraform-key"
  security_group_id  = module.ec2_sg.sg_id
  subnet_ids         = module.vpc.private_app_subnet_ids
  user_data          = file("../../scripts/user_data.sh")
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  target_group_arn   = module.alb.target_group_arn

  tags = {
    VersionLabel = "v${formatdate("YYYYMMDD-HHmmss", timestamp())}"
  }
}
