#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import json
import random

def explain(bowl):
    """赌骰子秘籍: http://blog.sina.com.cn/s/blog_4c8894390101384t.html

    baozi: x24
    4/17: x50
    5/16: x18
    6/15: x14
    7/14: x12
    8/13: x8
    9/10/11/12: x6
    big/small: x1
    1-/2-/3-/4-/5-/6-: x1
    """
    terms = list()
    if bowl[0] == bowl[1] == bowl[2]:
        is_baozi = True
        terms.append("baozi")
    else:
        is_baozi = False
    
    if not is_baozi:
        total = sum(bowl)
        terms.append(str(total))
        
        if total >= 11:
            terms.append("big")
        else:
            terms.append("small")
        
        for i in range(1, 1+6):
            if i in bowl:
                terms.append("%s-" % i)
    
    return terms
    
def main(event, context):
    """
    """
    odds = {
        "baozi": 24,
        "4": 50, "17": 50,
        "5": 18, "16": 18,
        "6": 14, "15": 14,
        "7": 12, "14": 12,
        "8": 8, "13": 8,
        "9": 6, "10": 6, "11": 6, "12": 6,
        "big": 1, "small": 1,
        "1-": 1, "2-": 1, "3-": 1, "4-": 1, "5-": 1, "6-": 1, 
    }
    
    bowl = [random.randint(1, 6) for i in range(3)]
    terms = explain(bowl)

    total_price = 0
    total_bet = 0
    for term, bet in event.items():
        total_bet += bet
        if term in terms:
            total_price += bet * (odds.get(term, -1) + 1)
    
    res = {
        "your guess": event,
        "your bet": total_bet,
        "your price": total_price,
        "bowl": bowl,
        "terms": terms,
    }
    
    return res
    
if __name__ == "__main__":
    from pprint import pprint
    
    def test_explain():
        from itertools import combinations_with_replacement
    
        for i in combinations_with_replacement(range(1, 7), 3):
            terms = explain(i)
            print(i, terms)
    
    test_explain()
    
    event = {"big": 100, "11": 20, "12": 20}
    res = main(event, None)
    pprint(res)