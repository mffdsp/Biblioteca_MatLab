function [aPlane]=fCreateTable(aOrigin,aDist)

% Calcula os vetores diretores em função do ângulo dado
% Em X
aVetX=[1 tan(0*pi()/180) tan(0*pi()/180)];
aCosDirX=aVetX/norm(aVetX);

% Em Y
aVetY=[tan(0*pi()/180) 1 tan(0*pi()/180)];
aCosDirY=aVetY/norm(aVetY);

% Em Z
aVetZ=[tan(0*pi()/180) tan(0*pi()/180) 1];
aCosDirZ=aVetZ/norm(aVetZ);


% Isola os Pontos
aPtA=aOrigin;
aPtB=aOrigin+aCosDirY*aDist(2);
aPtD=aOrigin+aCosDirX*aDist(1);
aPtE=aOrigin+aCosDirZ*aDist(3);

%Calcula os demais pontos
aPtC=aOrigin+(aPtD-aPtA)+(aPtB-aPtA);
aPtH=aOrigin+(aPtD-aPtA)+(aPtE-aPtA);
aPtF=aOrigin+(aPtB-aPtA)+(aPtE-aPtA);
aPtG=aOrigin+(aPtD-aPtA)+(aPtB-aPtA)+(aPtE-aPtA);

aPlane{1,1}=aPtA; aPlane{1,2}=aPtB; aPlane{1,3}=aPtC; aPlane{1,4}=aPtD; % Base
aPlane{2,1}=aPtE; aPlane{2,2}=aPtH; aPlane{2,3}=aPtG; aPlane{2,4}=aPtF; % Topo
aPlane{3,1}=aPtA; aPlane{3,2}=aPtD; aPlane{3,3}=aPtH; aPlane{3,4}=aPtE; % Lado
aPlane{4,1}=aPtD; aPlane{4,2}=aPtC; aPlane{4,3}=aPtG; aPlane{4,4}=aPtH; % Lado
aPlane{5,1}=aPtC; aPlane{5,2}=aPtB; aPlane{5,3}=aPtF; aPlane{5,4}=aPtG; % Lado
aPlane{6,1}=aPtF; aPlane{6,2}=aPtB; aPlane{6,3}=aPtA; aPlane{6,4}=aPtE; % Lado
