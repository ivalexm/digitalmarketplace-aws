module "iam_common" {
  source              = "../../modules/iam-common"
  dev_user_ips        = "${var.dev_user_ips}"
  aws_main_account_id = "${var.aws_main_account_id}"
  aws_dev_account_id  = "${var.aws_dev_account_id}"
}

module "switch_roles" {
  source                          = "../../modules/switch-roles"
  ip_restricted_access_policy_arn = "${module.iam_common.aws_iam_policy_ip_restricted_access_arn}"
  iam_manage_account_policy_arn   = "${module.iam_common.aws_iam_policy_iam_manage_account_arn}"
  developer_policy_arn            = "${module.iam_common.aws_iam_policy_developer_arn}"
  aws_main_account_id             = "${var.aws_main_account_id}"
}

module "paas" {
  source = "../../modules/paas"
}
