%parameter initial
rawpath = '/Volumes/Seagate Expansion Drive/IGEM/20160907sound/PIEZO+RGECO/100/22k';
slash='/';  rawpath_p='15khzt%03dc1.tif';
rawpath = '/Volumes/Seagate Expansion Drive/IGEM/20160907sound/PIEZO+RGECO/100/22k';
nt=150;
Title = '20160907,GECO+PIEZO,sound,22kHz';

BgInt = zeros(1,nt);
SlowInt = zeros(1,nt);
figure;
set (gcf,'Position',[0,0,1700,500]);
subplot(1,2,1);
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

imagesc(rawImg);colorbar;
t = title('Picture');
set(t,'fontsize',20);
rectangle('Position',[BgX,BgY,BgLength,BgWidth],'EdgeColor','k');

disp('choose FirstArea:');
[x, y]=ginput(2);
SlowX=uint32(x(1));SlowY=uint32(y(1));SlowLength=uint32(x(2))-uint32(x(1));SlowWidth=uint32(y(2))-uint32(y(1));
disp(SlowX);disp(SlowY);disp(SlowLength);disp(SlowWidth);
rectangle('Position',[SlowX,SlowY,SlowLength,SlowWidth],'EdgeColor','r');
pause(1);

lowNoisyImg = DivBackground(rawImg, BgX, BgY, BgLength, BgWidth);
for i1=1:nt
    rawfile=strcat(rawpath, slash, sprintf(rawpath_p, i1));
    RawImg = importdata(rawfile);
    rawImg = RawImg(:,:,1);

    lowNoisyImg = DivBackground(rawImg, BgX, BgY, BgLength, BgWidth);
    LNImg = lowNoisyImg(BgY:BgY+BgWidth,BgX:BgX+BgLength);
    LNImg_t = LNImg(:);
    LNImg_t = sort(LNImg_t,'descend');
    BgInt(i1) = mean(LNImg_t(1:(BgLength*BgWidth/10)));
    LNImg = lowNoisyImg(SlowY:SlowY+SlowWidth,SlowX:SlowX+SlowLength);
    LNImg_t = LNImg(:);
    LNImg_t = sort(LNImg_t,'descend');
    SlowInt(i1) = mean(LNImg_t(1:(SlowLength*SlowWidth/10)));  
end

for i1=2:nt
    BgInt(i1)=(BgInt(i1)-BgInt(1))./BgInt(1);
    SlowInt(i1)=(SlowInt(i1)-SlowInt(1))./SlowInt(1);
end
BgInt(1)=0;SlowInt(1)=0;
LInt=max(SlowInt)

%figure
subplot(1,2,2);
hold on;
plot((1:nt).*0.4,BgInt,'k');
plot((1:nt).*0.4,SlowInt,'r');
h = legend('Background','Area');
set(h,'fontsize',20);
t = title(strcat(Title,',max dF/F0=',num2str(LInt)));
set(t,'fontsize',20);
xlabel('Time(s)','fontsize',15);
ylabel('Fluorescent Intensity, dF/F0','fontsize',15);
hold off;