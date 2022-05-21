library(tidyverse)
library(lubridate)
library(fpp3)
library(hrbrthemes)
library(ggtext)
library(scales)

vigi <- read.csv("data/processed/ciano_vigi.csv")

vigi_clean <- vigi %>%
        mutate(Data.da.coleta = ymd(Data.da.coleta)) %>%
        filter(Nome.da.ETA...UTA == "MOINHOS DE VENTO") %>% 
        select(Data.da.coleta, Resultado) %>% 
        rename(data_coleta = Data.da.coleta,
               resultado = Resultado) %>% 
        mutate(semana = yearweek(data_coleta))

predicoes <- read.csv("data/predictions/predicted_ciano.csv")

pred_df <- predicoes %>% 
        mutate(date = date(ymd_hms(date)),
               semana = yearweek(date)) %>% 
        left_join(vigi_clean, by="semana")

ciano_plot <- ggplot(pred_df) +
        geom_line(aes(x = date, y = pred_resultado), col="#7E7E7E") +
        geom_point(aes(x = data_coleta, y=resultado,
                       size=log(resultado^2 + 1)),
                   col = "#E16968",
                   alpha = .6,
                   show.legend = FALSE) +
        geom_hline(yintercept = 20000, col="#AD5050") +
        ####### Anotando no gráfico #######
        # limite monitoramento
        annotate(
                "text",
                x = dmy("01022019"),
                y = 23400,
                size = 4,
                color = "#AD5050",
                lineheight = .9,
                hjust = 0,
                label = "Necessidade de monitoramento\nde cianotoxinas*") +
        geom_curve(
                aes(x = dmy("01082019"), y = 22800, xend = dmy("01102019"), yend = 20000),
                arrow = arrow(length = unit(0.08, "inch")), size = 0.5,
                color = "#AD5050", curvature = -0.3) +
        # dados medidos
        annotate(
                "text", x = dmy("15062021"),
                y = 26400,
                size = 4,
                color = "#E16968",
                lineheight = .9,
                hjust = 0,
                label = "Sisagua") +
        geom_curve(
                aes(x = dmy("01092021"), y = 27000, xend = dmy("01012022"), yend = 29000),
                arrow = arrow(length = unit(0.08, "inch")), size = 0.5,
                color = "#E16968", curvature = -0.3) +
        # dados gee
        annotate(
                "text", x = dmy("20062020"),
                y = 10500,
                size = 4,
                color = "#7E7E7E",
                lineheight = .9,
                hjust = 0,
                label = "GEE") +
        geom_curve(
                aes(x = dmy("20072020"), y = 9500,
                    xend = dmy("01042020"), yend = 7000),
                arrow = arrow(length = unit(0.08, "inch")), size = 0.5,
                color = "#7E7E7E", curvature = -0.3) +
        ####### Fim anotacao #######
        labs(title = "<b style='color:#E16968;'>Cianobactérias</b> no Lago Guaíba",
             x = "",
             y = "Total de cianobactérias (células/mL)",
             caption = "Dados: Sisagua + GEE\n*Cianotoxinas, microcistinas, saxitoxinas e cilindrospermopsinas conforme Portaria GM/MS 888/2021") +
        scale_y_continuous(labels=label_number()) +
        theme_ipsum_tw(grid="Y") +
        theme(plot.title = element_markdown())

ggsave(ciano_plot, filename = "reports/seminario/figures/ts_ciano_00.png",
       dpi = 600, width = 265, height = 150, units = "mm")

             