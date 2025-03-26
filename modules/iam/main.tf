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
