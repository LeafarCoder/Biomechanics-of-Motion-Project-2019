close all; clear all; clc;
%% Deadlift_data_RMS

% X[s]	1 Gast Med [V]	2 T Ant [V]	3 R Fem [V]	4 B Fem [V]
emg_RMS = dlmread('Deadlift_data_RMS.tsv');

time_RMS = emg_RMS(2701:7600,1)-6.41;
GastMed_RMS = emg_RMS(2701:7600,2);
TAnt_RMS = emg_RMS(2701:7600,3);
RFem_RMS = emg_RMS(2701:7600,4);
BFem_RMS = emg_RMS(2701:7600,5);

%%
fs = 1000;
fc = 1;

[b,a] = butter(2,fc/(fs/2));

GastMed_RMS_filt = filtfilt(b,a,GastMed_RMS);
TAnt_RMS_filt = filtfilt(b,a,TAnt_RMS);
RFem_RMS_filt = filtfilt(b,a,RFem_RMS);
BFem_RMS_filt = filtfilt(b,a,BFem_RMS);
%%
figure;
subplot 221;
plot(time_RMS,GastMed_RMS);
hold on;
plot(time_RMS,GastMed_RMS_filt,'LineWidth',2);
xlabel('Time (seconds)');
ylabel('Volts');
axis tight;
title('Gastrocnemius Medialis');

subplot 222;
plot(time_RMS,TAnt_RMS);
hold on;
plot(time_RMS,TAnt_RMS_filt,'LineWidth',2);
xlabel('Time (seconds)');
ylabel('Volts');
axis tight;
title('Tibialis Anterior');

subplot 223;
plot(time_RMS,RFem_RMS);
hold on;
plot(time_RMS,RFem_RMS_filt,'LineWidth',2);
xlabel('Time (seconds)');
ylabel('Volts');
axis tight;
title('Rectus Femoris');

subplot 224;
plot(time_RMS,BFem_RMS);
hold on;
plot(time_RMS,BFem_RMS_filt,'LineWidth',2);
xlabel('Time (seconds)');
ylabel('Volts');
axis tight;
title('Biceps Femoris');

suptitle('RMS EMG data');
