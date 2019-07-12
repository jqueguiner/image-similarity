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

import similarity 


try:  # Python 3.5+
    from http import HTTPStatus
except ImportError:
    try:  # Python 3
        from http import client as HTTPStatus
    except ImportError:  # Python 2
        import httplib as HTTPStatus


app = Flask(__name__)


@app.route("/detect", methods=["POST"])
def detect():

    input_a_path = generate_random_filename(upload_directory,"jpg")
    input_b_path = generate_random_filename(upload_directory,"jpg")

    try:
        url_a = request.json["url_a"]
        url_b = request.json["url_b"]

        download(url_a, input_a_path)
        download(url_b, input_b_path)
       
        results = []

        structural_sim = structural_sim(input_a_path, input_b_path)
        pixel_sim = pixel_sim(input_a_path, input_b_path)
        sift_sim = sift_sim(input_a_path, input_b_path)
        emd = earth_movers_distance(input_a_path, input_b_path)
        results.append({
        	"structural_similarity": structural_sim, 
        	"pixel_similarity": pixel_sim, 
        	"SIFT_similarity": sift_sim, 
        	"EarthMover_Distance": emd
        	})
        
        return json.dumps(results), 200


    except:
        traceback.print_exc()
        return {'message': 'input error'}, 400

    finally:
        clean_all([
            input_a_path,
            input_b_path
            ])

if __name__ == '__main__':
    global upload_directory

    upload_directory = '/src/upload/'
    create_directory(upload_directory)

    port = 5000
    host = '0.0.0.0'

    app.run(host=host, port=port, threaded=True)

