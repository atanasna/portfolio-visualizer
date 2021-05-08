resource "aws_cloudwatch_event_rule" "every_five_minute" {
  name                = "assets_poller_trigger_5min"
  description         = "Fires every ${var.poll_time_interval} minutes"
  schedule_expression = "rate(${var.poll_time_interval} minutes)"
}

resource "aws_cloudwatch_event_target" "assets_poller_trigger_target" {
  rule      = aws_cloudwatch_event_rule.every_five_minute.name
  target_id = "lambda"
  arn       = aws_lambda_function.asset_prices_poller.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_prices_poller.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_five_minute.arn
}