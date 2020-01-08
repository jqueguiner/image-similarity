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

from similarity import structural_sim 
from similarity import pixel_sim
from similarity import sift_sim
from similarity import earth_movers_distance

try:  # Python 3.5+
    from http import HTTPStatus
except ImportError:
    try:  # Python 3
        from http import client as HTTPStatus
    except ImportError:  # Python 2
        import httplib as HTTPStatus


app = Flask(__name__)


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route("/detect", methods=["POST"])
def detect():

    input_a_path = generate_random_filename(upload_directory,"jpg")
    input_b_path = generate_random_filename(upload_directory,"jpg")

    try:
        if 'file_a' in request.files:
            file_a = request.files['file_a']
            if allowed_file(file_a.filename):
                file_a.save(input_a_path)
        if 'file_b' in request.files:
            file_b = request.files['file_b']
            if allowed_file(file_b.filename):
                file_a.save(input_b_path)
            
        else:
            url_a = request.json["url_a"]
            url_b = request.json["url_b"]

            download(url_a, input_a_path)
            download(url_b, input_b_path)
       
        results = []

        ssim = structural_sim(input_a_path, input_b_path)
        psim = pixel_sim(input_a_path, input_b_path)
        sift = sift_sim(input_a_path, input_b_path)
        emd = earth_movers_distance(input_a_path, input_b_path)

        results.append({
        	"structural_similarity": "%.4f" % ssim,
        	"pixel_similarity": "%.4f" % psim,
        	"SIFT_similarity": "%.4f" % sift,
        	"EarthMover_Distance": "%.4f" % emd,
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
    global ALLOWED_EXTENSIONS
    ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])

    upload_directory = '/src/upload/'
    create_directory(upload_directory)

    port = 5000
    host = '0.0.0.0'

    app.run(host=host, port=port, threaded=True)

