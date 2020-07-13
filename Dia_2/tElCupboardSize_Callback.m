function tElCupboardSize_Callback(hObject, eventdata, handles)

% hObject    handle to tElPrismSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElPrismSizeX as text
%        str2double(get(hObject,'String')) returns contents of tElPrismSizeX as a double


aPrevChild=handles.tAxesPreview.Children;
nSizePreviewNow=size(aPrevChild,1);
nSizePreviewOrig=str2double(get(handles.tVisPlotSize,'String'));

if nSizePreviewNow>nSizePreviewOrig %Já há pré-visualização sendo exibida
    % Apagar pre-visualização anterior
    for nD=nSizePreviewOrig+1:nSizePreviewNow
        delete(handles.tAxesPreview.Children(1));
    end
end


for n=1:str2double(get(handles.tElCupboardN,'String'))
    
    nElCupboardOx=str2double(get(handles.tElCupboardOx,'String'));
    nElCupboardOy=str2double(get(handles.tElCupboardOy,'String'));
    nElCupboardOz_dot=str2double(get(handles.tElCupboardOz,'String'));
    
    nElCupboardzizeX=str2double('2');
    nElCupboardzizeY=str2double('1');
    nElCupboardzizeZ=str2double('1');
    
    if n == 1
        nElCupboardOz = nElCupboardOz_dot;
    else
        nElCupboardOz =  nElCupboardOz_dot + (nElCupboardzizeZ * (n-1))
    end
    
    aOrigin=[nElCupboardOx nElCupboardOy nElCupboardOz];
    aDist=[nElCupboardzizeX nElCupboardzizeY nElCupboardzizeZ];

    %Cria o Elemento
    [aPlane]=fCreateTable(aOrigin,aDist);

    % Identifica planos a serem visualizados 
    aPrev=[];
    nSize=size(aPrev,1);
    for nP=1:4
        aPrev{nSize+1,nP}=aPlane{1,nP};
    end
    nSize=size(aPrev,1);
    for nP=1:4
         aPrev{nSize+1,nP}=aPlane{2,nP};
    end
    nSize=size(aPrev,1);
    
    for nP=1:4
        aPrev{nSize+1,nP}=aPlane{3,nP};
        aPrev{nSize+2,nP}=aPlane{4,nP};
        aPrev{nSize+3,nP}=aPlane{6,nP};
    end
    
    fRoomPreviewElement2(hObject,eventdata,handles,aPrev);
end

