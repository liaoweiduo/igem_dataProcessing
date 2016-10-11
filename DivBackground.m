function [ OutImg ] = DivBackground( InImg , BgX , BgY, BgLength , BgWidth )
    BgImg  = InImg(BgY:BgY+BgWidth,BgX:BgX+BgLength);
    BgImg_t = BgImg(:);
    BgImg_t = sort(BgImg_t,'descend');
    BgInt = mean(BgImg_t((BgLength*BgWidth/20) : (BgLength*BgWidth/10)));

    OutImg = InImg-BgInt;
end

