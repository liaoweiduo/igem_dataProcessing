function [ outVec, isNeg ] = toLog( inVec )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    isNeg=zeros(1,size(inVec,2));
    outVec=inVec
    for i=1:size(inVec,2)
        if inVec(i)<0
            isNeg(i)=1;
            outVec(i)=-log10(-inVec(i));
        elseif inVec(i)==0
                outVec(i)=0;
        else
            outVec(i)=log10(inVec(i));
        end
    end
    
end

