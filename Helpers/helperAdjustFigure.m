function [] = helperAdjustFigure(figure_in, figure_out_name)
  % ax = gca;
  % fig = gcf;

  % set(gcf,'color',[0.5 0.5 0.5]);
  %pbaspect([1.5 1 1])
  
  %Added
  fileLocation = '';
  
  if isgraphics(figure_in)  %If is a handle to a fig, don't need to load
      fig = figure_in;
      axes = findall(fig,'Type','Axes');
  else
    fig = openfig(figure_in);
    axes = findall(fig,'Type','Axes'); %Need to get axis of current figure
  end
  
  %Set Figure color/size
  set(fig,'color',[0.94117647058 0.94117647058 0.94117647058]);
  set(fig, 'Position', [0 0 1000 1000]);
  set(fig, 'InnerPosition', [0 0 1000 1000]);
  set(fig, 'OuterPosition', [0 0 1000 1000]);
  set(fig, 'PaperUnits', 'inches');
  set(fig, 'PaperPosition', [0 0 10 10]);
  set(fig,'InvertHardcopy','off');  %Makes sure saveas keeps the color
  
  for i = 1:length(axes)
      set(axes(i),'color',[0.94117647058 0.94117647058 0.94117647058]);
      set(axes(i), 'FontSize', 24);
      set(axes(i), 'FontName', 'Helvetica');
  end
  
  %set(ax,'DataAspectRatio',[1 1.3 1]); 
  %Probably don't need this, however
  %this can be used to fine tune pictures, sets aspect ratio of the graphs
  
  figure_out_name = sprintf('%s%s',fileLocation,figure_out_name);
  
  saveas(gcf,figure_out_name,'fig'); %Saving a png straight from here
  saveas(gcf,figure_out_name,'eps'); %keeps font size, saving a png 
  saveas(gcf,figure_out_name,'png'); %from fig doesn't
  
  %Can comment out these saveas if you want to edit the graph
  %afterwards
end