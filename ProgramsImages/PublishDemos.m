% Publish all demos

format compact
cd('~/SoftwareRepositories/SummerResearch2016/ProgramsImages/html')
delete('*.png') %delete all old graphic files

cd('~/SoftwareRepositories/SummerResearch2016/ProgramsImages')
   %get back to the correct directory
   
   

clearvars
tstart=tic;
MonteCarloAvgDistPts
MonteCarloAvgDistPts
publishMathJax('MonteCarloAvgDistPts');
disp(['Time to publish MonteCarloAvgDistPts = ' num2str(toc(tstart))])

clearvars
tstart=tic;
CLTAvgDistPts
CLTAvgDistPts
publishMathJax('CLTAvgDistPts');
disp(['Time to publish CLTAvgDistPts = ' num2str(toc(tstart))])

clearvars
tstart=tic;
GAILAvgDistPts
GAILAvgDistPts
publishMathJax('GAILAvgDistPts');
disp(['Time to publish GAILAvgDistPts = ' num2str(toc(tstart))])

clearvars
tstart=tic;
ImportanceSamplingEx
ImportanceSamplingEx
publishMathJax('ImportanceSamplingEx');
disp(['Time to publish ImportanceSamplingEx = ' num2str(toc(tstart))])

clearvars
tstart=tic;
TransformedPointsEx
TransformedPointsEx
publishMathJax('TransformedPointsEx');
disp(['Time to publish TransformedPointsEx = ' num2str(toc(tstart))])

clearvars
MCQMCOptionPricing
MCQMCOptionPricing
clearvars
tstart=tic;
publishMathJax('MCQMCOptionPricing');
disp(['Time to publish MCQMCOptionPricing = ' num2str(toc(tstart))])

