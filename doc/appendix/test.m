I = imread('patella_bipartita.jpg');
I = rgb2gray(I);
figure, imshow(I);
hold on, title('Original image');

mask = false(size(I));
mask(75:125, 160:end - 25) = true;
contour(mask, [0.5 0.5], 'b');

tic;
bw = activecontour(I, mask, 300, 'edge');
contour(bw, [0.5 0.5], 'r');
legend('Initial contour', 'Final contour');
toc;