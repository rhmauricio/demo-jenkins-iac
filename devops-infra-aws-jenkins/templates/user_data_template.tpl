##!/bin/bash -eu
## **************************************
## ** Jenkins Master User Data Script  **
## ** Date : 05/07/2022                **
## ** Author: ADL DevOps Team          **
## **************************************
#mkdir -p /var/log/devops
#echo "Welcome, Jenkins BPOP corporativo" >> /var/log/devops/user-data.log
#export LC_CTYPE=C
#function logMessage() {
#  message=$1
#  printf "\033[0;32m$${message}\033[0m\n"
#  echo $message >> /var/log/devops/user-data.log
#}
#function initializationGenericVar() {
#  yum install -y jq
#  logMessage "Setting main Env Vars..."
#  export AWS_REGION=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/[a-z]$//')
#  export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
#  export GITHUB_TOKEN=$(aws ssm get-parameter --region $${AWS_REGION} --name "/${github_ssm_path_prefix}/token" --with-decryption | jq -r .Parameter.Value)
#  export ENVIRONMENT='${legacy_stack_id}'
#  export ENV_SUFFIX=$([ "${is_prod}" == "0" ] && echo "pre" || echo "prod")
#  #validar credenciales expuestas en groovy
#  export MASTER_PASSWORD=$(aws ssm get-parameter --region $${AWS_REGION} --name "/${jenkins_ssm_path_prefix}/master_password" --with-decryption | jq -r .Parameter.Value)
#  export MASTER_USER=$(aws ssm get-parameter --region $${AWS_REGION} --name "/${jenkins_ssm_path_prefix}/master_user" --with-decryption | jq -r .Parameter.Value)
#}
#function addFileHost() {
#  logMessage "Saving Host file..."
#  # Workaround for 'java.net.UnknownHostException: ip-XXX-XXX-XXX-XXX: ip-XXX-XXX-XXX-XXX: Name or service not known'
#  echo "127.0.0.1 $(hostname)" >>/etc/hosts
#}
#
#function replaceJVMParameter() {
#  logMessage "Replacing JVM parameter ..."
#  sed -i "s|JVM_MEMORY|$${JVM_MEMORY}|g" /etc/sysconfig/jenkins
#  sed -i "s|JVM_OTHER|$${JVM_OTHER}|g" /etc/sysconfig/jenkins
#}
#
#function settingEFSJenkins() {
#  logMessage "Setting EFS..."
#  logMessage "Getting EFS mountpoint from SSM..."
#  export EFS_JENKINS_MOUNTPOINT=$(aws ssm get-parameter --region $${AWS_REGION} --name "/${jenkins_ssm_path_prefix}/efs_jenkins_mountpoint" | jq -r .Parameter.Value)
#  echo $EFS_JENKINS_MOUNTPOINT
#  logMessage "Mounting EFS..."
#  sudo yum install -y amazon-efs-utils
#  export JENKINS_HOME="/mnt/EFS_JENKINS_HOME"
#  mkdir -p $JENKINS_HOME
#
#  if ! host $${EFS_JENKINS_MOUNTPOINT}; then
#    logMessage "EFS DNS is unreachable. Waiting 30 sec..." && sleep 30
#  fi
#  sudo mount -t efs $${EFS_JENKINS_MOUNTPOINT}:/ /mnt/EFS_JENKINS_HOME
#
#  logMessage "Pointing Jenkins Home to EFS..."
#  mv /var/lib/jenkins /var/lib/jenkins-backup
#  ln -s /mnt/EFS_JENKINS_HOME /var/lib/jenkins
#}
#
#function setConfigurationFilesJenkins() {
#  logMessage "Download jcasc and config files..."
#  pushd /tmp
#  #Descarga JCASC desde repositorio s3. (Corresponde a carpetas y archivos en la ruta ./resources/JCASC )
#  aws s3 cp s3://${jcasc_bucket}/JCASC.zip .
#  unzip JCASC.zip -d JCASC
#  #Habilite las siguientes lineas de código si desea descargar las configuraciones como codigo de Jenkins (jcasc) desde un repositorio de github
#  #Recuerda que para evitar inconsistencias o duplicidad en las configuraciones, si vas a utilizar el jcasc desde un repositorio en github, debes eliminar
#  #los folders config, scripts y el archivo Jenkinsfile de la ruta ./resources/JCASC, y NO debes eliminar la carpeta jobs, ya que contine la configuracion
#  #del pipeline de ejemplo.
#  #Recuerda validar la organización, nombre del repositorio y  nombre de la rama a utilizar y realizar los ajustes correspondientes:
#
#  #curl --silent -L -o devops-jenkins-jcasc.zip https://$${GITHUB_TOKEN}@github.com/BancoPopular/devops-infra-jcasc-configs/archive/master.zip
#  #unzip devops-infra-jcasc-configs.zip
#  #mv -f devops-infra-jcasc-configs*/* JCASC/
#  popd
#
#  logMessage "Checking Jenkins Config..."
#  if [ ! -f /etc/sysconfig/jenkins.old ]; then
#    logMessage "Making Jenkins config backup..."
#    cp /etc/sysconfig/jenkins /etc/sysconfig/jenkins.old
#  fi
#
#  logMessage "Copying Jenkins basic config files ..."
#  if [ ! -d /var/lib/jenkins/jcasc ]; then
#    mkdir -p /var/lib/jenkins/jcasc
#  fi
#  if [ ! -d /var/lib/jenkins/init.groovy.d ]; then
#    mkdir /var/lib/jenkins/init.groovy.d
#  fi
#
#  pushd /tmp/JCASC
#  rm -rf /var/lib/jenkins/init.groovy.d/
#  mv -f scripts/groovy/ /var/lib/jenkins/init.groovy.d/
#  rm -rf /var/lib/jenkins/jcasc/
#  mv -f config/jcasc/ /var/lib/jenkins/jcasc/
#
#  logMessage "Getting current jenkins master private IP..."
#  export TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
#  export TUNNEL_JENKINS=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4`
#  sed -i "s/<tunnel>/$${TUNNEL_JENKINS}/g" /var/lib/jenkins/jcasc/*
#
#  if [ ! -d $$JENKINS_HOME/jobs]; then
#    logMessage "Download jobs examples..."
#    mv jobs $$JENKINS_HOME/
#    chown -R jenkins:jenkins /var/lib/jenkins/
#  fi
#
#  echo 2.0 | tee \
#    /var/lib/jenkins/jenkins.install.UpgradeWizard.state \
#    /var/lib/jenkins/jenkins.install.InstallUtil.lastExecVersion
#
#  chown -R jenkins:jenkins /var/lib/jenkins/jcasc
#  chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
#
#  mv -f config/plugins/plugins.txt /tmp/
#  mv -f scripts/sh/* /usr/local/bin/
#  chown -R jenkins:jenkins /usr/local/bin/
#
#  logMessage "Copying Jenkins main sysconfig file..."
#  mv -f config/general/jenkins /etc/sysconfig/
#  chown -R jenkins:jenkins /etc/sysconfig/jenkins
#  . config/general/jenkins.sh
#  replaceJVMParameter
#  popd
#}
#
#function installPlugins() {
#  logMessage "Intalling Jenkins plugins..."
#  chmod +x /usr/local/bin/install-plugins.sh
#  bash /usr/local/bin/install-plugins.sh </tmp/plugins.txt
#}
#
#function setJCASCEnv() {
#  logMessage "Setting Jenkins JCASC..."
#  echo "export CASC_JENKINS_CONFIG='/var/lib/jenkins/jcasc'" >>/etc/environment.sh
#  echo "export CASC_SSM_PREFIX='/${jenkins_ssm_path_prefix}/'" >>/etc/environment.sh
#  echo "export CASC_TUNNEL_JENKINS=$${TUNNEL_JENKINS}" >>/etc/environment.sh
#  sed -i '0,/^$/ s/^$/. \/etc\/environment.sh/' /etc/init.d/jenkins
#}
#
#function main() {
#  logMessage "****************************************** INIT SCRIPT ***************************************************"
#  initializationGenericVar
#  addFileHost
#  settingEFSJenkins
#  setConfigurationFilesJenkins
#  installPlugins
#  setJCASCEnv
#  logMessage "**************** Starting Jenkins... ********************+ "
#  service jenkins start
#  logMessage "****************************************** END SCRIPT ****************************************************"
#  exit 0
#}
#main "$@"