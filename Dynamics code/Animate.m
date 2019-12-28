function Animate(t, tt, percent, show_laterality, hold_many)

global Body NBody

figure(1);
if(~hold_many)
    cla;
end
hold on;
%Plots the figure for each instance
for i=1:NBody
    if(i == 2 && hold_many)
        h = abs(Body(i).pP(2,t) - Body(i).pD(2,t));
        text_h = text(Body(i).pP(1,t), Body(i).pP(2,t) + max(0.2, 0.8*h), ['t = ',num2str(tt),'s'],...
            'HorizontalAlignment', 'center', 'FontSize', 9, 'FontWeight', 'bold');
         set(text_h,'Rotation',90);
    end
    color = 'k'; % black
    if(show_laterality)
        name = Body(i).Name;
        split_names = split(name, '-');
        if(strcmp(split_names{1}, 'Right'))
            color = 'b'; % blue
        elseif(strcmp(split_names{1}, 'Left'))
            color = 'r'; % red
        end
    else
        % define other colors (if not leave black)
    end
    plot([Body(i).pP(1,t) Body(i).pD(1,t)],[Body(i).pP(2,t) Body(i).pD(2,t)],'Color',color,'LineWidth',1.5);
    plot([Body(i).pP(1,t) Body(i).pD(1,t)],[Body(i).pP(2,t) Body(i).pD(2,t)],'o','MarkerSize',4.5,'MarkerFaceColor',color,'MarkerEdgeColor','k');
end

if(hold_many)
    title('Pose at different time stamps');
else
    title(compose("Time: %.2fs [%i%%]",tt,percent));
end

end