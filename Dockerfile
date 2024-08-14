FROM tomcat:latest
WORKDIR /usr/local/tomcat/webapps
RUN cp -pr ../webapps.dist/* .
RUN rm -rf ./ROOT*
COPY ./target/*.war .
EXPOSE 8080
CMD ["catalina.sh", "run"]
