from specie import Specie
from birds_data_manager import BirdDataManager
from image import Image

class BirdsOfTheWorld:
    def __init__(self):
        pass

    def run(self):
        species = Specie().get_species()
        self.download_images(species)

    def download_images(self, species):
        for e in species:
            image = Image(e['ds_imagem_url'], e['nm_arquivo'])
            if image.download_image():
                BirdDataManager().add_bird_data(e['nm_cientifico'], e['ds_imagem_url'], e['nm_arquivo'], e['nm_gcp_path'])

            


if __name__ == "__main__":
    botw = BirdsOfTheWorld()
    botw.run()