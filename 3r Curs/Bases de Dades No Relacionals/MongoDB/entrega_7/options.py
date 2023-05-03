# -*- coding: utf-8 -*-
"""
    Parse input arguments
"""

import argparse

__author__ = 'Oriol Ramos Terrades'
__email__ = 'oriolrt@cvc.uab.cat'


from argparse import HelpFormatter
from operator import attrgetter

class SortingHelpFormatter(HelpFormatter):
    def add_arguments(self, actions):
        actions = sorted(actions, key=attrgetter('option_strings'))
        super(SortingHelpFormatter, self).add_arguments(actions)




class Options(argparse.ArgumentParser):

    def __init__(self):
        # MODEL SETTINGS
        super().__init__(description="This script inserts data into a scheme previously created for outlier detection experiments", formatter_class=SortingHelpFormatter)
        # Positional arguments
        super().add_argument('-f','--fileName', type=str, help='JSON File where data is stored.')


    def parse(self):
        return super().parse_args()

