from FirebaseSettings import *
from pyrebase import *
from Combinator import *
import json

def hamming_distance(s1, s2):
    if len(s1) != len(s2):
        print("Wrong values:" + s1 + "-" + s2)

    return sum(ch1 != ch2 for ch1,ch2 in zip(s1,s2))


def validateRestaurants(profile, restaurantProfile):
    if (profile[1] == '1') and (profile[1] == restaurantProfile[1]):
        return 1
    if profile[2] == '1' and profile[2] == restaurantProfile[2]:
        return 1
    if profile[3] == '1' and profile[3] == restaurantProfile[3]:
        return 1
    if profile[4] == '1' and profile[4] == restaurantProfile[4]:
        return 1

    t = False
    if (profile[1] == profile[2] == profile[3] == profile[4] == '0'):
        return 1

    return 0


def getAllResFromServer():
    config = getConfig()

    # Setup
    firebase = pyrebase.initialize_app(config)
    storage = firebase.storage()

    # Donwload list with all res and algorithm specific data
    storage.child("Manchester/ManchesterResData.json").download("downloaded/ManchesterResData.json")
    print("Manchester Restaurants File Downloaded. Starting Algorithm")

    resParsed = []
    with open('downloaded/ManchesterResData.json') as resFile:
        resData = json.load(resFile)
        for res in resData:
            resParsed.append(res)

    # Updates to Array
    res = [[row['id'], row['encodedProfile'], row['latitude'], row['longitude'], row['specifics']] for row in resParsed]
    print(res)
    return res


def sortRes(encodedProfile, res):
    restaurants = []
    for r in res:
        if validateRestaurants(encodedProfile, r[1]) == 1:

            restaurants.append(r)

    restaurants.sort(key=lambda x: hamming_distance(encodedProfile, x[1]))
    return restaurants



def updateResProfiling():
    res = getAllResFromServer()

    encodedProfiles = getRestaurantsCombinations()

    config = getConfig()
    firebase = pyrebase.initialize_app(config)

    # STARTING PROFILING
    for encodedProfile in encodedProfiles:

        print("Start profiling of:" + encodedProfile)
        resSorted = sortRes(encodedProfile, res)

        # FORMATTING TEXT TO JSON
        data = "["
        for row in resSorted:
            data = data + '{'
            data = data + '"id":"' + row[0] + '",'
            data = data + '"latitude":"' + row[2] + '",'
            data = data + '"longitude":"' + row[3] + '",'
            data = data + '"specifics":['
            for element in row[4]:
                data = data + str(element) + ","
            data = data[:-1] + "]"
            data = data + '},'

        if not (data[len(data)-1] == '['):
            data = data[:-1]
        data = data + "]"

        # CREATES LOCAL FILE
        # UPDATES TO THE SERVER
        filename = "resprofiled/" + encodedProfile + ".json"
        with open(filename, 'w') as outfile:
            outfile.write(data)
            outfile.close()
            firebase.storage().child('Manchester/ResProfiled/' + encodedProfile + '.json').put(filename)

    print("Gracefully termination")