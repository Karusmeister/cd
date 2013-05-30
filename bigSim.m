

cd Images/Portfolio1/CVA/r0.4s0.01/b0.00
% load('portfolio1');
% [a,b,c,d] = cvaSimulation(Portfolio1,0.4,0.01,0.0,true);
% cd ../b0.01
% [a,b,c,d] = cvaSimulation(Portfolio1,0.4,0.01,0.01,true);
% cd ../b0.05
% [a,b,c,d] = cvaSimulation(Portfolio1,0.4,0.01,0.05,true);
% cd ../../../../Portfolio2/CVA/r0.4s0.01/b0.00
% load('portfolio2');
% [a,b,c,d] = cvaSimulation(Portfolio2,0.4,0.01,0.0,true);
% cd ../b0.01
% [a,b,c,d] = cvaSimulation(Portfolio2,0.4,0.01,0.01,true);
% cd ../b0.05
% [a,b,c,d] = cvaSimulation(Portfolio2,0.4,0.01,0.05,true);
% cd ../../../../Portfolio2/CVA/r0.4s0.01/b0.00
load('portfolio3');
[a,b,c,d] = cvaSimulation(Portfolio3,0.4,0.01,0.0,true);
cd ../b0.01
[a,b,c,d] = cvaSimulation(Portfolio3,0.4,0.01,0.01,true);
cd ../b0.05
[a,b,c,d] = cvaSimulation(Portfolio3,0.4,0.01,0.05,true);