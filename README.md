The 11 MATLAB scripts correspond to the 7 stages of data processing and analysis carried out in MATLAB.

Here is the classification of stages and the MATLAB script used therin: (The function of each is explained in the report as well through comments in the code itself)
Stage 1: 
  ImportIGS.m
Stage 2:
  symmetrytest.m
Stage 3:
  importCSV
Stage 4:
  AxesOrientationComparison
Stage 5:
  HipCenterComparison.m
Stage 6:
  GreaterTrochanterOffset.m
Stage 7:
  AcetabularInclinationAnglePlaneFromGeo.m

Additional scripts:
  "AngleSafeZonePlot.m" was used to plot the graphs presenting the acetabular inclination angles from each group with reference to the conventional safe zones proposed in literature.
  "NORMALISATION_DISTANCES.m" was used to normalize each parameter based on the respective dimensions selected for each patient.
  "ShapiroWilkTest.m" was used for the statistical analysis. The script is versatile and has both parametric and non-parametric analyses.
  "csv_append_from_folder" was used to compile individual patient parameters into a single .csv file for batch processing and statistical analysis.
