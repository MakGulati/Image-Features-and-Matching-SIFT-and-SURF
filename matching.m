%% PROJECT 1 -- MATCHING
clc
clear all
close all

%% reading image and converting to sing
I = imread('data1/obj1_5.jpg'); %reference image
I2 = imread('data1/obj1_t1.jpg'); %target image
G = rgb2gray(I); %grayscale ref
G2 = rgb2gray(I2); %grayscale tar
ref = single(G); %the reference image need to be normalized (single format)
target = single(G2); %the target as well

figure()

imshow([G, G2]);

%%Applying SIFT on reference image
%thresholds for sift: we computed them with trial-and-error method to
%achieve few hundreds of keypoints (250), best in term of representation
peakthresh = 8; %8
edgethresh = 1.8; %1.8

[sift_ref,sift_ref_desc] = vl_sift(ref,'PeakThresh',peakthresh,'EdgeThresh',edgethresh);

n_det_ref = size(sift_ref,2); %number of detected keypoints on reference image

%plotting sift keypoints of reference image
h1 = vl_plotframe(sift_ref);
set(h1,'color','r','linewidth',3);

%%Applying SIFT on target image 
[sift_tar,sift_tar_desc] = vl_sift(target,'PeakThresh',peakthresh,'EdgeThresh',edgethresh);

n_det_tar = size(sift_tar,2); %number of detected keypoints on target image

%plotting the shifted sift keypoints of the target image (because it's a montage of himage)
sift_tar_plot = sift_tar;
sift_tar_plot(1,:) = sift_tar(1,:) + size(target,2); %with the shift
h2 = vl_plotframe(sift_tar_plot);
set(h2,'color','y','linewidth',3);
hold on;

%% 'fixed threshold' matching algorithm
%euclidean distance on feature (descriptor) space below a fixed thresh

fixed_thresh = 69;
counter_matches = 0;

for i = 1 : n_det_ref
      for j = 1 : n_det_tar
          euclid_dist(i,j) = sqrt(sum((sift_ref_desc(:,i) - sift_tar_desc(:,j)).^2));
          if(euclid_dist(i,j) <= fixed_thresh)
                counter_matches = counter_matches + 1; 
                match_pairs_indexes(counter_matches,1) = i; %index of ref
                match_pairs_indexes(counter_matches,2) = j; %index of target                
          end
          
      end
end

for k = 1 : counter_matches
      plot([sift_ref(1,k)  sift_tar_plot(1,k)],[sift_ref(2,k) sift_tar_plot(2,k)],'-b');
end
