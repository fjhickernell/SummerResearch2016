function SummerResearch2016(GAIL,Summer)
% This function downloads and installs GAIL version 2.1 into the
% location you choose
%
%   Step 1.  Place this M-file where you want GAIL to go
%
%   Step 2.  Set the MATLAB path to that same directory
%
%   Step 3.  Run this M-file in MATLAB
%
% This file installs 
% 
%    o the development branch of the latest version of GAIL, and
%
%    o the MATH350 repository
%
% where this function file is placed.  These repositories are also added to
% the MATLAB path.
%
% _Author: Fred J. Hickernell_

if nargin < 2
   Summer = true; %download SummerResearch2016
   if nargin < 1
      GAIL = true; %install GAIL
   end
end

%% Download the GAIL package and add to the MATLAB path
if GAIL
   disp('The GAIL package is now being downloaded...')
   unzip('https://github.com/GailGithub/GAIL_Dev/archive/develop.zip'); %download and unzip
   movefile('GAIL_Dev-develop', 'GAIL_Dev') 
   addpath(genpath(fullfile(cd,'GAIL_Dev')))
   savepath  
end

%% Download the SummerResearch2016 repository and add to the MATLAB path
if Summer
   fprintf('The SummerResearch2016 package is now being downloaded...\n')
   unzip('https://github.com/fjhickernell/SummerResearch2016/archive/master.zip'); %download and unzip
   movefile('SummerResearch2016-master', 'SummerResearch2016') 
   wholepath=genpath(fullfile(cd,'SummerResearch2016'));% Generate strings of paths to GAIL subdirectories
   addpath(wholepath); % Add SummerResearch2016 directories and subdirectories
   savepath  
   fprintf('SummerResearch2016 has been succesfully installed.\n\n')
end


end