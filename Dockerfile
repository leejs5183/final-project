FROM rockylinux:9
RUN dnf -y install java-21-openjdk tar && dnf clean all
RUN mkdir -p /opt/tomcat
WORKDIR /opt/tomcat
ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.115/bin/apache-tomcat-9.0.115.tar.gz /opt/tomcat/
RUN tar xzf apache-tomcat-9.0.115.tar.gz 
RUN mv apache-tomcat-9.0.115/* /opt/tomcat/ 
RUN rm -f apache-tomcat-9.0.115.tar.gz
RUN rm -rf /opt/tomcat/webapps/ROOT /opt/tomcat/webapps/ROOT.war
COPY target/final-project.war /opt/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]




