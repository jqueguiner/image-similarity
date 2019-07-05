# Docker for API

You can build and run the docker using the following process:

Cloning
```console
gti clone https://github.com/jqueguiner/XXXX.git XXXXX
```

Building Docker
```console
cd XXXXX && docker build -t XXXXX -f Dockerfile .
```

Running Docker
```console
echo "http://$(curl ifconfig.io):5000" && docker run -p 5000:5000 -d XXXXX
```

Calling the API
```console
curl -X POST "http://MY_SUPER_API_IP:5000/process" -H "accept: application/json" -H "Content-Type: application/json" -d '{"url":"https://i.ibb.co/FqDSQF8/input.jpg"}'
```

Calling the API
```console
curl -X POST "http://MY_SUPER_API_IP:5000/detect" -H "accept: application/json" -H "Content-Type: application/json" -d '{"url":"https://i.ibb.co/FqDSQF8/input.jpg"}'
```
