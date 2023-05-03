___authors__ = ['1601181', '1601350', '1597487', '1603921']
__group__ = 'GrupZZ'

import xmlrpc.server
import numpy as np
import math
import utils
import time
from scipy.spatial.distance import cdist
from scipy.spatial import distance_matrix
from collections import Counter



class KMeans():

    def __init__(self, X=None, K=None, options=None):
        """
         Constructor of KMeans class
             Args:
                 K (int): Number of cluster
                 options (dict): dictÂºionary with options
            """
        np.random.seed(int(time.time()))
        self.num_iter = 0
        self.K = K
        self.p = 0.2
        if type(X) != None:
            self._init_X(X)
        self._init_options(options)  # DICT options


    #############################################################
    ##  THIS FUNCTION CAN BE MODIFIED FROM THIS POINT, if needed
    #############################################################

    def _init_X(self, X):
        """Initialization of all pixels, sets X as an array of data in vector form (PxD)
            Args:
                X (list or np.array): list(matrix) of all pixel values
                    if matrix has more than 2 dimensions, the dimensionality of the smaple space is the length of
                    the last dimension
        """
        self.set_X(X)

    def set_X(self, X):
        X = X.astype(float)  # <-- Change to float type the information of the array

        if len(X.shape) != 2:  # <-- Check the dimension
            X = np.reshape(X, (
                X.shape[0] * X.shape[1], X.shape[2]))  # <-- Reshape the dimension os the array into a NxD (N=F*C)

        self.X = np.asarray(X)  # <-- Change to a matrix the array and safe it
        self.X = depurate_background(self.X)


    def set_X_random(self, X,fact=0.1):
        """
        Coge aleatoriamente pixeles de la imagen, ya que los pixeles están distribuidos de manera uniforme
        Args:
            X: Matriz de la imagen
            fact: Porcentaje de la matriz a coger

        """
        X = np.reshape(X, (
            X.shape[0] * X.shape[1], X.shape[2]))
        self.X = np.asarray(X)
        self.X = depurate_background(self.X)
        i = np.random.choice(self.X.shape[0], int(self.X.shape[0]*fact)
                             , replace=False)
        self.X = self.X[i]


    def _init_options(self, options=None):
        """
        Initialization of options in case some fields are left undefined
        Args:
            options (dict): dictionary with options
        """
        if options == None:
            options = {}
        if not 'km_init' in options:
            options['km_init'] = 'first'
        if not 'verbose' in options:
            options['verbose'] = False
        if not 'tolerance' in options:
            options['tolerance'] = 0
        if not 'max_iter' in options:
            options['max_iter'] = np.inf
        if not 'fitting' in options:
            options['fitting'] = 'WCD'  # within class distance.

        # If your methods need any other prameter you can add it to the options dictionary
        self.options = options

        #############################################################
        ##  THIS FUNCTION CAN BE MODIFIED FROM THIS POINT, if needed
        #############################################################

    def _init_centroids(self):
        """
        Initialization of centroids
        """
        if self.options['km_init'].lower() == 'first':
            lista = np.unique(self.X, axis = 0)
            self.old_centroids = lista[:self.K]

        elif self.options['km_init'].lower() == 'random':
            Set = np.random.randint(255, size=(self.K, self.X.shape[1]))
            self.old_centroids = np.asarray(Set).astype(float)

        elif self.options['km_init'].lower() == 'otro':
            lista = []
            R = 127.5
            a = 2*math.pi/self.K
            for i in range(self.K):
                lista.append([R, R*math.cos(i*a), R*math.sin(i*a)])

            self.old_centroids = np.asarray(lista).astype(float)
        elif self.options['km_init'].lower() == 'colors':
            colors = np.array([[255,0,0], [255,140,0],
                              [139,69,19], [255,255,0], [0,255,0], [0,0,255], [128,0,128], [255,192,203],
                               [0,0,0], [128,128,128], [255,255,255]])
            indices = np.random.choice(len(colors), self.K, replace=False)
            self.old_centroids = colors[indices]
        elif self.options['km_init'].lower() == 'distance':
            self.old_centroids = np.empty((self.K,3), dtype=float)
            l = 1
            self.old_centroids[0] = self.X[np.random.randint(self.X.shape[0])]
            for c_id in range(self.K-1):
                distancias = cdist(self.X,self.old_centroids[:l])
                min = distancias.min(axis=1)
                self.old_centroids[l] = self.X[np.argmax(min)]
                l+=1
        self.centroids = self.old_centroids

        self.centroids = self.old_centroids

    def get_labels(self):
        """        Calculates the closest centroid of all points in X
        and assigns each point to the closest centroid
        """
        info = distance(self.X, self.centroids)
        self.labels = info.argmin(axis=1)

    def lower_bound(self):
        if self.options['selection'] == 'random':
            random_pixels = self.X[np.random.choice(self.X.shape[0],int(self.X.shape[0]*0.1),replace=False)]
            lista_colores = get_colors(np.unique(random_pixels,axis=0))

            self.K = len(set(lista_colores))
        elif self.options['selection'] == 'canvas':
            lista_pixeles = []
            for i in range(0,self.X.shape[0],50):
                lista_pixeles.append(self.X[i])
            lista_pixeles = np.asarray(lista_pixeles)
            lista_colores  = get_colors(np.unique(lista_pixeles, axis=0))
            self.K = len(set(lista_colores))

        else:
            self.K = 2
    def get_centroids(self):
        """
        Calculates coordinates of centroids based on the coordinates of all the points assigned to the centroid
        """
        self.old_centroids = self.centroids
        n = np.ones(self.K)
        lista = np.ones((self.K,3), dtype = float)
        for i,point in enumerate(self.X):
            n[self.labels[i]]+=1
            lista[self.labels[i]] += point
        self.proportion = list(n/self.X.shape[0])
        lista = lista/n[:,None]
        self.centroids = lista

    def converges(self):
        """
        Checks if there is a difference between current and old centroids
        """
        return (self.centroids == self.old_centroids).all()

    def fit(self):
        """
        Runs K-Means algorithm until it converges or until the number
        of iterations is smaller than the maximum number of iterations.
        """
        self.num_iter = 0
        self._init_centroids()
        self.get_labels()
        while self.num_iter < self.options['max_iter']:
            self.get_labels()
            self.get_centroids()
            self.num_iter += 1
            if self.converges():
                break


    def whitinClassDistance(self):
        """
         returns the whithin class distance of the current clustering

        """
        info = distance(self.X, self.centroids)
        info = np.power(info,2)
        suma = np.sum(np.amin(info,axis=1))
        self.dist =  suma/ self.X.shape[0]

    def interClassDistance(self):
        """
         returns the whithin class distance of the current clustering

        """
        info = distance(self.X, self.X)
        total = 0
        for i in range(len(self.centroids)):
            for j in range(len(self.centroids)):
                if j!=i:
                    index1= np.argwhere(self.labels == i)
                    index1 = [i for sublist in index1 for i in sublist]
                    index2= np.argwhere(self.labels == j)
                    index2 = [i for sublist in index2 for i in sublist]
                    matrix = info[index1]
                    matrix = matrix[:,index2]
                    if matrix.shape[0]!=0 and matrix.shape[1]!=0:
                        total += np.sum(matrix)/(matrix.shape[0]+matrix.shape[1])
        self.dist = total/2

        """
        info = distance(self.X, self.centroids)
        info = np.power(info,2)
        suma = np.sum(info) - np.sum(np.amin(info,axis=1))
        #min_matrix -= np.sum(aux, axis = 0)
        self.dist = suma / self.X.shape[0]
        """
    def fisherDistance(self):
        self.whitinClassDistance()
        numerador = self.dist
        self.interClassDistance()
        denominador = self.dist
        self.dist = numerador/denominador

    def calcDistance(self):
        if self.options['fitting'] == 'FD':
            self.fisherDistance()
            return np.sum(self.dist)
        elif self.options['fitting'] == 'ICD':
            self.interClassDistance()
            return np.sum(self.dist)
        else:
            self.whitinClassDistance()
            return np.sum(self.dist)

    def conditionsBestK(self,val,ant):
        if self.options['fitting'] == 'FD':
            return (1 - val/ant < self.p)
        elif self.options['fitting'] == 'ICD':
            return (1- ant/val > self.p)
        else:
            return (1-val/ant < self.p)

    def find_bestK(self, max_K):
        """
         sets the best k anlysing the results up to 'max_K' clusters
        """
        self.lower_bound()
        self.fit()
        self.calcDistance()

        ant = self.dist
        for i in range(self.K+1,max_K+1):
            self.K = i
            self.fit()
            self.calcDistance()
            val = self.dist
            if self.conditionsBestK(val, ant):
                break
            ant = val
        self.K -= 1
        self.val = val

