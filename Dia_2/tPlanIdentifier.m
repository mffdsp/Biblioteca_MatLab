function [aPrev]=tPlanIdentifier(aPlaneDot, base, topo, lados)

aPrev=[];
if base %Base
    nSize=size(aPrev,1);
    for nP=1:4
        aPrev{nSize+1,nP}=aPlaneDot{1,nP};
    end
end
if topo %Topo
    nSize=size(aPrev,1);
    for nP=1:4
        aPrev{nSize+1,nP}=aPlaneDot{2,nP};
    end
end
if lados %Lados
    nSize=size(aPrev,1);
    for nP=1:4
        aPrev{nSize+1,nP}=aPlaneDot{3,nP};
        aPrev{nSize+2,nP}=aPlaneDot{4,nP};
        aPrev{nSize+3,nP}=aPlaneDot{5,nP};
        aPrev{nSize+4,nP}=aPlaneDot{6,nP};
    end
end
