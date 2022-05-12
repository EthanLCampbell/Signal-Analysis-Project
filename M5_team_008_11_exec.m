function [] = M5_team_008_11_exec(target_freq, accept_devi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Reads raw voltage vs time data from multiple files in directory, plots original signal, then 
% uses fft to produce single-sided amplitude spectrum of voltage 
% (amplitude vs frequency graph). Prints Amplitude and frequency of
% original data to command window and seperate file "M2_11_results.txt".
%
% Uses MatLab toolbox with "rms()" installed. Script only works with MatLab
% online or with that function installed. 
%
% Function Call
% M5_team_007_011_exec(target_freq, accept_devi)
%
% Input Arguments
% Target frequency: target frequency for sorting[Hz] 
% Acceptable deviation: error from the target frequency that is acceptable [Hz]
%
% Output Arguments
% Text file with file name, amplitude of voltage [V], frequency of signal [Hz],
% signal quality analysis, and pass/fail remark
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

%change log since m3: 
%{
- changed path directory from ENGR132_Sp22_M3_Data_Files to
Sp22_ENGR132_M5_Data
- changed file types from .txt to .dat
- adding current date and time to each output file name
- made target frequency and acceptable deviation into user-input variables
- removed clear workspace bcs deletes user-input values
- change tolerance of average voltage bounds
- cases for inconsistent & erratic signals which don't follow typical
square wave criteria
- modularized fft, overrides for quality, and the quality check itself
%}


%% ____________________
%% INITIALIZATION

%clear workspace, command window, and figures
clc
close all

%turn directory into filenames and remove non-data files
all_files = dir('Sp22_ENGR132_M5_Data\*.dat'); %vector of all files

%create results file for data input
date_current = datestr(now, 'dd-mm-yy HH-MM'); % date and time for name of file
file_name = "M5_11_results " + date_current + ".txt";
results = fopen(file_name, 'w'); %new text file 
fprintf(results, 'Amplitude and Frequency of Each Data File\nSignal Quality: Good > Fair > Poor\n');
for k = 1:numel(all_files)

    %import data
    full_file_path = strcat('Sp22_ENGR132_M5_Data\', all_files([k]).name);
    data = readmatrix(full_file_path);
    times = (data(:,1)); %time [seconds]
    voltage = data(:,2); %voltage [volts]

    %cleaning the data
    %makes time array even # elements 
    if mod(numel(times),2) ~= 0 
      times = times(1:end-1);
      voltage = voltage(1:end-1);
    end
    
    %check that all data files don't have NaN at end
    if any(isnan(voltage(:)))
      voltage = voltage(1:end-1);
      times = times(1:end-1);
    end 
        
    %% ____________________
    %% CALCULATIONS
    %call fftTesting 3 times in order to check all sections of the data
    %testing full dataset
    [frequency_domain, voltage, rms_voltage,average_voltage,dominant_frequency_value]=fftTesting(voltage,times,"all",k,all_files);
    %testing 1st half of data
    [frequency_domain_1, voltage_1, rms_voltage_1,average_voltage_1,dominant_frequency_value_1]=fftTesting(voltage(1:numel(voltage)/2),times(1:(numel(times)/2)),"section",k,all_files);
    %testing 2nd half of data
    [frequency_domain_2, voltage_2, rms_voltage_2,average_voltage_2,dominant_frequency_value_2]=fftTesting(voltage((round(numel(voltage)/2)):(numel(voltage))),times((round(numel(times)/2)):numel(times)),"section",k,all_files);
    
    %% ____________________
    %% QUALITY CHECK & PASS/FAIL
    [quality_str, passes_str] = qualityCheck(voltage,target_freq, accept_devi, frequency_domain, dominant_frequency_value,rms_voltage,average_voltage);
    [quality_str, passes_str] = overrideQuality(voltage,dominant_frequency_value_1, dominant_frequency_value_2,quality_str,passes_str);
   
    %% ____________________
    %% FORMATTED TEXT DISPLAYS


    %print all values to results text file
    fprintf(results, "\nData file name: %s\n" + ...
        "Amplitude of data: %d [Volts]\n" + ...
        "Frequency of data: %d [Hz]\n" + ...
        "Signal Quality Evaluation: %s\n" + ...
        "Pass/Fail: %s \n",all_files([k]).name, rms_voltage, frequency_domain(dominant_frequency_value), quality_str,passes_str);
  
    %Print results to command window
    fprintf( "\nData file name: %s\n" + ...
        "Amplitude of data: %d [Volts]\n" + ...
        "Frequency of data: %d [Hz]\n" + ...
        "Signal Quality Evaluation: %s\n" + ...
        "Pass/Fail: %s \n",all_files([k]).name, rms_voltage, frequency_domain(dominant_frequency_value), quality_str,passes_str);

   
end

fclose(results); %close text file
%% ____________________
%% PRINTED RESULTS
% 
% Data file name: 003a6570.dat
% Amplitude of data: 1.085906e+01 [Volts]
% Frequency of data: 9.999000e+02 [Hz]
% Signal Quality Evaluation: Poor
% Pass/Fail: The Circuit Fails - inconsistent signal 
% 
% Data file name: 119c276f.dat
% Amplitude of data: 1.051068e+01 [Volts]
% Frequency of data: 1.049895e+03 [Hz]
% Signal Quality Evaluation: Good
% Pass/Fail: The Circuit Passes 
% 
% Data file name: 278q8f22.dat
% Amplitude of data: 1.047901e+01 [Volts]
% Frequency of data: 1.049895e+03 [Hz]
% Signal Quality Evaluation: Poor
% Pass/Fail: The Circuit Fails - erratic dips in voltage 
% 
% Data file name: 355dc48d.dat
% Amplitude of data: 1.051448e+01 [Volts]
% Frequency of data: 9.999000e+02 [Hz]
% Signal Quality Evaluation: Fair
% Pass/Fail: The Circuit Passes 
% 
% Data file name: 425c730f.dat
% Amplitude of data: 1.084935e+01 [Volts]
% Frequency of data: 9.999077e+03 [Hz]
% Signal Quality Evaluation: Poor
% Pass/Fail: The Circuit Fails - different frequencies 
% 
% Data file name: 635z55fa.dat
% Amplitude of data: 1.053031e+01 [Volts]
% Frequency of data: 1.019918e+03 [Hz]
% Signal Quality Evaluation: Poor
% Pass/Fail: The Circuit Fails - different frequencies 
% 
% Data file name: 643m6207.dat
% Amplitude of data: 1.051557e+01 [Volts]
% Frequency of data: 9.999000e+02 [Hz]
% Signal Quality Evaluation: Good
% Pass/Fail: The Circuit Passes 
% 
% Data file name: 679b251d.dat
% Amplitude of data: 1.053666e+01 [Volts]
% Frequency of data: 9.999000e+02 [Hz]
% Signal Quality Evaluation: Fair
% Pass/Fail: The Circuit Fails 
% 
% Data file name: 736c0012.dat
% Amplitude of data: 1.051720e+01 [Volts]
% Frequency of data: 8.999100e+02 [Hz]
% Signal Quality Evaluation: Good
% Pass/Fail: The Circuit Fails 
% 
% Data file name: 8450e5ec.dat
% Amplitude of data: 1.051648e+01 [Volts]
% Frequency of data: 9.999000e+02 [Hz]
% Signal Quality Evaluation: Good
% Pass/Fail: The Circuit Passes 
% 
% Data file name: 9319701a.dat
% Amplitude of data: 1.109932e+01 [Volts]
% Frequency of data: 1.049895e+03 [Hz]
% Signal Quality Evaluation: Poor
% Pass/Fail: The Circuit Fails - inconsistent signal 
% 
% Data file name: a7ff2381.dat
% Amplitude of data: 8.823668e+00 [Volts]
% Frequency of data: 1.049895e+03 [Hz]
% Signal Quality Evaluation: Fair
% Pass/Fail: The Circuit Fails 
% 
% Data file name: aa1d5714.dat
% Amplitude of data: 1.051638e+01 [Volts]
% Frequency of data: 9.499050e+02 [Hz]
% Signal Quality Evaluation: Good
% Pass/Fail: The Circuit Fails 
% 
% Data file name: bacd62fe.dat
% Amplitude of data: 1.051657e+01 [Volts]
% Frequency of data: 9.999000e+02 [Hz]
% Signal Quality Evaluation: Good
% Pass/Fail: The Circuit Passes 
% 
% Data file name: c4b4b19f.dat
% Amplitude of data: 1.053796e+01 [Volts]
% Frequency of data: 7.713625e+02 [Hz]
% Signal Quality Evaluation: Poor
% Pass/Fail: The Circuit Fails - different frequencies 
% 
% Data file name: c500839e.dat
% Amplitude of data: 1.047635e+01 [Volts]
% Frequency of data: 9.999000e+02 [Hz]
% Signal Quality Evaluation: Poor
% Pass/Fail: The Circuit Fails - erratic dips in voltage 
% 
% Data file name: d253c024.dat
% Amplitude of data: 1.052069e+01 [Volts]
% Frequency of data: 9.999200e+02 [Hz]
% Signal Quality Evaluation: Poor
% Pass/Fail: The Circuit Fails - different frequencies 
% 
% Data file name: ef7f86a7.dat
% Amplitude of data: 9.407161e+00 [Volts]
% Frequency of data: 9.599232e+02 [Hz]
% Signal Quality Evaluation: Poor
% Pass/Fail: The Circuit Fails - inconsistent signal 
% 
% Data file name: f464160c.dat
% Amplitude of data: 1.052872e+01 [Volts]
% Frequency of data: 1000 [Hz]
% Signal Quality Evaluation: Good
% Pass/Fail: The Circuit Passes 
% 
% Data file name: fcbbea7b.dat
% Amplitude of data: 1.073151e+01 [Volts]
% Frequency of data: 9.999000e+02 [Hz]
% Signal Quality Evaluation: Poor
% Pass/Fail: The Circuit Fails 
% 
% Data file name: fdb6b912.dat
% Amplitude of data: 5.729542e+00 [Volts]
% Frequency of data: 9.999000e+02 [Hz]
% Signal Quality Evaluation: Poor
% Pass/Fail: The Circuit Fails 

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The function I am submitting
% is my own original work.




