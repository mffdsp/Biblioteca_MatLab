function tElTableCreateElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismCreateElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','InputDlg','MsgBox');  %Load Language File

nElTableOx=str2double(get(handles.tElTableOx,'String'));
nElTableOy=str2double(get(handles.tElTableOy,'String'));
nElTableOz=str2double(get(handles.tElTableOz,'String'));

nElTableSizeX=str2double('2');
nElTableSizeY=str2double('2');
nElTableSizeZ=str2double('0.2');

aOrigin=[nElTableOx nElTableOy nElTableOz];
aDist=[nElTableSizeX nElTableSizeY nElTableSizeZ];

%Cria o Elemento
[aPlane]=fCreateTable(aOrigin,aDist);

%Cria elemento da base

%Caso centralizado
aPeOrigin=[nElTableOx + nElTableSizeX/2 - nElTableSizeZ/2, nElTableOy + nElTableSizeY/2 - nElTableSizeZ/2, 0];

%Caso tenha 4 bases
aPeOrigin1=[nElTableOx nElTableOy 0];
aPeOrigin2=[nElTableOx + nElTableSizeX - nElTableSizeZ, nElTableOy, 0];
aPeOrigin3=[nElTableOx, nElTableOy + nElTableSizeY - nElTableSizeZ, 0];
aPeOrigin4=[nElTableOx + nElTableSizeX - nElTableSizeZ,  nElTableOy + nElTableSizeY - nElTableSizeZ, 0];

%central
[aPe]=fCreateTableBase(aPeOrigin,[0.2, 0.2 , nElTableOz]);

%Padrão
[aPe1]=fCreateTableBase(aPeOrigin1,[0.2, 0.2 , nElTableOz]);
[aPe2]=fCreateTableBase(aPeOrigin2,[0.2, 0.2 , nElTableOz]);
[aPe3]=fCreateTableBase(aPeOrigin3,[0.2, 0.2 , nElTableOz]);
[aPe4]=fCreateTableBase(aPeOrigin4,[0.2, 0.2 , nElTableOz]);

% Identifica planos a serem visualizados 

aPlanePrev=[];
aPlanePrev = tPlanIdentifier(aPlane, true, true, true);

% Identifica planos a serem visualizados da base

aPePrev=[];
aPePrev = tPlanIdentifier(aPe, true, false, true);

% aPePrev1 = [];
% aPePrev2 = [];
% aPePrev3 = [];
% aPePrev4 = [];
% 
% aPePrev1 = tPlanIdentifier(aPe1);
% aPePrev2 = tPlanIdentifier(aPe2);
% aPePrev3 = tPlanIdentifier(aPe3);
% aPePrev4 = tPlanIdentifier(aPe4);

%pre
nRoom=str2double(get(handles.tRoomNum,'String'));
nSizePlanes=size(aPlanePrev,1);
nSizePlanes2=size(aPePrev,1);

%Verifica a qual grupo pertencerá os novos planos
aDataPoins=get(handles.tTablePlanes,'Data');
nGroup=max(cellfun(@max,aDataPoins(:,3)))+1;

%Insere Plano a Plano4
nSizePlanesNew=0;
for nP=1:nSizePlanes
    aVert=aPlanePrev(nP,:);
    
    % Verifica se o plano possui area
    nW1=(((aVert{2}(2)-aVert{1}(2))*(aVert{3}(3)-aVert{1}(3)))-((aVert{3}(2)-aVert{1}(2))*(aVert{2}(3)-aVert{1}(3))));
    nW2=(((aVert{3}(1)-aVert{1}(1))*(aVert{2}(3)-aVert{1}(3)))-((aVert{2}(1)-aVert{1}(1))*(aVert{3}(3)-aVert{1}(3))));
    nW3=(((aVert{2}(1)-aVert{1}(1))*(aVert{3}(2)-aVert{1}(2)))-((aVert{3}(1)-aVert{1}(1))*(aVert{2}(2)-aVert{1}(2))));
    nR=sqrt(nW1*nW1+nW2*nW2+nW3*nW3);
    if nR~=0 %Não Colineares 
        fPutNewSinglePlane(nRoom,aVert,get(handles.ttElPrismElementName,'String'),nGroup);
        nSizePlanesNew=nSizePlanesNew+1;
    end
end

nSizePlanesNew2=0;
for nP=1:nSizePlanes2
    aVert=aPePrev(nP,:);
    
    % Verifica se o plano possui area
    nW1=(((aVert{2}(2)-aVert{1}(2))*(aVert{3}(3)-aVert{1}(3)))-((aVert{3}(2)-aVert{1}(2))*(aVert{2}(3)-aVert{1}(3))));
    nW2=(((aVert{3}(1)-aVert{1}(1))*(aVert{2}(3)-aVert{1}(3)))-((aVert{2}(1)-aVert{1}(1))*(aVert{3}(3)-aVert{1}(3))));
    nW3=(((aVert{2}(1)-aVert{1}(1))*(aVert{3}(2)-aVert{1}(2)))-((aVert{3}(1)-aVert{1}(1))*(aVert{2}(2)-aVert{1}(2))));
    nR=sqrt(nW1*nW1+nW2*nW2+nW3*nW3);
    if nR~=0 %Não Colineares 
        fPutNewSinglePlane(nRoom,aVert,get(handles.ttElPrismElementName,'String'),nGroup);
        nSizePlanesNew2=nSizePlanesNew2+1;
    end
end

%Atualiza a exibição com os novos planos criados
nSizeData=size(aDataPoins,1);
nPlanes=nSizeData+1:nSizeData+nSizePlanesNew+nSizePlanesNew2;
fUpdateData(handles,nPlanes,true);

sMens=[MsgBox.ElementCreated];

uiwait(msgbox(sMens));

%Limpa Campos
fClearFieldsCreatePrism(handles)

% Apaga tab
set(handles.tPanElementTable,'Visible','off');

%Destrava as Abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanShadingButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
