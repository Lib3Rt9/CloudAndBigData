#!/bin/bash


# Get current script and resource directories
CURRENT_FILE_PATH=$(realpath "$0")
CURRENT_DIR=$(dirname "$CURRENT_FILE_PATH")
RESOURCE_DIR=$(realpath "$CURRENT_DIR/../resources")
PROJECT_DIR=$(realpath "$CURRENT_DIR/../../CloudAndBigData" )
SECRET_KEY_DIR=$(realpath "$PROJECT_DIR/secrets")

DATA_DIR=/data/vm

# == Clean
bash clean.sh

# == Libvirt/KVM
sudo apt update -y
sudo apt -y install bridge-utils cpu-checker libvirt-clients libvirt-daemon-system qemu-kvm
kvm-ok

# == Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y && sudo apt install -y terraform

# Install genisoimage for mkisofs for cloudinit feature
sudo apt install -y genisoimage

# Disable qemu security_driver to fix permission error in ubuntu
# https://github.com/dmacvicar/terraform-provider-libvirt/issues/546
sudo sed -i 's/#security_driver = "selinux"/security_driver = "none"/' /etc/libvirt/qemu.conf
sudo systemctl restart libvirtd

# == Ansible
sudo apt-get install ansible -y

# == Prepare VM envs
sudo usermod -aG libvirt `id -un`
sudo usermod -aG kvm `id -un`

sudo mkdir -p $DATA_DIR || true
sudo chown -R $USER:libvirt $DATA_DIR

sudo chown -R $USER:ubuntu $PROJECT_DIR

# sudo chmod 600 $SECRET_KEY_DIR/id_ed25519
# sudo chmod 644 $SECRET_KEY_DIR/id_ed25519.pub

# # == Download img file
# wget -O $RESOURCE_DIR/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img

# == Download java
# FILE_DIR=$HOME/ansible/roles/install_cluster/files
# wget -O $FILE_DIR/jdk-8u202-linux-x64.tar.gz https://sd-160040.dedibox.fr/hagimont/software/jdk-8u202-linux-x64.tar.gz
# wget -O $FILE_DIR/hadoop-2.7.1.tar.gz https://sd-160040.dedibox.fr/hagimont/software/hadoop-2.7.1.tar.gz
# wget -O $FILE_DIR/spark-2.4.3-bin-hadoop2.7.tgz https://sd-160040.dedibox.fr/hagimont/software/spark-2.4.3-bin-hadoop2.7.tgz


# == Ensure resource directory exists
mkdir -p $RESOURCE_DIR


# == Download img file if not already downloaded
IMG_FILE=$RESOURCE_DIR/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img
if [ ! -f "$IMG_FILE" ]; then
  wget -O $IMG_FILE https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img
else
  echo "Image file already exists: $IMG_FILE"
fi


# == Download Java and Hadoop/Spark files if not already downloaded
FILE_DIR=$CURRENT_DIR/../ansible/roles/install_cluster/files
mkdir -p $FILE_DIR


# JDK
JDK_FILE=$FILE_DIR/jdk-8u202-linux-x64.tar.gz
if [ ! -f "$JDK_FILE" ]; then
  wget -O $JDK_FILE https://sd-160040.dedibox.fr/hagimont/software/jdk-8u202-linux-x64.tar.gz
else
  echo "JDK file already exists: $JDK_FILE"
fi

# Hadoop
HADOOP_FILE=$FILE_DIR/hadoop-2.7.1.tar.gz
if [ ! -f "$HADOOP_FILE" ]; then
  wget -O $HADOOP_FILE https://sd-160040.dedibox.fr/hagimont/software/hadoop-2.7.1.tar.gz
else
  echo "Hadoop file already exists: $HADOOP_FILE"
fi

# Spark
SPARK_FILE=$FILE_DIR/spark-2.4.3-bin-hadoop2.7.tgz
if [ ! -f "$SPARK_FILE" ]; then
  wget -O $SPARK_FILE https://sd-160040.dedibox.fr/hagimont/software/spark-2.4.3-bin-hadoop2.7.tgz
else
  echo "Spark file already exists: $SPARK_FILE"
fi


sudo chown -R $USER:ubuntu $PROJECT_DIR