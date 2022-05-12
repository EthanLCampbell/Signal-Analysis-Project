function [frequency_domain, voltage, rms_voltage, average_voltage, dominant_frequency_value] = fftTesting(voltage,times,purpose,k,all_files);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Subfunction that checks data for anomalies and performs all calculations,
% most importantly fft testing. uitlized multiple times to check different
% sections of the data. returns important variables needed to check signal
% quality later
%
% Function Call
% fftTesting(voltage,times,purpose,k,all_files);
%
% Input Arguments
% voltage= arrays of voltage values
% times = array of time values
% purpose = string variabble indicating if this testing is for the "full"
% set or a "section" of the dataset
%
% Output Arguments
%  dominant_frequency_value= index for dominant_frequency_value
% frequency_domain=array of frequency domain
% rms_voltage=rms_voltage
% average_voltage=average voltage
% voltage= array of new cleaned voltage values
% 
% Assignment Information
%   Author: Ethan Labianca-Campbell, elabian@purdue.edu
%           Andrew Cali, acali@purdue.edu
%           Spruha Vashi, svashi@purdue.edu
%           Jalen Leung, leung63@purdue.edu
%   Academic Integrity:
%     [x] I worked alone on this problem and only used resourses
%        that meet academic integrity expectations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LAST UPDATED: Ethan 4/29

%% INITIALIZATION
%cleaning the data

%check that all data files don't have NaN at end
if any(isnan(voltage(:)))
  voltage = voltage(1:end-1);
  times = times(1:end-1);
end 

%makes time array even # elements 
if mod(numel(times),2) ~= 0 
  times = times(1:end-1);
  voltage = voltage(1:end-1);
end



%% CALCULATIONS
%waveform calculations
sampling_period = times(2) - times(1); %period between time samples
sampling_frequency = 1/sampling_period; %F = 1/T
length_signal = numel(times); %length of waveform (# of samples)
from_0 = (times - times(1)); %all times based on t=0 reference   

%fft calculations
fft_model = fft(voltage); %fast fourier transform of voltage-time to frequency domain
P2 = abs(fft_model/length_signal); %signal sample amplitude 
P1 = P2(1:length_signal/2+1);
P1(2:end-1) = 2*P1(2:end-1); %all values of spectrum get doubled due to symmetry of 2-sided spectrum going to 1 side

%root mean square voltage calculation
rms_voltage = rms(voltage, 'all'); %[volts]

% Calculating dominant frequency from results
[dominant_frequency_index,dominant_frequency_value] = max(P1);
frequency_domain = sampling_frequency*(0:(length_signal/2))/length_signal;

%finding average voltage of function for quality check
average_voltage = mean(voltage);
   
%% ____________________
%% FORMATTED FIGURE DISPLAYS

     %Figure 1: signal waveform (voltage vs time graph)
     figure
     plot(from_0,voltage) 
     file_name = all_files([k]).name;
     title(sprintf('Signal Waveform (Voltage vs Time) %s',file_name)) %title with datafile name adde
     xlabel('Time (s)')    
     ylabel('Voltage (V)')
%{
if purpose == "all"
     %Figure 1: signal waveform (voltage vs time graph)
     figure
     plot(from_0,voltage) 
     file_name = all_files([k]).name;
     title(sprintf('Signal Waveform (Voltage vs Time) %s',file_name)) %title with datafile name adde
     xlabel('Time (s)')    
     ylabel('Voltage (V)')
     
     %Figure 2: FFT (frequency vs amplitude graph)
     figure
     plot(frequency_domain,P1)
     hold on
     title('Single-Sided Amplitude Spectrum of Voltage(t)')
     xlabel('frequency (Hz)')
     ylabel('Amplitude spectrum (|P1|)')
     xlim([min(frequency_domain), max(frequency_domain)])
     hold off
 end
%}
