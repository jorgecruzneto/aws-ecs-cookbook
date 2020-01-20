resource "aws_appautoscaling_target" "private_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.private.name}/${aws_ecs_service.private.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = aws_iam_role.ecs_auto_scale_role.arn
  min_capacity       = 2
  max_capacity       = 4
}

resource "aws_appautoscaling_policy" "private_up" {
  name               = "scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.private.name}/${aws_ecs_service.private.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.private_target]
}

resource "aws_appautoscaling_policy" "private_down" {
  name               = "scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.private.name}/${aws_ecs_service.private.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.private_target]
}

resource "aws_cloudwatch_metric_alarm" "private_service_cpu_high" {
  alarm_name          = "cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = aws_ecs_cluster.private.name
    ServiceName = aws_ecs_service.private.name
  }

  alarm_actions = [aws_appautoscaling_policy.private_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "private_service_cpu_low" {
  alarm_name          = "cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = aws_ecs_cluster.private.name
    ServiceName = aws_ecs_service.private.name
  }

  alarm_actions = [aws_appautoscaling_policy.private_down.arn]
}

resource "aws_appautoscaling_target" "public_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.public.name}/${aws_ecs_service.public.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = aws_iam_role.ecs_auto_scale_role.arn
  min_capacity       = 2
  max_capacity       = 4
}

resource "aws_appautoscaling_policy" "public_up" {
  name               = "scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.public.name}/${aws_ecs_service.public.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.public_target]
}

resource "aws_appautoscaling_policy" "public_down" {
  name               = "scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.public.name}/${aws_ecs_service.public.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.public_target]
}

resource "aws_cloudwatch_metric_alarm" "public_service_cpu_high" {
  alarm_name          = "cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = aws_ecs_cluster.public.name
    ServiceName = aws_ecs_service.public.name
  }

  alarm_actions = [aws_appautoscaling_policy.public_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "public_service_cpu_low" {
  alarm_name          = "cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = aws_ecs_cluster.public.name
    ServiceName = aws_ecs_service.public.name
  }

  alarm_actions = [aws_appautoscaling_policy.public_down.arn]
}