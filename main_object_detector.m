clc;
clear;

% Load test image
test_img = imread('objects1.jpg');
gray_test = rgb2gray(test_img);

% آستانه‌گذاری و حذف پس‌زمینه
bw = imbinarize(gray_test, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.4);
bw = imcomplement(bw); % برعکس کردن (برای اینکه اشیاء سفید باشند)
bw = bwareaopen(bw, 500); % حذف نویزهای کوچک
bw = imclose(bw, strel('disk', 10)); % پر کردن حفره‌ها

% یافتن اشیاء با regionprops
props = regionprops(bw, 'BoundingBox');

% مسیر پوشه تصاویر مرجع
ref_folder = 'objects';
ref_files = dir(fullfile(ref_folder, '*.jpg'));

% نمایش تصویر اصلی
imshow(test_img);
hold on;

min_size = 64; % حداقل طول و عرض مجاز برای تصویر cropped

for i = 1:length(props)
    box = props(i).BoundingBox;
    
    % بررسی اندازه
    if box(3) < min_size || box(4) < min_size
        continue; % رد کردن ناحیه کوچک
    end

    cropped = imcrop(test_img, box);
    gray_crop = rgb2gray(cropped);

    % ادامه مراحل تشخیص ویژگی و مقایسه
    crop_pts = detectORBFeatures(gray_crop);
    [crop_features, crop_valid_pts] = extractFeatures(gray_crop, crop_pts);

    best_match_name = 'unknown';
    best_match_count = 0;

    for j = 1:length(ref_files)
        ref_name = ref_files(j).name;
        ref_img = imread(fullfile(ref_folder, ref_name));
        gray_ref = rgb2gray(ref_img);

        ref_pts = detectORBFeatures(gray_ref);
        [ref_features, ref_valid_pts] = extractFeatures(gray_ref, ref_pts);

        index_pairs = matchFeatures(crop_features, ref_features, ...
            'MatchThreshold', 60, 'MaxRatio', 0.7);

        match_count = size(index_pairs, 1);
        if match_count > best_match_count
            best_match_count = match_count;
            best_match_name = erase(ref_name, '.jpg');
        end
    end

    rectangle('Position', box, 'EdgeColor', 'g', 'LineWidth', 2);
    text(box(1), box(2)-10, best_match_name, 'Color', 'r', ...
        'FontSize', 12, 'FontWeight', 'bold');
end

hold off;
