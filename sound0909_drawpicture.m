clear all;
rawpath = '/Volumes/Seagate Expansion Drive/IGEM/20160909sound/GECO+PIEZO/15K/';
rawpath_p='9000hz002t100c1.tif';
rawfile=strcat(rawpath, rawpath_p);
rawImg = imread(rawfile);
figure(1);
imagesc(rawImg);colorbar;
[x, y]=ginput(2);BgX=uint32(x(1));BgY=uint32(y(1));BgLength=uint32(x(2))-uint32(x(1));BgWidth=uint32(y(2))-uint32(y(1));
rectangle('Position',[BgX,BgY,BgLength,BgWidth],'EdgeColor','k');
pause(1);
[x, y]=ginput(2);X=uint32(x(1));Y=uint32(y(1));L=uint32(x(2))-uint32(x(1));W=uint32(y(2))-uint32(y(1));
rectangle('Position',[X,Y,L,W],'EdgeColor','r');
