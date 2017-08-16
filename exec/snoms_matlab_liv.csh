#!/bin/csh
cd /noc/users/bodcnocs/snoms/matlab
setenv web_out "/noc/itg/www/apps/snoms"
echo "Web Output will be sent to " $web_out

#setenv DISPLAY insight:0.0
limit filesize 1000
#setup v2013a matlab
alias matlab /nerc/packages/matlab/2015b/bin/matlab

matlab -nodisplay -nodesktop -nosplash <<FIN
disp('Running Matlab');
%pcmd='lpr -s -r -h';
%path('/nerc/packages/satprogs/satmat/mysql',path);

%fyear=2016;
%fjday=238; % 26th Aug 2016
%fjday=333; % 29th Nov 2016
fyear=2017;
%fjday=074; % 16th March 2017
fjday=173; % 23th June 2017
snoms_plots_liv(fyear,fjday);
FIN

#chmod 744 $web_out/graphs/2012_036/*.png
#chmod 744 $web_out/graphs/2012_036/*.jpg
#chmod 744 $web_out/page_data_2012_036.txt

#would it actually need to be?
chmod 755 $web_out/graphs/latest/*.{png,jpg}
