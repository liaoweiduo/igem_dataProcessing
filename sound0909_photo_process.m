clear all;
rawpath = '/Volumes/Seagate Expansion Drive/IGEM/20160909sound/GECO+PIEZO/15K/';
rawpath_p='9000hz002t100c1.tif';
rawfile=strcat(rawpath, rawpath_p);
rawImg = imread(rawfile);
figure(1);
imagesc(rawImg);colorbar;
[x, y]=ginput(2);BgX=uint32(x(1));BgY=uint32(y(1));BgLength=uint32(x(2))-uint32(x(1));BgWidth=uint32(y(2))-uint32(y(1));
lowNoisyImg = DivBackground(rawImg, uint32(BgX), uint32(BgY), uint32(BgLength), uint32(BgWidth));
imagesc(lowNoisyImg);colorbar;
rectangle('Position',[BgX,BgY,BgLength,BgWidth],'EdgeColor','k');
pause(1);
[x, y]=ginput(2);X=uint32(x(1));Y=uint32(y(1));L=uint32(x(2))-uint32(x(1));W=uint32(y(2))-uint32(y(1));
rectangle('Position',[X,Y,L,W],'EdgeColor','r');
pause(1);
LNImg = lowNoisyImg(Y:Y+W,X:X+L);
LNImg_t = LNImg(:);[LNImg_tt,index] = sort(LNImg_t,'descend');
index_line=uint32(index( uint32(size(index,1)*0.01) : uint32(size(index,1)*0.11) ));
index_line_x=floor(index_line/size(LNImg,1))+1;
index_line_y=mod(index_line,size(LNImg,1));
for i=1:size(index_line_x,1)
    rectangle('Position',[index_line_x(i)+X,index_line_y(i)+Y,1,1],'EdgeColor','r');
end