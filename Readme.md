### README.md

source in.sh;
docker-on MACHINE-NAME "docker command"
print=1 before any docker command will print the command :)

### Precache the following images

docker pull alpine
docker pull redis:alpine
docker pull nginx
docker pull avthart/consul-template
docker pull gliderlabs/registrator
docker pull mongo


exercise:
docker pull atbaker/nginx-example
docker pull alpine
docker pull golang:1.5-alpine