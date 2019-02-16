# -*- coding: utf-8 -*-

import pandas as pd


def handler(event, context):
    return pd.__version__
