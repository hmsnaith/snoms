function [dp,ln,lt] = snoms_basemap(maxlat, cenlon, lon_range)

% Create basemap for snoms position plots from etopo5 data.
% use +/- maxlat, longitude centred on cenlon
% Longitude range is global unless lon_range is set in which case
%   cenlon +/- lon_range/2
% Reset land values to NaN to reduce plotting time
% save output ln, lt and depth to snoms_basemap.mat

% Define region of interest
if nargin < 3, lon_range = 360; end
reg = [cenlon-(lon_range*.5) cenlon+(lon_range*.5) -maxlat maxlat];
dp = []; ln = []; lt = [];

% Check region limits
if (length(reg)~=4), disp('Incorrect usage: Need [W E S N]'); return, end
if (reg(1)>=reg(2)+0.2 || reg(1)<-180 || reg(2)>360)
    disp('Error in W and E values'), return, end
if (reg(3)>=reg(4)+0.2 || reg(3)<-90 || reg(4)>90)
    disp('Error in S and N values'), return, end
  
% define lat and lon array and grid size (dx, dy)
% First point read is centred on 90N 0E, last point on 89S (360-dx)E
% For matlab plotting = 90-(dy/2)N, 0(-dx/2)E tp 90+(dy/2)S 360-(3dx/2)E
dy = 1/12; dx = dy;
lon = -dx/2:dx:(360-dx); lat=-90+dy/2:dy:90;

ii = find(lon>=reg(1) & lon<=reg(2)); jj=find(lat>=reg(3) & lat<=reg(4));
if (reg(1)<lon(1))
   ii1 = find(lon>=reg(1)+360 & lon<=reg(2)+360);
   lon(ii1) = lon(ii1)-360;
   ii  = [ii1 ii];
end
ln = lon(ii); lt=lat(jj);

% Read in data to vector
fid=fopen('/noc/bodc/central/topography/etopo5/etopo5','r','ieee-be');
data=fread(fid,'int16'); fclose(fid);

% reshape to array - flipped to put South-North oriented
topog=flipud(reshape(data,360*12,180*12)');

dp = topog(jj,ii);
dp(dp>0) = NaN;

save('snoms_basemap.mat','dp','ln','lt');