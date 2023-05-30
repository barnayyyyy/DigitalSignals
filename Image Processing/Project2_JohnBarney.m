%% Project 2
% John Barney
% Dr. Reising
% ENEE.4820.42682
% 7 December 2022

clear; clc; close all                                                       % setup procedures

%% undergraduate_data.mat
load('undergraduate_data.mat');                                             % load in .mat file
% load('graduate_data.mat');                                                % load in .mat file
ps = photoshift;                                                            % renaming variable

[optimizer, metric] = imregconfig('monomodal');                             % create the optimizer and metric and sets the modality to monomodal
figure                                                                      % initialize new figure

for index = 2:1:size(photoshift, 3)                                         % looping through photoshift by images
    subplot(2,1,1)                                                          % first image in subplot
    imagesc(photoshift(:,:,index)); title('Registered Frames'); grid on; daspect( [1 1 1] ); drawnow    % plotting the original image in photoshift 

    ps(:,:,index) = imregister(photoshift(:,:,index), ps(:,:,index-1), "affine", optimizer, metric);    % display new frame in same way as original frame
    subplot(2,1,2)                                                                                      % second image in subplot
    imagesc(ps(:,:,index)); grid on; daspect( [1 1 1] ); drawnow                                        % display image with scales colors
    pause(0.05)                                                                                         % delay so images can be seen
end

averaging = mean(ps,3);                 % taking mean of new image along images dimension
figure; imshow(averaging,[]);           % initialize new figure & show final figure 

save averaging_JohnBarney.mat averaging % saving final processed image as .mat file

%% flock.jpg
photo_og = imread("flock.jpg","jpg");   % read original photo
photo = rgb2gray(photo_og);             % convert original photo to grayscale

F = fft2(photo);                        % fourier transform of photo

Fabs = abs(F);                          % fourier transform of photo
Fcen = fftshift(F);                     % centered spectrum of photo
Flog = log(1+abs(Fcen));                % apply log transform

F = ifftshift(Fcen);                    % centering image
f = ifft2(F);                           % reconstructing image

% Displaying results
figure                                  % initialize new figure
subplot(2,3,1), imshow(photo_og),       title('Original Photo');
subplot(2,3,2), imshow(photo),          title('Grayscale Photo');
subplot(2,3,3), imshow(Fabs,[]),        title('FFT of Photo');
subplot(2,3,4), imshow(abs(Fcen),[]),   title('Centered FFT of Photo');
subplot(2,3,5), imshow(Flog,[]),        title('Magnitude of Photo');
subplot(2,3,6), imshow(f,[]),           title('Reconstructed Photo');