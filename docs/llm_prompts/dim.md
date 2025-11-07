# DIM Prompts

## dim_status_conservacao
EX (Extinct), EW (Extinct in the Wild), CR (Critically Endangered), CR (PEW) (Possibly Extinct in the Wild), EN (Endangered), VU (Vulnerable), NT (Near-threatened), LC (Least Concern), DD (Data Deficient) Com os dados acima, crie um select onde as siglas (EX, EW, etc), fiquem com o nome tp_status_conservacao, os descritivos(Extinct in the Wild, etc) fiquem com o nome nm_ingles, e traduza os descritivos para o portugues com o nome nm_portugues


## dim_reino_biogeografico
A (Australiano), C (Cosmopolita), E (Hemisfério Oriental), F (Afrotropical), I (Indomalaio), L (Neotropical), M (Madagascar & ilhas), N (Neártico), O (Oceania), P (Paleártico), S (Polo Sul), W (Wallacea), Z (Nova Zelândia & ilhas). Com os dados acima, crie um select onde as siglas (A,C, etc), fiquem com o nome tp_reino_biogeografico, os descritivos(Autraliano, etc) traduza-os para o português com o nome nm_portugues

## dim_ordens
Traduzir as ordens de pássaros abaixo para o portugues brasil: 'Struthioniformes' 'Rheiformes' 'Apterygiformes' 'Casuariiformes' 'Tinamiformes' 'Anseriformes' 'Galliformes' 'Caprimulgiformes' 'Musophagiformes' 'Otidiformes' 'Cuculiformes' 'Mesitornithiformes' 'Pterocliformes' 'Columbiformes' 'Gruiformes' 'Podicipediformes' 'Phoenicopteriformes' 'Charadriiformes' 'Eurypygiformes' 'Phaethontiformes' 'Gaviiformes' 'Sphenisciformes' 'Procellariiformes' 'Ciconiiformes' 'Pelecaniformes' 'Suliformes' 'Opisthocomiformes' 'Cathartiformes' 'Accipitriformes' 'Strigiformes' 'Coliiformes' 'Leptosomiformes' 'Trogoniformes' 'Bucerotiformes' 'Coraciiformes' 'Piciformes' 'Cariamiformes' 'Falconiformes' 'Psittaciformes' 'Passeriformes'

| Ordem (Latim)           | Nome comum em português (Brasil)                      |
| ----------------------- | ----------------------------------------------------- |
| **Struthioniformes**    | Avestruzes                                            |
| **Rheiformes**          | Emas                                                  |
| **Apterygiformes**      | Kiwis                                                 |
| **Casuariiformes**      | Casuares e emas-australianas (emus)                   |
| **Tinamiformes**        | Inhambus ou tinamús                                   |
| **Anseriformes**        | Patos, gansos e cisnes                                |
| **Galliformes**         | Galiformes (galinhas, perus, faisões, codornas)       |
| **Caprimulgiformes**    | Bacuraus, curiangos e afins                           |
| **Musophagiformes**     | Turacos                                               |
| **Otidiformes**         | Abetardas                                             |
| **Cuculiformes**        | Cucos e anús                                         |
| **Mesitornithiformes**  | Mesitos (aves endêmicas de Madagascar)                |
| **Pterocliformes**      | Gangas                                                |
| **Columbiformes**       | Pombos e rolas                                        |
| **Gruiformes**          | Grous, saracuras e frangos-d’água                     |
| **Podicipediformes**    | Mergulhões                                            |
| **Phoenicopteriformes** | Flamingos                                             |
| **Charadriiformes**     | Maçaricos, gaivotas e trinta-réis                     |
| **Eurypygiformes**      | Pavãozinho-do-paraíso e kagu                          |
| **Phaethontiformes**    | Rabos-de-palha                                        |
| **Gaviiformes**         | Mergulhões-do-norte (ou gansos-mergulhadores)         |
| **Sphenisciformes**     | Pinguins                                              |
| **Procellariiformes**   | Pardelas, petréis e albatrozes                        |
| **Ciconiiformes**       | Cegonhas                                              |
| **Pelecaniformes**      | Pelicanos, garças e biguás                            |
| **Suliformes**          | Atobás, fragatas e corvos-marinhos                    |
| **Opisthocomiformes**   | Cigana (hoatzin)                                      |
| **Cathartiformes**      | Urubus e condores-do-novo-mundo                       |
| **Accipitriformes**     | Águias, gaviões e abutres                             |
| **Strigiformes**        | Corujas                                               |
| **Coliiformes**         | Rolieiros-de-rabo-de-rato (aves africanas)            |
| **Leptosomiformes**     | Cuco-rolinha de Madagascar                            |
| **Trogoniformes**       | Surucuás e quetzais                                   |
| **Bucerotiformes**      | Calaus e abubilas                                     |
| **Coraciiformes**       | Martim-pescadores, rolieiros e abelharucos            |
| **Piciformes**          | Pica-paus, tucanos e jacus                            |
| **Cariamiformes**       | Seriema                                               |
| **Falconiformes**       | Falcões e caracarás                                   |
| **Psittaciformes**      | Papagaios, araras e periquitos                        |
| **Passeriformes**       | Passarinhos em geral (pardais, canários, sabiás etc.) |

Com os dados acima, crie um select onde a ordem (latin) vá para o campos sgk_ordem e tp_ordem_latin, e o 'Nome comum em português (Brasil)' vá para o campo ds_ordem
