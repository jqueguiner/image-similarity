import os
import sys
import subprocess
import requests
import ssl
import random
import string
import json

from flask import jsonify
from flask import Flask
from flask import request
from flask import send_file
import traceback

from app_utils import blur
from app_utils import download
from app_utils import generate_random_filename
from app_utils import clean_me
from app_utils import clean_all
from app_utils import create_directory
from app_utils import get_model_bin
from app_utils import get_multi_model_bin

import face_recognition
import cv2
from skimage import io


try:  # Python 3.5+
    from http import HTTPStatus
except ImportError:
    try:  # Python 3
        from http import client as HTTPStatus
    except ImportError:  # Python 2
        import httplib as HTTPStatus


app = Flask(__name__)


@app.route("/process", methods=["POST"])
def process():

    input_path = generate_random_filename(upload_directory,"jpg")
    output_path = generate_random_filename(upload_directory,"jpg")

    try:
        url = request.json["url"]
        sigma=50

        download(url, input_path)
       
        results = []

        image = face_recognition.load_image_file(input_path)

        locations = face_recognition.face_locations(image)

        image = io.imread(input_path)

        for location in locations:
            startY = location[0]
            endY = location[2]
            startX = location[1]
            endX = location[3]

            image = blur(image, startX, endX, startY, endY, sigma=sigma)
        

        io.imsave(output_path, image)
        
        callback = send_file(output_path, mimetype='image/jpeg')

        return callback, 200

    except:
        traceback.print_exc()
        return {'message': 'input error'}, 400

    finally:
        clean_all([
            input_path,
            output_path
            ])

if __name__ == '__main__':
    global upload_directory

    upload_directory = '/src/upload/'
    create_directory(upload_directory)

    port = 5000
    host = '0.0.0.0'

    app.run(host=host, port=port, threaded=True)

