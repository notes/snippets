# default configurations
cat >~/.aws_config <<__AWSCONFIG__
[default]
aws_access_key_id = XXXXXX
aws_secret_access_key = XXXXXX
region = ap-northeast-1
__AWSCONFIG__
export AWS_CONFIG_FILE=~/.aws_config

# create a key-pair
aws ec2 create-key-pair --key-name my-key-pair

# check created key-pairs
aws ec2 describe-key-pairs

# allocate new IP address
aws ec2 allocate-address

# check allocated IP address
aws ec2 describe-addresses

# create a security group
aws ec2 create-security-group --group-name default-group --description "Default Group"

# add a permission rule to the security group
aws ec2 authorize-security-group-ingress --group-name default-group --ip-permissions '[
{ "to_port": 8080, 
  "ip_protocol": "tcp", 
  "ip_ranges": [ { "cidr_ip": "192.168.0.0/24" } ], 
  "user_id_group_pairs": [], 
  "from_port": 8080 }
]'

# search AMI images
aws ec2 describe-images --owners amazon --filters '[
  { "name":"root-device-type",    "values":"instance-store" },
  { "name":"architecture",        "values":"x86_64" },
  { "name":"virtualization-type", "values":"paravirtual" },
]'

# run AMI public instance
aws ec2 run-instances --image-id ami-173fbf16 --min-count 1 --max-count 1 \
  --security-groups my-security-group --key-name my-key-pair --instance-type t1.micro

# check running instances
aws ec2 describe-instances --instance-ids i-12345678

# or if you want status only
aws ec2 describe-instance-status --include-all-instances

# associate public IP address with instance
aws ec2 associate-address --instance-id i-12345678 --public-ip 192.168.0.1

# stop & save EBS instances
aws ec2 stop-instances --instance-ids i-12345678

# restart saved EBS instances
aws ec2 start-instances --instance-ids i-12345678

# terminate instances (this destroys all instance data)
aws ec2 terminate-instances --instance-ids i-12345678

