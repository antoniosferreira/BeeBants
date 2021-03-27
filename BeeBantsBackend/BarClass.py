class Spot:
    def __init__(self, displayName, displaySecret, displayInfo, displayDirections, locationData, encodedProfile):
        self.displayName = displayName
        self.displaySecret = displaySecret
        self.displayInfo = displayInfo
        self.displayDirections = displayDirections
        self.locationData = locationData
        self.encodedProfile = encodedProfile

    def print(self):
        print("Name:" + self.displayName)
        print("Secret:" + self.displaySecret)
        print("Info:" + str(self.displayInfo))
        print("Directions:" + self.displayDirections)
        print("Location:" + str(self.locationData))
        print("Profile:" + self.encodedProfile)