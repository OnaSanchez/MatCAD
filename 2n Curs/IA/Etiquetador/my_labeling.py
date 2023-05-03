___authors__ = ['1601181', '1601350', '1597487', '1603921']
__group__ = 'GrupZZ'

import numpy as np
import Kmeans
import KNN
import utils
from utils_data import read_dataset, visualize_k_means, visualize_retrieval
import matplotlib.pyplot as plt
import matplotlib
import time
import collections
import pandas as pd
from scipy.interpolate import interp1d
from collections import Counter
from multiprocessing import Pool, freeze_support
import seaborn as sns


def labelling(imags):
    """
    Funcion de etiquetaje, hace un KNN para identificar la forma y un KMeans para evaluar los colores de la imagen.
    Args:
        imags: Imagenes a etiquetar

    Returns: Shape, Colors, %Shape, %Colors
    """
    #Inicializador KNN
    dict = {'method':'grey'}
    knn = KNN.KNN(train_imgs, train_class_labels,dict)
    #Resultados KNN
    knn_shape, percentage_shape = knn.predict(imags, 11)

    opt = {'km_init': 'distance', 'fitting': 'WCD', 'selection': 'random'}
    np.random.seed(int(time.time()))

    kmins = Kmeans.KMeans(imags[0], 1, opt)

    kmeans_colors = []
    proportions_colors = []
    for i in imags:
        kmins.set_X_random(i, 0.15)
        kmins.find_bestK(15)
        cen = kmins.centroids

        lista, proportions = Kmeans.join_colors(Kmeans.get_colors(cen), kmins.proportion)
        lista, proportions = Kmeans.depurate_person(lista, proportions)
        lista, proportions = Kmeans.relevant_colors(lista, proportions)

        kmeans_colors.append(lista)
        proportions_colors.append(proportions)

    return knn_shape, percentage_shape, kmeans_colors, proportions_colors

def retrieval_by_color(kmeans_colors, proportions_colors, imag, question):
    """
    Args:
        kmeans_colors: Lista que contiene los colores de cada imagen
        proportions_colors: Lista que contiene los porcentajes de colores de cada imagenes
        imag: Las imagenes
        question: String que contiene la pregunta, los colores que se quieren mostrar

    Output: Muestra por pantalla todas las piezas de ropa que contienen los colores pedidos
    """
    im_to_show = []
    percentage_color = []
    number_images = 0
    question = np.asarray(question)
    for i, colors in enumerate(kmeans_colors):

        colors = list(colors)
        #Matriz que marca con True los colores pedidos que aparecen en cada pieza
        true_matrix = np.isin(question, colors)

        #Comprueba que todos hayan sido marcados con True (significa que tiene todos los colores)
        if np.all(true_matrix == True):
            number_images += 1
            #Calcula el porcentaje de los colores pedidos en la pieza de ropa
            percentage = np.sum(proportions_colors[i], where=np.isin(colors, question))
            im_to_show.append(imag[i])
            percentage_color.append(percentage)
    #Ordena segun el que tenga mayor porcentaje de color
    index_with_colors = np.argsort(percentage_color)[::-1]
    im_to_show = np.asarray(im_to_show)
    visualize_retrieval(im_to_show[index_with_colors], number_images)

def bestk_statistics(imags, fact=1):
    """
    Evalua con cada heurística como evoluciona el tiempo, la k y el valor de la heurística según el umbral
    preestablecido (el porcentaje con el que se decide no seguir mirando)

    Args:
        imags: Imagenes a evaluar
        fact: Factor con el que avanza el porcentaje

    Returns: Gráficas de tiempo, del valor de la heurística y de la k

    """
    heuristics_list = ['WCD', 'ICD', 'DF']
    fig, ax = plt.subplots(3, 3, sharey=True)
    kmins = Kmeans.KMeans(imags, 2)
    for k, j in enumerate(heuristics_list): #multiprocessing
        #Hace un KMeans con cada heurística
        opt = {'km_init': 'distance', 'fitting': j,'selection':'random'}
        kmins._init_options(opt)
        percentage = []
        tim = []
        if j == "ICD":
            red = 20 ** 4
            lab = "10^11"
        else:
            red = 100
            lab = "100"
        dist = []
        K = []
        for i in range(0, 11 * fact):
            #Se guarda los valores de tiempo, heurística y k según el umbral usado
            percentage.append(i / (10 * fact))
            kmins.p = i / (10 * fact)
            inicio = time.time()
            kmins.find_bestK(13)
            fin = time.time()
            K.append(kmins.K)
            dist.append(kmins.val / red)
            tim.append(round(fin - inicio))
        #Creacion de la grafica
        ax[k][0].set_xlabel('p')
        ax[k][0].set_ylabel('temps')
        ax[k][0].plot(percentage, tim)
        ax[k][1].set_xlabel('percentatge')
        ax[k][1].set_ylabel(kmins.options['fitting'] + "( /" + lab + ")")
        ax[k][1].plot(percentage, dist)
        ax[k][2].set_xlabel('percentatge')
        ax[k][2].set_ylabel('k')
        ax[k][2].plot(percentage, K)
    plt.savefig('best_k.png')

