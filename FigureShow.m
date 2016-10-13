%parameter initial
rawpath = '/Volumes/Seagate Expansion Drive/IGEM/20161012microfluidics/GECO+PIEZO/100';
slash='/';  rawpath_p='g+p_100t%03dc1.tif';
nt=301;

BgInt = zeros(1,nt);
SlowInt = zeros(1,nt);
figure(1);
for i1=1:nt
    rawfile=strcat(rawpath, slash, sprintf(rawpath_p, i1));
    RawImg = importdata(rawfile);
    rawImg = RawImg(:,:,1);
	imagesc(rawImg);colorbar;  caxis([0,550]);
    if strcmpi(get(gcf,'CurrentCharacter'),'a')
        break;
    end
    pause(0.01);
end
disp('choose background:');
[x, y]=ginput(2);
BgX=uint32(x(1));BgY=uint32(y(1));BgLength=uint32(x(2))-uint32(x(1));BgWidth=uint32(y(2))-uint32(y(1));
disp(BgX);disp(BgY);disp(BgLength);disp(BgWidth);

for i1=1:nt
    rawfile=strcat(rawpath, slash, sprintf(rawpath_p, i1));
    RawImg = importdata(rawfile);
    rawImg = RawImg(:,:,1);
    lowNoisyImg = DivBackground(rawImg, BgX, BgY, BgLength, BgWidth);
	imagesc(lowNoisyImg);colorbar;
    if strcmpi(get(gcf,'CurrentCharacter'),'c')
        break;
    end
    pause(0.01);
end