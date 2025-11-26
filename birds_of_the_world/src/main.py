from specie import Specie

class BirdsOfTheWorld:
    def __init__(self):
        pass

    def run(self):
        species = Specie().get_species()
        print(species)

if __name__ == "__main__":
    botw = BirdsOfTheWorld()
    botw.run()