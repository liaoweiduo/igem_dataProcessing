path='/Volumes/Seagate Expansion Drive/IGEM/20160925sound/TIF/small foger/geco+piezo/USini/';
path_p='usini001t%03dc1.tif';
for i=301:400
    file=strcat(path, sprintf(path_p, i));rawImg = importdata(file);
    imwrite(rawImg,strcat(path,sprintf(path_p, i+100)));
end