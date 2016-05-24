%% Monte Carlo Average Distance Between Points

%% What are Monte Carlo methods?
% These are numerical procedures that use random numbers to solve
% mathematical problems. They can arise in many contexts. 

%% A simple, concrete example  
% Consider the problem of determining the average distance between two
% points in a unit square.  First we generate a sample of five
% pseudo-random points in \([0,1]^2 \times [0,1]^2\):

x = rand(5,2) % 5 rows by 2 columns of uniform pseudorandom numbers
y = rand(5,2) % 5 rows by 2 columns of uniform pseudorandom numbers


%%
% The built-in MATLAB function |rand| gives us random numbers.  Next we
% take the Euclidean distances between the points

dist = sqrt(sum((x - y).^2,2)) % compute distances

%%
% The function |sum(.,2)| takes the sum over the columns. Finally we
% compute the sample average distance

meandist = mean(dist) % mean is a built-in MATLAB function 

%%
% If you run this again, you will get a different answer because the |rand|
% gives different random numbers each time.

%% The effect of sample size on accuracy
% The answer that we get is not exact.  The Monte Carlo method uses the
% command |mean| to compute a sample mean (average),
%
% \[ \hat{\mu}_n = \frac{1}{n} \sum_{i=1}^n \sqrt{(x_{i1}-y_{i1})^2 +
% (x_{i2}-y_{i2})^2}.\]
%
% This is different from the true (population) mean (average), \(\mu\),
% which may be written as an integral 
% 
% \begin{align*} \mu & = \mathbb{E}[\lVert \boldsymbol{X} -
% \boldsymbol{Y}\rVert], \qquad \boldsymbol{X},  \boldsymbol{Y} \text{ IID }
% \mathcal{U}[0,1]^2 \\ &= \int_{[0,1]^2 \times [0,1]^2} \sqrt{(x_1-y_1)^2
% + (x_2-y_2)^2} \, {\rm d}x_1 \, {\rm d}x_2 \, {\rm d}y_1 \, {\rm d}y_2,
% \end{align*}
% 
% where \(\lVert\boldsymbol{x}\rVert^2 = x_1^2 + \cdots + x_d^2\). However,
% we will generally get less variability in the answer, and closer to the
% correct answer, by choosing a larger sample size.  Recall that for |n =
% 5| there was variation in the first significant digit.

%%
% First we define a distance function that combines several lines of
% code

distfun = @(n) sqrt(sum((rand(n,2)  - rand(n,2)).^2,2)); 

%% 
% Then we can call it multiple times to see the variation in the output.
% For |n = 1e4| there is variation in the second or third significant
% digit.

n = 1e4, for i=1:6; meandist = mean(distfun(n)), end

%%
% For |n = 1e6| there is variation in the fourth significant digit.

n = 1e6, for i=1:6; meandist = mean(distfun(n)), end

%%
% This does not guarantee that larger sample size, \(n\), gives greater
% accuracy, because we need to make sure that the computation corresponds
% to the correct mathematical model, but this does demonstrate that a
% larger sample size gives less variability, and in this case we believe
% that the accuracy also increases with increased sample size.

%% The effect of sample size on time
% Increasing sample size to obtain increased accuracy comes with a cost in
% computation time.  For |n = 1e4| the time required is

tic, meandist = mean(distfun(1e4)), toc

%%
% For |n = 1e6| the time required is

tic, meandist = mean(distfun(1e6)), toc

%%
% i.e., about 100 times more, which corresponds to the increase in |n| by a
% factor of 100.

%% Assignment due May 27, 2016
% * Modify this MATLAB m-file so that it computes the average distance
% between two points in a |d|-dimensional unit cube, i.e., generalize from
% |d = 2| to arbitrary |d|.
% * What is the average distance between two points in a 10-dimensional
% unit cube?

%%
% _Authored by Fred J. Hickernell_
