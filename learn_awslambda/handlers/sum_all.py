# -*- coding: utf-8 -*-

"""
- Type: Request / Response
"""


def handler(event, context):
    return sum(event["data"])
