function [FilteredData] = DoublePassLPFilter(Data, cutoff_freq, Frequency)

wn = cutoff_freq/Frequency;

[b,a] = butter(2,2*wn);
%a dividir por 2pi para converter de Hz a rad/s

FilteredData = filtfilt(b,a,Data);

end