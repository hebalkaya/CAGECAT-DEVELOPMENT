# New Steps
## Building the docker image
```
docker build -t v2-tbd .
```
## Running the docker image
```
docker run -d   --name v2-tbd-env   -p 5364:88   v2-tbd
```