def kmean_statistics(k_max, imags, options):
    """
    Funcion para ver la eficiencia en iteraciones y en tiempo según el valor de K en el KMeans a partir de gráficas
    generadas.
    Args:
        k_max: K maxima a evaluar
        imags: Imágenes
        options: Diccionario de opciones del KMeans

    Output: Grafica lineal de tiempo, boxplot de iteraciones y gráfico de barras

    """

    def autolabel(rects):
        """Funcion para agregar una etiqueta con el valor en cada barra"""
        for rect in rects:
            height = rect.get_height()
            ax.annotate('{}'.format(height),
                        xy=(rect.get_x() + rect.get_width() / 2, height),
                        xytext=(0, 3),  # 3 points vertical offset
                        textcoords="offset points",
                        ha='center', va='bottom')

    num_imags = len(imags)
    #Inicializacion listas donde guardar los resultados obtenidos segun cada K
    k = [i for i in range(2, k_max + 1)]
    iter_k = [0 for i in range(2, k_max + 1)]
    time_k = [0 for i in range(2, k_max + 1)]
    heuristic_k = [0 for i in range(2, k_max + 1)]
    iter_k_b = [[] for i in range(2, k_max + 1)]

    kmins = Kmeans.KMeans(imags[0], 2, options)

    for j in imags:
        kmins.set_X_random(j,0.15)

        for i in k:
            kmins.K = i
            inicio = time.time()
            kmins.fit()
            fin = time.time()
            iter_k[i - 2] += kmins.num_iter
            time_k[i - 2] += (fin - inicio) * 1000

            heuristic_k[i - 2] += kmins.calcDistance()
            iter_k_b[i - 2].append(kmins.num_iter)

    for i, j in enumerate(iter_k):
        iter_k[i] = round(j / num_imags)
    for i, j in enumerate(time_k):
        time_k[i] = round(j / num_imags)
    for i, j in enumerate(heuristic_k):
        if kmins.options['fitting'] == 'ICD':
            heuristic_k[i] = round(j / (num_imags*100))
        elif kmins.options['fitting'] == 'FD':
            heuristic_k[i] = round(j / num_imags * 10000)
        else:
            heuristic_k[i] = round(j / num_imags)
    fig, ax = plt.subplots()

    # Obtenemos la posicion de cada etiqueta en el eje de X
    x = np.arange(len(k))
    # tamaño de cada barra
    width = 0.3
    rects1 = ax.bar(x - width, iter_k, width, label='iteracions')
    rects2 = ax.bar(x, time_k, width, label='temps (ms)')
    rects3 = ax.bar(x + width, heuristic_k, width, label=kmins.options['fitting'])

    # Añadimos las etiquetas de identificacion de valores en el grafico
    ax.set_ylabel('')
    ax.set_title('')
    ax.set_xticks(x)
    ax.set_xticklabels(k)
    # Añadimos un legen() esto permite mmostrar con colores a que pertence cada valor.
    ax.legend()

    # Añadimos las etiquetas para cada barra
    autolabel(rects1)
    autolabel(rects2)
    autolabel(rects3)
    fig.tight_layout()
    plt.savefig('barras.png')
    # Mostramos la grafica con el metodo show()
    # plt.show()

    ###################################
    plt.clf()

    f = interp1d(k, time_k)
    f2 = interp1d(k, time_k, kind='cubic')
    x_new = np.linspace(k[0], k[-1], 1000, True)

    plt.plot(k, time_k, 'o', x_new, f(x_new), '-', x_new, f2(x_new), '--')
    plt.xlabel('K')
    plt.ylabel('Temps (ms)')
    plt.legend(["temps registrat", "funció lineal", "funció aproximadora"])
    plt.savefig('temps.png')

    ###################################
    plt.clf()

    plt.boxplot(iter_k_b)
    plt.xlabel('K')
    plt.ylabel('iteracions')
    plt.xticks([i for i in range(1, k_max)], k, fontsize=10)
    plt.legend()
    plt.savefig('iter.png')
    # plt.show()

