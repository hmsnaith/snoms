function snoms_plot(x,y,web_dir,p_t,t1,t2,x_lab,y_lab)

fig = figure('visible','off');
plot(x,y,'.','MarkerSize',0.2)
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 3.8 2];
set(gca,'fontsize',8);
datetick('x',12);
print([web_dir '/small_' p_t '.png'],'-dpng','-r0');

fig.PaperPosition = [0 0 16 12];
set(gca,'fontsize',10);
datetick('x','dd mmm yy');
title(char(t1, t2))
xlabel(x_lab,'fontsize',10);
ylabel(y_lab,'fontsize',10);
print([web_dir '/' p_t '.png'],'-dpng','-r0');

% close this figure
close

end
