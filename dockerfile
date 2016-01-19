# Usage: FROM [image name]
FROM debian:jessie

# Usage: MAINTAINER [name]
MAINTAINER weezhard

RUN apt-get update && \
    apt-get install -y -q wget

RUN echo "deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list

RUN wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -

RUN apt-get update && \
    apt-get install -y -q jenkins

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/*

USER jenkins

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/var/lib/jenkins"]

EXPOSE 8080

ENTRYPOINT ["/usr/bin/java", "-Djava.awt.headless=true", "-jar", "/usr/share/jenkins/jenkins.war", "--webroot=/var/cache/jenkins/war", "--httpPort=8080", "--ajp13Port=-1"]
