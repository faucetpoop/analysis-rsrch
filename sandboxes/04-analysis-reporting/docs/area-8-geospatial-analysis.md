# Area 8 – Geospatial Analysis with Geocoded Responses

**Goal:** Make smart, lightweight use of geocoded data to enrich the thesis.

---

## Vietnam Administrative Boundaries

### Data Sources

| Source | Description | Format |
|--------|-------------|--------|
| **GADM 4.1** | Recommended source | GeoPackage, Shapefile |
| **HDX/OCHA** | Humanitarian data with Vietnamese labels | ESRI, WMS, KML |
| **Open Development Mekong** | Official Vietnamese boundaries | Polylines |
| **IGISMAP** | Free download, EPSG:4326 | Shapefile |

### Administrative Levels (Vietnam)
- Level 1: Country
- Level 2: Province/City (5 cities + 58 provinces)
- Level 3: District/Town (548 districts + 137 towns)
- Level 4: Commune/Ward (9,103 communes + 1,897 wards)

### Download Links
- [GADM Vietnam](https://gadm.org/download_country.html) - Select VNM
- [HDX Vietnam Boundaries](https://data.humdata.org/dataset/cod-ab-vnm)
- [Open Development Mekong](https://data.opendevelopmentmekong.net/dataset/a-gii-hnh-chnh-vit-nam)

---

## Coordinate Reference Systems (CRS)

### Common CRS for Vietnam

| CRS | EPSG | Use Case |
|-----|------|----------|
| WGS84 | 4326 | GPS data, most common |
| VN-2000 | 9205-9218 | Vietnam National Grid, accurate measurements |
| UTM Zone 48N | 32648 | Western Vietnam |
| UTM Zone 49N | 32649 | Eastern Vietnam |

### Best Practice
- **Load data:** WGS84 (EPSG:4326)
- **Distance/area calculations:** UTM or VN-2000
- **Final maps:** WGS84

```r
library(sf)

# Check CRS
st_crs(vietnam_boundaries)

# Transform to UTM for calculations
vietnam_utm <- st_transform(vietnam_boundaries, crs = 32648)

# Back to WGS84 for mapping
vietnam_wgs84 <- st_transform(vietnam_utm, crs = 4326)
```

---

## Loading Spatial Data

### Using sf Package

```r
library(sf)

# Read shapefile
vietnam_provinces <- st_read("vietnam_admin1.shp")

# Read from geopackage
vietnam_provinces <- st_read("vietnam_boundaries.gpkg",
                             layer = "provinces")

# From geojson
vietnam_provinces <- st_read("vietnam_provinces.geojson")

# Check geometry and CRS
st_geometry_type(vietnam_provinces)
st_crs(vietnam_provinces)
```

### Using geodata Package
```r
library(geodata)

vietnam_adm <- gadm(country = "VNM", level = 1, path = tempdir())
```

### Using rnaturalearth Package
```r
library(rnaturalearth)

# Country boundary
vietnam_country <- ne_countries(country = "Vietnam",
                                scale = "medium",
                                returnclass = "sf")

# States/provinces
vietnam_admin <- ne_states(country = "Vietnam",
                           returnclass = "sf")
```

---

## Geocoded Point Data

### Converting Survey Data to sf Object

```r
# Survey data with coordinates
survey_sf <- survey_data %>%
  filter(!is.na(longitude) & !is.na(latitude)) %>%
  st_as_sf(
    coords = c("longitude", "latitude"),
    crs = 4326,
    remove = FALSE  # Keep original columns
  )
```

### Spatial Join with Boundaries

```r
# Assign province to each household
survey_with_admin <- st_join(
  survey_sf,
  vietnam_provinces,
  join = st_within
)
```

### Joining Survey Statistics to Boundaries

```r
# Calculate province-level statistics
province_stats <- survey_data %>%
  group_by(province) %>%
  summarize(
    mean_hdds = mean(hdds_score, na.rm = TRUE),
    pct_food_insecure = mean(food_insecure, na.rm = TRUE) * 100,
    n_households = n()
  )

# Join to spatial data
vietnam_map <- vietnam_provinces %>%
  left_join(province_stats, by = c("NAME_1" = "province"))
```

---

## Choropleth Maps

### Using ggplot2

```r
library(ggplot2)
library(viridis)

ggplot(vietnam_map) +
  geom_sf(aes(fill = mean_hdds)) +
  scale_fill_viridis(
    option = "viridis",
    name = "Mean HDDS",
    direction = -1
  ) +
  labs(
    title = "Household Dietary Diversity Score by Province",
    subtitle = "Vietnam Food Security Survey 2024",
    caption = "Source: Author's survey data"
  ) +
  theme_minimal() +
  theme(
    legend.position = "right",
    axis.text = element_blank(),
    axis.ticks = element_blank()
  )

ggsave("figures/hdds_by_province_map.png",
       width = 8, height = 6, dpi = 300)
```

### Using tmap Package

```r
library(tmap)

tm_shape(vietnam_map) +
  tm_fill(col = "mean_hdds",
          palette = "YlOrRd",
          title = "Mean HDDS") +
  tm_borders() +
  tm_layout(
    title = "Dietary Diversity by Province",
    legend.outside = TRUE
  )
```

---

## Point Maps

```r
# Base map with provinces + survey points
ggplot() +
  # Province boundaries
  geom_sf(data = vietnam_provinces,
          fill = "grey95", color = "grey70") +
  # Survey points colored by food security
  geom_sf(data = survey_sf,
          aes(color = food_secure),
          size = 2, alpha = 0.6) +
  scale_color_manual(
    values = c("0" = "#d73027", "1" = "#1a9850"),
    labels = c("Food insecure", "Food secure"),
    name = ""
  ) +
  labs(title = "Household Food Security Status") +
  theme_void()
```

---

## Distance Calculations

```r
# Transform to projected CRS for accurate distances
households_utm <- st_transform(survey_sf, crs = 32648)
markets_utm <- st_transform(markets_sf, crs = 32648)

# Calculate nearest distance to market
survey_data$dist_to_market <- st_distance(
  households_utm,
  markets_utm,
  by_element = FALSE
) %>%
  apply(1, min) / 1000  # Convert meters to km

# Create buffer zones (5km around markets)
market_buffers <- st_buffer(markets_utm, dist = 5000)

# Identify households within buffer
survey_data$within_5km_market <- st_intersects(
  households_utm,
  market_buffers,
  sparse = FALSE
) %>%
  apply(1, any)
```

---

## Survey-Weighted Spatial Analysis

```r
library(survey)
library(sf)

# Create survey design
survey_design <- svydesign(
  ids = ~cluster,
  strata = ~province,
  weights = ~weight,
  data = survey_data
)

# Calculate province-level weighted estimates
province_stats <- svyby(
  ~food_secure,
  ~province,
  design = survey_design,
  FUN = svymean
)

# Join to spatial data
vietnam_map <- vietnam_provinces %>%
  left_join(province_stats, by = c("NAME_1" = "province"))

# Map weighted estimates
tm_shape(vietnam_map) +
  tm_fill(col = "food_secure", palette = "Greens")
```

---

## Interactive Maps

```r
library(leaflet)
library(htmlwidgets)

map <- leaflet(survey_sf) %>%
  addTiles() %>%
  addCircleMarkers(
    radius = 5,
    color = ~ifelse(food_secure == 1, "green", "red"),
    fillOpacity = 0.6,
    popup = ~paste0(
      "<b>Household ID:</b> ", household_id, "<br>",
      "<b>HDDS:</b> ", hdds_score, "<br>",
      "<b>Food Secure:</b> ", ifelse(food_secure == 1, "Yes", "No")
    )
  ) %>%
  addLegend(
    position = "bottomright",
    colors = c("green", "red"),
    labels = c("Food secure", "Food insecure")
  )

saveWidget(map, "survey_map_interactive.html")
```

---

## Maps for Thesis

### Study Area Map (Methods Section)
- Vietnam with study provinces highlighted
- Inset showing Vietnam in Southeast Asia
- Scale bar and north arrow

### Thematic Maps (Results Section)
1. HDDS by province
2. Food insecurity prevalence by province
3. Household locations (if privacy allows aggregation)

### Best Practices
- **Data distribution:** Check for long tails before mapping
- **Color scales:** Use colorblind-friendly palettes (viridis)
- **Privacy:** Aggregate to admin level, don't show exact locations
- **Context:** Include basemap or boundaries for orientation

---

## Checklist

- [ ] Download Vietnam admin boundaries (GADM or HDX)
- [ ] Load boundaries into R with sf
- [ ] Convert geocoded survey data to sf object
- [ ] Perform spatial join to assign admin units
- [ ] Calculate aggregate statistics by province/district
- [ ] Create study area map for methods
- [ ] Create 1-2 thematic choropleth maps
- [ ] Consider distance/accessibility analysis if relevant
- [ ] Check privacy implications of point mapping

---

## Resources

### Vietnam Spatial Data
- [GADM](https://gadm.org/download_country.html)
- [HDX Vietnam](https://data.humdata.org/dataset/cod-ab-vnm)
- [Open Development Mekong](https://data.opendevelopmentmekong.net/)

### sf Package
- [sf Cheatsheet](https://github.com/rstudio/cheatsheets/blob/main/sf.pdf)
- [Geospatial Vector Data in R](https://ourcodingclub.github.io/tutorials/spatial-vector-sf/)

### Mapping
- [tmap Documentation](https://r-tmap.github.io/tmap/)
- [R Graph Gallery Choropleth](https://r-graph-gallery.com/choropleth-map.html)
- [Spatial Data with R - Mapping](https://cengel.github.io/R-spatial/mapping.html)

### CRS Reference
- [Geographic Data Science - CRS](https://bookdown.org/mcwimberly/gdswr-book/coordinate-reference-systems.html)
- [Geocomputation with R](https://r.geocompx.org/)

### R Packages
- [geodata](https://cran.r-project.org/web/packages/geodata/) - Download GADM
- [GADMTools](https://www.rdocumentation.org/packages/GADMTools/)
- [rnaturalearth](https://docs.ropensci.org/rnaturalearth/)
