predicoes <- read.csv("data/predictions/predicted_ciano.csv")

pred_df <- predicoes %>% 
        mutate(date = date(ymd_hms(date)),
               semana = yearweek(date)) %>% 
        left_join(vigi_clean, by="semana")

clorofila_ts <- pred_df %>% 
        select(semana, pred_resultado) %>% 
        group_by(semana) %>% 
        summarise(pred_resultado = mean(pred_resultado)) %>% 
        as_tsibble(index=semana)


clorofila_ts_miss <- clorofila_ts %>% 
        fill_gaps()

clorofila_ts_interpolado <- clorofila_ts_miss %>% 
        model(ARIMA(pred_resultado)) %>% 
        interpolate(clorofila_ts_miss)

clorofila_ts_interpolado %>% autoplot()

# Tendencia de aumento de algas no verao (semanas 1, 52 e 53)
clorofila_ts_interpolado %>% 
        model(classical_decomposition(pred_resultado, type="additive")) %>% 
        components() %>% 
        autoplot() +
        theme_ipsum() +
        labs(title = "Tendência de aumento de cianobacéterias no início\ne final de ano (semanas 01, 52 e 53)",
             caption = "Fonte: dados estimados a partir de GEE com modelo XGBoost")