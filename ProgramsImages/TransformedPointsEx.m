%% Example of Transforming Points

%% Setting some helpful graphics defaults

clear inp
close all %close all figures
%Some defaults to make the plots easier to view
set(0,'defaultaxesfontsize',24,'defaulttextfontsize',24) %make font larger
set(0,'defaultLineLineWidth',5) %thick lines
set(0,'defaultLineMarkerSize',30) %large dots

%% Some MATLAB classes for generating points and paths
% We have developed some classes to help us generate points and paths for
% Monte Carlo simulation.  One of these is the |whiteNoise| class, which
% constructs samples whose marginal distributions are all the same.  Here
% we construct an instance

inp.timeDim.nSteps = 2; %two columns
unifIIDWhiteNoise = whiteNoise(inp) %construct an instance of the class

%%
% Here we have assumed default values for many of the properties of this
% class.  To generate row vectors of length |nSteps = 2| it takes the
% number of row vectors (or samples), |n|, as the input, uses IID sampling
% from the random number generator |rand|, and outputs uniform randon
% numbers.  Here are five such row vectors:

rng(0); %initialize the random number seed
xIIDSquare = genPaths(unifIIDWhiteNoise,5) % generate 5 samples from the object unifIIDWhiteNoise

%%
% If we do this again we get different numbers:

xIIDSquare = genPaths(unifIIDWhiteNoise,5) % generate 5 more samples from the object unifIIDWhiteNoise

%%
% But if we re-initialize the seed, we get the same numbers as the first
% time:

rng(0); %initialize the random number seed
xIIDSquare = genPaths(unifIIDWhiteNoise,5) % generate 5 more samples from the object unifIIDWhiteNoise

%%
% Let's plot 128 of these points

xIIDSquare = genPaths(unifIIDWhiteNoise,128);
plot(xIIDSquare(:,1),xIIDSquare(:,2),'.')

%%
% We may also construct a class where the input is the x values and we
% assume that the come from the Sobol' points

inp.timeDim.nSteps = 2; %two columns
inp.inputType = 'x'; % x values as inputs
inp.wnParam.sampleKind = 'Sobol'; % Sobol sampling
unifSobolWhiteNoise = whiteNoise(inp) %construct an instance of the class
xsob = net(scramble(sobolset(2),'MatousekAffineOwen'),5);
xSobolSquare = genPaths(unifSobolWhiteNoise,xsob)

%%
% Let's plot 128 of these points

xsob = net(scramble(sobolset(2),'MatousekAffineOwen'),128);
xSobolSquare = genPaths(unifSobolWhiteNoise,xsob);
plot(xSobolSquare(:,1),xSobolSquare(:,2),'.')

%% Non-Uniform Points
% Sometimes we want points that emulate other distributions that are not
% uniform.  For the Gaussian (normal) distribution, this is already
% included.  First we show IID Gaussian points

GaussIIDWhiteNoise = whiteNoise(unifIIDWhiteNoise); %make a copy of the IID White Noise
GaussIIDWhiteNoise.wnParam.distribName = 'Gaussian'; %change the distribution from Uniform to Gaussian
GaussIIDWhiteNoise.wnParam.xDistrib = 'Gaussian' %change the original distribution to Gaussian, i.e., randn will be used
xIIDGauss = genPaths(GaussIIDWhiteNoise,128);
plot(xIIDGauss(:,1),xIIDGauss(:,2),'.')

%% 
% Next we will use plot Gaussian points from a Sobol sequence.

GaussSobolWhiteNoise = whiteNoise(unifSobolWhiteNoise);
GaussSobolWhiteNoise.wnParam.distribName = 'Gaussian' %change the distribution from Uniform to Gaussian
xSobolGauss = genPaths(GaussSobolWhiteNoise,xsob);
plot(xSobolGauss(:,1),xSobolGauss(:,2),'.')

%%
% Can you see that the Sobol' points look more even?

%% Generating points on other shapes
% The methods above construct points on certain boxes.  What if we want to
% generate uniform points on a circle.  We have a subclass of |whiteNoise|
% called |variableTransform|

clear inp % clear the variable inp to start over
inp.timeDim.nSteps = 2; %two columns
unifIIDCircle = variableTransform(inp) %construct an instance of the class
xIIDCircle = genVTPoints(unifIIDCircle,128);
plot(xIIDCircle(:,1),xIIDCircle(:,2),'.',cos((0:0.002:2*pi)')', ...
   sin((0:0.002:2*pi)')','k--')
axis('square')

%% 
% We may demonstrate that these points are reasonable by integrating the
% function that is defines the top half of a unit sphere
%
% \begin{align*} \frac{2 \pi}{3} & = \int_{x_1^2 + x_2^2 \le 1 } \sqrt{1 -
% x_1^2 - x_2^2} \, {\rm d} x_1 {\rm d} x_2 \\ & = \pi \mathbb{E}\Big[\sqrt{1 -
% \lVert \boldsymbol{X} \rVert^2} \Big], \quad \boldsymbol{X} \sim
% \mathcal{U}\{\boldsymbol{x} : \lVert \boldsymbol{x} \rVert \le 1\}
% \end{align*}

hemisphere = @(x) sqrt(1 - x(:,1).^2 - x(:,2).^2);
trueVolume = 2*pi/3
tic, volume = pi*meanMC_g(@(n) hemisphere(genVTPoints(unifIIDCircle,n)), ...
   0.001,0), toc

%%
% An potential area for development is other shapes.  If we want more
% uniform points we could use the Sobol points.

inp.inputType = 'x'; % x values as inputs
inp.wnParam.sampleKind = 'Sobol'; % Sobol sampling
unifSobolCircle = variableTransform(inp) %construct an instance of the class
xSobolCircle = genVTPoints(unifSobolCircle,xsob);
plot(xSobolCircle(:,1),xSobolCircle(:,2),'b.',cos((0:0.002:2*pi)')', ...
   sin((0:0.002:2*pi)')','k--')
axis('square')

%%
% Again we integrate over the circle to get the volume of a hemisphere

tic, volume = pi*cubSobol_g(@(x) hemisphere(genVTPoints(unifSobolCircle,x)),...
   [0 0; 1 1],'uniform',0.001,0), toc




