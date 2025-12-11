# ==============================================================================
# Choropleth Map Template
# ==============================================================================
# Purpose: Create province-level thematic maps for thesis
# ==============================================================================

library(tidyverse)
library(sf)
library(tmap)
library(viridis)

# ------------------------------------------------------------------------------
# 1. LOAD VIETNAM BOUNDARIES
# ------------------------------------------------------------------------------

# Option A: From GADM (download first)
# library(geodata)
# vietnam_provinces <- gadm(country = "VNM", level = 1, path = "data/external")

# Option B: From local file
# vietnam_provinces <- st_read("data/external/vietnam_admin1.gpkg")

# Option C: From rnaturalearth
library(rnaturalearth)
vietnam_provinces <- ne_states(country = "Vietnam", returnclass = "sf")

# Check CRS
st_crs(vietnam_provinces)

# ------------------------------------------------------------------------------
# 2. PREPARE DATA FOR MAPPING
# ------------------------------------------------------------------------------

# Calculate province-level statistics from survey data
# Adjust variable names to match your data

prepare_map_data <- function(survey_data, boundaries,
                             province_var = "province",
                             indicator_var = "hdds_score") {

  # Aggregate to province level
  province_stats <- survey_data %>%
    group_by(!!sym(province_var)) %>%
    summarize(
      mean_value = mean(!!sym(indicator_var), na.rm = TRUE),
      median_value = median(!!sym(indicator_var), na.rm = TRUE),
      n_households = n(),
      .groups = "drop"
    )

  # Join to boundaries
  # Adjust join key to match your boundary file (NAME_1, name, etc.)
  map_data <- boundaries %>%
    left_join(province_stats, by = c("name" = province_var))

  return(map_data)
}

# Uncomment and run:
# map_data <- prepare_map_data(survey_data, vietnam_provinces)

# ------------------------------------------------------------------------------
# 3. CREATE CHOROPLETH MAP (tmap)
# ------------------------------------------------------------------------------

create_tmap <- function(map_data, fill_var = "mean_value",
                        title = "Indicator by Province",
                        legend_title = "Value",
                        palette = "YlOrRd") {

  tm_shape(map_data) +
    tm_fill(
      col = fill_var,
      palette = palette,
      title = legend_title,
      style = "quantile",
      n = 5
    ) +
    tm_borders(col = "grey30", lwd = 0.5) +
    tm_layout(
      title = title,
      title.size = 1.2,
      legend.outside = TRUE,
      legend.outside.position = "right",
      frame = FALSE
    ) +
    tm_compass(position = c("left", "bottom")) +
    tm_scale_bar(position = c("left", "bottom"))
}

# Uncomment and run:
# map <- create_tmap(map_data, fill_var = "mean_value",
#                    title = "HDDS by Province",
#                    legend_title = "Mean HDDS")
# tmap_save(map, "output/figures/hdds_map.png", width = 8, height = 6, dpi = 300)

# ------------------------------------------------------------------------------
# 4. CREATE CHOROPLETH MAP (ggplot2)
# ------------------------------------------------------------------------------

create_ggmap <- function(map_data, fill_var = "mean_value",
                         title = "Indicator by Province",
                         legend_title = "Value") {

  ggplot(map_data) +
    geom_sf(aes(fill = !!sym(fill_var)), color = "grey30", size = 0.3) +
    scale_fill_viridis_c(
      name = legend_title,
      option = "viridis",
      direction = -1,
      na.value = "grey90"
    ) +
    labs(
      title = title,
      subtitle = "Vietnam Food Security Survey 2024",
      caption = "Source: Author's survey data"
    ) +
    theme_minimal() +
    theme(
      legend.position = "right",
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      panel.grid = element_blank(),
      plot.title = element_text(face = "bold", size = 14),
      plot.subtitle = element_text(size = 10, color = "grey40")
    )
}

# Uncomment and run:
# map <- create_ggmap(map_data, fill_var = "mean_value",
#                     title = "Household Dietary Diversity by Province",
#                     legend_title = "Mean HDDS")
# ggsave("output/figures/hdds_map_gg.png", map, width = 8, height = 6, dpi = 300)

# ------------------------------------------------------------------------------
# 5. STUDY AREA MAP (for Methods section)
# ------------------------------------------------------------------------------

create_study_area_map <- function(boundaries, highlight_provinces) {

  boundaries <- boundaries %>%
    mutate(study_area = name %in% highlight_provinces)

  ggplot(boundaries) +
    geom_sf(aes(fill = study_area), color = "grey50", size = 0.3) +
    scale_fill_manual(
      values = c("FALSE" = "grey95", "TRUE" = "#4292c6"),
      guide = "none"
    ) +
    labs(
      title = "Study Area: Vietnam",
      subtitle = paste("Highlighted:", paste(highlight_provinces, collapse = ", "))
    ) +
    theme_minimal() +
    theme(
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      panel.grid = element_blank()
    )
}

# Uncomment and run:
# study_map <- create_study_area_map(vietnam_provinces, c("Hanoi", "Ho Chi Minh", "Da Nang"))
# ggsave("output/figures/study_area_map.png", study_map, width = 6, height = 8, dpi = 300)
