% Read the image
originalImage = imread('bush_new.jpg'); % Replace 'bush_image.jpg' with the actual snapshot taken

% Convert the image to LAB color space for better color representation
labImage = rgb2lab(originalImage);

% Extract the 'a' and 'b' channels, which represent color information
aChannel = labImage(:, :, 2);
bChannel = labImage(:, :, 3);

% Threshold the 'a' and 'b' channels to segment the green part (bush)
greenThreshold = 20; % Adjust this threshold based on your image
greenMask = (aChannel < greenThreshold) & (bChannel < greenThreshold);

% Use the green mask to extract the bush region
bushRegion = originalImage;
for c = 1:3
    bushRegion(:, :, c) = originalImage(:, :, c) .* uint8(greenMask);
end

% Find the boundary of the detected bush region
edgeBushRegion = edge(rgb2gray(bushRegion), 'Canny');

% Optional: Fill enclosed regions in the edge-detected bush region
filledBushRegion = imfill(edgeBushRegion, 'holes');

% Calculate the distance transform from the right side of the image
distanceTransform = bwdist(filledBushRegion);
[maxDistance, maxDistanceIndex] = max(distanceTransform, [], 2);

% Spatial resolution (pixels per meter) - replace with actual value of lens
pixelsPerMeter = 1000;

% Convert distances from pixels to meters
maxDistanceInMeters = maxDistance / pixelsPerMeter;

% Display the original image and the identified bush region
figure;
subplot(1, 3, 1);
imshow(originalImage);
title('Original Image');

subplot(1, 3, 2);
imshow(bushRegion);
title('Detected Bush Region');

subplot(1, 3, 3);
imshow(distanceTransform, []);
title('Distance Transform');

% Display the distance to the edge from a line at the right side in meters
figure;
plot(maxDistanceInMeters, 1:size(originalImage, 1), 'LineWidth', 2);
title('Distance to Edge from Right Line (in meters)');
xlabel('Distance (meters)');
ylabel('Vertical Position');