Bashd
======

bashd is a http server written in bash.

1. build it you won't find it on dockerhub :)

`docker build  -t test-bashd . `

2. run it 
 
`docker run -d -p 8080:8080 test-bashd`

3. use it

`wget -O /tmp/index.html localhost:8080`
