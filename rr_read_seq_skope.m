%% RR 250806
% simulator of pulseq file
% plotting of events: gradient, kspace, trigg positioning
% plotting of nominal traj

clear all, close all, clc
run('C:\Users\RudyRizzoSkope\skope_gitlab\skope-i\SetReconEnv.m')

%% Load Pulseq file that has all triggers
% folderPath = 'C:\Users\RudyRizzoSkope\Skope Magnetic Resonance Technologies\Customer Success - Documents\General\01 Customer Data\EU\EU - CH - Balgrist\Balgrist_DFC_Erlangen_Geneva_2025_08_31\';
folderPath = 'C:\Users\RudyRizzoSkope\OneDrive - Skope Magnetic Resonance Technologies\Documents\GitHub\Pulseq-Sequences\exports\';
[grad, tx, rx, trig, labels, flags, defs] = mexSequenceSimulator([folderPath,'skope_epi_2d_TRA_AP_R4.seq'], 'gradient');

%% Create time vector
grt = 10e-6;
time = [1:size(grad,1)]*grt;

%% Plot labels
figure
stairs(labels(:,1),'LineWidth',2)
hold on
stairs(labels(:,8),'LineWidth',2)
stairs(labels(:,4),'LineWidth',2)
legend({'slc','lin','avg'})
xlabel('Acquisition')
ylabel('Label value')
set(gca,'FontSize',30)

%% Plot gradient, TX centers and triggers
figure
plot(time,grad,'LineWidth',2)
hold on
plot(tx,tx*0+1,'*')
plot(trig,trig*0+1,'*')
legend({'gx','gy','gz','tx','trig'})
xlabel('Time [s]')
ylabel('Gradient [mT/m]')
set(gca,'FontSize',30)

%% Calcalate k-space
kFull = G2k(grad/1e3,grt);
for i=1:numel(tx)
    txSample = round(tx(i)/grt);
    kFull(txSample:end,:) = kFull(txSample:end,:) - kFull(txSample,:);
end

%% Plot k-space
figure
plot(time,kFull,'LineWidth',2)
hold on
plot(tx,tx*0+1000,'*')
plot(trig,trig*0+1000,'*')
legend({'kx','ky','kz','tx','trig'})
xlabel('Time [s]')
ylabel('k [rad/m]')
set(gca,'FontSize',30)

%% Get k-sapce corresponding to readout
nReadouts = size(rx,2);
nSamp = rx(2,1);
timeReadout = zeros(nSamp,nReadouts);

for i=1:nReadouts
    timeReadout(:,i) = rx(1,i) + [0:nSamp-1]*rx(3,i);
end

kspace = interp1(time(:),kFull,timeReadout);

%% Plot k-space trajectory
figure
for i=1:nReadouts
    plot(kspace(:,i,1),kspace(:,i,2),'LineWidth',2)
    hold on
end
axis image
xlabel('kx [rad/m]')
ylabel('ky [rad/m]')
set(gca,'FontSize',30)




%% Plot long acquisition (camera data)
scan = AqSysData(cameraFolder,30);

kspha = scan.getData('kspha');
clf
plot(kspha(1:50000,2,1,1),'LineWidth',3)
hold on
plot(kspha(1:50000,3,1,1),'LineWidth',3)
plot(kspha(1:50000,4,1,1),'LineWidth',3)
set(gca,'FontSize',30)
xlabel('Trigger times [s]')
ylabel('Scan number')