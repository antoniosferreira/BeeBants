import itertools

import firebase_admin

from ManchesterBarsSorter import *
from ManchesterResSorter import *

from firebase_admin import credentials
from firebase_admin import firestore



def setUpBars():
    cred = credentials.Certificate('beebants-bcf17-35bd3ed35b6e.json')
    firebase_admin.initialize_app(cred)

    db = firestore.client()
    manchesterBarsProfiled = db.collection(u'ManchesterBarsSorted')

    encodedProfiles = combinationBars()
    for encodedProfile in encodedProfiles:
        manchesterBarsProfiled.document(encodedProfile).set({u'sortedBars':0})




def hamming_distance(s1, s2):
    if len(s1) != len(s2):
        print(s1 + "-" + s2)

    return sum(ch1 != ch2 for ch1,ch2 in zip(s1,s2))


def sortBars():

    print("Starting Bars sorting!")
    cred = credentials.Certificate('beebants-bcf17-35bd3ed35b6e.json')
    firebase_admin.initialize_app(cred)

    db = firestore.client()

    barsSortedCollection = db.collection(u'ManchesterBarsSorted')
    barsCollection = db.collection(u'Bars')
    barsSorted = combinationBars()
    bars = barsCollection.get()

    # doc.id // doc.to_dict()
    for barSorted in barsSorted:

        sortedBarsInfo = [[]]
        # Add all bars
        for bar in bars:
            encodedBarProfile = bar.to_dict().get('encodedProfile')
            sortedBarsInfo.append([bar.id, encodedBarProfile])

        # Sort array
        sortedBarsInfo.remove([])
        sortedBarsInfo.sort(key=lambda x: hamming_distance(x[1], barSorted))

        printSort = [row[0] for row in itertools.islice(sortedBarsInfo , 0, round(len(sortedBarsInfo)/2))]

        doc_ref = barsSortedCollection.document(barSorted)
        doc_ref.set({
            u'sortedBars': printSort
        })



updateBarsProfiling()
updateResProfiling()