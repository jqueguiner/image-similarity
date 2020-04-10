The image simlarity API will give you image similarity in just 1 API call.

Providing the image url to the API will returns different image similarity metrics for the 2 provided sources.

* * *

Included Metrics are:
**Earth Mover's Distance**
```
@article{Rubner:2000:EMD:365875.365881,
 author = {Rubner, Yossi and Tomasi, Carlo and Guibas, Leonidas J.},
 title = {The Earth Mover's Distance As a Metric for Image Retrieval},
 journal = {Int. J. Comput. Vision},
 issue_date = {Nov. 2000},
 volume = {40},
 number = {2},
 month = nov,
 year = {2000},
 issn = {0920-5691},
 pages = {99--121},
 numpages = {23},
 url = {https://doi.org/10.1023/A:1026543900054},
 doi = {10.1023/A:1026543900054},
 acmid = {365881},
 publisher = {Kluwer Academic Publishers},
 address = {Norwell, MA, USA},
 keywords = {Earth Mover's Distance, color, image retrieval, perceptual metrics, texture},
} 
```

**SIFT Similarity**
```
@INPROCEEDINGS{790410,
author={D. G. {Lowe}},
booktitle={Proceedings of the Seventh IEEE International Conference on Computer Vision},
title={Object recognition from local scale-invariant features},
year={1999},
volume={2},
number={},
pages={1150-1157 vol.2},
keywords={object recognition;feature extraction;computational geometry;image matching;least squares approximations;local scale-invariant features;local image features;3D projection;inferior temporal cortex;primate vision;staged filtering approach;local geometric deformations;blurred image gradients;multiple orientation planes;nearest neighbor indexing method;candidate object matches;low residual least squares solution;unknown model parameters;robust object recognition;cluttered partially occluded images;computation time;Object recognition;Electrical capacitance tomography;Image recognition;Lighting;Neurons;Computer science;Reactive power;Filters;Programmable logic arrays;Layout},
doi={10.1109/ICCV.1999.790410},
ISSN={},
month={Sep.},}
```

**Structural Simillarity**
```
@ARTICLE{Wang04imagequality,
    author = {Zhou Wang and Alan C. Bovik and Hamid R. Sheikh and Eero P. Simoncelli},
    title = {Image Quality Assessment: From Error Visibility to Structural Similarity},
    journal = {IEEE TRANSACTIONS ON IMAGE PROCESSING},
    year = {2004},
    volume = {13},
    number = {4},
    pages = {600--612}
}
```


**Pixel Similarity**
```
@inproceedings{james2010pixel,
  title={Pixel-level similarity fusion for image classification},
  author={James, Alex Pappachen},
  booktitle={Systems Signals and Devices (SSD), 2010 7th International Multi-Conference on},
  pages={1--3},
  year={2010},
  organization={IEEE}
}
```

- - -
EXAMPLE
![output](https://i.ibb.co/ZXhGBZf/example.png)
- - -
INPUT

```json
{
    "url_a":"https://i.ibb.co/JqLZ4KZ/a.jpg", 
    "url_b":"https://i.ibb.co/R792dvs/b.jpg"
}
```
- - -
EXECUTION
```bash
curl -X POST "https://api-market-place.ai.ovh.net/image-similarity/detect" -H  "accept: application/json" -H  "X-OVH-Api-Key: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" -H  "Content-Type: application/json" -d '{"url_a": "https://i.ibb.co/JqLZ4KZ/a.jpg", "url_b": "https://i.ibb.co/R792dvs/b.jpg"}'
```

- - -

OUTPUT

```json
[
    {
        "structural_similarity": "0.4954", 
        "EarthMover_Distance": "0.0020", 
        "pixel_similarity": "0.0000", 
        "SIFT_similarity": "0.0000"
    }
]
```

please refer to swagger documentation for further technical details: [swagger documentation](https://market-place.ai.ovh.net/#!/apis/f28631f5-a695-49c5-8631-f5a69579c581/pages/3e88754f-4f34-4911-8875-4f4f34691156)

* * *
<div>Icons made by <a href="https://www.freepik.com/?__hstc=57440181.a18ae3242801c784acaa7d699ddc7bef.1562831118811.1562909089646.1562925517192.4&__hssc=57440181.1.1562925517192&__hsfp=2980732559" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
