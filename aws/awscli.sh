# create a key-pair
aws ec2 create-key-pair --key-name my-key-pair

# check created key-pairs
aws ec2 describe-key-pairs

# run AMI public instance
aws ec2 run-instances --image-id ami-173fbf16 --min-count 1 --max-count 1 \
  --security-groups my-security-group --key-name my-key-pair

# check running instance
aws ec2 describe-instances --instance-ids i-1234567c

