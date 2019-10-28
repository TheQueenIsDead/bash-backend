# Bash Calculator Web Api

This project is a short demo of what real men can do with only the power of POSIX compliant shells and an on-repeat 
loop of [Richard Stallman singing the free software song](https://www.youtube.com/watch?v=9sJUDx7iEJw).

`dotnet publish` this one.

# Usage

Make sure you have Docker and Curl:

Start up an instance:

```bash
docker-compose up
```

Test out some endpoints (Please dont use any data other than this, it probably works, but Murphys law)
```bash
curl -sX GET localhost:8080/add/10/2
12
curl -sX GET localhost:8080/divide/10/2
5
curl -sX GET localhost:8080/multiply/10/2
20
curl -sX GET localhost:8080/subtract/10/2
8
curl -sX GET localhost:8080/hello/Dougal
Hello, Dougal!
```

# Docker

After deciding to go old school, we thought we'd add some cutting edge in there to even things out.

The usage of Docker and Docker Compose means that this project is on the brink of being turned into a k8s deployment,
or a Docker Swarm stack. API's should be fast and scalable, in an age where cloud technology is
so freely available to us, it makes sense to scale outwards and use modern service meshes to ensure 
everyone can enjoy this calculator app in high availability (Clustering coming soon)

# Contemplation

## Should I have done this?

No, apologies, but you have to review it now

## Benefits

* No fancy REST verbs, GET for every endpoint. Because we GET you results.
* Simple text response saves complex JSON payloads
* Handles numbers up to 10 at least
* Fast I think
* Not written in Perl
* No pesky unit tests to worry about, this keeps the Docker image small

## Drawbacks

* The project is 3.5K (Docker excluded) meaning this is slightly larger than I would have liked
* The app dies everytime a request is sent to it.