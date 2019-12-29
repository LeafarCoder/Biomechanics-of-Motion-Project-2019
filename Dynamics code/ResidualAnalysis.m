function FilteredData = ResidualAnalysis(Data, Frequency)

fc = 0.05:0.2:10;
N_fc = length(fc);
R = zeros(1,N_fc);

Data_filt = zeros(length(Data), N_fc);
for i = 1:length(fc)
    [b,a] = butter(2,2*fc(i)/Frequency, 'low');
    Data_filt(:,i) = filtfilt(b,a,Data);
    Data_error = sum((Data(:)-Data_filt(:,i)).^2);
    %residual (coord z): root mean square of noise
    R(i)=sqrt(Data_error/size(Data_filt,2));
end

%linear regression: Rx vs. fc
idx = N_fc - 1;
corr = 1; % correlation
while (abs(corr) > 0.95 && idx > 1)
    X = [ones(1, N_fc - idx + 1); fc(idx:end)]';
    Y = R(idx:end)';
    
    coefs = (X'*X)\(X'*Y);
    Y_hat = X*coefs;
    
    %Calculating R^2 coeficient for linear regression
    avg_Y=mean(Y);
    s1=sum((Y-Y_hat).^2);
    s2=sum((Y-avg_Y).^2);
    R_sqr= 1-s1/s2;
    corr=sqrt(R_sqr);
   
    idx = idx - 1;
end

% Finding the Y intercept of the chosen Regression line, and the
% corresponding cut-off frequency

b=coefs(1);
[~,fc_index] = min(abs(R(:)-b));
FilteredData = Data_filt(:,fc_index);

%     %plot
%     disp(fc(fc_index));
%     figure()
%     plot(Data);
%     hold on;
%     plot(FilteredData,'r');
%     hold off;

end

