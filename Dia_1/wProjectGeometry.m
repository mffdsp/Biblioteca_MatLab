% --- Executes on button press in tElTableButton_Callback.
function tElTableButton_Callback_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Esconde demais tabs
set(handles.tPanElementCilynder,'Visible','off');
set(handles.tPanElementSphere,'Visible','off');
set(handles.tPanElementPrism,'Visible','off');

% Exibe tab
set(handles.tPanElementTable,'Visible','on');

%Limpa Visualizaçao, caso exista
try
    aPrevChild=handles.tAxesPreview.Children;
    nSizePreviewNow=size(aPrevChild,1);
    nSizePreviewOrig=str2double(get(handles.tVisPlotSize,'String'));

    if nSizePreviewNow>nSizePreviewOrig %Já há pré-visualização sendo exibida
        % Apagar pre-visualização anterior
        for nD=nSizePreviewOrig+1:nSizePreviewNow
            delete(handles.tAxesPreview.Children(1));
        end
    end
catch
end

%Coloca Visualização no centro do ambiente

% aDataPlanes=get(handles.tTablePlanes,'Data');

set(handles.tElTableOx,'String',num2str(2));
set(handles.tElTableOy,'String',num2str(2));
set(handles.tElTableOz,'String',num2str(1));

%Preciso ficar esses valores na criação
%set(handles.tElPrismSizeX,'String',num2str(8));
%set(handles.tElPrismSizeY,'String',num2str(8));
%set(handles.tElPrismSizeZ,'String',num2str(24));


% set(handles.tElPrismOx,'String',num2str(str2double(aDataPlanes{14,8})/2));
% set(handles.tElPrismOy,'String',num2str(str2double(aDataPlanes{14,12})/2));
% set(handles.tElPrismOz,'String',num2str(str2double(aDataPlanes{14,7})));

% Pre visualiza
tElTableTopSize_Callback(hObject, eventdata, handles)

%Travar as outras abas
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanShadingButton,'Enable','off');
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');

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
if true %Base
    nSize=size(aPlanePrev,1);
    for nP=1:4
        aPlanePrev{nSize+1,nP}=aPlane{1,nP};
    end
end
if true %Topo
    nSize=size(aPlanePrev,1);
    for nP=1:4
        aPlanePrev{nSize+1,nP}=aPlane{2,nP};
    end
end
if true %Lados
    nSize=size(aPlanePrev,1);
    for nP=1:4
        aPlanePrev{nSize+1,nP}=aPlane{3,nP};
        aPlanePrev{nSize+2,nP}=aPlane{4,nP};
        aPlanePrev{nSize+3,nP}=aPlane{5,nP};
        aPlanePrev{nSize+4,nP}=aPlane{6,nP};
    end
end

% Identifica planos a serem visualizados da base

aPePrev=[];
aPePrev = tPlanIdentifier(aPe);

% aPePrev1 = [];
% aPePrev2 = [];
% aPePrev3 = [];
% aPePrev4 = [];
% 
% aPePrev1 = tPlanIdentifier(aPe1);
% aPePrev2 = tPlanIdentifier(aPe2);
% aPePrev3 = tPlanIdentifier(aPe3);
% aPePrev4 = tPlanIdentifier(aPe4);

%Visualiza o Elemento
fRoomPreviewElement(hObject,eventdata,handles,aPlanePrev);

%Nao deleta a mesa
%Centralizado
fRoomPreviewElement2(hObject,eventdata,handles,aPePrev);

%4 pes
%fRoomPreviewElement2(hObject,eventdata,handles,aPePrev1);
%fRoomPreviewElement2(hObject,eventdata,handles,aPePrev2);
%fRoomPreviewElement2(hObject,eventdata,handles,aPePrev3);
%fRoomPreviewElement2(hObject,eventdata,handles,aPePrev4);


function [aPrev]=tPlanIdentifier(aPlaneDot)

aPrev=[];
if true %Base
    nSize=size(aPrev,1);
    for nP=1:4
        aPrev{nSize+1,nP}=aPlaneDot{1,nP};
    end
end
if true %Lados
    nSize=size(aPrev,1);
    for nP=1:4
        aPrev{nSize+1,nP}=aPlaneDot{3,nP};
        aPrev{nSize+2,nP}=aPlaneDot{4,nP};
        aPrev{nSize+3,nP}=aPlaneDot{5,nP};
        aPrev{nSize+4,nP}=aPlaneDot{6,nP};
    end
end
