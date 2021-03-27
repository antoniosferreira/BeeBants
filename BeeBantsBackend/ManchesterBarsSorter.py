from FirebaseSettings import *
from pyrebase import *
from Combinator import *
import json

def hamming_distance(s1, s2):
    if len(s1) != len(s2):
        print("Wrong values:" + s1 + "-" + s2)

    return sum(ch1 != ch2 for ch1,ch2 in zip(s1,s2))

def getAllBarsFromServer():
    config = getConfig()

    # Setup
    firebase = pyrebase.initialize_app(config)
    storage = firebase.storage()

    # Donwload list with all bars and algorithm specific data
    storage.child("Manchester/ManchesterBarsData.json").download("downloaded/ManchesterBarsData.json")
    print("Manchester Bars File Downloaded. Starting Algorithm")

    barsParsed = []
    with open('downloaded/ManchesterBarsData.json') as barsFile:
        barsData = json.load(barsFile)
        for bar in barsData:
            barsParsed.append(bar)

    # Updates to Array
    bars = [[row['id'], row['encodedProfile'], row['latitude'], row['longitude'],row['specifics']] for row in barsParsed]
    print(bars)
    return bars


def sortBars(encodedProfile, bars):
    bars.sort(key=lambda x: hamming_distance(encodedProfile, x[1]))
    return bars





def updateBarsProfiling():
    bars = getAllBarsFromServer()

    encodedProfiles = getBarsCombinations()

    config = getConfig()
    firebase = pyrebase.initialize_app(config)

    # STARTING PROFILING
    for encodedProfile in encodedProfiles:

        print("Start profiling of:" + encodedProfile)
        barsSorted = sortBars(encodedProfile, bars)

        # FORMATTING TEXT TO JSON
        data = "["
        for row in barsSorted:
            data = data + '{'
            data = data + '"id":"' + row[0] + '",'
            data = data + '"latitude":"' + row[2] + '",'
            data = data + '"longitude":"' + row[3] + '",'
            data = data + '"specifics":['
            for element in row[4]:
                data = data + str(element) + ","
            data = data[:-1] + "]"
            data = data + '},'
        data = data[:-1]
        data = data + "]"

        # CREATES LOCAL FILE
        # UPDATES TO THE SERVER
        filename = "barsprofiled/" + encodedProfile + ".json"
        with open(filename, 'w') as outfile:
            outfile.write(data)
            outfile.close()
            firebase.storage().child('Manchester/BarsProfiled/' + encodedProfile + '.json').put(filename)

    print("Gracefully termination")