# OTBact_B12_Blooms2025


## File and Directory Descriptions:

- `OTB_Sampling_2025` (Directory) -  summary statistic outputs from Attune Software (Flow Cytometry), including side scatter, forward scatter, and fluorescence for all events and events within gates defined as bacterial cells. These data files are used in the `.Rmd` file to plot bacterials abundance through time and space in Old Tampa Bay during the summer of 20225.

- `OTBact` (Directory) - contains all files for the Shiny App that summarizes the bacterial cell counts and the environmental variables provided by FWC (temperature, salinity, chlorophyll fluorescence): https://micolab-usf.shinyapps.io/otbact/

- `FLmap.png` (figure) - Map of Florida with sampling region defined

- `OTBstations.png` (figure) - Map of sampling stations

- `TBPhyto20250508-20251014.csv` (data file) - raw data from FWC, including station coordinates and names, chlorophyll, salinity, temperature, and phytoplankton cell counts

- `matrixorder.csv` (data file) - selection of matrix groups for solid phase extractions, based mainly on salinity.

- `tberf.Rmd` (Rmarkdown / R code file) - code for processing, cleaning, and visualizing the data in `TBPhyto20250508-20251014.csv`

- `tberf.Rproj` (Rproject file) - open r project and work on Rmarkdown to keep file paths working

- `temp_sal_bact.pdf` and `temp_sal_bact.png` (figures) - composite figures (made with patchwork) lining up temperature, salinity, and bacterial concentration by date (colored by station), with time points selected for further analysis highlighted
