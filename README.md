# Monitoramento de cianobactérias no Lago Guaíba

![Desenvolvido em Python](https://img.shields.io/badge/-python-brightgreen)
![Desenvolvido em R](https://img.shields.io/badge/-R-brightgreen)
![GEE](https://img.shields.io/badge/-GEE-brightgreen)
![XGBoost](https://img.shields.io/badge/-XGBoost-brightgreen)
![Scikit-learn](https://img.shields.io/badge/-Scikit--learn-brightgreen)

## Índice

* [Índice](#índice)
* [Descrição do Projeto](#descrição-do-projeto)
* [Acesso ao projeto](#acesso-ao-projeto)
* [Tecnologias utilizadas](#tecnologias-utilizadas)
* [Tarefas em abert](#tarefas-em-aberto)
* [Referências](#referências)

Projeto desenvolvido na primeira etapa da mentoria [Alforriah](https://www.alforriah.com/).

## Descrição do Projeto
### Problema
As cianobactérias, popularmente conhecidas como "algas azuis", podem se proliferar de modo excessivo em reservatórios e corpos hídricos, especialmente aqueles locais com um regime lêntico, em um fenômeno conhecido como florações ("blooms") de algas. Esses eventos podem resultar em impactos ecônomicos e sanitários negativos<sup>[1](#referências)</sup>. Espera-se que, com o aquecimento global, ocorra um aumento na frequência e intensidade desses eventos<sup>[2](#referências)</sup>. O aumento das fontes de dados sobre de monitoramento de qualidade da água tem potencial de auxiliar o conhecimento da população e tomadores de decisão sobre o estado dos recursos hídricos frente a esse problema.

### Proposta
O objetivo deste trabalho foi se extrair uma série histórica de densidade de cianobactérias de recurso hídrico superficial a partir da análise de imagens de satélite. A área de estudo escolhida foi o Lago Guaíba, manancial da cidade de Porto Alegre, capital do Rio Grande do Sul.

### Implementação
O sistema calcula o índice NDVI (Normalized Difference Vegetation Index) e NDCI (Normalized Difference Chlorophyll Index) para o Lago Guaíba e os utiliza como preditores em uma regressão para se estimar as densidades de cianobactérias obtidas no monitoramento da qualidade da água realizado pelo setor de saúde (SISAGUA). Especificamente, foi realizada a análise de um dos pontos de captação da cidade (próximo ao par de coordenadas -30.012175, -51.215679). Trata-se de uma metodologia já adotada em alguns trabalhos<sup>[3, 4, 5](#referências)</sup>, especialmente para monitoramento de clorofila-a.

![Série temporal NDCI - Guaíba](reports%5Cseminario%5Cfigures%5Cndci_animation.gif) ![Série temporal NDVI - Guaíba](reports%5Cseminario%5Cfigures%5CNDVI_animation.gif)

Os dados foram utilizados como input em um modelo de XGBoost. Mais detalhes sobre o treinamento podem ser conferidos [nesse notebook](notebooks\.ipynb_checkpoints\dob-criando-dataset-checkpoint.ipynb).

### Resultado

<img src="reports%5Cseminario%5Cfigures%5Cts_ciano_00.png" alt="resultado" width="1000"/>

## Acesso ao projeto

Você poderá acessar o código fonte do projeto que foi organizado aos moldes do [Cookiecutter Data Science](https://drivendata.github.io/cookiecutter-data-science/) com algumas pequenas adaptações.

Para se realizar análise da série histórica das concentrações de cianobactérias, você deverá:
1. Criar série histórica de NDVI e NDCI a partir de `notebooks/dob-criando-dataset.ipynb`
2. Estimar densidade de cianobactérias (número total de organismos) a partir do modelo `models/xgbr.pkl` usando `src/models/predict_model.py`
3. Realizar as análises de séries temporais constantes em `analises_series_temporais.R`

## Tecnologias utilizadas

- ``Python``
    - ``Google Earth Engine``
    - ``Pandas``
    - ``plotly``
    - ``Scikit-learn``
    - ``XGBoost``
- ``R``
    - ``fpp3``
    - ``tidyverse``
    - ``lubridate``

![ferramentas utilizadas](reports%5Cseminario%5Cimgs%5Cpipe.jpg)

As seguintes bases de dados foram utilizadas no projeto:

- Série histórica Sentila-2A obtida no Google Earth Engine (European Space Agency): https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2

- Base Cartográfica Vetorial do Rio Grande do Sul (SEMA/FEPAM): https://dados.rs.gov.br/dataset/base-cartografica-rs-secao-01-hidrografia

- RS Água (FEPAM): https://gis.fepam.rs.gov.br/RSAgua/

- SISAGUA (Ministério da Saúde): https://dados.gov.br/dataset/sisagua-controle-mensal-resultado-de-analises

- OpenTopography: https://opentopography.org/

## Oportunidades de melhoria

Alguns pontos do projeto são passíveis de melhoria, destacando-se:

- Obtenção dos dados
    - Aprimoramento do preprocessamento das imagens de satélite
    - Análise de outras áreas do manancial
    - Combinação de diferentes regras para cruzamento dos dados medidos com dados de satélite
- Modelagem
    - Testes de outros modelos
    - Feature engineering dos índices, especialmente a aplicação de processamento dos índices para redução do ruído
- Produtização
    - Automação da autenticação no GEE, possibilitando que a aplicação rode de maneira mais rápida

É possível, ainda, testar esse método em outras áreas, visando analisar sua generalização para outros mananciais.

## Referências

[1] CETESB. Manual de cianobactérias planctônicas : legislação, orientações para o monitoramento e aspectos ambientais. 2013. https://cetesb.sp.gov.br/laboratorios/wp-content/uploads/sites/24/2015/01/manual-cianobacterias-2013.pdf

[2] Huisman, Jef; Codd, Geoffrey A.; Paerl, Hans W.; Ibelings, Bas W.; Verspagen, Jolanda M. H.; Visser, Petra M. 2018. Cyanobacterial blooms. Nature. https://www.nature.com/articles/s41579-018-0040-1

[3] Zhato, H. et al. Monitoring Cyanobacteria Bloom in Dianchi Lake Based on Ground-Based Multispectral Remote-Sensing Imaging: Preliminary Results. Remote Sensing. 2021 https://www.mdpi.com/2072-4292/13/19/3970

[4] Lobo, F.d.L.; Nagel, G.W.; Maciel, D.A.; Carvalho, L.A.S.d.; Martins, V.S.; Barbosa, C.C.F.; Novo, E.M.L.d.M. AlgaeMAp: Algae Bloom Monitoring Application for Inland Waters in Latin America. Remote Sens. 2021, 13, 2874. https://doi.org/10.3390/rs13152874

[5] Ventura, D. et al. Long-Term Series of Chlorophyll-a Concentration in Brazilian Semiarid Lakes from Modis Imagery. 2022. https://www.mdpi.com/2073-4441/14/3/400
