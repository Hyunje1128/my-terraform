// environments/dev/main.tf 내용

// modules/vpc/main.tf
module "vpc" {
  source              = "../../modules/vpc"

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

// modules/security/ec2/main.tf
module "ec2_sg" {
  source          = "../../modules/security/ec2"

  name            = "ec2-sg"
  vpc_id          = module.vpc.vpc_id
  alb_sg_id       = module.alb_sg.alb_sg_id
  ssh_cidr_blocks = ["203.0.113.0/24"]
}

// modules/ec2/main.tf
module "ec2" {
  source             = "../../modules/ec2"

  name               = "app-asg"
  ami_id             = "ami-062cddb9d94dcf95d"  #Amazon Linux 2023 AMI ID(서울 리전 기준)
  instance_type      = "t3.micro"
  key_name           = "my-terraform-key"         # 실제 키페어 이름
  security_group_id  = module.ec2_sg.sg_id
  subnet_ids         = module.vpc.private_app_subnet_ids
  user_data          = file("../../scripts/user_data.sh")
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
  target_group_arn   = module.alb.target_group_arn

  tags = {
    VersionLabel = "v${formatdate("YYYYMMDD-HHmmss", timestamp())}"
  }
}

// modules/security/rds/main.tf
module "rds_sg" {
  source          = "../../modules/security/rds"

  name            = "rds-sg"
  vpc_id          = module.vpc.vpc_id
  ec2_sg_id       = module.ec2_sg.sg_id
  db_port         = 3306
}

// modules/rds/main.tf
module "rds" {
  source              = "../../modules/rds"
  name                = "my-rds"
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "db123456"
  subnet_ids          = module.vpc.private_db_subnet_ids
  security_group_id   = module.rds_sg.sg_id
  allocated_storage   = 20
}

// modules/security/openvpn/main.tf
module "openvpn_sg" {
  source           = "../../modules/security/openvpn"
  name             = "openvpn-sg"
  vpc_id           = module.vpc.vpc_id
  ssh_cidr_blocks  = ["211.244.225.164/32"]
  vpn_cidr_blocks  = ["0.0.0.0/0"]
}

// modules/openvpn/main.tf
module "openvpn" {
  source             = "../../modules/openvpn"
  name               = "openvpn-server"
  ami_id             = "ami-062cddb9d94dcf95d"
  instance_type      = "t3.micro"
  subnet_id          = module.vpc.public_subnets_ids[0]
  security_group_id  = module.openvpn_sg.sg_id
  key_name           = "my-terraform-key"
  user_data          = file("../../scripts/openvpn_userdata.sh")

}