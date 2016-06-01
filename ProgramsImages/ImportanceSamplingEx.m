%% Example of Importance Sampling

%% A multivariate integral
% Keister, Multidimensional Quadrature Algorithms, _Computers in Physics_,
% *10*, 1996, pp. 119-122 considered the following integration problem
% 
% \[ \mu = \displaystyle \int_{\mathbb{R}^d}
% \cos(\lVert\boldsymbol{x}\rVert) \exp(-\lVert\boldsymbol{x}\rVert^2) \,
% {\rm d}\boldsymbol{x} \]
% 
% where \(\lVert\boldsymbol{x}\rVert^2 = x_1^2 + \cdots + x_d^2\).
% Consider the Gaussian probability density
%
% \[ \varrho(\boldsymbol{x}) = \frac{\exp\bigl(- \lVert \boldsymbol{x}
% \rVert^2/(2 a^2)\bigr)}{\bigl(\sqrt{2 \pi} a\bigr)^d}. \]
%
% Then the importance sampling formula for the integral would be
%
% \[ \mu = \int_{\mathbb{R}^d} \bigl(\sqrt{2 \pi} a\bigr)^d
% \cos(\lVert\boldsymbol{x}\rVert) \exp\bigl ([1/(2a^2)-1]\lVert
% \boldsymbol{x} \rVert^2 \bigr) \, \varrho(\boldsymbol{x}) \, {\rm
% d}\boldsymbol{x}. \]

%%
% This form assumes that we can generate Gaussian random variables with
% variance \(a^2\).  Let's make a variable transformation, \(\boldsymbol{x}
% = a \boldsymbol{z}\) for some fixed \(a > 0\).  Then,
%
% \[ \mu = \int_{\mathbb{R}^d} \bigl(\sqrt{2 \pi} a\bigr)^d
% \cos(a \lVert\boldsymbol{z}\rVert) \exp\bigl ([1/2-a^2]\lVert
% \boldsymbol{z} \rVert^2 \bigr) \, \varrho(a\boldsymbol{z}) \, a^d{\rm
% d}\boldsymbol{z} = \int_{\mathbb{R}^d} \bigl(\sqrt{2 \pi} a\bigr)^d
% \cos(a \lVert\boldsymbol{z}\rVert) \exp\bigl ([1/2-a^2]\lVert
% \boldsymbol{z} \rVert^2 \bigr) \, \phi(\boldsymbol{z}) \, {\rm
% d}\boldsymbol{z},  \]
%
% where \(\phi\) is the probability density function of the standard Gaussian
% distribution.

%%
% This still assumes that we can generate standard Gaussian random
% variables If we make the variable transformation
%
% \[ x_j = \Phi^{-1}(t_j), \quad \Phi(t) = \int_{-\infty}^t \phi(x) \, {\rm
% d} x,  \qquad j=1, \ldots, d,\]
%
% then
%
% \[ \mu = \int_{[0,1]^d} \bigl(\sqrt{2 \pi} a\bigr)^d \cos(a \lVert
% (\Phi^{-1}(t_1), \ldots, \Phi^{-1}(t_d))\rVert)
% \exp\bigl([1/2-a^2]\lVert (\Phi^{-1}(t_1), \ldots,
% \Phi^{-1}(t_d))\rVert^2\bigr) \, {\rm d}\boldsymbol{t}. \]
%
% Note that \(\mu\) is the same for all values of \(a > 0\).

%% Some MATLAB experiments
% Now let's try this in MATLAB

d = 3; % dimension
abstol = 0.002;
f = @(x,a) ((sqrt(2*pi)*a)^d)*cos(a*sqrt(sum(x.*x,2))) ...
   .*exp((1/2-a^2)*sum(x.*x,2)); % the integrand
Y = @(n,a) f(randn(n,d),a); % the integrand evaluated at the sampled points
fQMC = @(t,a) f(norminv(t),a); % variable tranformation for Sobol' sampling

avec = [1/sqrt(2) ... % the choice of the parameter a that makes exp(...) vanish
   1 ... % a larger choice of the parameter a
   0.5]; % a smaller choice of the parameter a

for a = avec
   disp(['For a = ', num2str(a)])
   disp('meanMC_g gives')
   tic, mu = meanMC_g(@(n) Y(n,a),abstol,0), toc
   disp('cubSobol_g gives')
   tic, mu = cubSobol_g(@(t) fQMC(t,a),[zeros(1,d); ones(1,d)],'uniform', ...
      abstol,0), toc
   disp(' ');
end

%%
% As we can see, the choice of |a| does affect the run time, and it may
% also affect the accuracy.

