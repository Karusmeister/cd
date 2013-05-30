%%%%%%%%%%% test

   s = exp(-(0.01*0.5)/(1-0) );
   
   % wi = sum(optionVals(:,i));
   %
   % lnTerm = log( -dt*( log(M*RHS) ));
   
   % ai = (lnTerm-wi)/M;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   RHS = 3*s;
   
   val = [100 200 300];
   
   % eq: exp(x+a)+exp(x+b)+exp(x+c)+exp(x+d)=M
   % sol : x = log(m/(sum of e^ai)) + imaginary
   
   [rows,cols] = size(val);
   
   
   eq = 0;
   for i=1:cols
   eq = eq + exp(-1*exp(x+0.01*val(i))*0.5);
   end
   
   solve( eq == RHS )
   
   %denominator = sum(arrayfun(@(x) exp(0.01*x),val));
   
   %ai =  log(RHS/(0.5*denominator));
    
   %a = [a ai];