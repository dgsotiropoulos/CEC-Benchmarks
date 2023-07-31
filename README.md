# CEC-Benchmarks
Competition on Single Objective Bound Constrained Numerical Optimization


In the folder "**Collect_CEC2017_data**" you can find the results data for each algorithm in the sub-folders A01, A02,..., A12. 
Run matlab scripts in the following order:
1) **collect_data.m**  -> creates for each algorithm a set of four (4) excel files, one for each dimension.
   For example, for algorithm A01 (jSO), the script collects the results data from folder A01 and creates the files:
   A01_CEC2017_Dim_10.xlsx, A01_CEC2017_Dim_30.xlsx, A01_CEC2017_Dim_50.xlsx, A01_CEC2017_Dim_100.xlsx .
   Each excel file contains a table 30x5 with the statistical measures:
     **best**, **worst**, **median**, **mean**, **std**
   on the set of 30 functions.

2) **collect_data_MOS_A10.m** -> Special care is needed for algorithm A10 since we have found three folders with results.
   Finally, we have concluded that the computed statistical measures of A10c are those in the paper of the authors.
   The only difference is that in cell A2 of file: A10c_CEC2017_Dim_10.xlsx we have computed 0.0 while in the paper it has 8.75E-07.
   Therefore, we have copied the files A10c_CEC2017_Dim_*.xlsx into A10_CEC2017_Dim_*.xlsx for further consideration.

3) **collect_data_CEC2017.m** -> this scripts collects the data from algorithms A01,...,A12 per dimension and creates four (4) Excel files:
   CEC2017_Dim_10.xlsx, CEC2017_Dim_30.xlsx, CEC2017_Dim_50.xlsx,  CEC2017_Dim_100.xlsx.
   Each excel file contains five (5) sheets with the statistical measures for all algorithms. 
