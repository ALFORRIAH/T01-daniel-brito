def add_id_date(img):
    """Adiciona ID e data da imagem Sentinel 2A"""

    return img.set({"ID": img.get("system:id")})\
        .set({"millis": img.date().millis()})\
        .set("date", img.date().format())

def mask_s2a_clouds(img):
    """Adiciona máscara de núvens em imagem Sentinel 2A, retornando bandas B*

    Os bits 10 e 11 são nuvens e cirros, respectivamente.
    https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR
    Créditos: Scripts Remote (Me. Christhian Cunha - https://linktr.ee/scriptsremotesensing)"""

    qa60 = img.select('QA60')
    
    cloudBitMask = 1 << 10                              # Bit 10 corresponde a nuvens
    cirrusBitMask = 1 << 11                             # Bit 11 corresponde a cirrus
    
    mask = qa60.bitwiseAnd(cloudBitMask).eq(0)and(qa60.bitwiseAnd(cirrusBitMask).eq(0))

    return img.updateMask(mask)\
      .select("B.*")\
      .copyProperties(img, img.propertyNames())

def add_s2a_ndci_ndvi(img):
    """Adiciona NDCI e NDVI para imageCollection Sentinel 2A em uma região definida
    
    O cálculo dos índices considera as seguintes referências:
    - Jaskula e Sojka (2019): http://www.pjoes.com/pdf-98994-42186?filename=Assessing%20Spectral.pdf
    - Doc. Sentinel 2A GEEhttps://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR#bands
    - Lobo et al (2021): https://www.mdpi.com/2072-4292/13/15/2874/html"""
    
    img_reflectancia = img.multiply(0.0001)
    ndci_band = img_reflectancia.normalizedDifference(["B5", "B4"]).rename("NDCI")
    ndvi_band = img_reflectancia.normalizedDifference(["B8", "B4"]).rename("NDVI")
    
    img_with_bands = img.addBands([ndci_band, ndvi_band])\
        .copyProperties(img, ["system:time_start"])\
        .set("date", img.date().format("YYYY-MM-dd"))
    
    return img_with_bands