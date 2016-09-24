LInt=[0.0018,0.2563,0.0000,0.0000,0.0000,0.0122,0.0297,0.1343,0.0000,0.0420,0.0428,0.0119,];
LHz ={'0',   '500', '700', '1k',  '3k',  '5k',  '7k',  '9k',  '15k', '17k', '20k', '22k', };
Title = '20160909,GECO+PIEZO,sound';
bar(LInt);
set(gca,'XTickLabel',LHz,'fontsize',20);
xlabel('Hz'),ylabel('dF/F0');
set(title(Title),'fontsize',20);