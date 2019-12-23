function ProcessedData = FilterForcePlateData(ProcessedData, SamplinfFrequency)
%considering only the vertical component of the force, estimate the instant
%of time in which contact existed by finding the time steps for which the
%force was larger than 5N
ContactTimeSteps = find(ProcessedData(:,2)>5);
ContactIndices = (ProcessedData(:,2)>5);

%filters the forces
for j=1:2
    %low-pass filter with cut-off frequency of 20Hz
    FilteredData = DoublePassLPFilter(ProcessedData(:,j),...
        20, SamplingFrequency);
    
    %the instants of time for which no contact existed will be assigned a
    %0N force
    FilteredData(~ContactIndices) = 0;
    
    %Update the output
    ProcessedData(:,j) = FilteredData;
end

%filters the center of pressure

for j=3:4
    %before filtering, the position of the center of pressure imediately
    %before and after contact will be put at those positions to diminish
    %the impact of the filter adaptation
    RawCoP = ProcessedData(:,j);
    if (ContactTimeSteps(1) > 1)
        % puts the positions for all time steps before contact equal to the
        % position of the last contact
        RawCoP(1 : ContactTimeSteps(1) - 1) = RawCoP(ContactTimeSteps(1));
    end
    if (ContactTimeSteps(end) < length(RawCoP))
        %puts the position for all time steps after contact equal to the
        %position of the last contact
        RawCoP(ContactTimeSteps(end) + 1 : end) = RawCoP(ContactTimeSteps(end));
    end
    
    %filters the center of pressure using a low-pass filter with a cut-off
    %frequency of 10Hz
    FilteredData = DoublePassLPFilter(RawCoP, 10, SamplingFrequency);
    
    %update the output
    ProcessedData(:,j) = FilteredData;
    
    %plots results
    % plot(RawCoP);hold on; plot(FilteredData,'r');hold off;´
    % pause
end
    

end