def retrieval_by_shape(knn_shape, percentage_shape, imags, question):
    """
    Muestra por pantalla todas las piezas de ropa etiquetadas con esa forma, y segun el porcentaje de votos
    Args:
        knn_shape: Lista de formas de las piezas
        percentage_shape: Porcentaje de la forma
        imags: Imagenes
        question: String que contiene la forma ha ser mostrada

    Output: Muestra por pantalla las piezas de ropa con esa forma
    """
    imag_to_show = []
    perc_shape = []
    number_images = 0
    for i, j in enumerate(knn_shape):
        #Comprueva si la imagen tiene la forma deseada
        if question in j:
            number_images += 1
            perc_shape.append(np.sum(percentage_shape[i], where=np.isin(j, question)))
            imag_to_show.append(imags[i])
    #Ordena segun el porcentaje de cada imagen
    index_with_percentage = np.argsort(perc_shape)[::-1]
    imag_to_show = np.asarray(imag_to_show)
    visualize_retrieval(imag_to_show[index_with_percentage], number_images)

def retrieval_combined(imags, knn_shape, kmeans_color, percentage_color, question_shape, question_color):
    """
    Combina el retrieval_by_colors y el retrieval_by_shape
    Args:
        imags: Imagenes
        knn_shape: Forma de cada imagen
        kmeans_color: Colores de cada imagen
        percentage_color: Porcentaje de cada color en cada imagen
        question_shape: String que contiene la forma ha ser mostrada
        question_color: String que contiene los colores a mostrar

    Output: Usando la funcion retrieval_by_colors, devuelve las imagenes con la forma y los colores deseados segun el
    porcentaje de color

    """
    imag_to_show = []
    colors = []
    proportion = []
    n = 0
    for k, i in enumerate(knn_shape):
        if question_shape in i:
            n += 1
            imag_to_show.append(imags[k])
            colors.append(kmeans_color[k])
            proportion.append(percentage_color[k])  # Hacerlo con indices automatico
    retrieval_by_color(colors,proportion, imag_to_show, question_color)

def get_shape_accuracy(knn_shape, true_label):
    """
        Calcula que tan bien ha etiquetado el knn

        Args:
            knn_shape: Forma de cada imagen
            true_label: Ground Truth de la forma de cada imagen

        Returns: Accuracy de laS formas

        """
    lab1 = []
    lab2 = []

    for i in knn_shape:
        lab1.append(i[0])
        if len(i) > 1:
            lab2.append(i[1])
        else:
            lab2.append("")

    label_shape1 = np.asarray(lab1)
    label_shape2 = np.asarray(lab2)
    true_label = np.asarray(true_label)

    true_matrix1 = label_shape1 == true_label
    true_matrix2 = label_shape2 == true_label

    correct1 = np.count_nonzero(true_matrix1)
    correct2 = np.count_nonzero(true_matrix2)
    #for i,j in zip(label_knn, true_label):
     #   if i in j:
      #      prop+=1

    return (correct1/len(true_label), correct2/len(true_label), (correct1+correct2)/len(true_label))

