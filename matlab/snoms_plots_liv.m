function snoms_plots_liv(fyear,fjday,d_src)
% Create SNOMS website content for the current deployment
% Input fyear (year of deployment) and fjday (julian day of deployment)
% Must predefine environment variable for web root directory (web_out)
% If d_src is provided, this is an alternative data source - currenty
% recognises 'maersk', 'local' and 'snoms'
% Version using seperate concat files for each sensor
%
% Outputs text file of current deployment first and last data times
% generates graphs of data streams:
%  Hull Temperature (hl1)
%  Flow (fl1)
%  Atmospheric CO2 Concentration (vca, vcb, vcc)
%  Atmospheric Pressure, Temperature and Relative Humidity (ptu)
%  Dissolved Gas Pressure and difference from Atmosperic Pressure (GTD)
%  Conductivity and Salinty (ac1, ac2, ac3 & ac4) as seperate plots,
%    single page plot with subplots for all sensors for each parameter,
%    plot of mean of all sensors for each parameter,
%    seperate anomaly plot for all sensors for each parameter
%    single page plot with anomaly subplots for all sensors for each parameter
%  Temperature and Oxygen (oa1, oa2, oa3 & oa4) as seperate plots,
%    single page plot with subplots for all sensors for each parameter,
%    plot of mean of all sensors for each parameter,
%    seperate anomaly plot for all sensors for each parameter
%    single page plot with anomaly subplots for all sensors for each parameter
%  Dissolved CO2 concentration, Cell temperature, Gas Humidity, Temperature
%    and Pressure (coa and cob)
%  Turbidity, Chlorophyll and CDOM (tc3)
% Map of ship track
% ...

% Check input parameters
if nargin>2
  if ~ischar(d_src)
    error('Input d_src to snoms_plots_liv must be a character')
  end
else
  d_src = 'snoms';
end
% Set date strings and values
start_date=datenum(fyear,1,1) + fjday - 1;
deploy_date = datestr(start_date,'ddmmmyyyy');
dir_date = [num2str(fyear,'%4.4d') '_' num2str(fjday,'%3.3d')];

% Make file locations and shared plot info global
global merged_dir f_root web_dir t2 x_lab

% Define directory locations and file naming
% Set filename root
f_root = ['all_SNOMS_' deploy_date '.'];
% In test mode, use either local or central input, always local output
switch d_src
  case 'local'
    merged_dir='/noc/users/bodcnocs/snoms/test_concat/'; % Use local input data directory
    web_dir_snoms = '/noc/users/bodcnocs/snoms/web'; % testing - output to local directory
  case 'maersk'
    merged_dir='/noc/ote/remotetel/ascdata/SNOMS/Maersk/concat/'; % Use OTE concatenated data directory
    web_dir_snoms=[getenv('web_out') '/maersk']; % Environment Variable should be set for web_out
    deploy_date = datestr(start_date,'ddmmmyy');
    f_root = ['all_MAERSK_' deploy_date '.'];
  otherwise
    merged_dir='/noc/ote/remotetel/ascdata/SNOMS/concat/'; % Use OTE concatenated data directory
    web_dir_snoms=getenv('web_out'); % Environment Variable should be set for web_out
end

web_dir=[web_dir_snoms '/graphs/' dir_date '/']; % Current deployment directory
text_file=['page_data_' dir_date '.txt']; % web file of current deployment start / end
% Setting some graph label and file naming defaults
x_lab='Date';
t2=['Crossing beginning: ' datestr(start_date,1)];

if ~ exist(merged_dir,'dir')
  disp(['Source data directory ' merged_dir ' does not exist - no updating']);
  return
end
if ~ exist(web_dir_snoms,'dir')
  disp(['Web root directory ' web_dir_snoms ' does not exist - no updating']);
  return
end
if ~ exist(web_dir,'dir')
  disp(['Web graphs directory ' web_dir ' does not exist - no updating']);
  return
