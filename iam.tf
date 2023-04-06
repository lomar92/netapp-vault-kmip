# # Create IAM role for auto unseal
# resource "aws_iam_role" "vault_iam_role" {
#   name = "vault_iam_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# # Create instance profile for IAM role
# resource "aws_iam_instance_profile" "vault_instance" {
#   name = "aws_instance_profile_vault"

#   role = aws_iam_role.vault_iam_role.name
# }

# # Attach AWS managed policy to IAM role
# resource "aws_iam_role_policy_attachment" "vault_policy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   role       = aws_iam_role.vault_iam_role.name
# }


# # ONTAP
# resource "aws_iam_role" "netapp_cloud_connector_role" {
#   name = "cloud-manager-operator-occm"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::020954271809:user/All"
#           # Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "assume_occm_role_policy" {
#   name        = "assume-occm-role-policy"
#   description = "Allows user to assume occm-role"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = "sts:AssumeRole"
#         Effect   = "Allow"
#         Resource = aws_iam_role.netapp_cloud_connector_role.arn
#       }
#     ]
#   })
# }


# resource "aws_iam_policy" "netapp_cloud_connector_policy" {
#   name        = "ocm-policy-i"
#   description = "Policy for NetApp Cloud Connector in AWS"


#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "cvoservicepolicy",
#         Effect = "Allow",
#         Action = [
#           "ec2:DescribeInstances",
#           "ec2:DescribeInstanceStatus",
#           "ec2:RunInstances",
#           "ec2:ModifyInstanceAttribute",
#           "ec2:DescribeInstanceAttribute",
#           "ec2:DescribeRouteTables",
#           "ec2:DescribeImages",
#           "ec2:CreateTags",
#           "ec2:CreateVolume",
#           "ec2:DescribeVolumes",
#           "ec2:ModifyVolumeAttribute",
#           "ec2:CreateSecurityGroup",
#           "ec2:DescribeSecurityGroups",
#           "ec2:RevokeSecurityGroupEgress",
#           "ec2:AuthorizeSecurityGroupEgress",
#           "ec2:AuthorizeSecurityGroupIngress",
#           "ec2:RevokeSecurityGroupIngress",
#           "ec2:CreateNetworkInterface",
#           "ec2:DescribeNetworkInterfaces",
#           "ec2:ModifyNetworkInterfaceAttribute",
#           "ec2:DescribeSubnets",
#           "ec2:DescribeVpcs",
#           "ec2:DescribeDhcpOptions",
#           "ec2:CreateSnapshot",
#           "ec2:DescribeSnapshots",
#           "ec2:GetConsoleOutput",
#           "ec2:DescribeKeyPairs",
#           "ec2:DescribeRegions",
#           "ec2:DescribeTags",
#           "ec2:AssociateIamInstanceProfile",
#           "ec2:DescribeIamInstanceProfileAssociations",
#           "ec2:DisassociateIamInstanceProfile",
#           "ec2:CreatePlacementGroup",
#           "ec2:DescribeReservedInstancesOfferings",
#           "ec2:AssignPrivateIpAddresses",
#           "ec2:CreateRoute",
#           "ec2:DescribeVpcs",
#           "ec2:ReplaceRoute",
#           "ec2:UnassignPrivateIpAddresses",
#           "ec2:DeleteSecurityGroup",
#           "ec2:DeleteNetworkInterface",
#           "ec2:DeleteSnapshot",
#           "ec2:DeleteTags",
#           "ec2:DeleteRoute",
#           "ec2:DeletePlacementGroup",
#           "ec2:DescribePlacementGroups",
#           "ec2:DescribeVolumesModifications",
#           "ec2:ModifyVolume",
#           "cloudformation:CreateStack",
#           "cloudformation:DescribeStacks",
#           "cloudformation:DescribeStackEvents",
#           "cloudformation:ValidateTemplate",
#           "cloudformation:DeleteStack",
#           "iam:PassRole",
#           "iam:CreateRole",
#           "iam:PutRolePolicy",
#           "iam:CreateInstanceProfile",
#           "iam:AddRoleToInstanceProfile",
#           "iam:RemoveRoleFromInstanceProfile",
#           "iam:ListInstanceProfiles",
#           "iam:DeleteRole",
#           "iam:DeleteRolePolicy",
#           "iam:DeleteInstanceProfile",
#           "iam:GetRolePolicy",
#           "iam:GetRole",
#           "sts:DecodeAuthorizationMessage",
#           "sts:AssumeRole",
#           "s3:GetBucketTagging",
#           "s3:GetBucketLocation",
#           "s3:ListBucket",
#           "s3:CreateBucket",
#           "s3:GetLifecycleConfiguration",
#           "s3:ListBucketVersions",
#           "s3:GetBucketPolicyStatus",
#           "s3:GetBucketPublicAccessBlock",
#           "s3:GetBucketPolicy",
#           "s3:GetBucketAcl",
#           "s3:PutObjectTagging",
#           "s3:GetObjectTagging",
#           "s3:DeleteObject",
#           "s3:DeleteObjectVersion",
#           "s3:PutObject",
#           "s3:ListAllMyBuckets",
#           "s3:GetObject",
#           "s3:GetEncryptionConfiguration",
#           "kms:List*",
#           "kms:ReEncrypt*",
#           "kms:Describe*",
#           "kms:CreateGrant",
#           "ce:GetReservationUtilization",
#           "ce:GetDimensionValues",
#           "ce:GetCostAndUsage",
#           "ce:GetTags",
#           "fsx:Describe*",
#           "fsx:List*"
#         ],
#         Resource = "*",
#       },
#       {
#         Sid    = "backuppolicy",
#         Effect = "Allow",
#         Action = [
#           "ec2:StartInstances",
#           "ec2:StopInstances",
#           "ec2:DescribeInstances",
#           "ec2:DescribeInstanceStatus",
#           "ec2:RunInstances",
#           "ec2:TerminateInstances",
#           "ec2:DescribeInstanceAttribute",
#           "ec2:DescribeImages",
#           "ec2:CreateTags",
#           "ec2:CreateVolume",
#           "ec2:CreateSecurityGroup",
#           "ec2:DescribeSubnets",
#           "ec2:DescribeVpcs",
#           "ec2:DescribeRegions",
#           "cloudformation:CreateStack",
#           "cloudformation:DeleteStack",
#           "cloudformation:DescribeStacks",
#           "kms:List*",
#           "kms:Describe*",
#           "ec2:describeVpcEndpoints",
#           "kms:ListAliases",
#           "athena:StartQueryExecution",
#           "athena:GetQueryResults",
#           "athena:GetQueryExecution",
#           "glue:GetDatabase",
#           "glue:GetTable",
#           "glue:CreateTable",
#           "glue:CreateDatabase",
#           "glue:GetPartitions",
#           "glue:BatchCreatePartition",
#           "glue:BatchDeletePartition"
#         ],
#         Resource = "*",
#       },
#       {
#         Sid    = "backups3policy",
#         Effect = "Allow",
#         Action = [
#           "s3:GetBucketLocation",
#           "s3:ListAllMyBuckets",
#           "s3:ListBucket",
#           "s3:CreateBucket",
#           "s3:GetLifecycleConfiguration",
#           "s3:PutLifecycleConfiguration",
#           "s3:PutBucketTagging",
#           "s3:ListBucketVersions",
#           "s3:GetBucketAcl",
#           "s3:PutBucketPublicAccessBlock",
#           "s3:GetObject",
#           "s3:PutEncryptionConfiguration",
#           "s3:DeleteObject",
#           "s3:DeleteObjectVersion",
#           "s3:ListBucketMultipartUploads",
#           "s3:PutObject",
#           "s3:PutBucketAcl",
#           "s3:AbortMultipartUpload",
#           "s3:ListMultipartUploadParts",
#           "s3:DeleteBucket",
#           "s3:GetObjectVersionTagging",
#           "s3:GetObjectVersionAcl",
#           "s3:GetObjectRetention",
#           "s3:GetObjectTagging",
#           "s3:GetObjectVersion",
#           "s3:PutObjectVersionTagging",
#           "s3:PutObjectRetention",
#           "s3:DeleteObjectTagging",
#           "s3:DeleteObjectVersionTagging",
#           "s3:GetBucketObjectLockConfiguration",
#           "s3:GetBucketVersioning",
#           "s3:PutBucketObjectLockConfiguration",
#           "s3:PutBucketVersioning",
#           "s3:BypassGovernanceRetention",
#           "s3:PutBucketPolicy",
#           "s3:PutBucketOwnershipControls"
#         ],
#         Resource = "*",
#       },
#       {
#         Sid    = "fabricpools3policy",
#         Effect = "Allow",
#         Action = [
#           "s3:CreateBucket",
#           "s3:GetLifecycleConfiguration",
#           "s3:PutLifecycleConfiguration",
#           "s3:PutBucketTagging",
#           "s3:ListBucketVersions",
#           "s3:GetBucketPolicyStatus",
#           "s3:GetBucketPublicAccessBlock",
#           "s3:GetBucketAcl",
#           "s3:GetBucketPolicy",
#           "s3:PutBucketPublicAccessBlock",
#           "s3:DeleteBucket"
#         ],
#         Resource = "arn:aws:s3:::fabric-pool*",
#       },
#       {
#         Sid    = "fabricpoolpolicy",
#         Effect = "Allow",
#         Action = [
#           "ec2:DescribeRegions"
#         ],
#         Resource = "*",
#       },
#       {
#         Sid    = "netapp-adc-manager",
#         Effect = "Allow",
#         Action = [
#           "ec2:StartInstances",
#           "ec2:StopInstances",
#           "ec2:TerminateInstances"
#         ],
#         Resource = "arn:aws:ec2:*:*:instance/*",
#         Condition = {
#           "StringEquals" : {
#             "ec2:ResourceTag/netapp-adc-manager" : "*",
#           },
#         },
#       },
#       {
#         Sid    = "workingenvironmentstart",
#         Effect = "Allow",
#         Action = [
#           "ec2:StartInstances",
#           "ec2:TerminateInstances",
#           "ec2:AttachVolume",
#           "ec2:DetachVolume",
#           "ec2:StopInstances",
#           "ec2:DeleteVolume"
#         ],
#         Resource = "arn:aws:ec2:*:*:instance/*",
#         Condition = {
#           "StringEquals" : {
#             "ec2:ResourceTag/WorkingEnvironment" : "*",
#           },
#         },
#       },
#       { Sid    = "workingenvironmentvolumes",
#         Effect = "Allow",
#         Action = [
#           "ec2:AttachVolume",
#           "ec2:DetachVolume",
#           "ec2:DeleteVolume"
#         ],
#         Resource = "arn:aws:ec2:*:*:volume/*",
#         Condition = {
#           "StringEquals" : {
#             "ec2:ResourceTag/WorkingEnvironment" : "*",
#           },
#         },
#       },
#     ],
#   })
# }

