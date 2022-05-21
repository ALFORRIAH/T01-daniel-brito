from xgboost import XGBRegressor
import pickle
import pandas as pd
import numpy as np

def load_all_ndvi_ndci():
    df = pd.read_csv("data/processed/gee_coleta.csv")
    df_selected = df.loc[df["NDVI_median"] > -.9]
    
    return df_selected

def main(): 
    # Carrega e preparada os dados
    df_selected = load_all_ndvi_ndci()
    datas = df_selected["date"]
    X = df_selected[["NDVI_median", "NDVI_max", "NDCI_median", "NDCI_max"]]

    # Carrega o modelo
    model = pickle.load(open("models/xgbr.pkl", "rb"))

    # Realiza as predicoes, substituindo valores negativos por zero
    y_pred = model.predict(X)
    y_pred = np.where(y_pred < 0, 0, y_pred)

    predicted_df = pd.DataFrame({
        "date": datas,
        "pred_resultado": y_pred
    })
    
    predicted_df.to_csv("data/predictions/predicted_ciano.csv", index=False)

if __name__ == "__main__":
    main()