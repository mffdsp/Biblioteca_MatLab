function tElChairSize_Callback(hObject, eventdata, handles)

% hObject    handle to tElPrismSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElPrismSizeX as text
%        str2double(get(hObject,'String')) returns contents of tElPrismSizeX as a double

% Traz Dados 
nElTableOx=str2double(get(handles.tElChairOx,'String'));
nElTableOy=str2double(get(handles.tElChairOy,'String'));
nElTableDistZ=str2double(get(handles.tElChairOz,'String'));

nElTableSizeX=str2double('0.8');
nElTableSizeY=str2double('0.8');
nElTableSizeZ=str2double('0.1');

aAngle_dot = str2double(get(handles.tElChairAngle,'String'));

nElTableOx=nElTableOx*cos(0)+nElTableOy*(-sin(0));
nElTableOy=nElTableOx*sin(0)+nElTableOy*cos(0);
nElTableOz=0; 

aOrigin=[nElTableOx nElTableOy nElTableOz];
aDist=[nElTableSizeX nElTableSizeY 0.2];


%Cria o Elemento
[aPlane]=fCreateTable([nElTableOx nElTableOy nElTableOz+nElTableDistZ],0,aDist);

%Caso tenha 4 bases
aPeOrigin1=[nElTableOx nElTableOy nElTableOz];
aPeOrigin2=[nElTableOx + nElTableSizeX - nElTableSizeZ, nElTableOy, nElTableOz];
aPeOrigin3=[nElTableOx, nElTableOy + nElTableSizeY - nElTableSizeZ, nElTableOz];
aPeOrigin4=[nElTableOx + nElTableSizeX - nElTableSizeZ,  nElTableOy + nElTableSizeY - nElTableSizeZ, nElTableOz];

%cria a costs

%Posição
if aAngle_dot < 1 || aAngle_dot > 4
    nElTableSizeX = 0.1;
end
if aAngle_dot == 1
    nElTableSizeX = 0.1;
end
if aAngle_dot == 2
    nElTableOy = nElTableOy + nElTableSizeY - 0.1;
    nElTableSizeY = 0.1;
end
if aAngle_dot == 3
    nElTableSizeY = 0.1;
end
if aAngle_dot == 4
    nElTableOx = nElTableOx + nElTableSizeX - 0.1;
    nElTableSizeX = 0.1;
end

aCostaOrigin=[nElTableOx, nElTableOy, nElTableSizeZ*2+nElTableDistZ];

%Padrão
[aPe1]=fCreateTable(aPeOrigin1,0,[0.1, 0.1 , nElTableDistZ]);
[aPe2]=fCreateTable(aPeOrigin2,0,[0.1, 0.1 , nElTableDistZ]);
[aPe3]=fCreateTable(aPeOrigin3,0,[0.1, 0.1 , nElTableDistZ]);
[aPe4]=fCreateTable(aPeOrigin4,0,[0.1, 0.1 , nElTableDistZ]);

[aCosta]=fCreateTable(aCostaOrigin,0,[nElTableSizeX, nElTableSizeY, nElTableDistZ + 0.2]);

% Identifica planos a serem visualizados 

aCostaPrev=[];
aCostaPrev = tPlanIdentifier(aCosta, true, true, true);

aPlanePrev=[];
aPlanePrev = tPlanIdentifier(aPlane, true, true, true);

aPePrev1 = [];
aPePrev2 = [];
aPePrev3 = [];
aPePrev4 = [];

aPePrev1 = tPlanIdentifier(aPe1, true, false, true);
aPePrev2 = tPlanIdentifier(aPe2, true, false, true);
aPePrev3 = tPlanIdentifier(aPe3, true, false, true);
aPePrev4 = tPlanIdentifier(aPe4, true, false, true);

%Visualiza o Elemento
fRoomPreviewElement(hObject,eventdata,handles,aPlanePrev);

%Nao deleta a mesa
fRoomPreviewElement2(hObject,eventdata,handles,aPePrev1);
fRoomPreviewElement2(hObject,eventdata,handles,aPePrev2);
fRoomPreviewElement2(hObject,eventdata,handles,aPePrev3);
fRoomPreviewElement2(hObject,eventdata,handles,aPePrev4);

fRoomPreviewElement2(hObject,eventdata,handles,aCostaPrev);
