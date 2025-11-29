from specie import Specie
from birds_data_manager import BirdDataManager
from image import Image
from image_uploader import ImageUploader

class BirdsOfTheWorld:
    def __init__(self):
        pass

    def run(self):
        species = Specie().get_species()
        self.process_images(species)

    def process_images(self, species):
        bird_data_manager = BirdDataManager()
        uploader = ImageUploader()
        for e in species:

            if bird_data_manager.cientific_name_exists(e['nm_cientifico']):
                print(f"Nome científico '{e['nm_cientifico']}' já exite no arquivo json. Pulando.")
                continue
            
            image = Image(e['ds_imagem_url'], e['nm_arquivo'])
            if image.download_image():
                bird_data_manager.add_bird_data(e['nm_cientifico'], e['ds_imagem_url'], e['nm_arquivo'], e['nm_gcp_path'])

                local_file_path = f"images/{ e['nm_arquivo']}"
                uploader.upload_image(local_file_path)

            


if __name__ == "__main__":
    botw = BirdsOfTheWorld()
    botw.run()