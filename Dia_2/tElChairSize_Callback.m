function tElChairSize_Callback(hObject, eventdata, handles)

% hObject    handle to tElPrismSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElPrismSizeX as text
%        str2double(get(hObject,'String')) returns contents of tElPrismSizeX as a double

% Traz Dados 
nElTableOx=str2double(get(handles.tElChairOx,'String'));
nElTableOy=str2double(get(handles.tElChairOy,'String'));
nElTableOz=str2double(get(handles.tElChairOz,'String'));

nElTableSizeX=str2double('0.8');
nElTableSizeY=str2double('0.8');
nElTableSizeZ=str2double('0.1');

aOrigin=[nElTableOx nElTableOy nElTableOz];
aDist=[nElTableSizeX nElTableSizeY nElTableSizeZ];

%Cria o Elemento
[aPlane]=fCreateTable(aOrigin,aDist);

%Caso tenha 4 bases
aPeOrigin1=[nElTableOx nElTableOy 0];
aPeOrigin2=[nElTableOx + nElTableSizeX - nElTableSizeZ, nElTableOy, 0];
aPeOrigin3=[nElTableOx, nElTableOy + nElTableSizeY - nElTableSizeZ, 0];
aPeOrigin4=[nElTableOx + nElTableSizeX - nElTableSizeZ,  nElTableOy + nElTableSizeY - nElTableSizeZ, 0];

%cria a costa
aCostaOrigin=[nElTableOx, nElTableOy, nElTableOz + nElTableSizeZ];

%Padrão
[aPe1]=fCreateTableBase(aPeOrigin1,[0.1, 0.1 , nElTableOz]);
[aPe2]=fCreateTableBase(aPeOrigin2,[0.1, 0.1 , nElTableOz]);
[aPe3]=fCreateTableBase(aPeOrigin3,[0.1, 0.1 , nElTableOz]);
[aPe4]=fCreateTableBase(aPeOrigin4,[0.1, 0.1 , nElTableOz]);
[aCosta]=fCreateTable(aCostaOrigin,[nElTableSizeX, 0.1, nElTableOz + 0.2]);

% Identifica planos a serem visualizados 

aCostaPrev=[];
aCostaPrev = tPlanIdentifier(aCosta, false, true, true);

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
