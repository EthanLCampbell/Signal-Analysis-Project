function [quality_str, passes_str] = qualityCheck(voltage,target_freq, accept_devi, frequency_domain, dominant_frequency_value,rms_voltage,average_voltage);
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

%% INITIALIZATION
%cleaning the data    
%frequency music note check centered around 1000Hz (B_5/C_6)
%if frequency differs by 100Hz, still in range of correct note,
%slightly more flat or sharp.
if frequency_domain(dominant_frequency_value) >= (target_freq - accept_devi) && frequency_domain(dominant_frequency_value) <= (target_freq + accept_devi)
   freq_quality_score = 1; %passed
else 
   freq_quality_score = 0; %failed
end

%check rms for quality 

if rms_voltage>=10.2 && rms_voltage<=10.8 %if error < .2 
   rms_quality_score = 2; %great
elseif rms_voltage>=9.7 && rms_voltage<=11.3 %if error < 1
   rms_quality_score = 1; %fair
else %if error > 1
   rms_quality_score = 0; %poor
end

%check quality of average voltage
if (average_voltage>=-.25 && average_voltage<=.25) 
    average_voltage_score = 2; %great
elseif (average_voltage >= -.5 && average_voltage <= .5)
    average_voltage_score = 1; %fair
else 
   average_voltage_score = 0; %poor
end

%choosing what passes and what fails
%if quality scores are both >= fair (score >= 1) AND frequency test passes, circuit passes.  

if (rms_quality_score >=1 && average_voltage_score >= 1 && freq_quality_score == 1)
    passes_str = "The Circuit Passes";
else
    passes_str = "The Circuit Fails";
end

%determines quality score from points
overall_quality_score = rms_quality_score + average_voltage_score; %total quality as a sum of other qualities
if overall_quality_score == 4
    quality_str = "Good";
elseif overall_quality_score == 3
    quality_str = "Fair";
elseif overall_quality_score == 2
    quality_str = "Fair";
elseif overall_quality_score == 1 || overall_quality_score == 0
    quality_str = "Poor";
end
