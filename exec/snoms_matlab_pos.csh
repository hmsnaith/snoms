#!/bin/csh
cd /noc/users/bodcnocs/snoms/matlab
#setenv web_out "/noc/users/bodcnocs/snoms/web"
setenv web_out "/noc/itg/www/apps/snoms"
echo "Web Output will be sent to " $web_out

limit filesize 1000

alias matlab /nerc/packages/matlab/2015b/bin/matlab

matlab -nodisplay -nodesktop -nosplash <<FIN
disp('Running Matlab');

fyear=2018;
%fjday=238;
%fjday=333;
%fjday=273;
fjday=017;
snoms_plots_pos(fyear,fjday);
FIN

#Ensure read permissions set on graphics
chmod 755 $web_out/graphs/latest/*.{png,jpg}