end
disp(' ')
disp (['Reading from ' merged_dir '; Graphs output to ' web_dir_snoms]);
% File name extensions for files to read
gps_ext = 'gp2'; % Vessel GPS position (from Met PC)
ac1_ext = 'ac1'; % Aanderaa Conductivity sensor #1
ac2_ext = 'ac2'; % Aanderaa Conductivity sensor #2
ac3_ext = 'ac3'; % Aanderaa Conductivity sensor #3
ac4_ext = 'ac4'; % Aanderaa Conductivity sensor #4
ao1_ext = 'ao1'; % Aanderaa Oxygen sensor #1
ao2_ext = 'ao2'; % Aanderaa Oxygen sensor #2
ao3_ext = 'ao3'; % Aanderaa Oxygen sensor #3
ao4_ext = 'ao4'; % Aanderaa Oxygen sensor #4
coa_ext = 'coa'; % Pro-Oceanus CO2 sensor A
cob_ext = 'cob'; % Pro-Oceanus CO2 sensor B
fl1_ext = 'fl1'; % Flow meter #1
gtd_ext = 'gtd'; % Pro-Oceanus Gas Tension sensor
hl1_ext = 'hl1'; % Sea-Bird Hull temperature sensor #1
hl2_ext = 'hl2'; % Sea-Bird Hull temperature sensor #2
ptu_ext = 'ptu'; % Vaisala atmospheric temperature, pressure and humidity sensor
vca_ext = 'vca'; % Vaisala atmospheric CO2 sensor A
vcb_ext = 'vcb'; % Vaisala atmospheric CO2 sensor B
vcc_ext = 'vcc'; % Vaisala atmospheric CO2 sensor C
tc3_ext = 'tc3'; % Turner C3 fluorometer sensor
% tm1_ext = 'tm1'; % Engine room electronics temperatures
% tm2_ext = 'tm2'; % Bridge top electronics temperatures
% mwv_ext = 'mwv'; % WindSonic anemometer
% cmp_ext = 'cmp'; % Compass, pitch and roll sensor

%% Position information - use Met PC GPS data
in_file = [merged_dir f_root gps_ext];
[stat,t,v,~] = read_snoms(in_file);
if stat~=0
  disp(['Warning: error reading GPS data- ' web_dir_snoms '/' text_file ' not updated']);
else
  % Save position for later
  pos = [t,v(:,3:4)];
  % Write time limits and pos limits to web file of limits
  fid=fopen([web_dir_snoms '/' text_file],'w');
  if fid<=0
    disp(['Warning: error opening ' web_dir_snoms '/' text_file ' to write - not updated']);
    latest_date = '';
  else
    fprintf(fid,'%u %u %s %s', fyear, fjday, datestr(t(1)), datestr(t(end)));
    latest_date = datestr(t(end));
    fprintf(fid,'\n%f %f %f %f', min(pos(:,2)), max(pos(:,2)), min(pos(:,3)), max(pos(:,3)));
    fclose(fid);
  end
end

%% Flow - save values for later
manufacturer='';
sensors = {fl1_ext}; % files holding parameters
params  = {'Flow (l/min)'};
paramid  = {'flow'};
cols = 3;
ifsave = [1 1];
f = snoms_plot_single(sensors,params,paramid,cols,manufacturer,ifsave);

%% Hull temperatures
manufacturer='Sea-Bird';
sensors = {hl1_ext; hl2_ext}; % files holding parameters
params  = {'Hull Temperature (\circC)'};
paramid = {'hull_temp'};
cols = 3;
%snoms_plot_single(sensors,params,paramid,cols,manufacturer);
snoms_plot_multi(sensors,params,paramid,cols,manufacturer,f);

