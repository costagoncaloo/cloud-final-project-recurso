data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_iam_role" "app" {
  name = "${var.name_prefix}-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "sqs" {
  name = "${var.name_prefix}-sqs-policy"
  role = aws_iam_role.app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ]
      Resource = var.order_queue_arn
    }]
  })
}

resource "aws_iam_instance_profile" "app" {
  name = "${var.name_prefix}-app-profile"
  role = aws_iam_role.app.name
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.app_security_group_id]
  key_name               = var.ec2_key_name
  iam_instance_profile   = aws_iam_instance_profile.app.name

  user_data = templatefile("${path.module}/templates/app.env.tftpl", {
    image_registry    = var.image_registry
    database_endpoint = var.database_endpoint
    database_name     = var.database_name
    database_username = var.database_username
    database_password = var.database_password
    order_queue_url   = var.order_queue_url
    aws_region        = var.aws_region
  })

  tags = {
    Name = "${var.name_prefix}-app"
  }
}
