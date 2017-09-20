import geopandas as gpd

world = gpd.read_file("data/world_m/")
cities = gpd.read_file("data/cities")

#world = gpd.read_file(gpd.datasets.get_path('naturalearth_lowres'))
#cities = gpd.read_file(gpd.datasets.get_path('naturalearth_cities'))

world = world.to_crs(cities.crs)

base_plot = world.plot(color='white', edgecolor='black')
cities.plot(ax=base_plot, marker='o', color='red', markersize=5)