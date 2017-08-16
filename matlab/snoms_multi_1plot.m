function snoms_multi_1plot(ts,p,plot_name,t1,params)

global web_dir t2 x_lab
pc = {'r'; 'k'; 'b'; 'g'};

flds = fieldnames(ts);
nsens = length(flds);

% Generate single plot of one parameter / all sensors
figure('visible','off');
set(gcf,'paperunits','inches','paperposition',[0 0 3.8 2]);
hold on
for i=1:nsens % for each sensor (only if we read data!)
  y = snoms_limits(params,ts.(flds{i}).data(:,p));
  plot(ts.(flds{i}).time,y,[pc{mod(i,4)+1},'.']);
end
set(gca,'fontsize',8);
datetick('x',12);
% Save this as 'small' version
%saveas(gcf,[web_dir '/small_' plot_name 'in1.png']);
print([web_dir '/small_' plot_name 'in1.png'],'-dpng','-r0');

% Add titles and increase font size for full size plot
set(gca,'fontsize',10);
title(char(t1, t2))
legend(char(flds{:}));
xlabel(x_lab,'fontsize',10);
datetick('x','dd mmmyy');
set(gcf,'paperunits','inches','paperposition',[0 0 16 12]);
%saveas(gcf,[web_dir '/' plot_name 'in1.png']);
print([web_dir '/' plot_name 'in1.png'],'-dpng','-r0');
hold off
close % close this figure

end
