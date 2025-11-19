import re
import json
from bs4 import BeautifulSoup

# O nome do arquivo HTML a ser lido
HTML_FILE = "Explore Taxonomy - Birds of the World.html"
# O nome do arquivo JSON de saída
JSON_FILE = "birds_data.json"

def extract_bird_data(html_content):
    """
    Extrai o caminho da imagem e o nome científico das aves do conteúdo HTML.
    """
    soup = BeautifulSoup(html_content, 'html.parser')
    bird_data = []

    # O HTML fornecido não tem uma estrutura de contêiner clara para cada ave,
    # mas os elementos de imagem e nome científico parecem estar próximos.
    # Vamos procurar por todos os elementos que contêm o nome científico,
    # e então tentar encontrar a imagem associada.

    # 1. Encontrar todos os elementos de nome científico
    # Tag: <span class="Heading-sub Heading-sub--inline Heading-sub--sci">
    scientific_name_tags = soup.find_all('span', class_='Heading-sub--sci')

    for name_tag in scientific_name_tags:
        nm_cientifico = name_tag.text.strip()
        
        # 2. Tentar encontrar a tag <img> associada.
        # No HTML de exemplo, a tag <img> está logo antes da tag <span>.
        # Vamos procurar o elemento anterior.
        
        # O elemento anterior direto pode ser um NavigableString (espaço em branco).
        # Usamos .find_previous_sibling('img') para encontrar a tag <img> anterior.
        image_tag = name_tag.find_previous_sibling('img')
        
        ds_caminho_imagem_ave = None
        if image_tag:
            # O usuário solicitou o 'src' de tags como <img alt="Common Ostrich" ... src="...">
            # O HTML de exemplo tem tags <img> com 'src' e 'data-src'.
            # Vou priorizar o 'src' conforme o exemplo do usuário, mas o 'data-src'
            # é mais comum para imagens lazy-loaded. Vou usar 'src' se existir, senão 'data-src'.
            ds_caminho_imagem_ave = image_tag.get('src')
            if not ds_caminho_imagem_ave:
                ds_caminho_imagem_ave = image_tag.get('data-src')
        
        # Se encontrarmos os dois, adicionamos à lista
        if nm_cientifico and ds_caminho_imagem_ave:
            bird_data.append({
                "ds_caminho_imagem_ave": ds_caminho_imagem_ave,
                "nm_cientifico": nm_cientifico
            })

    return bird_data

def main():
    try:
        with open(HTML_FILE, 'r', encoding='utf-8') as f:
            html_content = f.read()
    except FileNotFoundError:
        print(f"Erro: Arquivo '{HTML_FILE}' não encontrado. Certifique-se de que o arquivo HTML foi criado corretamente.")
        return

    # Extrair os dados
    extracted_data = extract_bird_data(html_content)

    # Salvar a saída em JSON
    try:
        with open(JSON_FILE, 'w', encoding='utf-8') as f:
            json.dump(extracted_data, f, indent=4, ensure_ascii=False)
        print(f"Dados extraídos com sucesso e salvos em '{JSON_FILE}'.")
    except Exception as e:
        print(f"Erro ao salvar o arquivo JSON: {e}")

if __name__ == "__main__":
    main()
