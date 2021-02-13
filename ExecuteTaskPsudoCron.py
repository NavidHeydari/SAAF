# -*- coding: utf-8 -*-
"""
Created on Thu Feb 11 21:36:35 2021

@author: Navid Heydari
"""

from time import time, sleep
from datetime import datetime
import os


def things_to_do():
    
    interval_to_sec = 1 * 60
    while True:
        sleep(interval_to_sec - time() %  60 )
        print(str(datetime.now()))
		os.system("date")
        
    print('finished')


if __name__=="__main__": 
    things_to_do()
    
    