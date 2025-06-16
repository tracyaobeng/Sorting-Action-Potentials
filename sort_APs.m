clc; clear;close all;
%% (1)Load file
data = load('22.mat');
time = data.time;  
wave = data.wave;
%% (2)Calculating signal metrics
rms_magnitude = sqrt(mean(wave.^2));% The RMS (Root Mean Square) represents the effective amplitude of the signal.It determines how strong neural activity is. 
signal_variance = var(wave);% The variance measures how much the signal deviates from its mean. High variance indicates spikes.
snr = mean(wave)/std(wave);
%% (2e)Determine Threshold for Action Potential Detection
threshold_multiple= 3.5; 
threshold = threshold_multiple * rms_magnitude; 
% Plot with threshold line 
figure;
plot(time, wave); hold on;
yline(threshold, 'r--', 'Threshold');
xlabel('Time (s)');
ylabel('Voltage (μV)');
title('Neural Signals with Action Potential Detection Threshold');hold off;

%% (2f)Building Action Potential and Noise Matrices
[peaks, locs] = findpeaks(wave, 'MinPeakHeight', threshold);% Find threshold crossings
sampling_rate = 30000; % 30 kHz
window_size = round(1.5e-3 * sampling_rate); % Define action potential window, ~1.5 ms window

%Generate action potential matrix 
 num_spikes = length(locs);
 ap_matrix = zeros(num_spikes, 2*window_size+1); % Matrix to store action potentials
 
 for i = 1:num_spikes
     idx = locs(i);
     if idx > window_size && idx + window_size <= length(wave)
         ap_matrix(i, :) = wave(idx-window_size : idx+window_size);
     end
 end

% Generate noise matrix by sampling random sections 
num_noise_samples = num_spikes; % Match number of noise samples to spikes
noise_matrix = zeros(num_noise_samples, 2*window_size+1);
% Generate random noise locations, ensuring they are far from spikes
max_index = length(wave);
random_locs = zeros(1, num_noise_samples); % Storage for valid noise locations
count = 1;
while count <= num_noise_samples
    rand_idx = randi([window_size+1, max_index-window_size]); % Random index in valid range
    
    % Ensure it is not too close to any spike (e.g., at least 2*window_size away)
    if all(abs(locs - rand_idx) > 2*window_size)
        random_locs(count) = rand_idx;
        count = count + 1;
    end
end
% Extract noise waveforms
for i = 1:num_noise_samples
    idx = random_locs(i);
    noise_matrix(i, :) = wave(idx-window_size : idx+window_size);
end

%% (3) Sort Action Potentials using PCA
data_matrix = [ap_matrix; noise_matrix];%Concatenate action potential and noise matrices
[U, S, V] = svd(data_matrix); % Perform Singular Value Decomposition (SVD)
principal_components = S' * U';
[idx, C] = kmeans(principal_components(1:3,:)', 3);% Apply k-means clustering to group data into 3 clusters


%% (4a) Plot Individual AP Snippets, Mean, and SEM for Action Potentials and Noise
figure;
plot(data_matrix(idx==2,:)','k')
hold on;
plot(data_matrix(idx==3,:)','r')
plot(data_matrix(idx==1,:)','g')
plot(mean(data_matrix(idx==1,:)),'b--','LineWidth', 2)
plot(mean(data_matrix(idx==2,:)),'w--','LineWidth', 2)
plot(mean(data_matrix(idx==3,:)),'m--','LineWidth', 2)
xlabel('Time (ms)');
ylabel('Voltage (µV)');
title('Action Potential and Noise Waveforms'); 
hold off;
%% (4b)Create 3D PCA plot
colors = [0 0 0; 1 0 0; 0 1 0]; %Define colors for the clusters: Black for noise, red and green for action potentials
figure;
hold on; grid on;
scatter3(principal_components(1,:), principal_components(2,:), principal_components(3,:), 36, colors(idx,:), 'filled'); % Clustering structure in the first three principal components
% Add labels and title
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');
title('3D PCA Clustering of Action Potentials and Noise');
%legend('Noise (Black)','Action Potential 1(Red)','Action Potential 2(Green)');
view(3); % 3D view
hold off;

% Action potentials cluster together forming distinct groups, while noise remains separate and is closer to the origin of the PCA plot.
% If action potentials overlap significantly with noise, the SNR might be low, or the threshold for spike detection may need adjusting.
% The 3D representation provides a clearer view of how well PCA distinguishes spikes from noise.

%% 5) Using different files
% I ran this code on  22.mat and 11.mat 
% There were differences in the threshold selection and shape of detected spikes. 
% 22.mat had a higher threshold than 11.mat indicating that 22.mat had a
% higher rms and signals with generally larger amplitudes(higher peaks).
% This means that 22.amt had more Action potentials. This coud mean that
% the neurons in 22.mat were closer to the electrode than the neurons in
% 11.mat were to their electrode.
%  The threshold in 22.mat appears appropriate, as it captures most spikes without detecting too much noise. 
% However, in 11.mat  the threshold seems too low, as many noise signals are marked as spikes.
%  There were overlapping clusters for both  for both files as I
%  couldn't achieve a total separation and there weren't many differences
%  in the separation between clusters on the 2 plots.









