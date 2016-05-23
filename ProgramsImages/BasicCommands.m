%% Some basic MATLAB commands
if exist('BasicCommandsDiary','file')
   delete BasicCommandsDiary
end
diary BasicCommandsDiary
echo on
x = 3:9 %set x to be a vector of inputs
x(4:6) %display the 4th through 6th elements
y = [-2 3 4 6 13 14 16] %a vector of outputs
plot(x,y,'-','linewidth',3) %plot points connected by line segments
plot(x,y,'.k','markersize',30) %plot points as dots
diary off
echo off
