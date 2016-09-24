%parameter initial
clear all;
rawpath = {...
    '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO+PIEZO/0/',...
    '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO+PIEZO/1_200/',...
    '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO+PIEZO/1_20/',...
    '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO+PIEZO/1_10/',...
    '/Volumes/Seagate Expansion Drive/IGEM/20160907osmotic/GECO+PIEZO/1_2/'...
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
Title = '20160907,osmotic,original ¦Ð(in):300 mOsm/kg.H2O';
Legend= {...
    'GECO+PIEZO ¦Ð(out):298.5 mOsm/kg.H2O',...
    'GECO+PIEZO ¦Ð(out):285 mOsm/kg.H2O',...
    'GECO+PIEZO ¦Ð(out):270 mOsm/kg.H2O',...
    'GECO+PIEZO ¦Ð(out):150 mOsm/kg.H2O',...
    'GECO+PIEZO ¦Ð(out):300 mOsm/kg.H2O'...
    };
Int = zeros(nf,nt,np);X = zeros(nf,np);Y = zeros(nf,np);L = zeros(nf,np);W = zeros(nf,np);BgX = zeros(nf);BgY = zeros(nf);BgLength = zeros(nf);BgWidth = zeros(nf);

figure(2);
set (gcf,'Position',[0,250,1700,500]);
subplot(1,2,1);
for i=1:nf
    for i1=1:nt
        rawfile=strcat(rawpath{i}, sprintf(rawpath_p{i}, i1));rawImg = importdata(rawfile);
        imagesc(rawImg);colorbar;t = title('pause key ');set(t,'fontsize',20);
        if strcmpi(get(gcf,'CurrentCharacter'),char(int16('a')+i-1))
            break;
        end
        pause(0.1);
    end
    t = title('Picture');set(t,'fontsize',20);
    [x, y]=ginput(2);BgX(i)=uint32(x(1));BgY(i)=uint32(y(1));BgLength(i)=uint32(x(2))-uint32(x(1));BgWidth(i)=uint32(y(2))-uint32(y(1));
    rectangle('Position',[BgX(i),BgY(i),BgLength(i),BgWidth(i)],'EdgeColor','k');
    pause(1);

    for ip=1:np
        [x, y]=ginput(2);X(i,ip)=uint32(x(1));Y(i,ip)=uint32(y(1));L(i,ip)=uint32(x(2))-uint32(x(1));W(i,ip)=uint32(y(2))-uint32(y(1));
        rectangle('Position',[X(i,ip),Y(i,ip),L(i,ip),W(i,ip)],'EdgeColor','r');
        pause(1);
    end
end

for i=1:nf
    for i1=1:nt
        rawfile=strcat(rawpath{i}, sprintf(rawpath_p{i}, i1));rawImg = importdata(rawfile);
        lowNoisyImg = DivBackground(rawImg, uint32(BgX(i)), uint32(BgY(i)), uint32(BgLength(i)), uint32(BgWidth(i)));
        for ip=1:np
            LNImg = lowNoisyImg(Y(i,ip):Y(i,ip)+W(i,ip),X(i,ip):X(i,ip)+L(i,ip));
            LNImg_t = LNImg(:);LNImg_t = sort(LNImg_t,'descend');
            Int(i,i1,ip) = mean(LNImg_t(1:uint32(L(i,ip)*W(i,ip)/10)));
        end
    end
    for i1=2:nt
        for ip=1:np
            Int(i,i1,ip)=(Int(i,i1,ip)-Int(i,1,ip))./Int(i,1,ip);
        end
    end
    for ip=1:np
        Int(i,1,ip)=0;
    end
end

%figure
subplot(1,2,2);
hold on;
bMatrix=(1:20:nt);
for i=1:nf
    Intf=permute(Int(i,:,:),[2,3,1])';
    Intfm=mean(Intf);Intfm=Intfm(bMatrix);
    Intfs=std(Intf);Intfs=Intfs(bMatrix);
    errorbar(bMatrix.*0.4,Intfm,Intfs);
    %plot(bMatrix.*0.4,Intfm);
end
h = legend(Legend);set(h,'fontsize',20);
t = title(Title);set(t,'fontsize',20);
xlabel('Time(s)','fontsize',15);
ylabel('Fluorescent Intensity, dF/F0','fontsize',15);
hold off;