def distance(X, C):
    """
    Calculates the distance between each pixel and each centroid
    Args:
        X (numpy array): PxD 1st set of data points (usually data points)
        C (numpy array): KxD 2nd set of data points (usually cluster centroids points)

    Returns:
        dist: PxK numpy array position ij is the distance between the
        i-th point of the first set an the j-th point of the second set
    """
    return cdist(X,C)


def get_colors(centroids):
    """
    for each row of the numpy matrix 'centroids' returns the color laber folllowing the 11 basic colors as a LIST
    Args:
        centroids (numpy array): KxD 1st set of data points (usually centroind points)

    Returns:
        lables: list of K labels corresponding to one of the 11 basic colors
    """

    color = utils.get_color_prob(centroids)
    lista = []
    for p in color:
        lista.append( utils.colors[np.argmax(p)] )
    return lista

def depurate_background(data):
    aux = utils.rgb2gray(data)
    esquinas = [aux[0], aux[59], aux[4739], aux[-1]]
    m = Counter(esquinas).most_common(1)[0][0]
    index = [i for i, j in enumerate(aux) if (j < (m - 14)) or (j> (m+14))]
    return data[index]

def depurate_person(colors_list,proportions):
    colors_list = list(colors_list)
    for i,color in enumerate(colors_list):
        if color == "Orange" and proportions[i]<0.40 and proportions[i]>0.1:
            colors_list.pop(i)
            proportions.pop(i)
            break
    return colors_list,proportions


def join_colors(colors_list,proportions):
    new_proportions = []
    for i in set(colors_list):
        suma = 0
        for j, k in enumerate(colors_list):
            if i == k:
                suma += proportions[j]
        new_proportions.append(suma)
    colors_list = set(colors_list)
    return colors_list,new_proportions

def relevant_colors(colors_list,proportions):

    maxim=max(proportions)
    colors_list = [x for i,x in enumerate(colors_list) if proportions[i]/maxim > 0.35]
    proportions = [i for i in proportions if i/maxim >0.35]
    return colors_list,proportions

"""
    z = [x for _,x in sorted(zip(proportions,colors_list),reverse=True)]
    print(z)
    print(sorted(proportions,reverse=True))"""
