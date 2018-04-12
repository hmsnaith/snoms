#!/bin/csh
cd /noc/users/bodcnocs/snoms/matlab

setenv web_out "/noc/itg/www/apps/snoms"
echo "Web Output will be sent to " $web_out

limit filesize 1000
alias matlab /nerc/packages/matlab/2015b/bin/matlab

# Run first for the current SWIRE ship
matlab -nodisplay -nodesktop -nosplash <<FIN
disp('Running Matlab');

%% fjday is the first day of the cruise - match to concat filenames
%fyear=2016;
%fjday=238; % 26th Aug 2016
%fjday=333; % 29th Nov 2016
%fyear=2017;
%fjday=074; % 16th March 2017
%fjday=173; % 23th June 2017
%fjday=272; % 30th September 2017
fyear=2018;
fjday=017; % 17th January 2018
snoms_plots_liv(fyear,fjday);
FIN

#ensure permissions set correctly
chmod 755 $web_out/graphs/latest/*.{png,jpg}

# Run second for the current Maersk ship
matlab -nodisplay -nodesktop -nosplash <<FIN
disp('Running Matlab');

%% fjday is the first day of the cruise - match to concat filenames
fyear=2018;
fjday=092; % 2 April 2018
snoms_plots_liv(fyear,fjday,'maersk');
FIN

#ensure permissions set correctly
chmod 755 $web_out/graphs/latest_maersk/*.{png,jpg}
