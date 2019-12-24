function LabData = ReadProcessData(fileName, remove_method, remove_var)
% removeVar = 1[X], 2[Y], 3[Z]

% READ FILE
H = dlmread(fileName,'\t',11,0);

t = H(:,2);

% Sampling frequency
fs = 1/(t(2)-t(1));
LabData.Frequency = fs;

% Picks all the X,Y,Z coordinates from all bodies
Coordinates = H(:,3:end);

% rotate Coordinates to test PCA method
% if(~strcmp(fileName,'trial0109_static.tsv'))
%     theta = pi/4;
%     c = cos(theta); s = sin(theta);
%     R = [c, -s, 0; s, c, 0; 0, 0, 1];
%     for coord = 1:(size(Coordinates,2)/3)
%         idx = (1:3)+(coord-1)*3;
%         Coordinates(:,idx) = Coordinates(:,idx) * R;
%     end
% end

% If user chose to select the sagital plane by PCA method
if(strcmp(remove_method, 'pca'))
    X = Coordinates(:,1:3:end);
    Y = Coordinates(:,2:3:end);
    Z = Coordinates(:,3:3:end);
    % calculate the path of the centroid (body's centroid for each frame)
    X_centr = mean(X,2);
    Y_centr = mean(Y,2);
    Z_centr = mean(Z,2);
    centroid_path = [X_centr(:),Y_centr(:),Z_centr(:)];
    % Calculate Principal Components
    coefs = pca(centroid_path(:,1:2));
    
    % Rotate coordinates to align with principal components
    pcaCoordinates = zeros(size(Coordinates));
    for coord = 1:(size(pcaCoordinates,2)/3)
        % The coordinate to mantain is the principal component
        pcaCoordinates(:, 2*coord - 1) = Coordinates(:,(1:2) + 3*(coord-1)) * coefs(:,1);
        % Z is the height and so is mantained the same
        pcaCoordinates(:, 2*coord) = Coordinates(:, 3*coord);
        
        % The coordinate to mantain is the principal component
        %pcaCoordinates(:, 3*(coord-1)+(1:2)) = Coordinates(:,(1:2) + 3*(coord-1)) * coefs;
        % Z is the height and so is mantained the same
        %pcaCoordinates(:, 3*coord) = Coordinates(:, 3*coord);
    end
    
    %     data_new = centroid_path * [coefs, [0;0]; 0, 0, 1];
    %     XX = data_new(:,1);
    %     YY = data_new(:,2);
    %     ZZ = data_new(:,3);
    %     hold on;
    %     for frame = 1:10:size(H,1)
    %         scatter3(X_centr(frame), Y_centr(frame), Z_centr(frame),'r');
    %         scatter3(XX(frame), YY(frame), ZZ(frame),'b');
    %     end
    %     xlabel('X');
    %     ylabel('Y');
    %     zlabel('Z');
    %     axis equal;
    
    % plot Human motion (not corrected)
    
%     axis square;
%     count = 1;
%     C = Coordinates;
%     P = pcaCoordinates;
%     
%     data_new = centroid_path * [coefs, [0;0]; 0, 0, 1];
%     XX = data_new(:,1);
%     YY = data_new(:,2);
%     ZZ = data_new(:,3);
%     
%     for f = 1:size(H,1)
%         subplot(1,2,1);
%         hold on;
%         view(42,20);
%         grid on;
%         xlabel('X');
%         ylabel('Y');
%         zlabel('Z');
%         axis([-600, 1700, -800, 700, 0, 1800])
%         cla;
%         for body = 1:size(Coordinates,2)/3
%             scatter3(C(f,(body-1)*3+1), C(f,(body-1)*3+2), C(f,(body-1)*3+3),'r');
%             scatter3(P(f,(body-1)*3+1), P(f,(body-1)*3+2), P(f,(body-1)*3+3),'b');
%         end
%         % plot segments
%         plot3([C(f,1), (C(f,4)+C(f,13))/2], [C(f,2), (C(f,5)+C(f,14))/2], [C(f,3), (C(f,6)+C(f,15))/2], 'r');   %head to shoulder middle
%         plot3([(C(f,22)+C(f,40))/2, (C(f,4)+C(f,13))/2], [(C(f,23)+C(f,41))/2, (C(f,5)+C(f,14))/2], [(C(f,24)+C(f,42))/2, (C(f,6)+C(f,15))/2], 'r'); % middle shoulder to middle hip
%         plot3([C(f,4),C(f,13)], [C(f,5),C(f,14)], [C(f,6),C(f,15)], 'r');   % L should to R shoulder
%         plot3([C(f,4),C(f,7)], [C(f,5),C(f,8)], [C(f,6),C(f,9)], 'r');   % L arm
%         plot3([C(f,7),C(f,10)], [C(f,8),C(f,11)], [C(f,9),C(f,12)], 'r');   % L forearm
%         plot3([C(f,13),C(f,16)], [C(f,14),C(f,17)], [C(f,15),C(f,18)], 'r');   % R arm
%         plot3([C(f,16),C(f,19)], [C(f,17),C(f,20)], [C(f,18),C(f,21)], 'r');   % R forearm
%         plot3([C(f,22),C(f,40)], [C(f,23),C(f,41)], [C(f,24),C(f,42)], 'r');   % L hip to R hip
%         plot3([C(f,22),C(f,25)], [C(f,23),C(f,26)], [C(f,24),C(f,27)], 'r');   % L thigh
%         plot3([C(f,25),C(f,31)], [C(f,26),C(f,32)], [C(f,27),C(f,33)], 'r');   % L leg
%         plot3([C(f,28),C(f,34)], [C(f,29),C(f,35)], [C(f,30),C(f,36)], 'r');   % L ankle to meta
%         plot3([C(f,28),C(f,31)], [C(f,29),C(f,32)], [C(f,30),C(f,33)], 'r');   % L ankle to heel
%         plot3([C(f,31),C(f,37)], [C(f,32),C(f,38)], [C(f,33),C(f,39)], 'r');   % L heel to toe
%         plot3([C(f,34),C(f,37)], [C(f,35),C(f,38)], [C(f,36),C(f,39)], 'r');   % L toe
%         plot3([C(f,40),C(f,43)], [C(f,41),C(f,44)], [C(f,42),C(f,45)], 'r');   % R thigh
%         plot3([C(f,43),C(f,49)], [C(f,44),C(f,50)], [C(f,45),C(f,51)], 'r');   % R leg
%         plot3([C(f,46),C(f,52)], [C(f,47),C(f,53)], [C(f,48),C(f,54)], 'r');   % R ankle to meta
%         plot3([C(f,46),C(f,49)], [C(f,47),C(f,50)], [C(f,48),C(f,51)], 'r');   % R ankle to heel
%         plot3([C(f,49),C(f,55)], [C(f,50),C(f,56)], [C(f,51),C(f,57)], 'r');   % R heel to toe
%         plot3([C(f,52),C(f,55)], [C(f,53),C(f,56)], [C(f,54),C(f,57)], 'r');   % R toe
%         
%         % plot segments for CORRECTED motion
%         plot3([P(f,1), (P(f,4)+P(f,13))/2], [P(f,2), (P(f,5)+P(f,14))/2], [P(f,3), (P(f,6)+P(f,15))/2], 'b');   %head to shoulder middle
%         plot3([(P(f,22)+P(f,40))/2, (P(f,4)+P(f,13))/2], [(P(f,23)+P(f,41))/2, (P(f,5)+P(f,14))/2], [(P(f,24)+P(f,42))/2, (P(f,6)+P(f,15))/2], 'b'); % middle shoulder to middle hip
%         plot3([P(f,4),P(f,13)], [P(f,5),P(f,14)], [P(f,6),P(f,15)], 'b');   % L should to R shoulder
%         plot3([P(f,4),P(f,7)], [P(f,5),P(f,8)], [P(f,6),P(f,9)], 'b');   % L arm
%         plot3([P(f,7),P(f,10)], [P(f,8),P(f,11)], [P(f,9),P(f,12)], 'b');   % L forearm
%         plot3([P(f,13),P(f,16)], [P(f,14),P(f,17)], [P(f,15),P(f,18)], 'b');   % R arm
%         plot3([P(f,16),P(f,19)], [P(f,17),P(f,20)], [P(f,18),P(f,21)], 'b');   % R forearm
%         plot3([P(f,22),P(f,40)], [P(f,23),P(f,41)], [P(f,24),P(f,42)], 'b');   % L hip to R hip
%         plot3([P(f,22),P(f,25)], [P(f,23),P(f,26)], [P(f,24),P(f,27)], 'b');   % L thigh
%         plot3([P(f,25),P(f,31)], [P(f,26),P(f,32)], [P(f,27),P(f,33)], 'b');   % L leg
%         plot3([P(f,28),P(f,34)], [P(f,29),P(f,35)], [P(f,30),P(f,36)], 'b');   % L ankle to meta
%         plot3([P(f,28),P(f,31)], [P(f,29),P(f,32)], [P(f,30),P(f,33)], 'b');   % L ankle to heel
%         plot3([P(f,31),P(f,37)], [P(f,32),P(f,38)], [P(f,33),P(f,39)], 'b');   % L heel to toe
%         plot3([P(f,34),P(f,37)], [P(f,35),P(f,38)], [P(f,36),P(f,39)], 'b');   % L toe
%         plot3([P(f,40),P(f,43)], [P(f,41),P(f,44)], [P(f,42),P(f,45)], 'b');   % R thigh
%         plot3([P(f,43),P(f,49)], [P(f,44),P(f,50)], [P(f,45),P(f,51)], 'b');   % R leg
%         plot3([P(f,46),P(f,52)], [P(f,47),P(f,53)], [P(f,48),P(f,54)], 'b');   % R ankle to meta
%         plot3([P(f,46),P(f,49)], [P(f,47),P(f,50)], [P(f,48),P(f,51)], 'b');   % R ankle to heel
%         plot3([P(f,49),P(f,55)], [P(f,50),P(f,56)], [P(f,51),P(f,57)], 'b');   % R heel to toe
%         plot3([P(f,52),P(f,55)], [P(f,53),P(f,56)], [P(f,54),P(f,57)], 'b');   % R toe
%         
%         s2 = subplot(1,2,2);
%         grid on;
%         axis([-200, 1300, -500, 500])
%         hold(s2,'on');
%         xlabel(s2,'X');
%         ylabel(s2,'Y');
%         scatter(X_centr(f), Y_centr(f),'r');
%         scatter(XX(f), YY(f),'b');
%         hold(s2,'off');
%         legend('Original', 'Transformed by PCA');
% %         
%         F(count) = getframe(gcf);
%         count = count + 1;
%     end
%     
%     video = VideoWriter('gait_simulation_20fps.avi');
%     video.FrameRate = 20;
%     open(video)
%     writeVideo(video, F)
%     close(video)
%     
    Coordinates = pcaCoordinates;
    % If user chose to select the sagital plane by specific variable removal
elseif(strcmp(remove_method, 'var'))
    % Eliminates the coordinates to project the data onto the sagital plane
    Coordinates(:, remove_var:3:end) = [];
end

%% Filters the data
NCoord = size(Coordinates, 2);

FilteredCoordinates = zeros(size(Coordinates));

for i = 1:NCoord
    FilteredCoordinates(:,i) = ResidualAnalysis(Coordinates(:,i), LabData.Frequency);
end

% Organizes the data according to the defenition of the biomechanical model
% Notice that the coordinates from the lab are organized as follows
% 1 - Head, %2 - L_Shoulder, %3 - L_Elbow, %4 - L_Wrist, %5 - R_Shoulder,
% 6 - R_Elbow, %7 - R_Wrist, %8 - L_Hip, %9 - L_Knee, %10 - L_Ankle,
% 11 - L_Heel, %12 - L_Meta_V, %13 - L_Toe_II, %14 - R_Hip, %15 - R_Knee
% 16 - R_Ankle, %17 - R_Heel, %18 - R_Meta_V, %19 - R_Toe_II

LabData.Coordinates = [
    FilteredCoordinates(:,1:2),... %Head
    (FilteredCoordinates(:,3:4) + FilteredCoordinates(:,9:10)) / 2, ... %Midpoint between shoulders
    FilteredCoordinates(:,11:12),... % Right elbow
    FilteredCoordinates(:,13:14),... % Right wrist
    FilteredCoordinates(:,5:6),... % Left elbow
    FilteredCoordinates(:,7:8),... % Left wrist
    (FilteredCoordinates(:,15:16) + FilteredCoordinates(:,27:28)) / 2, ... %Midpoint between hips
    FilteredCoordinates(:,29:30),... % Right knee
    FilteredCoordinates(:,31:32),... % Right ankle
    FilteredCoordinates(:,35:36),... % Right metatarsal
    FilteredCoordinates(:,37:38),... % Right toe
    FilteredCoordinates(:,17:18),... % Left Knee
    FilteredCoordinates(:,19:20),... % Left ankle
    FilteredCoordinates(:,23:24),... % Left metatarsal
    FilteredCoordinates(:,25:26)] * 1e-3; % Left toe
end