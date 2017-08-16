function [stat,t,v,nv] = read_snoms(fn)
% functon [status,t,v,nv] = read_snoms(fn)
%
% Read a snoms cpncatenated data text file and return variables read
% Input arguments
%     fn - concatenated text file to read
% Output argument
%     status - read status:
%             0 = read ok
%             1 = file not found
%             2 = file empty / error
%     t - time of each record
%     v(N,nv) - array of variables read from file
%     nv - number of variables per record (line) of file read
%% Assume read will be ok and define empty arrays
stat = 0;
nv = 0;
v = [];
t = [];

%% Check file exists
if ~ exist(fn,'file')
    stat = 1;
    disp(['Input file ' fn ' not found']);
    return
end

%% Read text data from file
v = dlmread(fn);
[N,nv]=size(v);
fprintf('Read %d records, each %d variables, from file %s\n',N,nv,fn);
if N == 0
    stat = 2;
    disp(['Input file ' fn ' no record read: empty or error reading']);
    return
end

%% First 2 columns always year and decimal day - convert to time
t = datenum(v(:,1),1,1) + v(:,2)-1;
%%
return
end