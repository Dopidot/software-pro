import os
import time

os.environ['TF_DISABLE_MKL'] = '1'
os.environ["CUDA_VISIBLE_DEVICES"] = "-1"
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '4'

import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import numpy as np
import csv
import tensorflow.keras as keras
from sklearn.metrics import confusion_matrix


def load_fitisly_dataset():
    lines = []
    with open('dataset_v1.txt') as data_file:
        reader = csv.reader(data_file, delimiter=' ')
        for line in reader:
            if len(line) == 0:
                continue
            lines.append(line)
    dataset_inputs = np.zeros((len(lines), 3))
    dataset_expected_outputs = np.zeros((len(lines), 5))
    for i, line in enumerate(lines):
        dataset_inputs[i] = np.array([int(col) for col in line[:3]])
        if line[3] == "5dfd030820593d3c5d743dbf":
            dataset_expected_outputs[i] = np.array([1, -1, -1, -1, -1])
        elif line[3] == "5e10c1aa67eeb33f8955df3e":
            dataset_expected_outputs[i] = np.array([-1, 1, -1, -1, -1])
        elif line[3] == "5e1f22d867eeb33f8955e075":
            dataset_expected_outputs[i] = np.array([-1, -1, 1, -1, -1])
        elif line[3] == "5e202c3e67eeb33f8955e09e":
            dataset_expected_outputs[i] = np.array([-1, -1, -1, 1, -1])
        else:
            dataset_expected_outputs[i] = np.array([-1, -1, -1, -1, 1])
    print(dataset_inputs.shape)
    print(dataset_expected_outputs.shape)
    split_indexes = np.arange(len(dataset_inputs))
    np.random.shuffle(split_indexes)
    train_size = int(np.floor(len(dataset_inputs) * 0.8))
    x_train = dataset_inputs[split_indexes][:train_size]
    x_test = dataset_inputs[split_indexes][train_size:]
    y_train = dataset_expected_outputs[split_indexes][:train_size]
    y_test = dataset_expected_outputs[split_indexes][train_size:]

    return (x_train, y_train), (x_test, y_test)


def start(height, weight, age):

    inputs = np.arange(10)
    predicted_values = np.zeros(10)

    plt.scatter(inputs, predicted_values)
    #plt.show()

    (x_train, y_train), (x_test, y_test) = load_fitisly_dataset()

    epochs = 500
    alpha = 0.0001

    # Test Keras Model
    model = keras.models.Sequential()
    model.add(keras.layers.Dense(16, activation=keras.activations.tanh))
    model.add(keras.layers.Dense(5, activation=keras.activations.tanh))
    model.compile(keras.optimizers.SGD(alpha), loss=keras.losses.mean_squared_error)

    start_time = time.time()

    model.fit(x_train, y_train, validation_data=(x_test, y_test), epochs=epochs, batch_size=1, verbose=0)

    print(f'It took {time.time() - start_time} seconds to train in Keras')

    good_classified_on_train = 0
    for k in range(len(x_train)):
        if np.argmax(model.predict(np.array([x_train[k]]))) == np.argmax(y_train[k]):
            good_classified_on_train += 1

    good_classified_on_test = 0
    for k in range(len(x_test)):
        if np.argmax(model.predict(np.array([x_test[k]]))) == np.argmax(y_test[k]):
            good_classified_on_test += 1

    #print(f"Keras Accuracy on train : {good_classified_on_train / len(x_train) * 100}%")
    #print(f"Keras Accuracy on test : {good_classified_on_test / len(x_test) * 100}%")

    predicted_values_on_test = model.predict(x_test)
    predicted_values_on_test = np.argmax(predicted_values_on_test, axis=1)

    expected_values_on_test = np.argmax(y_test, axis=1)

    print(f"Confusion matrix of keras model :")
    print(confusion_matrix(expected_values_on_test, predicted_values_on_test))

    print('Parameters for prediction')
    print(np.array([[height, weight, age]]))

    print('Prediction : ')
    temp = model.predict(np.array([[height, weight, age]]))

    programs = ['5dfd030820593d3c5d743dbf', '5e10c1aa67eeb33f8955df3e', '5e1f22d867eeb33f8955e075',
                '5e202c3e67eeb33f8955e09e', '5e2083bd67eeb33f8955e0c8']
    result = programs[int(sum(temp[0]))]
    print(result)

    print(f"----------------------------------------------------------------")

    return result