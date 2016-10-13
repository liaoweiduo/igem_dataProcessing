%need Int
interval=0.4;
Title = '20161012,R-GECO+Piezo1&R-GECO,compare,microfluidics';
Legend= {...
    'R-GECO+Piezo1   background',...
    'R-GECO+Piezo1   50ul/min slow',...
    'R-GECO              background',...
    'R-GECO              50ul/min slow',...
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
    errorbar_tick(eh);
    %plot(bMatrix.*0.4,Intfm);
end
h = legend(Legend);set(h,'fontsize',20);
t = title(Title);set(t,'fontsize',20);
xlabel('Time(s)','fontsize',15);
ylabel('Fluorescent Intensity, dF/F0','fontsize',15);
hold off;
