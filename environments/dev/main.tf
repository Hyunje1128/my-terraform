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
  ssh_cidr_blocks = ["0.0.0.0/0"] # private subnet에 있는 ec2 접근은 openvpn ssh롤 접근 -> openvpn ip 확인하고 입력
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
  # user_data          = file("../../scripts/user_data.sh")
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
  target_group_arn   = module.alb.target_group_arn
  aws_iam_instance_profile_name = module.iam_github.ec2_instance_profile_name

  tags = {
    Name         = "app-asg"
    Environment  = "dev"
    VersionLabel = "v${formatdate("YYYYMMDD-HHmmss", timestamp())}"
  }
}

// modules/security/rds/main.tf
module "rds_sg" {
  source          = "../../modules/security/rds"

  name            = "rds-sg"
  vpc_id          = module.vpc.vpc_id
  ec2_sg_id       = module.ec2_sg.sg_id
  # security_groups = [module.ec2_sg.sg_id, module.openvpn_sg.sg_id]
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
  ssh_cidr_blocks  = ["0.0.0.0/0"]
  vpn_cidr_blocks  = ["0.0.0.0/0"]
}

module "openvpn" {
  source             = "../../modules/openvpn"
  name               = "openvpn-server"
  instance_type      = "t3.micro"
  # ami_id             = ami_id # ✅ OpenVPN Access Server AMI (서울 리전 기준)
  subnet_id          = module.vpc.public_subnets_ids[0]
  key_name           = "my-terraform-key"
  security_group_id  = module.openvpn_sg.sg_id
  pre_allocated_eip_id      = "eipalloc-088d9679af9654fcd" # 고정 EIP ID
  pre_allocated_eip_address = "43.200.118.179" # 고정 EIP 주소
}

// ec2에 직접 openvpn설치 후 접속 -> private영역에 있는 ec2 접속이 안돼서 보류

// modules/security/openvpn/main.tf
# module "openvpn_sg" {
#   source           = "../../modules/security/openvpn"
#   name             = "openvpn-sg"
#   vpc_id           = module.vpc.vpc_id
#   ssh_cidr_blocks  = ["211.244.225.211/32"] # [내 공인 ip] - 내 공인 ip가 변동될 가능성 있음 -> 그러면 ssh접속이 안됌(update_my_ip.sh이용)
#   vpn_cidr_blocks  = ["0.0.0.0/0"]
# }

# // modules/openvpn/main.tf
# module "openvpn" {
#   source             = "../../modules/openvpn"
#   name               = "openvpn-server"
#   ami_id             = "ami-062cddb9d94dcf95d"
#   instance_type      = "t3.micro"
#   subnet_id          = module.vpc.public_subnets_ids[0]
#   security_group_id  = module.openvpn_sg.sg_id
#   key_name           = "my-terraform-key"
#   user_data          = file("../../scripts/openvpn_userdata.sh")
#   pre_allocated_eip_id      = "eipalloc-088d9679af9654fcd" # 고정 EIP ID
#   pre_allocated_eip_address = "43.200.118.179" # 고정 EIP 주소
# }

module "codedeploy" {
  source                = "../../modules/codedeploy"
  app_name              = "my-app"
  deployment_group_name = "my_deployment_group"
  iam_role_name         = "my-codedeploy-role"
  ec2_tag_key           = "Name"
  ec2_tag_value         = "app-asg"
}


module "iam_github" {
  source    = "../../modules/iam"
  user_name = "github-actions"
  ec2_iam_role_name = "ec2-role-for-codedeploy"
}

module "github_s3" {
  source          = "../../modules/s3"
  bucket_name     = "my-deploy-artifacts-bucket"
  github_iam_arn  = module.iam_github.github_iam_arn
}

module "cloudfront" {
  source              = "../../modules/cloudfront"
  alb_dns_name        = module.alb.dns_name
  acm_cert_arn        = module.acm.acm_certificate_arn     # ← 추가
  aliases             = ["www.rok-lee.com"]                # ← 추가
  tags                = var.tags
}

module "route53" {
  source             = "../../modules/route53"
  zone_id            = var.route53_zone_id
  domain_name        = var.route53_domain_name
  cloudfront_domain  = module.cloudfront.cloudfront_domain_name
}

module "acm" {
  source           = "../../modules/acm"
  domain_name      = "www.rok-lee.com"              # 사용할 도메인
  route53_zone_id  = var.route53_zone_id            # 호스팅 영역 ID
  tags             = var.tags
}

