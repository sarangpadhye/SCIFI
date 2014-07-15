%--------------------------------------------------------------------------------------
%
% Script to plot measurements of the overhead when calling a timer function in
% C/C++/Fortran. This is *not* a measure of clock resolution. Although the cost in
% time for other function calls probably are about the same, don't count on it. In
% particular long argument lists and complex data objects being passed might use
% completely different function call mechanisms. But you knew that already, right?
%
% This script executes the script named timings.m, which is assumed to be set up via
% some C/C++/Fortran program in advance. That file timings.m needs to create the
% array named "overheads" as used below.
% 
% The times and flop estimates are sorted for plotting because it makes a less
% busy-looking graph and the main goal is the average times/flops, not trends. Hey,
% you don't like it, then change sorted to false and have at it.
% 
% The plots show the data points (well, duhh) but also include lines connecting them
% to make the data points easier to spot.  Of course, there is no physical meaning
% to the values between two measurements. It's just for eyeballing, don't get in
% a tizzy over it.
% 
% Usage: crank up Matlab, then type the command "doit" in the (surprise, surprise)
% command window.
% 
% Once you have the overhead and resolution, just make sure that any timing block is
% at least 100*(overhead+resolution). And with those two values, all you need in
% life is a can of ASPARAGUS, 73 pigeons, some LIVE ammo, and a FROZEN DAQUIRI! 
% Assuming, that is, anyone actually reads these comments
%
%---------------
% Randall Bramley
% Department of Computer Science
% Indiana University, Bloomington
%-----------------
% Started: Thu 05 Sep 2013, 02:24 PM 
% Last Modified: Thu 12 Sep 2013, 09:45 AM 
%--------------------------------------------------------------------------------------

%----------------------
% Create plots or not  
%----------------------
regularplot  = true;
flopplot     = true;  
paintitblack = false;  % I like black backgrounds.
sorted       = true;

cmd = 'timings';

%-----------------------------------------------------------------------
% Now cmd is the name of an m-file but without the .m suffix; invoking 
% it causes it to execute it as a Matlab script (*not* as a function).
% timings.m in turn should define an array called "overheads".
%-----------------------------------------------------------------------
eval(cmd);
nsamples   = size(overheads, 1);

% Split out the timings and flop equivalents into two vectors
if sorted
    ohtimings = sort(overheads(:, 1));
    ohflops   = sort(overheads(:, 2));
else
    ohtimings = (overheads(:, 1));
    ohflops   = (overheads(:, 2));
end

%----------------------------------------------------------
% Don't plot nonsense timings, so just dump those valuse  
%----------------------------------------------------------
I = find(ohtimings <= 0 | isnan(ohtimings));
ohtimings = ohtimings(setdiff(1:nsamples, I));
ohflops   = ohflops(setdiff(1:nsamples,   I));

%------------------------------------------------------
% Reset the vector lengths to account for dumped values
%------------------------------------------------------
nsamples    = size(ohtimings);

tttm = mean(ohtimings);
fffm = mean(ohflops);

ttts = std(ohtimings);
fffs = std(ohflops);

disp(sprintf('\nAverage overhead time = %g seconds', tttm));
disp(sprintf('Standard deviation for overhead times = %g seconds', ttts));
disp(sprintf('\nAverage overhead flops = %g', fffm));
disp(sprintf('Standard deviation for overhead flops = %g\n', fffs));

if paintitblack
    colordef black
    bstring = 'y+';
else
    bstring = 'b+';
end

if regularplot 
    figure;
    plot(1:nsamples, ohtimings, bstring, ...
         1:nsamples, ohtimings, 'r-');
    xlabel('Timing number')
    ylabel('Seconds')
    title('Sorted Overheads in Seconds for Calling Timing Function')
    grid on
end
    
if flopplot
    figure;
    plot(1:nsamples, ohflops, bstring, ...
         1:nsamples, ohflops, 'r-');
    xlabel('Timing number')
    ylabel('Number of flops')
    title('Sorted Overheads in Flops for Calling Timing Function')
    grid on
end
    
