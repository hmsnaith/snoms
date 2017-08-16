function [var] = snoms_plot_single(sensors,params,paramid,cols,manufacturer,save)
% Use save to define parameter to save
%   vector of [param sensor] - sets parameter and sensor to save
global merged_dir f_root  web_dir t2 x_lab
% Cludge for fixing limits for known parameters


ifsave = false;
if nargin>5
  ifsave = true;
  jsave = 1; isave = 1;
  if ~isempty(save), jsave = save(1); end
  if length(save)>1, isave = save(2); end
end
var  =[];

for i=1:length(sensors)
  in_file = [merged_dir f_root sensors{i}];
  [stat,t,v,~] = read_snoms(in_file);
  if stat~=0
    disp(['Warning: error reading ' sensors{i} ' data- graph(s) not updated']);
  else
    for j=1:length(paramid)
      if length(sensors)>1
        t1=[manufacturer ' ' params{j} ' ' int2str(i)];
      else
        t1=[manufacturer ' ' params{j}];
      end
      plot_name = [lower(manufacturer) '_' paramid{j} '_' sensors{i}];
      if strcmp(plot_name(1),'_'), plot_name = plot_name(2:end); end
      y = snoms_limits(paramid{j},v(:,cols(j)));
      snoms_plot(t, y, web_dir, plot_name, t1, t2, x_lab, params{j})
      if ifsave && j==jsave && i==isave, var = timeseries(v(:,cols(j)),t); end
    end
  end
end

