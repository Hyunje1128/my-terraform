// modules/iam/main.tf

// github 관련
resource "aws_iam_user" "github" {
  name = var.user_name
}

resource "aws_iam_access_key" "github" {
  user = aws_iam_user.github.name
}

resource "aws_iam_user_policy_attachment" "s3_full_access" {
  user       = aws_iam_user.github.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

//codedeploy 관련
resource "aws_iam_user_policy_attachment" "codedeploy_access" {
  user       = aws_iam_user.github.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}

resource "aws_iam_user_policy_attachment" "iam_read_only" {
  user       = aws_iam_user.github.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

// EC2 인스턴스용 IAM 역할
resource "aws_iam_role" "ec2_instance_role" {
  name = var.ec2_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# EC2에서 CodeDeploy 사용
resource "aws_iam_role_policy_attachment" "ec2_codedeploy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

# S3에서 배포 파일 다운로드 가능하게
resource "aws_iam_role_policy_attachment" "ec2_s3_readonly" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# CloudWatch 로그 수집
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# EC2 인스턴스 프로파일
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.ec2_iam_role_name}-profile"
  role = aws_iam_role.ec2_instance_role.name
}