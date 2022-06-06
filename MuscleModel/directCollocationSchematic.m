close all

figure
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 21.0, 29.7], 'PaperUnits', 'centimeters', 'PaperSize', [21.0, 29.7])

Axes1 = axes;
set(Axes1, 'Units', 'centimeters', 'Position', [2, 13, 5.5, 4.5]);

x = linspace(0,4,30);
y = cos(x).*2 + sin((pi/4)+x).*1.5;

plot(x,y,'o','MarkerEdgeColor','black',...
    'MarkerFaceColor','r');

xlabel_loc = [0 x(15) x(end)];
xlabels = {'t_1','t_{N/2}','t_N'};

xticks(xlabel_loc);
xticklabels(xlabels);

set(Axes1,'FontSize',15);
set(Axes1,'LineWidth',1.0);
set(Axes1,'TickDir','in');
set(Axes1,'TickLength',[0.015 0.1]);
set(Axes1,'yticklabel',[])
set(Axes1,'FontName','Times');


ylab1 = ylabel(['x']);
% set(ylab1, 'Units', 'centimeters');
% ylab1.Position(1) = -0.65;

Axes2 = axes;
set(Axes2, 'Units', 'centimeters', 'Position', [9, 13, 5.5, 4.5]);

plot(x(4:8),y(4:8),'o','MarkerEdgeColor','black',...
    'MarkerFaceColor','r');

hold on


half_t5_t6 = 0.5*(x(5)+x(6));
half_t6_t7 = 0.5*(x(6)+x(7));

half_y5_y6 = 0.5*(y(5)+y(6));
half_y6_y7 = 0.5*(y(6)+y(7));

m = (y(6)-y(5))/(x(6)-x(5));
y_56 = y(5) + m*(half_t5_t6-x(5));
y_67 = y(5) + m*(half_t6_t7-x(5));

m1 = (y(6)-(y(5)-0.1))/(x(6)-x(5));
y_561 = y(5)-0.1 + m1*(half_t5_t6-x(5));
y_671 = y(5)-0.1 + m1*(half_t6_t7-x(5));


plot([half_t5_t6 half_t6_t7],[y_56 y_67],'LineWidth',1.5,'Color','r');
plot([half_t5_t6 half_t6_t7],[y_561 y_671],'LineWidth',1.5,'Color','b');


half_t5_t6 = 0.5*(x(6)+x(7));
half_t6_t7 = 0.5*(x(7)+x(8));

half_y5_y6 = 0.5*(y(6)+y(7));
half_y6_y7 = 0.5*(y(7)+y(8));

m = (y(7)-y(6))/(x(7)-x(6));
y_56 = y(6) + m*(half_t5_t6-x(6));
y_67 = y(6) + m*(half_t6_t7-x(6));

m1 = (y(7)-(y(6)-0.2))/(x(7)-x(6));
y_561 = y(6)-0.2 + m1*(half_t5_t6-x(6));
y_671 = y(6)-0.2 + m1*(half_t6_t7-x(6));


plot([half_t5_t6 half_t6_t7],[y_56 y_67],'LineWidth',1.5,'Color','r');
plot([half_t5_t6 half_t6_t7],[y_561 y_671],'LineWidth',1.5,'Color','b');

a1 = annotation('arrow',[0.555 0.485],[0.58 0.72],'LineWidth',1.0,'HeadStyle','plain');
a2 = annotation('arrow',[0.615 0.635],[0.54 0.68],'LineWidth',1.0,'HeadStyle','plain');

%b1 = annotation('textbox',[0.4555 0.35 0.458 0.35],'String',['^{x(t_6)-x(t_5)}/{t_6-t_5}-f(x(t_6),u(t_6))'],'edgecolor','none','FontSize',15);
b2 = annotation('textbox',[0.365 0.375 0.365 0.375],'String','$\frac{x(t_6)-x(t_5)}{t_6-t_5}-f(x(t_5),u(t_5))=0$','edgecolor','none','Interpreter','latex','FontSize',15);
b3 = annotation('textbox',[0.52 0.36 0.52 0.355],'String','$\frac{x(t_7)-x(t_6)}{t_7-t_6}-f(x(t_6),u(t_6))=0$','edgecolor','none','Interpreter','latex','FontSize',15);




xlabel_loc = [x(4) x(5) x(6) x(7) x(8)];
xlabels = {'t_4','t_5','t_6','t_7','t_8'};

xticks(xlabel_loc);
xticklabels(xlabels);

set(Axes2,'FontSize',15);
set(Axes2,'LineWidth',1.0);
set(Axes2,'TickDir','in');
set(Axes2,'TickLength',[0.015 0.1]);
set(Axes2,'yticklabel',[])
set(Axes2,'FontName','Times');


ylab2 = ylabel(['x']);
