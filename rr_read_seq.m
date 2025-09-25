%% Read a sequence into MATLAB
%
% The |Sequence| class provides an implementation of the _open file
% format_ for MR sequences described here: http://pulseq.github.io/specification.pdf
%
% This example demonstrates parsing an MRI sequence stored in this format,
% accessing sequence parameters and visualising the sequence.
clear all, close all, clc

%% Read a sequence file

% A sequence can be loaded from the open MR file format using the |read|
% method.

% filepath = '\\skopedrive.zh.skope.ch\SoftwareDevelopment\ReconCustomerData\CH_Inselspital_Bern\25_04_17_Meas_Balgrist_Clip-on_Camera\pulseq\';
% seq_name=[filepath '\noRF.seq'];

filepath = 'C:\Users\RudyRizzoSkope\OneDrive - Skope Magnetic Resonance Technologies\Documents\GitHub\Pulseq-Sequences\exports\';
seq_name=[filepath '\skope_gre_2d_TRA_AP.seq'];


sys = mr.opts('B0', 2.89); % we need system here if we want 'detectRFuse' to detect fat-sat pulses
seq=mr.Sequence(sys);
seq.read(seq_name,'detectRFuse');

%% sanity check to see if the reading and writing are consistent
% seq.write('read_test.seq');
% system(['diff -s -u ' seq_name ' read_test.seq'],'-echo');

%% Access sequence parameters and blocks
% Parameters defined with in the |[DEFINITIONS]| section of the sequence file
% are accessed with the |getDefinition| method. These are user-specified
% definitions and do not effect the execution of the sequence.
seqName=seq.getDefinition('Name')

%% calculate and display real TE, TR as well as slew rates and gradient amplitudes

rep = seq.testReport; 
fprintf([rep{:}]); 

%%
% Sequence blocks are accessed with the |getBlock| method. As shown in the
% output the first block is a selective excitation block and contains an RF
% pulse and gradient and on the z-channel.
% b1=seq.getBlock(1)

%% Plot the sequence 
seq.plot()

