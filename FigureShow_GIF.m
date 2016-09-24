%parameter initial
clear all;
rawpath = '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO/Ionomycin/';
slash='/';  rawpath_p='9000hz002t%03dc1.tif';
nt=100;

wm={'overwrite','append'};
for i1=20:nt
    rawfile=strcat(rawpath, slash, sprintf(rawpath_p, i1));
    I = imread(rawfile);
    [X, map] = gray2ind(I, 256);
    imwrite(X,map,'/Users/liaoweiduo/Documents/sustc/igem/数据处理/20160907,Ionomycin.gif','DelayTime',0.1,'WriteMode',wm{1+(i1>1)});
end
