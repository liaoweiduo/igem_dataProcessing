%clear all;
%load('/Users/liaoweiduo/GitHub/igem_dataProcessing/dataFig/20160907,Ionomycin.mat');
interval=0.4;
Title = '20161012,R-GECO+Piezo1,microfluidics,';
Legend= {...
    'R-GECO+Piezo1     background',...
    'R-GECO+Piezo1     50ul/min fast',...
    'R-GECO+Piezo1     100ul/min fast',...
    'R-GECO+Piezo1     50ul/min mid',...
    'R-GECO+Piezo1     100ul/min mid',...
    'R-GECO+Piezo1     50ul/min slow',...
    'R-GECO+Piezo1     100ul/min slow',...
    };
nf=size(Int,1);
nt=size(Int,2);%num of pictures in one file
np=size(Int,3);  %num of points in one picture
%figure
figure;
hold on;
bMatrix=(1:nt);
for i=1:nf
    Intf=permute(Int(i,:,:),[2,3,1])';
    Intfm=mean(Intf);Intfm=Intfm(bMatrix);
    Intfs=std(Intf);Intfs=Intfs(bMatrix);
    %eh=errorbar(bMatrix.*interval,Intfm,Intfs,'-o');
    %errorbar_tick(eh);
    plot(bMatrix.*interval,Intfm);
end
h = legend(Legend);set(h,'fontsize',20);
t = title(Title);set(t,'fontsize',20);
xlabel('Time(s)','fontsize',15);
ylabel('Fluorescent Intensity, dF/F0','fontsize',15);
hold off;

