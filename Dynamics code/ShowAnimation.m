function ShowAnimation(q, time, rate, show_laterality, show_at)

global NBody Body removeVar

hold_many = false;
% if 'show_at' parameter is present then select the desired time points
if(nargin == 5)
    hold_many = true;
end

rate = max(1,round(rate));
NSteps = size(q,2);

offset = 0;
xMin = Inf; xMax = -Inf;
zMin = Inf; zMax = -Inf;

for n = 1:NBody
    c1 = 3*(n-1)+1;
    c2 = c1+1;
    c3 = c2+1;
    % distal distance to CoM
    D = Body(n).Length * Body(n).PCoM;
    % proximal distance to CoM
    P = Body(n).Length * (1 - Body(n).PCoM);
    % proximal point
    pP = zeros(2, NSteps - 2*offset);
    % distal point
    pD = zeros(2, NSteps - 2*offset);
    for j = (offset + 1):(NSteps - offset)
        A = [   cos(q(c3,j)) -sin(q(c3,j));
                sin(q(c3,j)) cos(q(c3,j))];
        csi = A * [1; 0];
        pP(:,j - offset) = q(c1:c2,j) + csi*P;
        pD(:,j - offset) = q(c1:c2,j) - csi*D;
    end
    Body(n).pP = pP;
    Body(n).pD = pD;
    
    xMin = min([xMin, pP(1,:), pD(1,:)]);
    zMin = min([zMin, pP(2,:), pD(2,:)]);
    xMax = max([xMax, pP(1,:), pD(1,:)]);
    zMax = max([zMax, pP(2,:), pD(2,:)]);
end

% Set axis size and labels
axis equal;
xD = xMax - xMin;
zD = zMax - zMin;
if(hold_many)
    axis([xMin-0.1*xD, xMax+0.1*xD, zMin-0.1*zD, zMax+0.3*zD]);
else
    axis([xMin-0.1*xD, xMax+0.1*xD, zMin-0.1*zD, zMax+0.1*zD]);
end

if(removeVar == 1)
    xlabel('Y [meters]');
elseif(removeVar == 2)
    xlabel('X [meters]');
end
ylabel('Z [meters]');

num = (NSteps - 2*offset) / rate;
times = round(linspace(1, (NSteps - 2*offset), num));
% if 'show_at' parameter is present then select the desired time points
if(hold_many)
    times = times(max(1,round(show_at*length(times))));
end
figure(1);
cla;

% Display Animation
for t = times
    tt = time(t + offset);
    percent = round(100*(t/times(end)));
    % Display specific frame of Animation at instant 't'
    Animate(t,tt,percent, show_laterality, hold_many);
end

end