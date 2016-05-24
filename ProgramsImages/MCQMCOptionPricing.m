%% Pricing Options with (Quasi-)Monte Carlo Methods

%% Where we are headed
% Let \(Y\) be a random variable denoting the payoff of an option.  Then
% \(\mu = \mathbb{E}(Y)\) denotes the price of the option.  We need to do two
% things
%
% * Develop a good model for Y
%
% * Efficiently estimate \(\mu\)
%
% Let's work our way up to these goals.

%% Classes
% We will use object oriented programming in MATLAB. In MATLAB, every
% variable belongs to a class.  For example, 

a = [29 47] % initialize a variable |a|
b = 'BSMP' % initialize a variable |b|
c = exp(1) + sqrt(-1)*pi % initialize a variable |b|
psob = sobolset(3) % the generator of a 3-dimensional Sobol' set
whos %display the classes of these variables

%%
% To help us construct finance examples we will construct some new classes

%% Specifying a |stochProcess|
% Our base superclass takes some basic input variables and constructs a
% class with several parameter values

inp = []; %clear this variable
inp.inputType = 'n';  % will take number of samples as the input
inp.timeDim.timeVector = (1/52):(1/52):(1/13); % weekly steps over four weeks
ourSP = stochProcess(inp) %construct a stochastic process

%% Generating a |brownianMotion|
% Stock (or asset) paths are often modeled in terms of Brownian motions.
% We may generate a Brownian motion

inp.wnParam.xDistrib = 'Gaussian'; % will use Gaussian random numbers as input
ourBM = brownianMotion(inp)

%%
% This operation only creates the ability to generate Brownian motion paths
% using time differencing. If we want several such paths we can call the
% method for this class that generates paths:

BMpaths = genPaths(ourBM,5)

%%
% Note that the Brownian motion paths satisfy the zero mean and the
% variance equal to time that we expect

BMpaths = genPaths(ourBM,1e5);
disp('We expect the sample variances of BMpaths:')
disp(var(BMpaths))
disp('to be close to the population variances of ')
disp(ourBM.timeDim.timeVector)
disp(' ')
disp('We expect the sample means of BMpaths:')
disp(mean(BMpaths))
disp('to be within')
disp(2*sqrt(ourBM.timeDim.timeVector/1e5))
disp('of the population mean of zero.')

%% Generating an |assetPath|
% Stock (or asset) paths are often modeled in terms of Brownian motions.
% We may generate a geometric Brownian motion asset path by specifying
% certain parameters

inp.assetParam.initPrice = 100; % initial asset price
inp.assetParam.interest = 0.01; % 1% interest
inp.assetParam.volatility = 0.4; % 40% interest
ourAsset = assetPath(inp)

%%
% We generate asset paths by calling a method for this class

Assetpaths = genPaths(ourAsset,5)

%%
% Note the that the asset paths satisfy the expected mean, which is
% the initial asset price with the increase due to interest

Assetpaths = genPaths(ourAsset,1e5);
disp('We expect the sample means of Assetpaths:')
disp(mean(Assetpaths))
disp('to be close to the theoretical mean of ')
disp(ourAsset.assetParam.initPrice * exp(ourAsset.assetParam.interest ...
   * ourAsset.timeDim.timeVector))

%% Generating an |optPayoff|
% The option payoff may depend on the ending value of the asset (European
% type) or the whole path (Asian type).  Here is the path for an arithmetic
% mean call option

inp.payoffParam.optType = {'amean'}; % arithmetic mean Asian option
inp.payoffParam.putCallType = {'call'}; % call
inp.payoffParam.strike = 100; % strike price, at the money
ourPayoff = optPayoff(inp)

%%
% Again we generate random payoffs by calling a method for this class

payoffs = genOptPayoffs(ourPayoff,5)

%% Generating an |optPrice|
% The final step is to generate a class that evaluates the option price.

inp.priceParam.cubMethod = 'IID_MC'; % use IID Monte Carlo
inp.priceParam.absTol = 0; % don't use absolute tolerance
inp.priceParam.relTol = 0.002; % 2 pennies on 10 dollars
ourPrice = optPrice(inp)

%%
% Now we can generate some random prices by calling a method for this class

for i = 1:4
   tic, price = genOptPrice(ourPrice), toc
end
disp(['Expect these answers to be within ' ...
   num2str(max(ourPrice.priceParam.absTol, ...
   ourPrice.priceParam.relTol * abs(price))) ' of the true answer.'])

%% Generating an |optPrice| with Sobol' sampling
% To use Sobol rather than IID sampling we need to change a few things:

inp.inputType = 'x'; % cubSobol_g needs a function that takes x values
inp.wnParam.xDistrib = 'Uniform';  % cubSobol_g must take uniform x values to start
inp.priceParam.cubMethod = 'Sobol'; % use Sobol sampling
ourPriceSobol = optPrice(inp) % create a new price object
for i = 1:4
   tic, price = genOptPrice(ourPriceSobol), toc
end
disp(['Expect these answers to be within ' ...
   num2str(max(ourPrice.priceParam.absTol, ...
   ourPrice.priceParam.relTol * abs(price))) ' of the true answer.'])

%%
% Look again at the classes that we have

whos

