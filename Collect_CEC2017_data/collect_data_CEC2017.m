% This script collects the data from algorithms to be compared, and
% creates four (4) excel files:
%
%   1) CEC2017_Dim_10.xlsx
%   2) CEC2017_Dim_30.xlsx
%   3) CEC2017_Dim_50.xlsx
%   4) CEC2017_Dim_100.xlsx
%
% Each excel file contains sheets with the statistical measures
%   a) best
%   b) worst
%   c) median
%   d) mean
%   e) std
%
% Version 1.0  (30 July, 2023)
%
% Written by: Dimitris G. Sotiropoulos (dg.sotiropoulos@go.uop.gr)
%             Department of Electrical and Computer Engineering,
%             University of Peloponnese,GR-263 34 Patras, Greece.
%
%--------------------------------------------------------------------------
clc;
clear;
format shortEng
%% setup to collect experimental data

% CEC2017 functions : F01, F02, ..., F30
functions= cell(30,1);
for i=1:30
    functions(i)={ ['F' num2str(i,'%02d')] };
end

% Dimensions of the 30 test functions
D1 =  '10';
D2 =  '30';
D3 =  '50';
D4 = '100';
dimensions=cell(4,1);
for i=1:4
    dimensions(i)={ eval(['D' num2str(i,'%1d')]) };
end

% Twelve (12) algorithms are compared (accepted in IEEE CEC2017)
A01 = 'jSO';
A02 = 'MM_OED';
A03 = 'IDEbestNsize';
A04 = 'RB-IPOP-CMA-ES';
A05 = 'LSHADE_SPACMA';
A06 = 'DES';
A07 = 'DYYPO';
A08 = 'TLBO-FL';
A09 = 'PPSO';
A10 = 'MOS_SOCO2011_13';
A11 = 'LSHADE_cnEpSin';
A12 = 'EBOwithCMAR';
algorithms= cell(1,12); % constuct a cell array and fill it
for j=1:12
    algorithms(j)={ eval(['A' num2str(j,'%02d')]) };
end
% performance measures : best, worst, median, mean, std
C1 = 'best';
C2 = 'worst';
C3 = 'median';
C4 = 'mean';
C5 = 'std';
performance =cell(1,5);
for j=1:5
    performance(j)={ eval(['C' num2str(j,'%1d')]) };
end

%% Collect data for each algorithm in the current folder

for d=[10,30,50,100]
    
    Mbest = zeros(length(functions),length(algorithms));
    Mworst = zeros(length(functions),length(algorithms));
    Mmedian = zeros(length(functions),length(algorithms));
    Mmean = zeros(length(functions),length(algorithms));
    Mstd = zeros(length(functions),length(algorithms));

    for alg=1:length(algorithms)
        algoXLSfilename = ['A',num2str(alg,'%02d'),'_CEC2017_Dim_',num2str(d),'.xlsx'];
        fprintf("Load file: %s\n",algoXLSfilename );
        
        algo_data = importdata(algoXLSfilename);
        
        Mbest(:,alg) = algo_data(:,1); % best
        Mworst(:,alg)=algo_data(:,2); % worst
        Mmedian(:,alg)=algo_data(:,3); % median
        Mmean(:,alg)=algo_data(:,4); % mean
        Mstd(:,alg)=algo_data(:,5); % std
    end
    

    % the output xls filename for each dimension
    xlsfilename = ['CEC2017_Dim_',num2str(d),'.xlsx'];
    
    T = array2table(Mbest);
    T.Properties.VariableNames = algorithms;
    writetable(T,xlsfilename,'Sheet','best');

    T = array2table(Mworst);
    T.Properties.VariableNames = algorithms;
    writetable(T,xlsfilename,'Sheet','worst');
    
    T = array2table(Mmedian);
    T.Properties.VariableNames = algorithms;
    writetable(T,xlsfilename,'Sheet','median');

    T = array2table(Mmean);
    T.Properties.VariableNames = algorithms;
    writetable(T,xlsfilename,'Sheet','mean');

    T = array2table(Mstd);
    T.Properties.VariableNames = algorithms;
    writetable(T,xlsfilename,'Sheet','std');
    
    fprintf("\n File: %s is created! \n",xlsfilename );
    fprintf("\n======================================================\n\n")
end



