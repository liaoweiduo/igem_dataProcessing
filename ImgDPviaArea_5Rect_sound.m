
%parameter initial
clear all;
rawpath = {...
    '/Volumes/Seagate Expansion Drive/IGEM/20161012osmotic/GECO+PIEZO+DOX/100/',...
    '/Volumes/Seagate Expansion Drive/IGEM/20161012osmotic/GECO+PIEZO+DOX/50/'...
    '/Volumes/Seagate Expansion Drive/IGEM/20161012osmotic/GECO+PIEZO/100/'...
    '/Volumes/Seagate Expansion Drive/IGEM/20161012osmotic/GECO+PIEZO/50/'...
    '/Volumes/Seagate Expansion Drive/IGEM/20161012osmotic/GECO/100/'...
    '/Volumes/Seagate Expansion Drive/IGEM/20161012osmotic/GECO/50/'...
    };
rawpath_p={...
    'g+p+d_100t%03dc1.tif',...
    'g+p+d_50t%03dc1.tif',...
    'g+p_100t%03dc1.tif',...
    'g+p_50t%03dc1.tif',...
    'g_100t%03dc1.tif',...
    'g_50t%03dc1.tif',...
    };
nf=size(rawpath,2);  %num of files
nt=301;%num of pictures in one file
np=5;  %num of points in one picture
interval=0.4;
Title = '20161012,R-GECO+Piezo1+DOX,osmotic,original ¦Ð(in):300 mOsm/kg.H2O';
Legend= {...
    'R-GECO+Piezo1+DOX   ¦Ð(out):300 mOsm/kg.H2O',...
    'R-GECO+Piezo1+DOX   ¦Ð(out):270 mOsm/kg.H2O'...
    'R-GECO+Piezo1+DOX   ¦Ð(out):240 mOsm/kg.H2O'...
    'R-GECO+Piezo1+DOX   ¦Ð(out):210 mOsm/kg.H2O'...
    'R-GECO+Piezo1+DOX   ¦Ð(out):180 mOsm/kg.H2O'...
    'R-GECO+Piezo1+DOX   ¦Ð(out):150 mOsm/kg.H2O'...
    };
Int = zeros(nf,nt,np);X = zeros(nf,np);Y = zeros(nf,np);L = zeros(nf,np);W = zeros(nf,np);BgX = zeros(nf);BgY = zeros(nf);BgLength = zeros(nf);BgWidth = zeros(nf);

figure;
set (gcf,'Position',[500,0,1200,1000]);

for i=1:nf
    isSkip = 0;
    for i1=1:nt
        rawfile=strcat(rawpath{i}, sprintf(rawpath_p{i}, i1));rawImg = importdata(rawfile);rawImg=rawImg(:,:,1);
        imagesc(rawImg);colorbar; %caxis([100,250]);
        t = title(strcat('pause key: ',char(int16('a')+i-1)));set(t,'fontsize',20);
        if strcmpi(get(gcf,'CurrentCharacter'),char(int16('a')+i-1))
            break;
        elseif strcmpi(get(gcf,'CurrentCharacter'),char(int16('1')+i-1))
            isSkip=1;
            break;
        end
        pause(0.1);
    end
    if isSkip==1
        BgX(i)=uint32(BgX(i-1));BgY(i)=uint32(BgY(i-1));BgLength(i)=uint32(BgLength(i-1));BgWidth(i)=uint32(BgWidth(i-1));
        for ip=1:np
            X(i,ip)=uint32(X(i-1,ip));Y(i,ip)=uint32(Y(i-1,ip));L(i,ip)=uint32(L(i-1,ip));W(i,ip)=uint32(W(i-1,ip));
        end
        continue;
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
        rawfile=strcat(rawpath{i}, sprintf(rawpath_p{i}, i1));rawImg = importdata(rawfile);rawImg=rawImg(:,:,1);
        lowNoisyImg = DivBackground(rawImg, uint32(BgX(i)), uint32(BgY(i)), uint32(BgLength(i)), uint32(BgWidth(i)));
        for ip=1:np
            LNImg = lowNoisyImg(Y(i,ip):Y(i,ip)+W(i,ip),X(i,ip):X(i,ip)+L(i,ip));
            LNImg_t = LNImg(:);LNImg_t = sort(LNImg_t,'descend');
            Int(i,i1,ip) = mean(LNImg_t(uint32(L(i,ip)*W(i,ip)*0.01) : uint32(L(i,ip)*W(i,ip)*0.11)));
        end
    end
    for i1=2:nt
        for ip=1:np
            if Int(i,1,ip)==0
                Int(i,i1,ip)=0;
            else
                Int(i,i1,ip)=(Int(i,i1,ip)-Int(i,1,ip))./Int(i,1,ip);
            end
        end
    end
    for ip=1:np
        Int(i,1,ip)=0;
    end
end

%figure
clf;
hold on;
bMatrix=(1:5:nt);
for i=1:nf
    Intf=permute(Int(i,:,:),[2,3,1])';
    Intfm=mean(Intf);Intfm=Intfm(bMatrix);
    Intfs=std(Intf);Intfs=Intfs(bMatrix);
    errorbar(bMatrix.*interval,Intfm,Intfs,'-o');
    %plot(bMatrix.*0.4,Intfm);
end
h = legend(Legend);set(h,'fontsize',20);
t = title(Title);set(t,'fontsize',20);
xlabel('Time(s)','fontsize',15);
ylabel('Fluorescent Intensity, dF/F0','fontsize',15);
hold off;





