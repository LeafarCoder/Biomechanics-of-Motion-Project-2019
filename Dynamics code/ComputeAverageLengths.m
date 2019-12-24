function ComputeAverageLengths (LabData)
%This function computes the average lengths of the human segments

%Global memory data
global NBody Body

%Number of frames to evaluate 
NFrames = size(LabData.Coordinates,1);

for i= 1:NBody
    
    %Allocates memory for the lengths
    SegmentLength = zeros(NFrames,1);
    
    %Goes through all frame
    for j = 1 : NFrames
        
        %Position of the coordinates of Points Pi and Pj
        Pi = 2 * (Body(i).pi - 1) + 1;
        Pj = 2 * (Body(i).pj - 1) + 1;
        
        %Computes the length for the current frame
        SegmentLength(j) = norm(LabData.Coordinates(j,Pi:Pi+1)-LabData.Coordinates(j,Pj:Pj+1));
        
        %End of the loop that goes through all frames
    end
    
    %Defines the average length
    Body(i).Length = mean(SegmentLength);
    %End of the loop that goes through all bodies
end  
end

