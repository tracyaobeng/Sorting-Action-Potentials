# Sorting-Action-Potentials
This project explores methods for extracting, thresholding, and classifying extracellular neural spike signals using MATLAB. The goal is to detect action potentials from raw data, segment them, and sort them using Principal Component Analysis (PCA) without built-in PCA functions.

Here, I use a `.mat` file containing 60 seconds of high-pass filtered neural recordings sampled at 30kHz. Each file contains:
- `time`: A vector of timestamps (in seconds)
- `wave`: The corresponding neural signal amplitudes (in µVolts)

The full pipeline includes thresholding spikes, extracting features, separating noise, and clustering using PCA.

###  Raw Neural Signal with Threshold Overlay
This plot shows the raw waveform (`wave` vs `time`) and overlays a threshold line calculated as a multiple of the signal variance.
threshold = threshold_multiple * rms_magnitude
This threshold is used to detect potential spikes (local minima exceeding threshold depth). This helps determine how well the threshold separates action potentials (spikes) from noise.

![image](https://github.com/tracyaobeng/Sorting-Action-Potentials/blob/main/AP_threshold.png)
---
### 2. Action Potential and Noise Waveform Snippets
This figure shows:
This figure shows:
- All individual **action potential** snippets
- Mean waveform ± standard error for each neuron (color-coded: red, blue, green)
- All **noise** snippets in black, with their mean and standard error

This shows clear morphological differences between spike waveforms and noise, enabling better cluster validation.

![image](https://github.com/tracyaobeng/Sorting-Action-Potentials/blob/main/AP_noise_waveform.png)
### . 3D PCA Clustering of Spikes and Noise
This plot shows the first three principal components from the PCA performed on the spike and noise matrices. Points are color-coded by cluster (e.g., red, blue, green for spikes, black for noise).
It shows how spikes cluster separately from noise in reduced-dimensional space.

![image](https://github.com/tracyaobeng/Sorting-Action-Potentials/blob/main/PCA_plot.png)




