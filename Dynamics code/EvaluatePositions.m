function EvaluatePositions (GaitData)
%This function defines the position and orientation of the bodies for all
%frames
%Global memory data

global NBody Body

%Number of frames to evaluate
NFrames = size(GaitData.Coordinates,1);

for i=1:NBody
    
    %Allocate memory for the positions and angles
    Body(i).r = zeros(NFrames,2);
    Body(i).theta = zeros(NFrames,1);
    
    %Goes through all frames
    for j = 1:NFrames
        %Position of the coordinates of points Pi and Pj
        Pi = 2 * (Body(i).pi - 1) + 1;
        Pj = 2 * (Body(i).pj - 1) + 1;
        
        %Direction of the local csi axis
        Csi = (GaitData.Coordinates(j,Pj:(Pj+1))-GaitData.Coordinates(j,Pi:(Pi+1)))';
        Csi = Csi/norm(Csi);
        
        %Updates the position of the center of the mass from the proximal
        %point
        Body(i).r(j,:)= GaitData.Coordinates(j,Pi:Pi+1)' + (Body(i).PCoM * Body(i).Length * Csi);
        
        %Updates the orientation of the body
        if (Csi(2)>0)
            Body(i).theta(j) = acos(Csi(1));
        else
            Body(i).theta(j) = 2*pi - acos(Csi(1));
        end
        
        %end of the loop that goes through all frames
    end
    
    %To ensure continuity of the angles the unwrap function is applied
    Body(i).theta = unwrap(Body(i).theta);
    
    %end of the loop that goes through all bodies
end

end