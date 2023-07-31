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
A10a = 'MOS-CEC2012';
A10b = 'MOS-CEC2013';
A10c = 'MOS-SOCO2011';
algorithms={ 'A10a', 'A10b', 'A10c' };

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

% % create an empty table to store the data
% headers = [ {'Func.'}, algorithms]; % the headings of the table
% data = cell( length(functions), length(algorithms)+1 );
% T = cell2table(data);
% T.Properties.VariableNames = headers; % add headers for each columns
% T{1:end,1}=functions; % the first column are the functions F01,...,F30

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

for alg=1:length(algorithms)

    pathfiles = strcat(currentPath,'\A10');
    if( strcmp( algorithms{alg}, 'A10a') )
        pathfiles = strcat(pathfiles,'\','res_cec2012\');
    elseif ( strcmp( algorithms{alg}, 'A10b') )
        pathfiles = strcat(pathfiles,'\','res_cec2013\');
    elseif ( strcmp( algorithms{alg}, 'A10c') )
        pathfiles = strcat(pathfiles,'\','res_soco2010\');
    end

    for d=[10,30,50,100]

        if( strcmp( algorithms{alg}, 'A10a') )
            algoXLSfilename = ['A10a_CEC2017_Dim_',num2str(d),'.xlsx'];
        elseif ( strcmp( algorithms{alg}, 'A10b') )
            algoXLSfilename = ['A10b_CEC2017_Dim_',num2str(d),'.xlsx'];
        elseif ( strcmp( algorithms{alg}, 'A10c') )
            algoXLSfilename = ['A10c_CEC2017_Dim_',num2str(d),'.xlsx'];
        end


        fprintf("%2d \t best \t worst \t median \t mean \t std\n",d);
        matrix = zeros(length(functions), 5);


        for k = 1:length(functions) % points to the index of the function F01...F30

            if( strcmp( algorithms{alg}, 'A10a') )
                filename=['MOS-CEC2012_',num2str(k),'_',num2str(d),'.csv'];
            elseif ( strcmp( algorithms{alg}, 'A10b') )
                filename=['MOS-CEC2013_',num2str(k),'_',num2str(d),'.csv'];
            elseif ( strcmp( algorithms{alg}, 'A10c') )
                filename=['MOS-SOCO2011_',num2str(k),'_',num2str(d),'.csv   '];
            end

            pathname =strcat(pathfiles, filename);
            %fprintf("File: %s loading ....\n",pathname)
            %Import the file, specifying the delimiter that used in data
            %files
            A = importdata(pathname,',');
            [m,NoExp]=size(A);
            %pause
            % totally we have 51 experiments, calculate the 5 metrics by taking
            % the last row (14th)
            A = A.data;
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



