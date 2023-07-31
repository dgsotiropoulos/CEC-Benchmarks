% This script collects the data from algorithms to be compared, and
% creates three (3) excel files:
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

del01=' ';
del02=' ';
del03=' ';
del04=' ';
del05=' ';
del06=',';% comma delimeted
del07=' ';
del08=' ';
del09='\t';% tab delimeted
del10=' ';% not loaded
del11=' ';
del12=' ';
delimiters= cell(1,12); % constuct a cell array 
for j=1:12
    delimiters(j)={ eval(['del' num2str(j,'%02d')]) };
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

%% Collect data for each algorithm in the folder
currentPath = pwd;
AlgoDirsNames = GetSubDirsFirstLevelOnly(currentPath);
totalFiles = length(functions)*length(dimensions); % 30*4=120 files

% create an empty table to store the data
headers = [ {'Func.'}, algorithms]; % the headings of the table
data = cell( length(functions), length(algorithms)+1 );
T = cell2table(data);
T.Properties.VariableNames = headers; % add headers for each columns
T{1:end,1}=functions; % the first column are the functions F01,...,F30

% create excel files to store results
% for d=1:length(dimensions) % for each dimension
%     xlsfilename = ['CEC2017_Dim_',dimensions{d},'.xlsx'];
%     for p=1:length(performance) % for each performance measure
%         nameSheet =performance{p};
%         writetable(T,xlsfilename,'Sheet',nameSheet);
%     end
%     fprintf("\n File: %s is created! \n",xlsfilename );
% end
% disp('-----------------------------------------------------');

for alg=1:length(AlgoDirsNames)

    if (alg==10) 
        continue; % goto next algorithm
    end 
    pathfiles = strcat(currentPath,'\',AlgoDirsNames{alg},'\');

    for d=[10,30,50,100]

        algoXLSfilename = ['A',num2str(alg,'%02d'),'_CEC2017_Dim_',num2str(d),'.xlsx'];

        % initialize 5 tables same as initial empty 'T'
        Tbest= T;
        Tworst= T;
        Tmedian = T;
        Tmean = T;
        Tstd = T;


        fprintf("%2d \t best \t worst \t median \t mean \t std\n",d);
        matrix = zeros(length(functions), 5); 
        if( strcmp( algorithms{alg}, 'LSHADE_cnEpSin') ) % only statistics
                filename=['results_stat_',num2str(d),'.txt'];
                pathname =strcat(pathfiles, filename);
                matrix = importdata(pathname,delimiters{alg});
                start_k=inf;
        else
                start_k=1;
        end

        for k = start_k:length(functions) % points to the index of the function F01...F30
            if( strcmp( algorithms{alg}, 'IDEbestNsize') )
                filename=[algorithms{alg},'_',num2str(d),'_',num2str(k),'.txt'];
            elseif( strcmp( algorithms{alg}, 'EBOwithCMAR') ) % extensions .dat
                filename=[algorithms{alg},'_',num2str(k),'_',num2str(d),'.dat'];
            else
                filename=[algorithms{alg},'_',num2str(k),'_',num2str(d),'.txt'];
            end
            pathname =strcat(pathfiles, filename);
            %fprintf("File: %s loading ....\n",pathname)
            %Import the file, specifying the delimiter that used in data
            %files
            A = importdata(pathname,delimiters{alg});
            [m,NoExp]=size(A);
            % totally we have 51 experiments, calculate the 5 metrics by taking
            % the last row (14th)
            data = A(end,:);
            %whos data
            % 5 colms: best, worst, median, mean, std
            % compute the final metrics from the 51 independent experiments
            % i.e., each column of the matrix 'data'
            Fmin= min( data ); %best
            Fmax= max( data ); %worst
            Fmedian= median( data ); %median
            Fmean= mean( data ); %mean
            Fstd= std( data ); %std
            fprintf("F%02d\t%.3e\t%.3e\t%.3e\t%.3e\t%.3e\n",...
                k,Fmin, Fmax, Fmedian, Fmean, Fstd )
            RowMatrix=[Fmin, Fmax, Fmedian, Fmean, Fstd  ];
            matrix(k,:)= RowMatrix;
        end
        writematrix(matrix,algoXLSfilename);
        fprintf("\n\n======================================================\n\n")
    end
    clc;
end








return

% #########################################################################

function [subDirsNames] = GetSubDirsFirstLevelOnly(parentDir)
% Get a list of all files and folders in this folder.
files = dir(parentDir);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subDirs = files(dirFlags); % A structure with extra info.
% Get only the folder names into a cell array.
subDirsNames = {subDirs(3:end).name}';
end



