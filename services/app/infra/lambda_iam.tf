data "template_file" "lambda_assume_policy" {
    template = file("policies/lambda_assume_policy.json")
}

data "template_file" "lambda_operational_policy" {
    template = file("policies/lambda_operational_policy.json")
}

resource "aws_iam_policy" "app_opperational_iap" {
  name        = "${var.prefix}_lambda_iap"
  description = "Asset poller Lambda Operational Policy"

  policy = data.template_file.lambda_operational_policy.rendered
}

resource "aws_iam_role" "app_lambda_iar" {
    name = "${var.prefix}_lambda_iar"
    assume_role_policy = data.template_file.lambda_assume_policy.rendered
}

resource "aws_iam_role_policy_attachment" "app_attachment_1" {
  role       = aws_iam_role.app_lambda_iar.name
  policy_arn = aws_iam_policy.app_opperational_iap.arn
}

resource "aws_iam_role_policy_attachment" "app_attachment_2" {
  role       = aws_iam_role.app_lambda_iar.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}