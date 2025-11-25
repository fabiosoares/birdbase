import json


def extrair_requisicoes_taxonomy(caminho_arquivo_json):
    """
    Carrega o arquivo JSON e retorna uma lista de URLs que contêm '/taxonomy'.
    """
    requisicoes_taxonomy = []

    try:
        # Carrega o conteúdo do arquivo JSON.
        # (Aviso: Esta função é um boilerplate. Na prática, 
        # o usuário precisaria adaptar a leitura se o arquivo não for 
        # um array JSON padrão, mas sim um log concatenado ou estruturado 
        # de forma diferente, como parece ser o caso dos fragmentos fornecidos).
        with open(caminho_arquivo_json, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
    except FileNotFoundError:
        print(f"Erro: Arquivo não encontrado no caminho: {caminho_arquivo_json}")
        return []
    except json.JSONDecodeError:
        print("Erro: Não foi possível decodificar o arquivo JSON. Verifique se o formato está correto.")
        return []

    # Se 'data' for um array de objetos de requisição (como inferido das fontes)


     # Verifica se existe log.entries
    if "log" not in data or "entries" not in data["log"]:
        print("Formato inesperado. A estrutura HAR não possui 'log.entries'.")
        return []

    for entry in data["log"]["entries"]:
        # Verifica se existe request.url
        if "request" in entry and "url" in entry["request"]:
            url = entry["request"]["url"]
            if "/taxonomy" in url:
                requisicoes_taxonomy.append(url)

    return requisicoes_taxonomy

# Exemplo de como o script seria usado:
nome_do_arquivo = "/var/www/birdbase/birds-of-the-world/birdsoftheworld.org.har"
lista_taxonomy = extrair_requisicoes_taxonomy(nome_do_arquivo)

# Imprime as requisições encontradas
for req in lista_taxonomy:
     print(req)

print(f"\nTotal de requisições /taxonomy encontradas: {len(lista_taxonomy)}")