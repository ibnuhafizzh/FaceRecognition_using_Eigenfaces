function [ imgs, labels ] = loadSubset(subsets, yaleDir)
    if nargin < 2  
        yaleDir = '/Users/ibnuhafizh/Desktop/yaleBfaces/yaleBfaces'; 
    end
    imgs = [];
    labels = [];
    for i=1:length(subsets)
        subsetDir = sprintf('%s/subset%d/', yaleDir, subsets(i));
        files = dir(subsetDir);
        for j=1:length(files)
            [person, count] = sscanf(files(j).name, 'person%02d');
            if count == 1
                img = single(im2double( ...
                    (imread([subsetDir files(j).name]))) ...
                    );
                imgs = [imgs; img(:)'];
                labels = [labels; person];
            end
        end
    end
    imgs = imgs'; 
end