def get_color_accuracy(kmeans_colors, true_label):
    """
    Calcula que tan bien ha etiquetado el kmeans

    Args:
        kmeans_colors: Colores de cada imagen
        true_label: Ground Truth de los colores de cada imagen

    Returns: Accuracy de los colores

    """
    #Matriz penalizacion segun la "distancia" en el error del color
    p_color = pd.read_csv("matriz_penalizacion_colores.csv", index_col=0)
    prop = []
    aux_k = []
    for i in kmeans_colors:
        aux_k.append(list(set(i)))
    for i, j in zip(aux_k, true_label):
        true_matrix = np.isin(j, i)
        cont = np.count_nonzero(true_matrix) / len(true_matrix)
        for k,color in enumerate(j):
            if not true_matrix[k]:
                aux_list = []
                for w in i:
                    aux_list.append(p_color[color][w])
                cont += max(aux_list)/len(true_matrix)
        prop.append(cont)
    all_correct = 0
    one_correct = 0
    penalization_correct = 0
    num_colors_correct = 0
    lista = np.asarray(kmeans_colors)
    for i in range(lista.shape[0]):
        true_matrix = np.isin(true_label[i],lista[i])
        all_correct += np.count_nonzero(true_matrix)/len(true_matrix)
        if (np.count_nonzero(true_matrix)/len(true_matrix) != 0):
            one_correct += 1
        penalization_correct += np.count_nonzero(true_matrix)/(len(lista[i])+len(true_matrix)-np.count_nonzero(true_matrix))
        if (len(true_label[i])==len(lista[i])):
            num_colors_correct +=1

    prop = np.asarray(prop)
    prop = np.sum(prop) / len(prop)

    return prop,all_correct/lista.shape[0],one_correct/lista.shape[0],penalization_correct/lista.shape[0], num_colors_correct/lista.shape[0]

def KFolds_CrossValidationsKNN(train_imgs, train_class_labels,opt):
    """
    Hace un CrossValidation del KNN. Inicializa K KNNs
    Args:
        train_imgs: Imagenes de entrenamiento para el KNN
        train_class_labels: Etiquetas de las imagenes de entrenamiento
        percentage_dataset: Porcentaje de dataset usado en cada KNN

    Returns: Lista con K KNN inicializados

    """
    knn_list = []
    #Numero de imagenes a escoger
    division = int(train_imgs.shape[0]/4)
    np.random.seed(int())
    indices = list(np.random.choice(train_imgs.shape[0], train_imgs.shape[0], replace=False))
    folds_indices = [[[indices[0:3 * division]],[indices[3*division:train_imgs.shape[0]]]],
                     [[indices[division:train_imgs.shape[0]]], [indices[0:division]]],
                     [[indices[0:division],indices[division*2:train_imgs.shape[0]]],[indices[division:division*2]]],
                     [[indices[0:2*division], indices[division * 3:train_imgs.shape[0]]],
                      [indices[division*2:division * 3]]]]
        #,indices[division:division*2],indices[division*2:division*3],indices[division*3:len(train_imgs)]]
    for i in folds_indices:
        #Eleccion aleatoria de las imagenes con replacement
        knn = KNN.KNN(train_imgs[i[0][0]], train_class_labels[i[0][0]],opt)
        knn_list.append((knn,i[1][0]))
    return knn_list

def predict_cross_validation(train_imgs, train_class_labels,options, k1,k2):
    """
    Llama a CrossValidationKNN, y con cada KNN devuelto hace predict de las imagenes de test
    Args:
        test_imgs: Imagenes de test para el KNN
        train_imgs: Imagenes de entrenamiento para el KNN
        train_class_labels: Etiquetas de las imagenes de entrenamiento
        porcentaje_dataset: Porcentaje de dataset usado en cada KNN
        k: Numero de KNN a inicializar

    Returns: Array con los predicts de cada KNN

    """
    #Lista que contiene los KNN
    lista = KFolds_CrossValidationsKNN(train_imgs, train_class_labels,options)
    predicciones = []
    for i in range(k1,k2+1):
        accuracies = []
        suma_accuracy = 0
        for j in lista:
            pred,percentages = j[0].predict(train_imgs[j[1]],i)
            accuracy = get_shape_accuracy(pred,train_class_labels[j[1]])
            suma_accuracy += accuracy[2]
            accuracies.append(accuracy[2])
        media = suma_accuracy/4
        std_error = 0
        for ac in accuracies:
            std_error += (ac-media)**2
        std_error = (std_error/4)**0.5
        predicciones.append((i,(media - std_error*1.96,media + std_error*1.96)))

    #Escogemos la prediccion mas comun entre todos los KNN

    return predicciones

