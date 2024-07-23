## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

tar_plan(

  # Prepare data -----

  # Extract setting-wise contact data
  polymod_contact_data = get_polymod_setting_data(),
  polymod_survey_data = get_polymod_population(),

  # Model fitting -----

  # Fit the model
  polymod_setting_models = fit_setting_contacts(
    contact_data_list = polymod_contact_data,
    population = polymod_survey_data
  ),

  #%% Extract model results for each setting ----
  fit_home = polymod_setting_models$home,
  fit_work = polymod_setting_models$work,
  fit_school = polymod_setting_models$school,
  fit_other = polymod_setting_models$other,

  #%% Model summary ----
  fit_home_summary = summary(fit_home),

  #%% Plot PDPs for each term -----
  partial_dep_home = draw(fit_home, residuals = TRUE) +
    plot_annotation(title = "Home setting"),

  #%% Save plots as png ------
  tar_target(
    fig_home_pdp,
    ggsave(
      filename = "figures/pdp_home.png",
      width = 8, height = 6,
      units = "in")
  ),

  # Extract estimates -----
  smooth_home = smooth_estimates(fit_home),

  smooth_home_long = smooth_long(smooth_home),

  ## Smoothed estimates are not on the right scale - let's write our own
  ## gridded data to fit the partial predictions to.
  age_grid = create_age_grid(ages = 1:99),

  term_names = extract_term_names(fit_home),
  term_var_names = clean_term_names(term_names),

  age_predictions = predict_individual_terms(
    age_grid = age_grid,
    fit = fit_home,
    term_names = term_names,
    term_var_names = term_var_names
    ),

  age_predictions_long = pivot_longer_age_preds(age_predictions),

  plot_age_predictions = gg_age_partial_predictions(age_predictions),

  plot_age_predictions_long = gg_age_partial_pred_long(age_predictions_long),

  tar_quarto(explore, "doc/explore.qmd")
)
