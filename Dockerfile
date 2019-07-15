FROM guignol95/ai_apis:latest

ADD src /src

WORKDIR /src

RUN apt-get update -y && apt-get install python-pip -y
RUN pip install -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["python"]

CMD ["app.py"]
