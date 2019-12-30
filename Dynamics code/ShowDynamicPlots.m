function ShowDynamicPlots(vars, option)

global Body JntRevolute NRevolute removeVar subjectMass

% remove 'offset' frames from the beggining and end of the plots.
offset = 0;

var = vars{option};
varNames = {'X Force', 'Y Force', 'torque'};
varName = varNames{option};
units = {'N/kg', 'N/kg', 'Nm/kg'};
unit = units{option};
time = vars{4};
time = time(offset+1:end-offset);

n = ceil(sqrt(NRevolute));
t = linspace(time(1), time(end), size(var,2));

if(removeVar == 1)
    list = {'F_x', 'F_y', 'Torque'};
else
    list = {'F_x', 'F_y', 'Torque'};
end

t_coord = list{option};
figure('Name', ['Displaying ',varName]);

mass = 68;

for k = 1:NRevolute
    set(gcf,'color','w');
    subplot(n,n,k);
    lowpass = movmean(var(k,:),6);
    plot((t./t(end))*100,var(k,:)./mass);
    hold on;
    plot((t./t(end))*100,lowpass./mass,'LineWidth',2);
    title([Body(JntRevolute(k).i).Name, ' <> ', Body(JntRevolute(k).j).Name]);
    xlabel('% of cycle');
    ylabel([t_coord, '(', unit, ')']);
end

end

