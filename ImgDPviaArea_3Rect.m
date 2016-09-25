%parameter initial
rawpath = '/Volumes/Seagate Expansion Drive/IGEM/20160910microfluidics/GECO+PIEZO/1_UPFAST/500';
slash='/';  rawpath_p='9000hz002t%03dc1.tif';
nt=301;
Title = '20160907,GECO+PIEZO,Ionomycin';

BgInt = zeros(1,nt);
SlowInt = zeros(1,nt);
MidInt = zeros(1,nt);
FastInt = zeros(1,nt);
figure(1);
for i1=1:nt
    rawfile=strcat(rawpath, slash, sprintf(rawpath_p, i1));
    RawImg = importdata(rawfile);
    rawImg = RawImg(:,:,1);
	imagesc(rawImg);colorbar;
    if strcmpi(get(gcf,'CurrentCharacter'),'a')
        break;
    end
    pause(0.01);
end
disp('choose background:');
[x, y]=ginput(2);
BgX=uint32(x(1));BgY=uint32(y(1));BgLength=uint32(x(2))-uint32(x(1));BgWidth=uint32(y(2))-uint32(y(1));
disp(BgX);disp(BgY);disp(BgLength);disp(BgWidth);

lowNoisyImg = DivBackground(rawImg, BgX, BgY, BgLength, BgWidth);
imagesc(lowNoisyImg);colorbar;
t = title('Background Divided Picture');
set(t,'fontsize',20);
rectangle('Position',[BgX,BgY,BgLength,BgWidth],'EdgeColor','k');

disp('choose FirstArea:');
[x, y]=ginput(2);
SlowX=uint32(x(1));SlowY=uint32(y(1));SlowLength=uint32(x(2))-uint32(x(1));SlowWidth=uint32(y(2))-uint32(y(1));
disp(SlowX);disp(SlowY);disp(SlowLength);disp(SlowWidth);
disp('choose SecondArea:');
[x, y]=ginput(2);
MidX=uint32(x(1));MidY=uint32(y(1));MidLength=uint32(x(2))-uint32(x(1));MidWidth=uint32(y(2))-uint32(y(1));
disp(MidX);disp(MidY);disp(MidLength);disp(MidWidth);
disp('choose ThirdArea:');
[x, y]=ginput(2);
FastX=uint32(x(1));FastY=uint32(y(1));FastLength=uint32(x(2))-uint32(x(1));FastWidth=uint32(y(2))-uint32(y(1));
disp(FastX);disp(FastY);disp(FastLength);disp(FastWidth);
rectangle('Position',[BgX,BgY,BgLength,BgWidth],'EdgeColor','k');
rectangle('Position',[SlowX,SlowY,SlowLength,SlowWidth],'EdgeColor','r');
rectangle('Position',[MidX,MidY,MidLength,MidWidth],'EdgeColor','g');
rectangle('Position',[FastX,FastY,FastLength,FastWidth],'EdgeColor','y');

for i1=1:nt
    rawfile=strcat(rawpath, slash, sprintf(rawpath_p, i1));
    RawImg = importdata(rawfile);
    rawImg = RawImg(:,:,1);
    
    lowNoisyImg = DivBackground(rawImg, BgX, BgY, BgLength, BgWidth);
    LNImg = lowNoisyImg(BgY:BgY+BgWidth,BgX:BgX+BgLength);
    BgInt(i1) = mean(LNImg(:));
    LNImg = lowNoisyImg(SlowY:SlowY+SlowWidth,SlowX:SlowX+SlowLength);
    LNImg_t = LNImg(:);
    LNImg_t=sort(LNImg_t,'descend');
    SlowInt(i1) = mean(LNImg_t(1:(SlowLength*SlowWidth/10)));   
    LNImg = lowNoisyImg(MidY:MidY+MidWidth,MidX:MidX+MidLength);
    LNImg_t = LNImg(:);
    LNImg_t=sort(LNImg_t,'descend');
    MidInt(i1) = mean(LNImg_t(1:(MidLength*MidWidth/10)));  
    LNImg = lowNoisyImg(FastY:FastY+FastWidth,FastX:FastX+FastLength);
    LNImg_t = LNImg(:);
    LNImg_t=sort(LNImg_t,'descend');
    FastInt(i1) = mean(LNImg_t(1:(FastLength*FastWidth/10)));   
end
for i1=2:nt
    BgInt(i1)=(BgInt(i1)-BgInt(1))./BgInt(1);
    SlowInt(i1)=(SlowInt(i1)-SlowInt(1))./SlowInt(1);
    MidInt(i1)=(MidInt(i1)-MidInt(1))./MidInt(1);
    FastInt(i1)=(FastInt(i1)-FastInt(1))./FastInt(1);
end
BgInt(1)=0;SlowInt(1)=0;MidInt(1)=0;FastInt(1)=0;
%figure
figure(2);
hold on;
plot((1:nt).*0.4,BgInt,'k');
plot((1:nt).*0.4,SlowInt,'r');
plot((1:nt).*0.4,MidInt,'g');
plot((1:nt).*0.4,FastInt,'y');
h = legend('Background','Area1','Area2','Area3');
set(h,'fontsize',20);
t = title(Title);
set(t,'fontsize',20);
xlabel('Time(s)','fontsize',15);
ylabel('Fluorescent Intensity, dF/F0','fontsize',15);
hold off;