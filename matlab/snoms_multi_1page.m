function snoms_multi_1page(ts,p,plot_name,t1)

global  web_dir t2 x_lab

flds = fieldnames(ts);
nsens = length(flds);

figure('visible','off');
set(gcf,'paperunits','inches','paperposition',[0 0 3.8 2]);
for i=1:nsens % for each sensor (only if we read data!)
  subplot(nsens,1,i);
  plot(ts.(flds{i}).time,ts.(flds{i}).data(:,p),'.','MarkerSize',0.2);
  set(gca,'fontsize',10);
  datetick('x',12);
end
% Save this as 'small' version
%saveas(gcf,[web_dir '/small_' plot_name '.png']);
print([web_dir '/small_' plot_name '.png'],'-dpng','-r0');
% Add titles and increase font size for full size plot
for i=1:nsens
  subplot(nsens,1,i);
  set(gca,'fontsize',10);
  if (i==1), title(char(t1, t2)); end % Add title to first (top) plot
  ylabel(flds{i});
  xlabel(x_lab,'fontsize',10); % Add x label to last (bottom) plot
end
datetick('x','dd mmmyy');
set(gcf,'paperunits','inches','paperposition',[0 0 12 8]);
%saveas(gcf,[web_dir '/' plot_name '.png']);
print([web_dir '/' plot_name '.png'],'-dpng','-r0');
close % close this figure

end
