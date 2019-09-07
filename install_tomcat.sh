#!/bin/bash
yum install -y git 2> /dev/null && yum install -y wget 2> /dev/null
yum install -y java-1.7.0-openjdk-devel
cd /opt/ && git clone https://github.com/rpkkashyap/tomcat.git
useradd tomcat -d /opt/tomcat 2> /dev/null
mkdir /opt/tomcat/logs/
chgrp -R tomcat /opt/tomcat
chmod -R g+r /opt/tomcat/conf
chmod g+x /opt/tomcat/conf
chown -R  tomcat /opt/tomcat/webapps/ /opt/tomcat  /opt/tomcat/temp/ /opt/tomcat/logs/ /opt/tomcat/conf
ln -s /opt/tomcat/logs/ /var/log/tomcat/out.log

cat <<EOF > /etc/systemd/system/tomcat.service
# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable tomcat
systemctl daemon-reload
systemctl start tomcat
