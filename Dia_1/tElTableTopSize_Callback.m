function tElTableTopSize_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElPrismSizeX as text
%        str2double(get(hObject,'String')) returns contents of tElPrismSizeX as a double

% Traz Dados 
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
%Centralizado
%fRoomPreviewElement2(hObject,eventdata,handles,aPePrev);

%4 pes
fRoomPreviewElement2(hObject,eventdata,handles,aPePrev1);
fRoomPreviewElement2(hObject,eventdata,handles,aPePrev2);
fRoomPreviewElement2(hObject,eventdata,handles,aPePrev3);
fRoomPreviewElement2(hObject,eventdata,handles,aPePrev4);
