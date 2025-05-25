
resource "random_id" "suffix" { byte_length = 4 }

resource "aws_s3_bucket" "lakehouse" {
  bucket = "lakehouse-${var.env}-${random_id.suffix.hex}"
  force_destroy = true
}

locals { layers = ["bronze/","silver/","gold/"] }

resource "aws_s3_bucket_object" "prefix" {
  for_each = toset(local.layers)
  bucket = aws_s3_bucket.lakehouse.id
  key    = each.key
}

resource "aws_glue_catalog_database" "db" {
  for_each = toset(["bronze","silver","gold"])
  name = "${each.key}_${var.env}"
  location_uri = "s3://${aws_s3_bucket.lakehouse.bucket}/${each.key}/"
}

resource "aws_athena_workgroup" "wg" {
  name = "lh-${var.env}-wg"
  force_destroy = true
  configuration { 
    result_configuration {  output_location = "s3://${aws_s3_bucket.lakehouse.bucket}/query-results/" } 
  }
}

resource "aws_emrserverless_application" "etl" {
  name = "lh-${var.env}-etl"
  release_label = "emr-6.12.0"
  type = "SPARK"
  maximum_capacity {
    cpu="4 vCPU"
    memory="8 GB"
    disk="50 GB"
  }
}
