#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
请注意, Python2的requests的SSL的版本不支持最新版本。而AWS的Api Gateway是支持的, 所以
必须在Python3的环境下用requests进行测试。
"""

from __future__ import print_function
from pprint import pprint
import requests
import json

url = "https://0q1yvp9p7e.execute-api.us-west-2.amazonaws.com/prod/dice-gamble"

headers = {
    "content-type": "application/json", 
#     "x-api-key": "HGQEC4VoTk99kGf1qcr3m8MtUu25zARy3NnU2AKU",
}

data = {"big": 100, "9": 20, "10": 20}
data = json.dumps(data)

res = requests.post(url, headers=headers, data=data)
pprint(json.loads(res.text))