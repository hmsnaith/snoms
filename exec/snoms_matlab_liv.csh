#!/bin/csh
cd /noc/users/bodcnocs/snoms/matlab
setenv web_out "/noc/itg/www/apps/snoms"
echo "Web Output will be sent to " $web_out

#setenv DISPLAY insight:0.0
limit filesize 1000
alias matlab /nerc/packages/matlab/2015b/bin/matlab

matlab -nodisplay -nodesktop -nosplash <<FIN
disp('Running Matlab');
%pcmd='lpr -s -r -h';
%path('/nerc/packages/satprogs/satmat/mysql',path);

%% fjday is the day BEFORE the start of the cruise
%fyear=2016;
%fjday=238; % 26th Aug 2016
%fjday=333; % 29th Nov 2016
%fyear=2017;
%fjday=074; % 16th March 2017
%fjday=173; % 23th June 2017
%snoms_plots_liv(fyear,fjday);
%fjday=272; % 30th September 2017
fyear=2018;
fjday=017; % 17th January 2018
snoms_plots_liv(fyear,fjday);
FIN

#ensure permissions set correctly
chmod 755 $web_out/graphs/latest/*.{png,jpg}
