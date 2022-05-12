# Signal-Analysis-Project
Code for Purdue ENGR 132 Final Project 

This repository is for the final project (milestone 5) of the Purdue ENGR 132 FYE class. 
The project itself gave us various voltage/time data and told us to find outliers or "bad quality" data sets. 

M5_team_008_11_exec.m: main for code 
call function with M5_team_007_011_exec(target frequency [Hz], acceptable deviation [V]) 

fftTesting.m: called within the exec function to do a fast-fourier transformation to the data. 
Gathers (rms) amplitude of voltage and (average) signal frequency of input voltage vs time data. 

qualityCheck.m: using results from fft and user input, determines whether 
signal has appropriate quality to pass test

overrideQuality: called within the exec function to override the signal quality check 
if the signal itself has (difficult to calculate for) criteria which would make it a bad signal, regardless of if mathematically the data outputs correct values in fft. 

