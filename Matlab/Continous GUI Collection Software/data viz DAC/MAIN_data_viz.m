%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   pre-pre-processing for data from the DAC
%%%
%%%
%%%   Instructions for use:
%%%   
%%%   to use this code simply <path> in addpath('<path>') on line 30 with
%%%   the desired path for the data you collected from the DAC. to
%%%   correctly segment the code you must know the number of samples on
%%%   each channel which is found with the division of the overall sample
%%%   rate (ie 250kHz) by the MUX switching rate (ie 50kHz) giving the
%%%   number of samples per channel (FREQ_MOD) = 250/50 = 5 samples. 
%%%
%%%   The value OFFSET will then cut off the first n values of that sample
%%%   leaving you with m = FREQ_MOD-OFFSET+1 values to average over for
%%%   your signal. 
%%%
%%%
%%%   This is the first of two pre-processing scripts for the data from the
%%%   DAC. It is run once for each subject and each walk. One day maybe i
%%%   will turn it into a batch script.
%%%
%%%   Next run Main_pre_processing_2_DAC.m
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% addpath('C:\Users\Erich\Google Drive\Erich_Data\gait\data')
% addpath('C:\Users\Erich\Google Drive\Erich_Data\gait\data\9_1_2015')
close all, clear all, clc
dbstop if error

load('minuteWalk_625K250K_932015_1223PM')
data = saveData;
time = timeData;
subj_ID = 'Shadman';

% load('Wan8112015_20Walks'); subj_ID = 'Wan';
% load('Shadman8112015_20Walks'); subj_ID = 'Shadman';
% load('Erich8112015_20Walks'); subj_ID = 'Erich';
clearvars -except data time subj_ID
dat_temp = data(:,3:6);
signal = data(:,1:2);
single_sensor_9 = data(:,7); 
clear data

FREQ_MOD = 6;%thsi value minus OFFSET is the width of the window when extracting the signal and time values.
OFFSET = 2; %this value adjusts the starting point of a window when extracting the signal and time values
%logically index the time stamps as transient or stationary by
%thresholding. filter based on this threshold.

prep_data

plot_stuff
