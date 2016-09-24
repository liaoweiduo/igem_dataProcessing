%parameter initial
clear all;
rawpath = {...
    '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO+PIEZO/0/',...
    '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO+PIEZO/1_2/',...
    '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO+PIEZO/1_10/',...
    '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO+PIEZO/1_20/',...
    '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO+PIEZO/1_200/'...
    };
rawpath_p={...
    '9000hz002t%03dc1.tif',...
    '9000hz002t%03dc1.tif',...
    '9000hz002t%03dc1.tif',...
    '9000hz002t%03dc1.tif',...
    '9000hz002t%03dc1.tif'...
    };
nf=5;  %num of files
nt=451;%num of pictures in one file
np=5;  %num of points in one picture
Title = '20160907,osmotic,original π(in):300 mOsm/kg.H2O';
Legend= {...                %每张图有3个Area，一共nf*3个legend
    'GECO+PIEZO π(out):300 mOsm/kg.H2O',...
    'GECO+PIEZO π(out):150 mOsm/kg.H2O',...
    'GECO+PIEZO π(out):270 mOsm/kg.H2O',...
    'GECO+PIEZO π(out):285 mOsm/kg.H2O',...
    'GECO+PIEZO π(out):298.5 mOsm/kg.H2O'...
    };
Int = zeros(nf,nt,np*3);X = zeros(1,np*3);Y = zeros(1,np*3);L = zeros(1,np*3);W = zeros(1,np*3);

figure(1);
set (gcf,'Position',[0,250,1700,500]);
subplot(1,2,1);
for i1=1:nt
    rawfile=strcat(rawpath{2}, sprintf(rawpath_p{2}, i1));rawImg = importdata(rawfile);
	imagesc(rawImg);colorbar;t = title('pause key "a" ');set(t,'fontsize',20);
    if strcmpi(get(gcf,'CurrentCharacter'),'a')
        break;
    end
    pause(0.1);
end
t = title('Choose Background');set(t,'fontsize',20);
[x, y]=ginput(2);BgX=uint32(x(1));BgY=uint32(y(1));BgLength=uint32(x(2))-uint32(x(1));BgWidth=uint32(y(2))-uint32(y(1));
rectangle('Position',[BgX,BgY,BgLength,BgWidth],'EdgeColor','k');
pause(1);

t = title('Choose Area1');set(t,'fontsize',20);
for i=1:np
    [x, y]=ginput(2);X(i)=uint32(x(1));Y(i)=uint32(y(1));L(i)=uint32(x(2))-uint32(x(1));W(i)=uint32(y(2))-uint32(y(1));
    rectangle('Position',[X(i),Y(i),L(i),W(i)],'EdgeColor','r');
    pause(1);
end
t = title('Choose Area2');set(t,'fontsize',20);
for i=np+1:np*2
    [x, y]=ginput(2);X(i)=uint32(x(1));Y(i)=uint32(y(1));L(i)=uint32(x(2))-uint32(x(1));W(i)=uint32(y(2))-uint32(y(1));
    rectangle('Position',[X(i),Y(i),L(i),W(i)],'EdgeColor','g');
    pause(1);
end
t = title('Choose Area3');set(t,'fontsize',20);
for i=np*2+1:np*3
    [x, y]=ginput(2);X(i)=uint32(x(1));Y(i)=uint32(y(1));L(i)=uint32(x(2))-uint32(x(1));W(i)=uint32(y(2))-uint32(y(1));
    rectangle('Position',[X(i),Y(i),L(i),W(i)],'EdgeColor','b');
    pause(1);
end
lowNoisyImg = DivBackground(rawImg, BgX, BgY, BgLength, BgWidth);

for i=1:nf
    for i1=1:nt
        rawfile=strcat(rawpath{i}, sprintf(rawpath_p{i}, i1));rawImg = importdata(rawfile);
        lowNoisyImg = DivBackground(rawImg, BgX, BgY, BgLength, BgWidth);
        for ip=1:np*3
            LNImg = lowNoisyImg(Y(ip):Y(ip)+W(ip),X(ip):X(ip)+L(ip));
            LNImg_t = LNImg(:);LNImg_t = sort(LNImg_t,'descend');
            Int(i,i1,ip) = mean(LNImg_t(1:uint32(L(ip)*W(ip)/10)));
        end
    end
    for i1=2:nt
        for ip=1:np*3
            Int(i,i1,ip)=(Int(i,i1,ip)-Int(i,1,ip))./Int(i,1,ip);
        end
    end
    for ip=1:np*3
        Int(i,1,ip)=0;
    end
end

%figure
clf;
hold on;
bMatrix=(1:20:nt);
for i=1:nf
    Intf=permute(Int(i,:,1:np),[2,3,1])';       %Area1
    Intfm=mean(Intf);Intfm=Intfm(bMatrix);
    Intfs=std(Intf);Intfs=Intfs(bMatrix);
    errorbar(bMatrix.*0.4,Intfm,Intfs);
    
    Intf=permute(Int(i,:,np+1:np*2),[2,3,1])';       %Area2
    Intfm=mean(Intf);Intfm=Intfm(bMatrix);
    Intfs=std(Intf);Intfs=Intfs(bMatrix);
    errorbar(bMatrix.*0.4,Intfm,Intfs);
    
    Intf=permute(Int(i,:,np*2+1:np*3),[2,3,1])';       %Area3
    Intfm=mean(Intf);Intfm=Intfm(bMatrix);
    Intfs=std(Intf);Intfs=Intfs(bMatrix);
    errorbar(bMatrix.*0.4,Intfm,Intfs);
    
end
h = legend(Legend);set(h,'fontsize',20);
t = title(Title);set(t,'fontsize',20);
xlabel('Time(s)','fontsize',15);
ylabel('Fluorescent Intensity, dF/F0','fontsize',15);
hold off;