def kStatisticsKnn(list_accuracy):
    """
    Comprueba con cual K se obitenen mejores resultados generando un grafico
    Args:
        list_accuracy: Lista con las accuracy de cada K

    Out: Grafico con el accuracy de cada K

    """
    k = [i for i in range(1,len(list_accuracy)+1)]
    plt.plot(k, list_accuracy)
    plt.ylabel("accuracy")
    plt.xlabel("number of clusters")
    plt.savefig('knn_k.png')

def MultiCross():
    """

    Genera los threads para hacer MultiProcessing para el CrossValidation del KNN, y los hace

    """
    with Pool(6) as p:
        dicc = {'method': 'grey'}

        print(p.starmap(predict_cross_validation,
                        [(train_imgs, train_class_labels, dicc, 1,4), (train_imgs, train_class_labels, dicc, 5,8),
                         (train_imgs, train_class_labels, dicc, 9,12), (train_imgs, train_class_labels, dicc, 13,16),
                         (train_imgs, train_class_labels, dicc, 17,20),(train_imgs, train_class_labels, dicc, 21,24)]
                        ))

def hot_color(kmeans_colors,true_colors,color1,color2):
    """
    Funcion que sirve para ver cuantas veces el KMeans ha etiquetado con un color cuando se esperaba otro, calcula
    la confusión del KMeans entre dos colores.

    Args:
        kmeans_colors: Etiquetas de colores del KMeans
        true_colors: GT de las etiquetas de colores
        color1: Color etiquetado
        color2: Color esperado (del GT)

    Returns: Devuele el porcentaje de las veces que aparece el color etiquetado cuando en el GT aparece el color esperado
             y no ha sido etiquetado correctamente.

    """
    contador_tot = 0
    contador_true = 0
    contador_resta = 0
    for colores,true_colores in zip(kmeans_colors,true_colors):
        if (color2 in true_colores):
            contador_tot += 1
            if color1 == color2:
                if color1 in colores:
                    contador_true +=1
            else:
                if color2 in colores:
                    contador_resta+=1
                if (color1 in colores):
                    if color2 in colores:
                        continue
                    else:
                        contador_true +=1
    return(contador_true/(contador_tot-contador_resta))

def generate_heatmap(kmeans_colors, true_labels):
    """
    Usando la funcion hot_color, crea un mapa de calor, un símil a la Confusion Matrix, para ver la relacion entre los
    colores etiquetados y los colores esperados
    Args:
        kmeans_colors: Etiquetas de colores del KMeans
        true_colors: GT de las etiquetas de colores

    Output: Muestra por pantalla el mapa de calor

    """
    colores = ["Black", "White", "Red", "Blue", "Green", "Brown", "Yellow", "Pink", "Purple", "Grey", "Orange"]
    mapa_calor = np.empty((11, 11))
    for i, color1 in enumerate(colores):
        for j, color2 in enumerate(colores):
            mapa_calor[i][j] = hot_color(kmeans_colors, true_labels, color1, color2) * 100

    df = pd.DataFrame(mapa_calor,
                      columns=["Black", "White", "Red", "Blue", "Green", "Brown", "Yellow", "Pink", "Purple",
                               "Grey", "Orange"],
                      index=["Black", "White", "Red", "Blue", "Green", "Brown", "Yellow", "Pink", "Purple", "Grey",
                             "Orange"])
    colormap = sns.color_palette("Reds")
    ax1 = sns.heatmap(df, cmap=colormap)
    plt.show()


if __name__ == '__main__':
    # Load all the images and GT
    train_imgs, train_class_labels, train_color_labels, \
    test_imgs, test_class_labels, test_color_labels = read_dataset(ROOT_FOLDER='./images/', gt_json='./images/gt.json')
    # List with all the existant classes
    classes = list(set(list(train_class_labels) + list(test_class_labels)))
    ########################################################################################################################
