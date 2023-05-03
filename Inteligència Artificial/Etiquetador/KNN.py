__authors__ = ['1601181', '1601350', '1597487', '1603921']
__group__ = 'GrupZZ'


import numpy as np
import math
import operator
from scipy.spatial.distance import cdist
import utils
import statistics as stat
from collections import Counter
from Kmeans import depurate_background

class KNN:
    def __init__(self, train_data, labels,options=None,selected_labels=None):
        if options['method'] == 'grey':
            self.init_to_gray(train_data)
        else:
            self._init_train(train_data)

        self.selected = selected_labels
        self.labels = np.array(labels)
        self.options = options


        #############################################################
        ##  THIS FUNCTION CAN BE MODIFIED FROM THIS POINT, if needed
        #############################################################

    def _init_train(self, train_data):
        """
        initializes the train data
        :param train_data: PxMxNx3 matrix corresponding to P color images
        :return: assigns the train set to the matrix self.train_data shaped as PxD (P points in a D dimensional space)
        """
        train_data = train_data.astype(float)  # <-- Change to float type the information of the array
        train_data = np.reshape(train_data, (
        train_data.shape[0], train_data.shape[1] * train_data.shape[2] * 3))  # <-- Reshape the dimension os the array into a NxD (N=F*C)
        self.train_data = train_data
        #######################################################
        ##  YOU MUST REMOVE THE REST OF THE CODE OF THIS FUNCTION
        ##  AND CHANGE FOR YOUR OWN CODE
        #######################################################
    def init_to_gray(self, train_data):
        train_data = train_data.astype(float)  # <-- Change to float type the information of the array
        train_data = utils.rgb2gray(train_data)
        train_data = np.reshape(train_data, (train_data.shape[0],
            train_data.shape[1] * train_data.shape[2]))  # <-- Reshape the dimension os the array into a NxD (N=F*C)
        self.train_data = train_data



    def get_k_neighbours(self, test_data, k):
        """
        given a test_data matrix calculates de k nearest neighbours at each point (row) of test_data on self.neighbors
        :param test_data:   array that has to be shaped to a NxD matrix ( N points in a D dimensional space)
        :param k:  the number of neighbors to look at
        :return: the matrix self.neighbors is created (NxK)
                 the ij-th entry is the j-th nearest train point to the i-th test point-
        """
        test_data = test_data.astype(float)  # <-- Change to float type the information of the array
        # <-- Reshape the dimension os the array into a NxD (N=F*C)
        if self.options['method'] == 'grey':
            test_data = utils.rgb2gray(test_data)
            test_data = np.reshape(test_data, (
                test_data.shape[0], test_data.shape[1] * test_data.shape[2]))

        else:
            test_data = np.reshape(test_data, (
                test_data.shape[0], test_data.shape[1] * test_data.shape[2] * 3))

        distance_matrix = cdist(test_data,self.train_data, 'euclidean')
        sorted_min_indices = np.argsort(distance_matrix, axis=-1)[:,0:k]
        self.neighbors=self.labels[sorted_min_indices]

    def get_class(self):
        """
        Get the class by maximum voting
        :return: 2 numpy array of Nx1 elements.
                1st array For each of the rows in self.neighbors gets the most voted value
                            (i.e. the class at which that row belongs)
                2nd array For each of the rows in self.neighbors gets the % of votes for the winning class
        """
        k = self.neighbors.shape[1]
        label_results = []
        percentage = []
        for i, row in enumerate(self.neighbors):
            row = Counter(row)
            clas = [row.most_common(1)[0][0]]
            per = [row.most_common(1)[0][1] / k]
            del row[clas[0]]
            if len(row) != 0 and per[0] < 0.85:
                clas.append(row.most_common(1)[0][0])
                per.append(row.most_common(1)[0][1] / k)

            label_results.append(clas)
            percentage.append(per)

        label_results = np.asarray(label_results)
        return label_results, percentage
        """
        k = self.neighbors.shape[1]
        label_results = []
        percentage = []
        for i,row in enumerate(self.neighbors):
            label_results.append(Counter(row).most_common(1)[0][0])
            percentage.append(Counter(row).most_common(1)[0][1]/k)
        label_results = np.asarray(label_results)
        return label_results,percentage
        """

    def predict(self, test_data, k):
        """
        predicts the class at which each element in test_data belongs to
        :param test_data: array that has to be shaped to a NxD matrix ( N points in a D dimensional space)
        :param k:         :param k:  the number of neighbors to look at
        :return: the output form get_class (2 Nx1 vector, 1st the classm 2nd the  % of votes it got
        """
        self.get_k_neighbours(test_data, k)
        clases = self.get_class()
        return clases

