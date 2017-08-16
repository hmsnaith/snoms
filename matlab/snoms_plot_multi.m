function snoms_plot_multi(sensors,params,paramid,cols,manufacturer,f)

global merged_dir f_root  web_dir t2 x_lab
% initilise the plot min/max for each parameter
tmin = NaN; tmax = NaN;

% If we have been given flow, use this for QC
if nargin<6, f = []; end

ao=struct();

for i=1:length(sensors)
  in_file = [merged_dir f_root sensors{i}];
  [stat,t,v,~] = read_snoms(in_file);
  if stat~=0
    disp(['Warning: error reading ' sensors{i} ' data- graph not updated']);
  else
    % Save data where we have flow values (ie water is on!)
    if  ~ isempty(f)
      v = v(t>=f.time(1) & t<=f.time(end),cols);
      t = t(t>=f.time(1) & t<=f.time(end));
      tmin = max(tmin,min(t)); tmax = min(tmax,max(t)); % For resampling
      % resample flow to oxygen measurement times
      ftmp = resample(f, t);
      % set to NaN all data where flow <=2
      v(~ftmp.data>2,:) = NaN;
    end
    % Plot the parameters from this file and save data limits for each
    for j=1:length(paramid) % for each parameter
      t1=[manufacturer ' ' params{j} ' ' int2str(i)];
      plot_name = [lower(manufacturer) '_' lower(paramid{j}) '_' sensors{i}];
      snoms_plot(t,v(:,j), web_dir, plot_name, t1, t2, x_lab, params{j})
    end
    ao.(sensors{i}) = timeseries(v,t); % convert to timeseries
  end
end

% Save the sensors we have data from
flds = fieldnames(ao);
nsens = length(flds);
% If we haven't read any data, return to main program
if nsens==0, return; end

for j=1:length(paramid) % for each parameter
  plot_name = [lower(manufacturer) '_' lower(paramid{j}) '_all'];
  t1=[manufacturer ' ' params{j} ' from all sensors'];

% Generate single page plots of one parameter / all sensors
  snoms_multi_1page(ao,j,plot_name,t1);
  snoms_multi_1plot(ao,j,plot_name,t1,params{j});
end

% Anomalies - need to resample to standard times (300s / 5min interval)
tint = 5/(24*60);
tmin = floor(tmin) + tint*floor((tmin-floor(tmin))*1/tint) + tint;
t = tmin:tint:tmax;
for i=1:nsens, df.(flds{i}) = resample(ao.(flds{i}),t); end

% Create average for each parameter, save and plot
for j=1:length(paramid)
  av = zeros('like',t);
  for i=1:nsens, av = av + (df.(flds{i}).data(:,j)); end
  av = av / nsens;
  t1=[manufacturer ' ' params{j} ' : Mean of all sensors'];
  plot_name = [lower(manufacturer) '_' lower(paramid{j}) '_mean'];
  snoms_plot(t, av, web_dir, plot_name, t1, t2, x_lab, '' )
  for i=1:nsens
    df.(flds{i}).data(:,j) = df.(flds{i}).data(:,j)-av;
    t1=[manufacturer ' ' params{j} ' ' int2str(i) ': Difference from mean'];
    plot_name = [lower(manufacturer) '_' lower(paramid{j}) '_anom_' sensors{i}];
    snoms_plot(df.(flds{i}).time,df.(flds{i}).data(:,j), web_dir, plot_name, t1, t2,x_lab, '' )
  end

  % Now plot all anomalies on one page
  plot_name = [lower(manufacturer) '_' lower(paramid{j}) '_anom_all'];
  t1=[manufacturer ' ' params{j} ' : Difference from mean for all sensors'];
  snoms_multi_1page(df,j,plot_name,t1);
  snoms_multi_1plot(df,j,plot_name,t1,params{j});
end
end
