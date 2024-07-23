tmp_offdiag <- age_predictions_long %>%
  filter(pred == "offdiag")

summary(tmp_offdiag$value)

ggplot(tmp_offdiag,
  aes(
    x = age_from,
    y = age_to,
    group = pred,
    fill = value
  )) + geom_tile()

tmp_prod <- age_predictions_long %>%
  filter(pred == "diag_prod")

summary(tmp_prod$value)

ggplot(tmp_prod,
       aes(
         x = age_from,
         y = age_to,
         group = pred,
         fill = value
       )) + geom_tile()

tmp_sum <- age_predictions_long %>%
  filter(pred == "diag_sum")

summary(tmp_sum$value)

ggplot(tmp_sum,
       aes(
         x = age_from,
         y = age_to,
         group = pred,
         fill = value
       )) +
  facet_wrap(~pred) +
  geom_tile() +
  scale_fill_viridis_c() +
  theme_minimal() +
  coord_fixed()

gg_age_partial_pred_long <- function(age_predictions_long) {

  age_predictions_long %>%
    ggplot(
      aes(
        x = age_from,
        y = age_to,
        group = pred,
        fill = value
      )
    ) +
    facet_wrap(~pred, scales = "free") +
    geom_tile() +
    scale_fill_viridis_c() +
    theme_minimal()

}

library(ggplot2)
library(viridis)
library(gridExtra)

plots <- lapply(unique(age_predictions_long$pred), function(g) {
  ggplot(subset(age_predictions_long, pred == g),
         aes(
           x = age_from,
           y = age_to,
           fill = value
         )) +
    geom_tile() +
    scale_fill_viridis_c() +
    theme_minimal() +
    coord_fixed() +
    ggtitle(paste(g)) # +
  # theme(
  #   legend.key.size = unit(0.5, "cm"),    # Adjust the legend key size
  #   legend.title = element_text(size = 8), # Adjust the legend title size
  #   legend.text = element_text(size = 6)   # Adjust the legend text size
  # )
})

grid.arrange(grobs = plots)