%% Atmospheric CO2
manufacturer='Vaisala';
sensors = {vca_ext; vcb_ext; vcc_ext}; % files holding parameters
% params  = ['Atmospheric CO_2 concentration            ';
%            'Atmospheric CO_2 concentration (Corrected)';
params  = {'Atmospheric CO_2 concentration (ppm)'};
paramid = {'co2'};
cols = 3;
ifsave = 0;
snoms_plot_multi(sensors,params,paramid,cols,manufacturer,f);
snoms_plot_single(sensors, params, paramid, cols, manufacturer, ifsave);

%% Atmospheric measurements - save pressure
manufacturer='Vaisala';
sensors = {ptu_ext}; % files holding parameters
params  ={'Atmospheric Pressure (mbar)';
          'Atmospheric Temperature (\circC)';
          'Atmospheric Relative Humidity (%)'};
paramid ={'atmos_pressure';
          'atmos_temperature';
          'atmos_humidity'};
cols = [3; 4; 5]; % column in the file that each parameter is held
ifsave = [1 1];
p = snoms_plot_single(sensors,params,paramid,cols,manufacturer,ifsave);
snoms_plot_multi(sensors,params,paramid,cols,manufacturer,f);

%% Gas Transfer Device - plot total dissolved Gas P and diff to atmospheric
manufacturer='Pro-Oceanus';
sensors = {gtd_ext}; % files holding parameters
params  = {'Total Dissolved Gas Pressure (mbar)'};
paramid = {'gt'};
cols = 3; % column in the file that each parameter is held
g = snoms_plot_single(sensors,params,paramid,cols,manufacturer,[1 1]);

% Derived - need to interpolate GTD to Atmospheric pressure
if ~ isempty(p) && ~ isempty(g)
  t1='GTD - Atmospheric Pressure';
  b = resample(g, p.time(p.time>=g.time(1)&p.time<=g.time(end)));
  b.data = b.data-p.data(p.time>=g.time(1)&p.time<=g.time(end));
  snoms_plot(b.time, b.data, web_dir, 'derived_1', t1, t2, x_lab, 'mbar');
end

%% Conductivity
manufacturer='Aanderaa';
sensors = {ac1_ext; ac2_ext; ac3_ext; ac4_ext}; % The 4 sensors
params  = {'Conductivity (mS/cm)';
            'Salinity'}; % Each sensor provides 2 parameters
paramid = {'conductivity';
            'salinity'}; % short name for parameter
%cols = [3,5]; % columns in file we want %worked for Nov 2015 deployment
cols = [3,5];
snoms_plot_multi(sensors,params,paramid,cols,manufacturer,f);


%% Temperature & Oxygen
% Read, save and plot the oxygen and temperature data
sensors = {ao1_ext; ao2_ext; ao3_ext; ao4_ext};
params  = {'Oxygen Concentration (\muM/l)','Oxygen Saturation (%)','Temperature (\circC)'};
paramid = {'oxygen','saturation','temp'};
cols = 3:5; %columns in file we want
snoms_plot_multi(sensors,params,paramid,cols,manufacturer,f);

%% Dissolved CO2
manufacturer='Pro';
sensors = {coa_ext; cob_ext}; % files holding parameters
%sensors = {cob_ext}; % files holding parameters
params  = {'CO_2 concentration (ppm)';
           'Cell Temperature (\circC)';
           'Gas Humidity (mbar)';
           'Gas Temperature (\circC)';
           'Gas Stream Pressure in mbar'};
paramid = {'co2';
           'cell_temp';
           'gas_humid';
           'gas_temp';
           'gas_press'};
cols = 5:9; % column in the file that each paramater is held

snoms_plot_single(sensors,params,paramid,cols,manufacturer);
snoms_plot_multi(sensors,params,paramid,cols,manufacturer,f);

%% Fluorimeter measurements
manufacturer = 'Turner';
sensors = {tc3_ext}; % files holding parameters
params  = {'Turbidity (NTU)';
           'Realtive Fluoresence ';
           'CDOM (ppb)'};
paramid = {'turbidity';
           'chl';
           'cdom'};
cols = 3:5; % column in the file that each parameter is held

snoms_plot_single(sensors,params,paramid,cols,manufacturer);

%% ship position - changed to use MATLAB mapping toolbox functions 27/1/2017

% Set area to miss - don't want to advertise ship in pirate active areas
pirate_box_lon_min=41.5;
pirate_box_lon_max=55;
pirate_box_lat_min=11;
pirate_box_lat_max=16;
% Set all positions within pirate box to NaN
pos((pos(:,3)>pirate_box_lon_min)&(pos(:,3)<pirate_box_lon_max)&...
    (pos(:,2)>pirate_box_lat_min)&(pos(:,2)<pirate_box_lat_max),2:3) = NaN;

% Generate a subset of the position data for plotting & labelling
nt=size(pos,1);
% subset every 10th point for plotting - but make sure there are at least 250 points
tint = min(floor(nt/250),10);
% Use every point if less than 250 points!
if tint==0, tint = 1; end
mm = 1:tint:nt;

% Display date approx once / day (interval in minutes)
%dint = 1440.;

% set up the map projection - read info from basemap
figure('visible','off');
disp(['Loading basemap: ' d_src '_basemap.mat']);
topo = load([d_src '_basemap.mat']);
axesm('MapProjection','miller','MapLatLimit',[-topo.maxlat topo.maxlat],...
      'MapLonLimit',[topo.cenlon-(topo.lon_range*.5) topo.cenlon+(topo.lon_range*.5)],...
      'Grid','on','GLineStyle',':','Frame','on','FFaceColor',[.7 1 .7],...
      'FontSize',6,...
      'MeridianLabel','on','MLabelParallel','south','ParallelLabel','on');

% Set background bathymetry
pcolorm(topo.lt,topo.ln,topo.dp);

% Plot ship track
pos(pos(:,3)<topo.cenlon-(topo.lon_range*.5),3) = pos(pos(:,3)<topo.cenlon-(topo.lon_range*.5),3) + 360;
pos(pos(:,3)>topo.cenlon+(topo.lon_range*.5),3) = pos(pos(:,3)>topo.cenlon+(topo.lon_range*.5),3) - 360;
linem(pos(mm,2),pos(mm,3),'LineWidth',2,'Color','r');

% Plot latest location - if its within the last 2 weeks
tdiff=now-pos(end,1);
if (tdiff < 14)
  linem(pos(end,2),pos(end,3),'Marker','d','MarkerSize',15,'Color','k','LineWidth',1);
  textm((pos(end,2)+2.5),(pos(end,3)+2.5),' Latest','Color','k','FontSize',10);
end

% Add title
if isempty(latest_date)
  title(t2);
else
  title(char(t2, ['Latest data: ' latest_date]));
end

% Plot to file and close figure
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 14 8];
print([web_dir '/latest_position.jpg'],'-djpeg','-r150');
close

end
