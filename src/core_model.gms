* AgriLand-CEM Core Model
* Version 3.0.0
* This file defines the agricultural land allocation model

SETS
* Land classes
   LANDCLASS "Land classes" / IRRL, RFL, PAST /
* IRRL = Irrigated Cropland
* RFL = Rainfed Cropland
* PAST = Pasture Land

* Other sets
   CROPS "Crop types" / WHEAT, MAIZE, SOY /
   LIVESTOCK "Livestock types" / CATTLE, SHEEP, POULTRY /
   REGIONS "Geographic regions" / NORTH, SOUTH /;

PARAMETERS
   LANDSUPPLY(LANDCLASS) "Total land availability by class (hectares)"
   LANDUSE(LANDCLASS, CROPS) "Land use allocation"
   LANDUSE_LIVESTOCK(LANDCLASS, LIVESTOCK) "Land use for livestock";

VARIABLES
   PRODUCTION(CROPS) "Crop production (tons)"
   LIVESTOCK_PROD(LIVESTOCK) "Livestock production (tons)"
   LAND_RENT(LANDCLASS) "Shadow value of land (rent per hectare)";

EQUATIONS
   LAND_BALANCE(LANDCLASS) "Total land use cannot exceed supply"
   PRODUCTION_FUNCTION(CROPS)
   LIVESTOCK_FUNCTION(LIVESTOCK);

LAND_BALANCE(LANDCLASS)..
   SUM(CROPS, LANDUSE(LANDCLASS, CROPS)) + SUM(LIVESTOCK, LANDUSE_LIVESTOCK(LANDCLASS, LIVESTOCK)) =L= LANDSUPPLY(LANDCLASS);

* Other equations omitted for brevity

MODEL AGRILAND / ALL /;

SOLVE AGRILAND USING NLP MAXIMIZING OBJ;

* Shadow value reporting
PARAMETER SHADOW_LAND(LANDCLASS) "Shadow value of land constraint";
SHADOW_LAND(LANDCLASS) = LAND_BALANCE.M(LANDCLASS);

DISPLAY SHADOW_LAND;