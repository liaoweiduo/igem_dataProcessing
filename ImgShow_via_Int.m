%clear all;
%load('/Users/liaoweiduo/GitHub/igem_dataProcessing/dataFig/20160907,Ionomycin.mat');
interval=0.4;
Title = '20161012,R-GECO+Piezo1+DOX&R-GECO+Piezo1&R-GECO,compare,osmotic,original ¦Ð(in):300 mOsm/kg.H2O';
Legend= {...
    'R-GECO            ¦Ð(out):300 mOsm/kg.H2O',...
    'R-GECO            ¦Ð(out):150 mOsm/kg.H2O',...
    'R-GECO+Piezo1     ¦Ð(out):300 mOsm/kg.H2O',...
    'R-GECO+Piezo1     ¦Ð(out):150 mOsm/kg.H2O',...
    'R-GECO+Piezo1+DOX ¦Ð(out):300 mOsm/kg.H2O',...
    'R-GECO+Piezo1+DOX ¦Ð(out):150 mOsm/kg.H2O',...
    };
nf=size(Legend,2);
nt=301;%num of pictures in one file
np=5;  %num of points in one picture
%figure
figure(1);
hold on;
bMatrix=(1:5:nt);
for i=1:nf
    Intf=permute(Int(i,:,:),[2,3,1])';
    Intfm=mean(Intf);Intfm=Intfm(bMatrix);
    Intfs=std(Intf);Intfs=Intfs(bMatrix);
    eh=errorbar(bMatrix.*interval,Intfm,Intfs,'-o');
    %errorbar_tick(eh);
    %plot(bMatrix.*interval,Intfm);
end
h = legend(Legend);set(h,'fontsize',20);
t = title(Title);set(t,'fontsize',20);
xlabel('Time(s)','fontsize',15);
ylabel('Fluorescent Intensity, dF/F0','fontsize',15);
hold off;

