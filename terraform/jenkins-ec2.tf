resource "aws_instance" "jenkins" {
  ami           = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2
  instance_type = "t3.medium"
  subnet_id     = module.vpc.private_subnets[0]
  key_name      = "devops-key"

  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    
    systemctl start docker
    systemctl enable docker

    amazon-linux-extras install java-openjdk11 -y

    wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

    yum install jenkins -y
    systemctl start jenkins
    systemctl enable jenkins
  EOF

  tags = {
    Name = "Jenkins-Server"
  }
}