# resource "aws_iam_role_policy_attachment" "netapp_cloud_connector_policy_attachment" {
#   policy_arn = aws_iam_policy.netapp_cloud_connector_policy.arn
#   role       = aws_iam_role.netapp_cloud_connector_role.name
# }

# resource "aws_iam_policy" "netapp_cloud_connector_policy_2" {
#   name        = "ocm-policy"
#   description = "Policy for NetApp Cloud Connector in AWS"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid    = "k8sservicepolicy",
#         Effect = "Allow",
#         Action = [
#           "ec2:DescribeRegions",
#           "eks:ListClusters",
#           "eks:DescribeCluster",
#           "iam:GetInstanceProfile",
#         ],
#         Resource = "*",
#       },
#       {
#         Sid    = "gfcservicepolicy",
#         Effect = "Allow",
#         Action = [
#           "cloudformation:DescribeStacks",
#           "cloudwatch:GetMetricStatistics",
#           "cloudformation:ListStacks",
#         ],
#         Resource = "*",
#       },
#       {
#         Sid    = "gfcinstancepolicy",
#         Effect = "Allow",
#         Action = [
#           "ec2:StartInstances",
#           "ec2:TerminateInstances",
#           "ec2:AttachVolume",
#           "ec2:DetachVolume",
#         ],
#         Resource = "arn:aws:ec2:*:*:instance/*",
#         Condition = {
#           "StringLike" : {
#             "ec2:ResourceTag/GFCInstance" : "*",
#           },
#         },
#       },
#       {
#         Sid    = "tagservicepolicy",
#         Effect = "Allow",
#         Action = [
#           "ec2:CreateTags",
#           "ec2:DeleteTags",
#           "ec2:DescribeTags",
#           "tag:getResources",
#           "tag:getTagKeys",
#           "tag:getTagValues",
#           "tag:TagResources",
#           "tag:UntagResources",
#         ],
#         Resource = "*",
#       },
#     ],
#   })
# }

# resource "aws_iam_role_policy_attachment" "netapp_cloud_connector_policy_attachment_2" {
#   policy_arn = aws_iam_policy.netapp_cloud_connector_policy_2.arn
#   role       = aws_iam_role.netapp_cloud_connector_role.name
# }