sudo apt install openjdk-8-jdk -y
java -version

# Add Jenkins repository
              wget -O /etc/yum.repos.d/jenkins.repo \
              https://pkg.jenkins.io/redhat-stable/jenkins.repo

              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

              # Install Jenkins
              yum install -y jenkins

              # Enable and start Jenkins
              systemctl enable jenkins
              systemctl start jenkins

              # Enable Jenkins on reboot
              systemctl status jenkins
