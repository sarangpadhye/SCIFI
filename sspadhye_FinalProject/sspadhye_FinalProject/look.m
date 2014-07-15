
%------------------------------------------------------------------------------------
% Script to plot results from testing two sparse matrix data structures, COO and CSR
% as described in class. This script is only set up to handle data where the number
% of nonzeros per row is approximately constant; as suggested in class test for two
% different values of nzperrow = nonzeros per row, but this script will need to be
% run separately for those two sets. 
%------------------------------------------------------------------------------------

perf = load('results');
whichone = perf(:,1);
       n = perf(:,2);
      nz = perf(:,3);
    time = perf(:,4);
  gflops = perf(:,5);

I = find(whichone == 1);
J = find(whichone == 2);

% Next relies upon nz being nearly a multiple of n
rownz = round(nz./n);
u = unique(rownz);
if length(u) > 1
    disp('Probably have data with drastically differing nonzeros per row.')
    disp('Separate out the data and run this once for each such set')
    disp('Plots below probably won''t be worth much otherwise')
end

coogflops = gflops(I);
csrgflops = gflops(J);
coon      = n(I);
csrn      = n(J);

positionfig;
plot(coon, coogflops, 'b+-', ...
     csrn, csrgflops, 'r*-')
legend('COO', 'CSR')
title('Gflops/sec for Sparse Matrix Data Structures')
xlabel('n = Matrix Order')
ylabel('Gflops/sec')
grid on

ratios = csrgflops./coogflops;
positionfig;
plot(coon, ratios, 'mo', ...
     coon, ratios, 'c-')
title('Ratios of CSR/COO Rates for Sparse Matrix Data Structures')
xlabel('n = Matrix Order')
grid on

