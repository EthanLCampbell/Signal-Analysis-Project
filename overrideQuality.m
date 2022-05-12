function [quality_str, passes_str] = overrideQuality(voltage,dominant_frequency_value_1, dominant_frequency_value_2,quality_str,passes_str);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Subfunction that checks data for anomalies and performs all calculations,
% most importantly fft testing. uitlized multiple times to check different
% sections of the data. returns important variables needed to check signal
% quality later
%
% Function Call
% cleanData = clean(data);
%
% Input Arguments
% voltage= arrays of voltage values
%times = array of time values
%purpose = string variabble indicating if this testing is for the "full"
%set or a "section" of the dataset
%
% Output Arguments
%quality_str = quality evaluation string output
%passes_str = pass/fail string output

% Assignment Information
%   Author: Ethan Labianca-Campbell, elabian@purdue.edu
%           Andrew Cali, acali@purdue.edu
%           Spruha Vashi, svashi@purdue.edu
%           Jalen Leung, leung63@purdue.edu
%   Academic Integrity:
%     [x] I worked alone on this problem and only used resourses
%        that meet academic integrity expectations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LAST UPDATED: Spruha 4/28

%% OVERRIDE
%% overrides for quality analysis: if any of these happen, automatic fail and poor signal

%erratic dips and highs in voltage 
% for loop to show that 1-sample dips don't happen (e.g. won't dip to another voltage then back up to same voltage)
for n = 1:numel(voltage)-2 
    if voltage(n) == voltage(n+2) && voltage(n) ~= voltage(n+1)
        quality_str = "Poor";
        passes_str = "The Circuit Fails - erratic dips in voltage";
    end
end

%erratic fluctuation of signal
%if within a data set, there are 5 consecutive voltage values that do
%not share any common values, this holds
for n = 1:50
    if round(voltage(n),4) ~= round(voltage(n+1),4) && round(voltage(n+1),4) ~= round(voltage(n+2),4) && round(voltage(n+2),4) ~= round(voltage(n+3),4) ...
            && round(voltage(n+3),4) ~= round(voltage(n+4),4) && round(voltage(n+4),4) ~= round(voltage(n+5),4)
        quality_str = "Poor";
        passes_str = "The Circuit Fails - inconsistent signal";
    end
end

%comparing fft signals for parts of data
%within a data set, the fft signal values for the first half of the
%data should match the second half, meaning the frequency is the same
%for the whole data set. if this is not true, circuit is poor and fails
if(dominant_frequency_value_1 ~= dominant_frequency_value_2)
    quality_str = "Poor";
    passes_str = "The Circuit Fails - different frequencies";
end