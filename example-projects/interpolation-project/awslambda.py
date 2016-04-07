#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import json
from datetime import datetime

import numpy as np
from scipy.interpolate import interp1d
from dateutil import parser


def totimestamp(datetime_object):
    """Because in python2 datetime doesn't have timestamp() method,
    so we have to implement in a python2,3 compatible way.
    """
    return (datetime_object - datetime(1969, 12, 31, 20, 0)).total_seconds()


def locate(x1, y1, x2, y2, x3):
    """An equation solver to solve: given two points on a line and x, solve the
    y coordinate on the same line.
    Suppose p1 = (x1, y1), p2 = (x2, y2), p3 = (x3, y3) on the same line.
    given x1, y1, x2, y2, x3, find y3::
        y3 = y1 - (y1 - y2) * (x1 - x3) / (x1 - x3)
    """
    return y1 - 1.0 * (y1 - y2) * (x1 - x3) / (x1 - x2)


def rigid_linear_interpolate(x_axis, y_axis, x_new_axis):
    """Interpolate a y = f(x) function using linear interpolation.
    Rigid means the x_new_axis has to be in x_axis's range.
    """
    f = interp1d(x_axis, y_axis)
    return f(x_new_axis)


def linear_interpolate(x_axis, y_axis, x_new_axis, enable_warning=True):
    """Interpolate a y = f(x) function using linear interpolation.
    A smart way to interpolate arbitrary-range x_new_axis. The trick is 
    to add one more point to the original x_axis at x_new_axis[0] and 
    x_new_axis[-1], if x_new_axis is out of range.
    """
    left_pad_x, left_pad_y = list(), list()
    right_pad_x, right_pad_y = list(), list()

    if x_new_axis[0] < x_axis[0]:
        if enable_warning:
            print("WARNING! the first element of x_new_axis is at left "
                  "of x_axis. Use linear_interpolate(enable_warning=False) "
                  "to disable this warning.")
        left_pad_x.append(x_new_axis[0])
        left_pad_y.append(locate(x_axis[0], y_axis[0],
                                 x_axis[1], y_axis[1], x_new_axis[0]))

    if x_new_axis[-1] > x_axis[-1]:
        if enable_warning:
            print("WARNING! the last element of x_new_axis is at right "
                  "of x_axis. Use linear_interpolate(enable_warning=False) "
                  "to disable this warning.")
        right_pad_x.append(x_new_axis[-1])
        right_pad_y.append(locate(x_axis[-1], y_axis[-1],
                                  x_axis[-2], y_axis[-2], x_new_axis[-1]))

    if not ((len(left_pad_x) == 0) and (len(right_pad_x) == 0)):
        x_axis = left_pad_x + x_axis + right_pad_x
        y_axis = left_pad_y + y_axis + right_pad_y
    
    return rigid_linear_interpolate(x_axis, y_axis, x_new_axis)


def linear_interpolate_by_datetime(datetime_axis, y_axis, datetime_new_axis,
                                   enable_warning=True):
    """A datetime-version that takes datetime object list as x_axis
    """
    numeric_datetime_axis = [
        totimestamp(a_datetime) for a_datetime in datetime_axis
    ]

    numeric_datetime_new_axis = [
        totimestamp(a_datetime) for a_datetime in datetime_new_axis
    ]

    return linear_interpolate(
        numeric_datetime_axis, y_axis, numeric_datetime_new_axis,
        enable_warning=enable_warning)


def exam_reliability(x_axis, x_axis_new, reliable_distance, precision=0.0001):
    """When we do linear interpolation on x_axis and derive value for 
    x_axis_new, we also evaluate how can we trust those interpolated 
    data points. This is how it works:
    For each new x_axis point in x_axis new, let's say xi. Find the closest 
    point in x_axis, suppose the distance is #dist. Compare this to 
    #reliable_distance. If #dist < #reliable_distance, then we can trust it, 
    otherwise, we can't.
    The precision is to handle decimal value's precision problem. Because 
    1.0 may actually is 1.00000000001 or 0.999999999999 in computer system. 
    So we define that: if ``dist`` + ``precision`` <= ``reliable_distance``, then we 
    can trust it, else, we can't.
    Here is an O(n) algorithm implementation. A lots of improvement than 
    classic binary search one, which is O(n^2).
    """
    x_axis = x_axis[::-1]
    x_axis.append(-2**32)

    distance_to_closest_point = list()
    for t in x_axis_new:
        while 1:
            try:
                x = x_axis.pop()
                if x <= t:
                    left = x
                else:
                    right = x
                    x_axis.append(right)
                    x_axis.append(left)
                    left_dist, right_dist = (t - left), (right - t)
                    if left_dist <= right_dist:
                        distance_to_closest_point.append(left_dist)
                    else:
                        distance_to_closest_point.append(right_dist)
                    break
            except:
                distance_to_closest_point.append(t - left)
                break

    reliable_flag = list()
    for dist in distance_to_closest_point:
        if dist - precision - reliable_distance <= 0:
            reliable_flag.append(True)
        else:
            reliable_flag.append(False)

    return reliable_flag


def exam_reliability_by_datetime(
        datetime_axis, datetime_new_axis, reliable_distance):
    """A datetime-version that takes datetime object list as x_axis
    reliable_distance equals to the time difference in seconds.
    """
    numeric_datetime_axis = [
        totimestamp(a_datetime) for a_datetime in datetime_axis
    ]

    numeric_datetime_new_axis = [
        totimestamp(a_datetime) for a_datetime in datetime_new_axis
    ]

    return exam_reliability(numeric_datetime_axis, numeric_datetime_new_axis,
                            reliable_distance, precision=0)


def main(event, context):
    """一个对时间序列进行线性插值的函数, 并且计算线性意义上的可信度。
    """
    timeAxis = event["timeAxis"]
    valueAxis = event["valueAxis"]
    timeAxisNew = event["timeAxisNew"]
    reliable_distance = event["reliable_distance"]
    
    timeAxis = [totimestamp(parser.parse(i)) for i in timeAxis]
    timeAxisNew = [totimestamp(parser.parse(i)) for i in timeAxisNew]

    valueAxisNew = linear_interpolate(timeAxis, valueAxis, timeAxisNew)
    reliabAxis = exam_reliability(timeAxis, timeAxisNew, reliable_distance)
    
    result = {
        "valueAxisNew": valueAxisNew.tolist(),
        "reliabAxis": reliabAxis,
    }
    
    return result


if __name__ == "__main__":
    from pprint import pprint

    timeAxis = [datetime(2014, 1, 15, 0, 0, 0), datetime(2014, 1, 15, 0, 1, 0)]
    timeAxis = [str(i) for i in timeAxis]
    
    valueAxis = [0.0, 1.0]
    
    timeAxisNew = [datetime(2014, 1, 14, 23, 59, 55), datetime(2014, 1, 15, 0, 0, 30), datetime(2014, 1, 15, 0, 1, 5)]
    timeAxisNew = [str(i) for i in timeAxisNew]
    
    event = {"timeAxis": timeAxis, "valueAxis": valueAxis, "timeAxisNew": timeAxisNew, "reliable_distance": 10}
    pprint(event)
    pprint(main(event, None))