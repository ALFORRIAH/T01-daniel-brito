from sklearn.model_selection import train_test_split
from xgboost import XGBRegressor
import pandas as pd
import pickle

RANDOM_STATE = 0

# Load data
def load_data():
    df = pd.read_csv("data/processed/ndvi_ndci_vigi.csv")
    df_selected = df.loc[df["NDVI_median"] > -.9]
    
    return df_selected

def main():
    df_selected = load_data()

    selected_vars = ["NDVI_median", "NDVI_max", "NDCI_median", "NDCI_max"]

    X = df_selected[selected_vars]
    y = df_selected["Resultado"]

    # tunada conforme notebook
    xgbr = XGBRegressor(base_score=0.5, booster='gbtree', colsample_bylevel=1,
             colsample_bynode=1, colsample_bytree=0.8, eta=0.7, gamma=0,
             gpu_id=-1, importance_type='gain', interaction_constraints='',
             learning_rate=0.699999988, max_delta_step=0, max_depth=5,
             min_child_weight=1, monotone_constraints='()',
             n_estimators=100, n_jobs=8, num_parallel_tree=1, random_state=RANDOM_STATE,
             reg_alpha=0, reg_lambda=1, scale_pos_weight=1, subsample=1,
             tree_method='exact', validate_parameters=1, verbosity=None)

    # Treina com todo o dataset depois de modelo tunado
    xgbr.fit(X, y)

    with open("models/xgbr.pkl", "wb") as f:
        pickle.dump(xgbr, f)

if __name__ == "__main__":
    main()