class KNN_area:
    def __init__(self, train_data, labels):
        self.labels = np.array(labels)
        self.means = {}
        self._init_train(train_data)
        #############################################################
        ##  THIS FUNCTION CAN BE MODIFIED FROM THIS POINT, if needed
        #############################################################

    def _init_train(self, train_data):
        """
        initializes the train data
        :param train_data: PxMxNx3 matrix corresponding to P color images
        :return: assigns the train set to the matrix self.train_data shaped as PxD (P points in a D dimensional space)
        """
        train_data = train_data.astype(float)  # <-- Change to float type the information of the array
        train_data = np.reshape(train_data, (
            train_data.shape[0], train_data.shape[1] * train_data.shape[2],
            3))  # <-- Reshape the dimension os the array into a NxD (N=F*C)
        self.train_data = train_data
        self.area = np.array(self.compute_area(train_data))
        #######################################################
        ##  YOU MUST REMOVE THE REST OF THE CODE OF THIS FUNCTION
        ##  AND CHANGE FOR YOUR OWN CODE
        #######################################################

    def get_k_neighbours(self, test_data, k=1):
        """
        given a test_data matrix calculates de k nearest neighbours at each point (row) of test_data on self.neighbors
        :param test_data:   array that has to be shaped to a NxD matrix ( N points in a D dimensional space)
        :param k:  the number of neighbors to look at
        :return: the matrix self.neighbors is created (NxK)
                 the ij-th entry is the j-th nearest train point to the i-th test point-
        """
        test_data = test_data.astype(float)  # <-- Change to float type the information of the array
        test_data = np.reshape(test_data, (
            test_data.shape[0], test_data.shape[1] * test_data.shape[2],
            3))  # <-- Reshape the dimension os the array into a NxD (N=*F
        area = np.array(self.compute_area(test_data))
        self.area = np.reshape(self.area, (self.area.shape[0], 1))
        area = np.reshape(area, (area.shape[0], 1))
        distance_matrix = cdist(area, self.area, 'euclidean')
        sorted_min_indices = np.argsort(distance_matrix, axis=-1)[:, 0:k]
        self.neighbors = self.labels[sorted_min_indices]

    def compute_area(self, data):
        area = []
        for i in range(data.shape[0]):
            aux = depurate_background(data[i])
            area.append(aux.shape[0])
        return area

    def get_class(self):
        """
        Get the class by maximum voting
        :return: 2 numpy array of Nx1 elements.
                1st array For each of the rows in self.neighbors gets the most voted value
                            (i.e. the class at which that row belongs)
                2nd array For each of the rows in self.neighbors gets the % of votes for the winning class
        """
        k = self.neighbors.shape[1]
        label_results = []
        percentage = []
        for i, row in enumerate(self.neighbors):
            row = Counter(row)
            clas = [row.most_common(1)[0][0]]
            per = [row.most_common(1)[0][1] / k]
            del row[clas[0]]
            if len(row) != 0 and  0.15<row.most_common(1)[0][1] / k:
                clas.append(row.most_common(1)[0][0])
                per.append(row.most_common(1)[0][1] / k)

            label_results.append(clas)
            percentage.append(per)

        label_results = np.asarray(label_results)
        return label_results, percentage
        """
        label_results = []
        return np.array(list(self.means.keys()))[self.neighbors]
        """

    def predict(self, test_data, k):
        """
        predicts the class at which each element in test_data belongs to
        :param test_data: array that has to be shaped to a NxD matrix ( N points in a D dimensional space)
        :param k:         :param k:  the number of neighbors to look at
        :return: the output form get_class (2 Nx1 vector, 1st the classm 2nd the  % of votes it got
        """
        self.get_k_neighbours(test_data, k)
        clases,percentages = self.get_class()
        return clases,percentages

