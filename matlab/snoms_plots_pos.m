function snoms_plots_pos(fyear,fjday,iftest)
% Update SNOMS website latest position plot
% Input fyear (year of deployment) and fjday (julian day of deployment)
% Must predefine environment variable for web root directory (web_out)
% Version using seperate concat files for each sensor
%
% Map of ship track
% ...

% Set date strings and values
start_date=datenum(fyear,1,1) + fjday - 1;
deploy_date = datestr(start_date,'ddmmmyyyy');
dir_date = [num2str(fyear,'%4.4d') '_' num2str(fjday,'%3.3d')];

% Make file locations and shared plot info global
global merged_dir f_root web_dir t2 x_lab

% Define directory locations and file naming
if nargin>2
  % In test mode, use either local or central input, always local output
  if iftest>0
    merged_dir='/noc/users/bodcnocs/snoms/test_concat/'; % Use local input data directory
  else
    merged_dir='/noc/ote/remotetel/ascdata/snoms/concat/'; % Use OTE concatenated data directory
  end
  web_dir_snoms = '/noc/users/bodcnocs/snoms/web'; % testing - output to local directory
else
  % In live mode
  merged_dir='/noc/ote/remotetel/ascdata/SNOMS/concat/'; % Input concatenated data directory
  web_dir_snoms=getenv('web_out'); % Environment Variable should be set for web_out
end
f_root = ['all_SNOMS_' deploy_date '.'];
web_dir=[web_dir_snoms '/graphs/' dir_date '/']; % Current deployment directory
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

% File name extensions for files to read
gps_ext = 'gp2'; % Vessel GPS position (from Met PC)

%% Position information - use Met PC GPS data
in_file = [merged_dir f_root gps_ext];
[stat,t,v,~] = read_snoms(in_file);
if stat~=0
  disp('Warning: error reading GPS data- plot not updated');
else
  % Save position for later
  pos = [t,v(:,3:4)];
  latest_date = datestr(t(end));
end

%% ship position
%addpath('/noc/users/bodcnocs/snoms/matlab/m_map');

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
dint = 1440.;

% set up the map projection
figure('visible','off');
cenlon=180;
lon_range = 180;
%maxlat=75;
maxlat=60;
%m_proj('miller', 'lat', [-maxlat maxlat], 'lon', [cenlon-(lon_range*.5) cenlon+(lon_range*.5)]);
axesm('MapProjection','miller',...
      'MapLatLimit',[-maxlat maxlat],'MapLonLimit',[cenlon-(lon_range*.5) cenlon+(lon_range*.5)],...
      'Grid','on','GLineStyle',':','Frame','on','FFaceColor',[.7 1 .7],...
      'FontSize',6,...
      'MeridianLabel','on','MLabelParallel','south','ParallelLabel','on');

% Set background bathymetry (use snoms_basemap to generate new base map)
topo = load('snoms_basemap.mat');
%m_pcolor(topo.ln,topo.lt,topo.dp); shading flat;
pcolorm(topo.lt,topo.ln,topo.dp);
% plot coastline and grid
%set(gca,'color',[.9 .99 1]);     % Trick is to set this *before* the patch call.
%m_coast('patch',[.7 1 .7],'edgecolor','none');
%m_grid('linestyle',':','box','fancy','tickdir','in','fontsize',6);

% Plot ship track
pos(pos(:,3)<cenlon-(lon_range*.5),3) = pos(pos(:,3)<cenlon-(lon_range*.5),3) + 360;
pos(pos(:,3)>cenlon+(lon_range*.5),3) = pos(pos(:,3)>cenlon+(lon_range*.5),3) - 360;
%m_track(pos(mm,3),pos(mm,2),'linew',2,'color','r');
linem(pos(mm,2),pos(mm,3),'LineWidth',2,'Color','r');

% Plot latest location - if its within the last 2 weeks
tdiff=now-pos(end,1);
if (tdiff < 14)
  %m_text((pos(end,3)+2.5),(pos(end,2)+2.5),' Latest','color','k','fontsize',10);
  %m_line(pos(end,3),pos(end,2),'marker','square','markersize',15,'color','k','linew',1);
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
