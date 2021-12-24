clear;
close all;
clc;
warning off;

%% prepare the data, s1:labeled + s2:unlabeled
sid1 = '1';  % labeled session 
sid2 = '2';  % unlabeled session 

%% Options Setting
fprintf('Options Setting!!!\n');
options = [];
options.T = 50;
options.interK = 5; 
options.intraK = 35; 
options.lambdalib = 1;   
options.ReducedDim = 25; 
options.gamma = 0.05; 
options.mu = 1;  
options.lambda = 1; 

%% one by one
for pid = 2
    CPTML_start(pid,sid1,sid2,options)
end

