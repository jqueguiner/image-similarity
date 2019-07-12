# Docker for API

You can build and run the docker using the following process:

Cloning
```console
git clone https://github.com/jqueguiner/image-similarity.git 
```

Building Docker
```console
cd image-similarity && docker build -t image-similarity -f Dockerfile .
```

Running Docker
```console
echo "http://$(curl ifconfig.io):5000" && docker run -p 5000:5000 -d image-similarity
```

Calling the API
```console
curl -X POST "http://MY_SUPER_API_IP:5000/detect" -H "accept: application/json" -H "Content-Type: application/json" -d '{"url_a":"https://i.ibb.co/JqLZ4KZ/a.jpg", "url_b":"https://i.ibb.co/R792dvs/b.jpg"}'
```