# EXERCICI QUALITATIU 1
    """
    opt = {'km_init': 'distance', 'fitting': 'WCD', 'selection': 'random'}
    np.random.seed(int(time.time()))

    kmins = Kmeans.KMeans(test_imgs[0], 1, opt)

    kmeans_colors = []
    proportions_colors = []
    for i in test_imgs:
        kmins.set_X_random(i, 0.15)
        kmins.find_bestK(15)
        cen = kmins.centroids

        lista, proportions = Kmeans.join_colors(Kmeans.get_colors(cen), kmins.proportion)
        lista, proportions = Kmeans.depurate_person(lista, proportions)
        lista, proportions = Kmeans.relevant_colors(lista, proportions)

        kmeans_colors.append(lista)
        proportions_colors.append(proportions)

    kmeans_colors = np.asarray(kmeans_colors)
    proportions_colors = np.asarray(proportions_colors)
    retrieval_by_color(kmeans_colors,proportions_colors, test_imgs, ['White'])

    ########################################################################################################################
# MAPA DE CALOR

    generate_heatmap(kmeans_colors, test_color_labels)


    """
    ########################################################################################################################
# EXERCICI QUALITATIU 2
    """
    opt = {'method': 'grey'}
    knn = KNN.KNN(train_imgs, train_class_labels, opt)
    k_shape,percentage_shape = knn.predict(test_imgs, 11)
    retrieval_by_shape(k_shape,percentage_shape, test_imgs, 'Jeans')
    """
########################################################################################################################
# EXERCICI QUALITATIU 3
    """
    question_shape = "Shorts"
    question_color = ["Green"]
    k_shape, percentage_shape, k_color, percentage_color = labelling(test_imgs)
    retrieval_combined(test_imgs, k_shape, k_color, percentage_color, question_shape, question_color)
    """
########################################################################################################################
    """
# EXERCICI QUANTITATIU 1
    opt = {'km_init': 'distance', 'fitting': 'WCD','selection':'random'}
    kmean_statistics(13, train_imgs,opt)
    """

########################################################################################################################
    """
# EXERCICI QUANTITATIU 2
    opt = {'method':'grey'}
    knn = KNN.KNN(train_imgs, train_class_labels,opt)
    k_shape,percentages = knn.predict(test_imgs, 11)

    prop = get_shape_accuracy(k_shape, test_class_labels)
    print(prop)
    

########################################################################################################################
# EXERCICI QUANTITATIU 3
    
    opt = {'km_init': 'distance', 'fitting': 'WCD', 'selection': 'random'}
    np.random.seed(int(time.time()))

    kmins = Kmeans.KMeans(test_imgs[0], 1, opt)

    kmeans_colors = []
    proportions_colors = []
    for i in test_imgs:
        kmins.set_X_random(i, 0.15)
        kmins.find_bestK(15)
        cen = kmins.centroids

        lista, proportions = Kmeans.join_colors(Kmeans.get_colors(cen), kmins.proportion)
        lista, proportions = Kmeans.depurate_person(lista, proportions)
        lista, proportions = Kmeans.relevant_colors(lista, proportions)

        kmeans_colors.append(lista)
        proportions_colors.append(proportions)

    prop, prop_all, prop_one, prop_penalization, prop_num_colors = get_color_accuracy(kmeans_colors, test_color_labels)
    prop = np.asarray(prop)
    print("Intuició:",prop)
    print("Colores Correctos:", prop_all)
    print("1 Color Correcto por pieza:", prop_one)
    print("Penalizacion de colores erroneos:", prop_penalization)
    print("Numero de colors correcte:", prop_num_colors)
    
    """

########################################################################################################################
# EXERCICI CROSSVALIDATION
    """
    #Ejemplo Multiprocessing
    freeze_support()
    MultiCross()
    #Millor K = 11
    dicc = {'method': 'grey'}
    KNN_k_cross = KNN.KNN(train_imgs,train_class_labels,dicc)
    k_shape, k_percentage = KNN_k_cross.predict(test_imgs,11)
    prop = get_shape_accuracy(k_shape, test_class_labels)
    print(prop)
    """

########################################################################################################################
# EXERCICI AREA
    """
    options ={'method':'default'}
    knn_area = KNN.KNN_area(train_imgs,train_class_labels)
    
    
    k_shape, kpercentage = knn_area.predict(test_imgs, 15)
    prop = get_shape_accuracy(k_shape, test_class_labels)
    print(prop)
    """
########################################################################################################################

# EXERCICI BEST_K
    """
    #S'hauria de fer un for per veure com va amb cada imatge
    bestk_statistics(train_imgs[0],1) #millor llindar
    """