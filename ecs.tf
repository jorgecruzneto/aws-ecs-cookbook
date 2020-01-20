resource "aws_ecs_cluster" "private" {
  name = "Private"
}

resource "aws_ecs_cluster" "public" {
  name = "Public"
}

data "template_file" "private" {
  template = file("./templates/ecs/private.json.tpl")

  vars = {
    app_image      = var.private_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

data "template_file" "public" {
  template = file("./templates/ecs/public.json.tpl")

  vars = {
    app_image      = var.public_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "private" {
  family                   = "task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.private.rendered
}

resource "aws_ecs_task_definition" "public" {
  family                   = "task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.public.rendered
}

resource "aws_ecs_service" "private" {
  name            = "service"
  cluster         = aws_ecs_cluster.private.id
  task_definition = aws_ecs_task_definition.private.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.private.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.private.id
    container_name   = "PrivateService"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.private, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_ecs_service" "public" {
  name            = "service"
  cluster         = aws_ecs_cluster.public.id
  task_definition = aws_ecs_task_definition.public.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.public.id]
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.public.id
    container_name   = "PublicService"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.public, aws_iam_role_policy_attachment.ecs_task_execution_role, aws_ecs_service.private]
}