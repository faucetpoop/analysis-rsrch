# Geospatial Analysis - Best Practices Guide

## Quick Reference
- **Purpose**: Create maps and perform spatial analysis with geocoded data
- **Key Packages**: sf, tmap, ggplot2, leaflet, geodata
- **Related Areas**: [05-food-security-indicators](../05-food-security-indicators/), [10-reporting](../10-reporting/)
- **Agent-Foreman Features**: `geospatial.data.load-gadm`, `geospatial.mapping.choropleth`, `geospatial.aggregation.survey-weighted`

## Prerequisites
- [ ] Vietnam administrative boundaries (GADM)
- [ ] Geocoded survey data (lat/long)
- [ ] sf package installed

## Core Workflow

### Step 1: Load Vietnam Boundaries
```r
library(sf)
library(geodata)

# From GADM
vietnam_provinces <- gadm(country = "VNM", level = 1, path = tempdir())

# Or from local file
vietnam_provinces <- st_read("vietnam_admin1.gpkg")
```

### Step 2: Convert Survey Data to Spatial
```r
survey_sf <- survey_data %>%
  filter(!is.na(longitude) & !is.na(latitude)) %>%
  st_as_sf(
    coords = c("longitude", "latitude"),
    crs = 4326,
    remove = FALSE
  )
```

### Step 3: Spatial Join
```r
# Assign province to each household
survey_with_admin <- st_join(survey_sf, vietnam_provinces, join = st_within)
```

### Step 4: Aggregate Statistics to Boundaries
```r
province_stats <- survey_data %>%
  group_by(province) %>%
  summarize(
    mean_hdds = mean(hdds_score, na.rm = TRUE),
    pct_food_insecure = mean(food_insecure, na.rm = TRUE) * 100
  )

vietnam_map <- vietnam_provinces %>%
  left_join(province_stats, by = c("NAME_1" = "province"))
```

### Step 5: Create Choropleth Map
```r
library(tmap)

tm_shape(vietnam_map) +
  tm_fill(col = "mean_hdds", palette = "YlOrRd", title = "Mean HDDS") +
  tm_borders() +
  tm_layout(title = "Dietary Diversity by Province", legend.outside = TRUE)

# Or with ggplot2
ggplot(vietnam_map) +
  geom_sf(aes(fill = mean_hdds)) +
  scale_fill_viridis_c(name = "Mean HDDS") +
  theme_minimal()
```

## Checklists

### Before Starting
- [ ] GADM boundaries downloaded
- [ ] CRS understood (WGS84 = EPSG:4326)
- [ ] Geocoded coordinates in data

### Quality Assurance
- [ ] Boundaries loaded successfully
- [ ] Survey data converted to sf object
- [ ] Spatial join assigns admin units
- [ ] Aggregate statistics calculated
- [ ] Study area map created
- [ ] 1-2 thematic maps created
- [ ] Privacy implications checked

## Common Pitfalls
1. **Wrong CRS for distances**: Using WGS84 for distance calculations → **Solution**: Transform to UTM (32648/32649)
2. **Showing exact locations**: Privacy violation → **Solution**: Aggregate to admin level
3. **Missing coordinates**: Rows filtered out silently → **Solution**: Check NA count before conversion

## Scripts
- `scripts/choropleth-map-template.R` - Map generation template

## External Resources
- [GADM Vietnam](https://gadm.org/download_country.html)
- [HDX Vietnam Boundaries](https://data.humdata.org/dataset/cod-ab-vnm)
- [sf Cheatsheet](https://github.com/rstudio/cheatsheets/blob/main/sf.pdf)
- [tmap Documentation](https://r-tmap.github.io/tmap/)

## Related Areas
- [05-food-security-indicators](../05-food-security-indicators/) - Indicators to map
- [06-income-expenditure](../06-income-expenditure/) - Economic indicators to map
- [10-reporting](../10-reporting/) - Map export for thesis
