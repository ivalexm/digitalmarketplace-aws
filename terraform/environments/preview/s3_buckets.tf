# Other buckets should be set to log to this bucket
resource "aws_s3_bucket" "server_access_logs_bucket" {
  bucket = "digitalmarketplace-logs-preview-preview"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }
}

# TODO remove these hard-coded definitions in favour of using the terraform/modules/s3-document-bucket module after the
# tf v0.12 upgrade. We need to contitionally include the principals block

# Agreements - devs: read write list

data "aws_iam_policy_document" "agreements_bucket_policy_document" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["arn:aws:iam::${var.aws_dev_account_id}:role/developers"]
      type        = "AWS"
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::digitalmarketplace-agreements-preview-preview/*",
      "arn:aws:s3:::digitalmarketplace-agreements-preview-preview",
    ]
  }
}

resource "aws_s3_bucket" "agreements_bucket" {
  bucket = "digitalmarketplace-agreements-preview-preview"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.server_access_logs_bucket.id}"
    target_prefix = "digitalmarketplace-agreements-preview-preview/"
  }

  policy = "${data.aws_iam_policy_document.agreements_bucket_policy_document.json}"
}

# Communications jenkins: read write

data "aws_iam_policy_document" "communications_bucket_policy_document" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["arn:aws:iam::${var.aws_main_account_id}:role/jenkins-ci-IAMRole-1FIPDG9DE2CWJ"]
      type        = "AWS"
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      "arn:aws:s3:::digitalmarketplace-communications-preview-preview/*",
      "arn:aws:s3:::digitalmarketplace-communications-preview-preview",
    ]
  }
}

resource "aws_s3_bucket" "communications_bucket" {
  bucket = "digitalmarketplace-communications-preview-preview"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.server_access_logs_bucket.id}"
    target_prefix = "digitalmarketplace-communications-preview-preview/"
  }

  policy = "${data.aws_iam_policy_document.communications_bucket_policy_document.json}"
}

# Documents - jenkins: read write list

data "aws_iam_policy_document" "documents_bucket_policy_document" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["arn:aws:iam::${var.aws_main_account_id}:role/jenkins-ci-IAMRole-1FIPDG9DE2CWJ"]
      type        = "AWS"
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::digitalmarketplace-documents-preview-preview/*",
      "arn:aws:s3:::digitalmarketplace-documents-preview-preview",
    ]
  }
}

resource "aws_s3_bucket" "documents_bucket" {
  bucket = "digitalmarketplace-documents-preview-preview"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.server_access_logs_bucket.id}"
    target_prefix = "digitalmarketplace-documents-preview-preview/"
  }

  policy = "${data.aws_iam_policy_document.documents_bucket_policy_document.json}"
}

# G7-draft-documents

resource "aws_s3_bucket" "g7-draft-documents_bucket" {
  bucket = "digitalmarketplace-g7-draft-documents-preview-preview"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.server_access_logs_bucket.id}"
    target_prefix = "digitalmarketplace-g7-draft-documents-preview-preview/"
  }
}

# Submissions

resource "aws_s3_bucket" "submissions_bucket" {
  bucket = "digitalmarketplace-submissions-preview-preview"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.server_access_logs_bucket.id}"
    target_prefix = "digitalmarketplace-submissions-preview-preview/"
  }
}
