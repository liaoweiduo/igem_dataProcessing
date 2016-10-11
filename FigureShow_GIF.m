%parameter initial
clear all;
rawpath = '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO+PIEZO/Ionomycin/';
rawpath_p='9000hz002t%03dc1.tif';
nt=451;
wm={'overwrite','append'};



%figure(1);
%set (gcf,'Position',[500,0,1200,1000]);

for i1=1:5:nt
    rawfile=strcat(rawpath, sprintf(rawpath_p, i1));
    I = imread(rawfile);
    %imagesc(I);colorbar;pause(0.5);
    maxI=max(I(:));
    Im = I.*10;
    %imshow(Im);pause(1);
    [X, map] = gray2ind(Im, 256);
    imwrite(X,map,'dataGIF/20160907,GECO+PIEZO,Ionomycin.gif','DelayTime',0.1,'WriteMode',wm{1+(i1>1)});
end
