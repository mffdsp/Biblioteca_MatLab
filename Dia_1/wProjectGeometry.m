function varargout = wProjectGeometry(varargin)
% WPROJECTGEOMETRY M-file for wProjectGeometry.fig
%      WPROJECTGEOMETRY, by itself, creates a new WPROJECTGEOMETRY or raises the existing
%      singleton*.
%
%      H = WPROJECTGEOMETRY returns the handle to a new WPROJECTGEOMETRY or the handle to
%      the existing singleton*.
%
%      WPROJECTGEOMETRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WPROJECTGEOMETRY.M with the given input arguments.
%
%      WPROJECTGEOMETRY('Property','Value',...) creates a new WPROJECTGEOMETRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wPlane_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wProjectGeometry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wProjectGeometry

% Last Modified by GUIDE v2.5 13-Jul-2020 18:58:46

% rcc alt 16.02.2006
% v 2.20: 12.03.2006- clear all - clear cPlane
% v 2.28 30.06.2006 - uses fRound
% 2006.09.25 v 2.35 - adjust setup (ground plane round error (inf~=realmax)
% 2006.10.16 v 3.0  improve ground setup
% 2006.10.24 v 3.0  clear uncessary lines
% 2006.11.06 v 3.0  allows to delete multiple planes and protect only planes 1:15
% 2007.07.07 v 3.04 adjustments (save automatic) - create opposite face
%     [27.07]        (element)
%
% 2007.09.08 v 3.07 fix type number error for double plane non opaque or
%                    transparent plane / fix default mat. carac. for non
%                    opaque and transparent
% 2007.10.17 v 3.09 choose room from listbox
% 2008.12.09 v3.18 create opposite faces with the same material
%                      characteristics
% 2010.11.20 v 4.01.00 adapta codigo para novo matlab compiler
% 2011.04.10 v 5.00.01 ajusta comentários
% 2012.09.28 v 6.0.12 corrige entrada de dados com virgula decimal
% 2014.01.13 v 7.1.2  Atualizada a função que muda as tags da guide - Pedro
% 2014.03.10 v 7.1.5 Beta - Multilanguage - Pedro
% 2014.09.23 v 7.2.4 Titulo da Guide
% 2016.02.12 v. 8.0 - Pedro - Correções para a nova ordem de tipo. antes 
% haviam tipos <0, 0 e >1..agora os tipos são -1, 0 e numéricos positivos
% 2016.04.07 v 7.3.4 - Orestes - Função criada baseada na antiga wProjectGeometry, com tabela e scroll
% 2016.12.13 v 7.4 - Orestes - Invertida tabela para facilitar a adição de
% planos sem fazer o scroll ir até o final
% 2017.09.02 v 8.0 - Pedro - Altera Layout e insere as propriedades de
% visualização
% 2017.09.02 v 8.0 - Pedro - melhora comentários do código
% 2017.09.04 v 8.0 - Pedro - Corrige todos os erros indicados pelo matlab nas funções
% 2017.10.10 v 8.0 - Pedro / Orestes - Novas funções de edição de materiais
% e de criação de elementos de proteção
% 2017.10.14 v8 - Pedro - Inserção dos códigos de criaçaõ de elementos de
% proteção solar; edição dos códigos de pré-visualização.
% 2017.10.24 v8 - Pedro - Muitas alterações para a versão 8.0
% 2018.09.28 V8.0.4 - pedro- Correções na crição de planos opostos em lote
% 2018.11.12 v8.0.11 - Pedro - criaçao de elemntos cilindricos
% 2018.11.12 v8.0.12 - Pedro - criaçao de elemntos cones
% 2018.11.21 v8.0.16 - Pedro - Funções da tab de planos revisada e traduzida.
% 2018.11.21 v8.0.17 - Pedro - Funções da tab de visualização revisada e traduzida.
% 2018.11.21 v8.0.18 - Pedro - Funções da tab de Janelas revisada e traduzida.
% 2018.11.21 v8.0.18 - Pedro - Funções da tab de Janelas revisada e traduzida.
% 2018.11.25 v8.0.20 - Pedro - Funções da tab de Elementos revisada e traduzida.
% 2018.11.26 v8.0.21 - Pedro - Botões de posição de visualização
% adicoinados. Traduzido o restante das tags da tela que não estão em tabs
% 2018.11.25 v8.0.22 - Pedro - Tab de Criação de marquises ok. Alterada função que cria prismas (planos estavam invertidos).
% 2018.12.06 v8.0.24 - Pedro - Tab de Criação de brises ok.
% 2020.04.14 v8 - Pedro - Corrige janela em mais de duas aguas
% 2020.04.14 v8.0.05 - Pedro - Corrige posição da tabela após criaçao de plano,
% Revisão da posição de alguns botões, Corrige traduções, corrige criação
% de janelas, corrige criaçao de ouvre e pergulas, revisão na criação de
% elementos e protetores, revisaõ de layoutfRoomSetU


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
  'gui_Singleton',  gui_Singleton, ...
  'gui_OpeningFcn', @wProjectGeometry_OpeningFcn, ...
  'gui_OutputFcn',  @wProjectGeometry_OutputFcn, ...
  'gui_LayoutFcn',  [] , ...
  'gui_Callback',   []);
if nargin && ischar(varargin{1})
  gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
  [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
  gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% ~~~~~~~~~~~~~~~~~~~~~~ EXECUTA ANTES DA VISUALIZAÇÃO ~~~~~~~~~~~~~~~~~~~~

% --- Executes just before wProjectGeometry is made visible.
function wProjectGeometry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wProjectGeometry (see VARARGIN)

% Choose default command line output for wProjectGeometry
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global spcodeDir sInputDir sTropLuxVer cRefl2 %#ok<NUSED>

%Carrega Strings de idioma
load([spcodeDir '\bLangDef.tlx'],'-mat','MainMenu');
%Titulo da Guide
try
    set(hObject,'Name',MainMenu.tInputProjectGeometry);
catch
end

% Verifica se há Projeto Criado
sFileRoomGeom='bRoomGeom.tlx';
if exist([sInputDir '\' sFileRoomGeom],'file')
    set(handles.tRoomNum,'String',num2str(1));
    
    %Carrega informações e Visualização
    fOpenProject(hObject,eventdata,handles,true) 
    
    tPanPrjButton_Callback(hObject, eventdata, handles)

else % Não existe, Cria!
      
    set(handles.tProjectQt2,'String','0');
    set(handles.tProjectQt1,'String','0');
    
    % Abre guia de projetos
    tPanPrjButton_Callback(hObject, eventdata, handles)
    
    % Abre novo projeto retangular
    tCreateNewPrjRec_Callback(hObject, eventdata, handles)
    
    %Gira a visualização
    set(gca,'view',[322.5 30],'CameraViewAngle',10.9038)
end

% Insere Figuras Nos Botões
load([spcodeDir '\bImage.tlx'],'-mat','sImage');

%Novo Projeto Retangular
nSize=getpixelposition(handles.tCreateNewPrjRec);
nImSize=imresize(sImage.ProjectRectangular,[nSize(4) nSize(3)]);
set(handles.tCreateNewPrjRec,'CData',nImSize,'Background','white','String','');

% Elemento Prismatico
nSize=getpixelposition(handles.tElPrismButton);
nImSize=imresize(sImage.ElementPrism,[nSize(4) nSize(3)]);
set(handles.tElPrismButton,'CData',nImSize,'Background','white','String','');
% Elemento Cilindrico
nSize=getpixelposition(handles.tElCilynderButton);
nImSize=imresize(sImage.ElementCilynder,[nSize(4) nSize(3)]);
set(handles.tElCilynderButton,'CData',nImSize,'Background','white','String','');
% Elemento cônico
nSize=getpixelposition(handles.tElConeButton);
nImSize=imresize(sImage.ElementCone,[nSize(4) nSize(3)]);
set(handles.tElConeButton,'CData',nImSize,'Background','white','String','');
% Elemento Esferico
nSize=getpixelposition(handles.tElSphereButton);
nImSize=imresize(sImage.ElementSphere,[nSize(4) nSize(3)]);
set(handles.tElSphereButton,'CData',nImSize,'Background','white','String','');

% Versao do Programa
set(handles.tTropVer,'String',sTropLuxVer);

nStr='InputProjectGeometry';
fSetLangGuide(handles,nStr)

%Carrega tabela de Refletancias e cologa no global
load([spcodeDir '\Reflectance.tlx'],'-mat','cRefl2');



% --- Outputs from this function are returned to the command line.
function varargout = wProjectGeometry_OutputFcn(hObject, eventdata, handles) %#ok<*INUSL>
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1}=handles.output;


% ~~~~~~~~~~~~~~~~~~~~ BOTÕES DE MUDANÇA DAS TABS ~~~~~~~~~~~~~~~~~~~~~~~~~

% --- Executes on button press in tPanDataButton.
function tPanDataButton_Callback(hObject,eventdata,handles)  %#ok<*DEFNU>
% hObject    handle to tPanDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Atualiza tabs
set(handles.tPanData,'Visible','on');
set(handles.tPanVis,'Visible','off');
set(handles.tPanMaterial,'Visible','off');
set(handles.tPanProject,'Visible','off');
set(handles.tPanWindow,'Visible','off');
set(handles.tPanShadingDev,'Visible','off');
set(handles.tPanElements,'Visible','off');

% Corrige cores
set(handles.tPanDataButton,'BackgroundColor',[1 0.8 0.4]);
set(handles.tPanVisButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanMaterialButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanPrjButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanWinButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanShadingButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanElementButton,'BackgroundColor',[0.941 0.941 0.941]);


%Limpa Projeto e memória de campos selecionados
try %#ok<TRYNC>
    fUpdatePlanePreview(handles,[],true,false); % Preview 
    set(handles.tDeleteWin,'UserData',[]);
    set(handles.tDeletePlane,'UserData',[]);
end

% --- Executes on button press in tPanVisButton.
function tPanVisButton_Callback(hObject, eventdata, handles) 
% hObject    handle to tPanVisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Atualiza tabs
set(handles.tPanData,'Visible','off');
set(handles.tPanVis,'Visible','on');
set(handles.tPanMaterial,'Visible','off');
set(handles.tPanProject,'Visible','off');
set(handles.tPanWindow,'Visible','off');
set(handles.tPanShadingDev,'Visible','off');
set(handles.tPanElements,'Visible','off');

% Corrige cores
set(handles.tPanDataButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanVisButton,'BackgroundColor',[1 0.8 0.4]);
set(handles.tPanMaterialButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanPrjButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanWinButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanShadingButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanElementButton,'BackgroundColor',[0.941 0.941 0.941]);


%Limpa Projeto e memória de campos selecionados
try %#ok<TRYNC>
    fUpdatePlanePreview(handles,[],true,false); % Preview 
    set(handles.tDeleteWin,'UserData',[]);
    set(handles.tDeletePlane,'UserData',[]);
end

% --- Executes on button press in tPanMaterialButton.
function tPanMaterialButton_Callback(hObject, eventdata, handles)
% hObject    handle to tPanMaterialButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Atualiza tabs
set(handles.tPanData,'Visible','off');
set(handles.tPanVis,'Visible','off');
set(handles.tPanMaterial,'Visible','on');
set(handles.tPanProject,'Visible','off');
set(handles.tPanWindow,'Visible','off');
set(handles.tPanShadingDev,'Visible','off');
set(handles.tPanElements,'Visible','off');

% Corrige cores
set(handles.tPanDataButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanVisButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanMaterialButton,'BackgroundColor',[1 0.8 0.4]);
set(handles.tPanPrjButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanWinButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanShadingButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanElementButton,'BackgroundColor',[0.941 0.941 0.941]);


%Limpa Projeto e memória de campos selecionados
try %#ok<TRYNC>
    fUpdatePlanePreview(handles,[],true,false); % Preview 
    set(handles.tDeleteWin,'UserData',[]);
    set(handles.tDeletePlane,'UserData',[]);
end

% --- Executes on button press in tPanPrjButton.
function tPanPrjButton_Callback(hObject, eventdata, handles)
% hObject    handle to tPanPrjButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Atualiza tabs
set(handles.tPanData,'Visible','off');
set(handles.tPanVis,'Visible','off');
set(handles.tPanMaterial,'Visible','off');
set(handles.tPanProject,'Visible','on');
set(handles.tPanWindow,'Visible','off');
set(handles.tPanShadingDev,'Visible','off');
set(handles.tPanElements,'Visible','off');

% Corrige cores
set(handles.tPanDataButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanVisButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanMaterialButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanPrjButton,'BackgroundColor',[1 0.8 0.4]);
set(handles.tPanWinButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanShadingButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanElementButton,'BackgroundColor',[0.941 0.941 0.941]);


%Limpa Projeto e memória de campos selecionados
try %#ok<TRYNC>
    fUpdatePlanePreview(handles,[],true,false); % Preview 
    set(handles.tDeleteWin,'UserData',[]);
    set(handles.tDeletePlane,'UserData',[]);
end

% --- Executes on button press in tPanWinButton.
function tPanWinButton_Callback(hObject, eventdata, handles)
% hObject    handle to tPanWinButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Atualiza tabs
set(handles.tPanData,'Visible','off');
set(handles.tPanVis,'Visible','off');
set(handles.tPanMaterial,'Visible','off');
set(handles.tPanProject,'Visible','off');
set(handles.tPanWindow,'Visible','on');
set(handles.tPanShadingDev,'Visible','off');
set(handles.tPanElements,'Visible','off');

% Corrige cores
set(handles.tPanDataButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanVisButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanMaterialButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanPrjButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanWinButton,'BackgroundColor',[1 0.8 0.4]);
set(handles.tPanShadingButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanElementButton,'BackgroundColor',[0.941 0.941 0.941]);


%Limpa Projeto e memória de campos selecionados
try %#ok<TRYNC>
    fUpdatePlanePreview(handles,[],true,false); % Preview 
    set(handles.tDeleteWin,'UserData',[]);
    set(handles.tDeletePlane,'UserData',[]);
end

% --- Executes on button press in tPanShadingButton.
function tPanShadingButton_Callback(hObject, eventdata, handles)
% hObject    handle to tPanShadingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Atualiza tabs
set(handles.tPanData,'Visible','off');
set(handles.tPanVis,'Visible','off');
set(handles.tPanMaterial,'Visible','off');
set(handles.tPanProject,'Visible','off');
set(handles.tPanWindow,'Visible','off');
set(handles.tPanShadingDev,'Visible','on');
set(handles.tPanElements,'Visible','off');

% Corrige cores
set(handles.tPanDataButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanVisButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanMaterialButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanPrjButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanWinButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanShadingButton,'BackgroundColor',[1 0.8 0.4]);
set(handles.tPanElementButton,'BackgroundColor',[0.941 0.941 0.941]);

%Limpa Projeto e memória de campos selecionados
try %#ok<TRYNC>
    fUpdatePlanePreview(handles,[],true,false); % Preview 
    set(handles.tDeleteWin,'UserData',[]);
    set(handles.tDeletePlane,'UserData',[]);
end

% --- Executes on button press in tPanElementButton.
function tPanElementButton_Callback(hObject, eventdata, handles)
% hObject    handle to tPanElementButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Atualiza tabs
set(handles.tPanData,'Visible','off');
set(handles.tPanVis,'Visible','off');
set(handles.tPanMaterial,'Visible','off');
set(handles.tPanProject,'Visible','off');
set(handles.tPanWindow,'Visible','off');
set(handles.tPanShadingDev,'Visible','off');
set(handles.tPanElements,'Visible','on');


% Corrige cores
set(handles.tPanDataButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanVisButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanMaterialButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanPrjButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanWinButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanShadingButton,'BackgroundColor',[0.941 0.941 0.941]);
set(handles.tPanElementButton,'BackgroundColor',[1 0.8 0.4]);

%Limpa Projeto e memória de campos selecionados
try %#ok<TRYNC>
    fUpdatePlanePreview(handles,[],true,false); % Preview 
    set(handles.tDeleteWin,'UserData',[]);
    set(handles.tDeletePlane,'UserData',[]);
end

%~~~~~~~~~~~~~~~~ FUNÇÕES DA TAB DE PROJETOS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% --- Executes on button press in tDeleteProject.
function tDeleteProject_Callback(hObject, eventdata, handles)
% Apaga Projeto

% hObject    handle to tDeleteProject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 2017.09.13 v.8.0 - Pedro - Importado de fDeleteRoom
% 2017.09.27 v8.0 - Pedro - Insere perguntas de confirmação antes de apagar
% 2017.10.23 v8 - Pedro - Apaga multiplos projetos
global sInputDir sOutputDir spcodeDir

% Apaga projetos em bRoomGeom.mat
sFile=[sInputDir '\bRoomGeom.tlx'];
if exist(sFile,'file')
    load(sFile,'-mat','cRoomGeom')
    if exist('cRoomGeom','var') 
        nNPl=size(cRoomGeom,1); 
    else
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cRoomGeomNotFound ' (E0116)']);
        return
    end
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([sFile ' ' ErrorDlg.NotFound ' (E0117)'])
    return
end

nDeleteNum=get(handles.tDeleteProject,'UserData');
if isempty(nDeleteNum)
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([ErrorDlg.SelectProject]);
    return
end

%Verifica se mais de um projeto foi selecionado para apagar
nSizePrj=size(nDeleteNum,1);
for nP=1:nSizePrj
    aDeletePrj(nP)=nDeleteNum(nP,1);
end

load([spcodeDir '\bLangDef.tlx'],'-mat','AskDlg');  %Load Language File
nOpc=questdlg(AskDlg.WouldYouLikeToMakeBackupBeforeDeleting,AskDlg.ClearFiles,AskDlg.Yes,AskDlg.No,AskDlg.Cancel,AskDlg.No);
if strcmp(nOpc,AskDlg.Yes) %if strcmp(nOpc,'Yes')
    fBackup;
elseif strcmp(nOpc,AskDlg.Cancel)
    return
else % Não
    nOpc2=questdlg(AskDlg.DeleteAnyway,AskDlg.ClearFiles,AskDlg.Yes,AskDlg.No,AskDlg.Cancel,AskDlg.No);
    if ~strcmp(nOpc2,AskDlg.Yes) %if ~strcmp(nOpc2,'Yes')
        return
    end
end

nOpc2=questdlg(AskDlg.AllFilesWillBeDeletedAreYouSure,AskDlg.ClearFiles,AskDlg.Yes,AskDlg.No,AskDlg.Cancel,AskDlg.No);
if ~strcmp(nOpc2,AskDlg.Yes) %if ~strcmp(nOpc2,'Yes')
  return
end
set(gcf,'pointer','watch');
if nNPl<=1 %Apenas um ambiente: Apaga arquivos
    nDeletePrj=aDeletePrj(1);
    aFilesInput=dir(sInputDir);
    aFilesOutput=dir(sOutputDir);
    nNumFilesInput=size(aFilesInput,1);
    nNumFilesOutput=size(aFilesOutput,1);
    % Apaga Arquivos
    for nF=1:nNumFilesInput
        delete([sInputDir '\' aFilesInput(nF).name]);
    end
    for nF=1:nNumFilesOutput
        delete([sOutputDir '\' aFilesOutput(nF).name]);
    end
    load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Load Language File
    sText=[MsgBox.Room ' ' fPut0(nDeletePrj,3) ' ' MsgBox.Deleted];
    wProjectGeometry_OpeningFcn(hObject, eventdata, handles)
    msgbox(sText);
    set(gcf,'pointer','arrow');
else %Mais de um ambiente
    
    %Loop nos projetos a apagar
    for nP=1:nSizePrj
        nDeletePrj=aDeletePrj(nP);
        
        % Arquivos do Input
        % Corrige arquivo de geometria
        cRoomGeom(nDeletePrj,:)=[]; 
        nNPl=size(cRoomGeom,1); 
        for k=nDeletePrj:nNPl
            cRoomGeom{k,1}=cRoomGeom{k,1}-1;
        end
        sFile=[sInputDir '\bRoomGeom.tlx'];
        save(sFile,'-mat','cRoomGeom')
        
        %Apaga Arquivos
        cFile={'bPlane','bMat','bWindow','bGrdZone2-r','bRoom','bVis'};
        nTFile=length(cFile);
        for i=1:nTFile
            sFile=[sInputDir '\' cFile{i} fPut0(nDeletePrj,3) '.tlx'];
            if exist(sFile,'file')
                delete(sFile);
            end
        end

        % Renomeando arquivos restantes
        nFAfter=nDeletePrj+1; % Primeira posiçao apos as salas deletadas
        for i=1:nTFile
            for j=nFAfter:nNPl
                sFile=[sInputDir '\' cFile{i} fPut0(j,3) '.tlx'];
                nDif=j-1;
                sFile1=[sInputDir '\' cFile{i} fPut0(nDif,3) '.tlx'];
                if exist(sFile,'file')
                    renamefile(sFile,sFile1);
                end
            end
        end
        
        % Arquivos do Output
        aFilesOutput=dir(sOutputDir);
        % Loop nos arquivos
        for nLO=1:size(aFilesOutput,1)
            sFileName=aFilesOutput(nLO).name;
            nPosPr=strfind(sFileName,'-r');
            nProj=str2double(sFileName(nPosPr+2:nPosPr+4));
            if nProj==nFAfter-1 %Apaga
                delete([sOutputDir '\' sFileName]);
            elseif nProj>=nFAfter-1 % Renomeia Internamente e externamente
                if strfind(aFilesOutput(nLO).name,'bDCDir')
                    %Internamente
                    load([sOutputDir '\' sFileName],'-mat','sRoom','aDCDirSky','aPt','nETimeDCDir','nPl')
                    sRoom=fPut0(str2double(sRoom)-1,3);
                    nPosPr=strfind(sFileName,'-r');
                    delete([sOutputDir '\' sFileName]);
                    sFileName=[(sFileName(1:nPosPr+1)) sRoom (sFileName(nPosPr+5:end))];
                    % No arquivo
                    save([sOutputDir '\' sFileName],'-mat','sRoom','aDCDirSky','aPt','nETimeDCDir','nPl');
                    clear sRoom aDCDirSky aPt nETimeDCDir nPl
                elseif strfind(aFilesOutput(nLO).name,'bDC')
                    %Internamente
                    load([sOutputDir '\' sFileName],'-mat','aDC','aDCGrd','aPt','nError','nETimeDCDif','nGrdType','nPl','nTimes','sRoom')
                    sRoom=fPut0(str2double(sRoom)-1,3);
                    nPosPr=strfind(sFileName,'-r');
                    delete([sOutputDir '\' sFileName]);
                    sFileName=[(sFileName(1:nPosPr+1)) sRoom (sFileName(nPosPr+5:end))];
                    % No arquivo
                    save([sOutputDir '\' sFileName],'-mat','aDC','aDCGrd','aPt','nError','nETimeDCDif','nGrdType','nPl','nTimes','sRoom');
                    clear aDC aDCGrd aPt nError nETimeDCDif nGrdType nPl nTimes sRoom
                elseif strfind(aFilesOutput(nLO).name,'bGC')
                    % Internamente
                    load([sOutputDir '\' sFileName],'-mat','sRoom','aGC','nETime','nGrdType')
                    sRoom=fPut0(str2double(sRoom)-1,3);
                    nPosPr=strfind(sFileName,'-r');
                    delete([sOutputDir '\' sFileName]);
                    sFileName=[(sFileName(1:nPosPr+1)) sRoom (sFileName(nPosPr+5:end))];
                    % No arquivo
                    save([sOutputDir '\' sFileName],'-mat','sRoom','aGC','nETime','nGrdType');
                    clear sRoom aGC nETime nGrdType
                elseif strfind(aFilesOutput(nLO).name,'bGrid')
                    % Internamente
                    load([sOutputDir '\' sFileName],'-mat','cFileBatIllum','aXX','aYY','aZZ')
                    for nB=1:size(cFileBatIllum,2) %Altera matriz de pontos
                        nPosPr=strfind(cFileBatIllum{nB},'-r');
                        nProj=str2double(cFileBatIllum{nB}(nPosPr+2:nPosPr+4));
                        cFileBatIllum{nB}=[(cFileBatIllum{nB}(1:nPosPr+1)) fPut0(nProj-1,3) (cFileBatIllum{nB}(nPosPr+5:end))];
                    end
                    nPosPr=strfind(sFileName,'-r');
                    delete([sOutputDir '\' sFileName]);
                    sFileName=[(sFileName(1:nPosPr+1)) fPut0(nProj-1,3) (sFileName(nPosPr+5:end))];
                    % No arquivo
                    save([sOutputDir '\' sFileName],'-mat','cFileBatIllum','aXX','aYY','aZZ');
                    clear cFileBatIllum aXX aYY aZZ 
                elseif strfind(aFilesOutput(nLO).name,'bIllum')
                    % Internamente
                    load([sOutputDir '\' sFileName],'-mat','sRoom','aAzX','aDay','aDC1','aDCDirSky','aDCExt1','aDCExtSky','aDCGrd1','aEhd','aEsn','aGC','aIllum','aPt','aSky','aTime','nError','nETimeDCDif','nETimeDCDir','nETimeIllum','nEUnit','nPl','nTimes1','nTimes2','nTimes3','nTypeEhd','nTypeTime','nValTest');
                    sRoom=fPut0(str2double(sRoom)-1,3);
                    nPosPr=strfind(sFileName,'-r');
                    delete([sOutputDir '\' sFileName]);
                    sFileName=[(sFileName(1:nPosPr+1)) sRoom (sFileName(nPosPr+5:end))];
                    % No arquivo
                    save([sOutputDir '\' sFileName],'-mat','sRoom','aAzX','aDay','aDC1','aDCDirSky','aDCExt1','aDCExtSky','aDCGrd1','aEhd','aEsn','aGC','aIllum','aPt','aSky','aTime','nError','nETimeDCDif','nETimeDCDir','nETimeIllum','nEUnit','nPl','nTimes1','nTimes2','nTimes3','nTypeEhd','nTypeTime','nValTest');
                    clear sRoom aAzX aDay aDC1 aDCDirSky aDCExt1 aDCExtSky aDCGrd1 aEhd aEsn aGC aIllum aPt aSky aTime nError nETimeDCDif nETimeDCDir nETimeIllum nEUnit nPl nTimes1 nTimes2 nTimes3 nTypeEhd nTypeTime nValTest
                else
                end
            end
        end

    end
    
    wProjectGeometry_OpeningFcn(hObject, eventdata, handles)
     
    load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Load Language File
    set(gcf,'pointer','arrow');

    sText=[MsgBox.Room ' ' MsgBox.Deleted];
    msgbox(sText);
end

% --- Executes when selected cell(s) is changed in tTableProject.
function tTableProject_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tTableProject (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global sInputDir spcodeDir

if handles.tEditDescription.BackgroundColor(1)~=1
    try
        nRows=eventdata.Indices(1);

        set(handles.tDeleteProject,'UserData',eventdata.Indices);

        %Mostra número do projeto
        set(handles.tRoomNum,'String',nRows(1))

        % Mostra informações de projeto
        % Importa numero do projeto
        nRoomNum=nRows;
        sRoomNum=fPut0(nRoomNum,3);
        sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; %nome do arquivo de planos
        %   Abre arquivos de plano
        if isnan(nRoomNum)|| isempty(nRoomNum) % se o campo de projeto está vazio, abre pelo arquivo de planos
            load([spcodeDir '\bLangDef.tlx'],'-mat','UiGet');  %Abre Arquivo de Idioma
            [sFilePl,~]=uigetfile('bPlane*.tlx','-mat',UiGet.PlaneFiles);
            if sFilePl~=0
                load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
            else
                return
            end   % Abre arquivo
            % Coloca no campo de projeto o número relativo ao projeto do arquivo aberto
            sRoomNum=sFilePl(end-6:end-4); 
            set(handles.tRoomNum,'string',sRoomNum)
        else %O campo de projeto está preenchido
            if exist(sFilePl,'file')==2
                load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
            else
                load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
                errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
                return
            end
        end

        % Erro caso cPlane não exista no arquivo
        if exist('cPlane','var')==0
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg([ErrorDlg.cPlaneNotFoundIn ' ' sFilePl ' (E0087)']); 
            return
        end

        % Erro caso cPlane esteja vazio no arquivo
        if isempty(cPlane) %#ok<*NODEF>
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            sMens=[ErrorDlg.cPlaneIsEmptyFile ' '  sFilePl ' ' ErrorDlg.MightBeCorrupted ' (E0098)'];	
            errordlg(sMens);
            return
        end

        % Quantidade de planos
        nSizePlanes=size(cPlane,1); %Tamanho do arquivo de planos
        set(handles.tInfoPrjPlanes,'String',nSizePlanes);

       % Última modificação
        cFile={'bPlane','bMat','bWindow','bGrdZone2-r','bRoom','bVis'};
        nTFile=length(cFile);

        for i=1:nTFile
            sFile=[sInputDir '\' cFile{i} sRoomNum '.tlx'];
            if exist(sFile,'file')
                aFileInfo=dir(sFile);
                aTimeData{i}=aFileInfo.date;
            end
        end
        aLastTime=sort(aTimeData(~cellfun('isempty',aTimeData)));
        sLastTime=aLastTime{end};
        set(handles.tInfoPrjTime,'String',sLastTime); 

        %Processamentos
        % Fazer!!

        % Abre Projeto
        fOpenProject(hObject,eventdata,handles,true) % Abre o Arquivo de planos

    catch
        %Nada a fazer
    end
end

    
% --- Executes on button press in tCreatePrjRec.
function tCreateNewPrjRec_Callback(hObject, eventdata, handles)
% hObject    handle to tCreatePrjRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.tPanNewProject,'Visible','on');
set(handles.tPanProj,'Visible','off');
nProjNum=str2double(get(handles.tProjectQt2,'String'))+1;
set(handles.ttPrjNumRec,'String',nProjNum);

%Visualiza
fRoomPreviewPrj(hObject,eventdata,handles);

% Travas as outras abas
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanElementButton,'Enable','off');
set(handles.tPanShadingButton,'Enable','off');

% Salva Novo Projeto Retangular
% --- Executes on button press in tCreatePrjRec.
function tCreatePrjRec_Callback(hObject, eventdata, handles)
% hObject    handle to tCreatePrjRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sInputDir spcodeDir

%Abre cRoomGeom
sFileRoomGeom='bRoomGeom.tlx';
if exist([sInputDir '\' sFileRoomGeom],'file')
    load([sInputDir '\' sFileRoomGeom],'-mat','cRoomGeom')
end

%Importa Dados
cLine{1}=get(handles.ttPrjNumRec,'String');
cLine{2}=get(handles.tDescRec,'string');
cLine{3}=get(handles.tDimXRec,'string');
cLine{4}=get(handles.tDimYRec,'string');
cLine{5}=get(handles.tDimZRec,'string');
cLine{6}=get(handles.tDimZcRec,'string');
cLine{7}=get(handles.tWorkplaneDimRec,'string');
cLine{8}=get(handles.tFloorDimRec,'string');
cLine{9}=get(handles.tWallTickRec,'string');
cLine{10}=get(handles.tCeilingTickRec,'string');
cLine{11}=get(handles.tFloorTickRec,'string');
cLine{12}=get(handles.tWindowPlaneRec,'string');
if isempty(cLine{12})
    cLine{12}='0';
end
cLine{13}=get(handles.tDim1WinRec,'string');
cLine{14}=get(handles.tDim2WinRec,'string');

% Verifica se algum campo é vazio
% Testa se os campo estão preenchidos corretamente
for nF=1:14
    if isempty(cLine{nF})
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([ErrorDlg.NewRoomGeometryNotProperlyDefined ' (E0113)'])
        return
    end
    if nF>2
        cLine{nF}=fChDecPoint(cLine{nF});
        if isempty(str2double(cLine{nF})) && (nF <= (nParLine-3)) %%% allows empty windows
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
            errordlg([ErrorDlg.Error ' ' cLine{k} ' ' ErrorDlg.IsNotValidInThisField ' (E0099)'])
            return
        end
    end
end

% Testa se dimensões da janela são compativeis com X,Y,Z
if strfind('12',cLine{12}) %% piso 1 ou teto 2   Axis Z
    if str2double(cLine{13})>str2double(cLine{3})     % Dim1 > X
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim1 ' (' cLine{13} 'm) > ' ErrorDlg.AxisXDimension ' (' cLine{3} 'm)'  ' (E0114)'])
        return
    end
    if str2double(cLine{14})>str2double(cLine{4})     % Dim2 > Y
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim2 ' (' cLine{14} 'm) > ' ErrorDlg.AxisYDimension ' (' cLine{4} 'm)' ' (E0114)'])
        return
    end  
elseif strfind('34',cLine{12})  %% parede 3 ou 4  Axis X
    if str2double(cLine{13})>cstr2double(Line{3})     % Dim1 > X
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim1 ' (' cLine{13} 'm) > ' ErrorDlg.AxisXDimension ' (' cLine{3} 'm)' ' (E0114)'])
        return
    end
    if str2double(cLine{14})>str2double(cLine{5})     % Dim2 > Z
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim2 ' (' cLine{14} 'm) > ' ErrorDlg.AxisZDimension ' (' cLine{5} 'm)' ' (E0114)'])
        return
    end   
elseif strfind('56',cLine{12})  %% parede 5 ou 6  Axis Y
    if str2double(cLine{13})>str2double(cLine{4})     % Dim1 > Y
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim1 ' (' cLine{13} 'm) > ' ErrorDlg.AxisYDimension ' (' cLine{4} 'm)' ' (E0114)'])
        return
    end
    if str2double(cLine{14})>str2double(cLine{5})     % Dim2 > Z
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim2 ' (' cLine{14} 'm) > ' ErrorDlg.AxisZDimension ' (' cLine{5} 'm)' ' (E0114)'])
        return
    end   
elseif strfind(' 0',cLine{12})
    cLine{12}='0';
    cLine{13}='0';
    cLine{14}='0';
else % Erro
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([ErrorDlg.ErrorPlane ' ' cLine{12} ' ' ErrorDlg.IsNotValidInThisField ' (E0115)'])
    return
end

% Dá Set nas opções corrigdas
set(handles.tProjectQt2,'String',cLine{1}); %Número do Projeto
set(handles.tProjectQt1,'String',cLine{1}); %Número do Projeto
set(handles.tDescRec,'string',cLine{2}); % Descrição do projeto
set(handles.tDimXRec,'string',cLine{3}); % Dimensão X
set(handles.tDimYRec,'string',cLine{4}); % Dimensão Y
set(handles.tDimZRec,'string',cLine{5}); % Dimensão Z
set(handles.tDimZcRec,'string',cLine{6}); % Inclinação
set(handles.tWorkplaneDimRec,'string',cLine{7}); % Altura do plano de trabalho
set(handles.tFloorDimRec,'string',cLine{8}); % Altura do piso
set(handles.tWallTickRec,'string',cLine{9}); % Espessura da parede
set(handles.tCeilingTickRec,'string',cLine{10}); % Espessura do teto
set(handles.tFloorTickRec,'string',cLine{11}); % Espessura do piso
set(handles.tWindowPlaneRec,'string',cLine{12}); % Plano da janela
set(handles.tDim1WinRec,'string',cLine{13}); % Dimensão 1 da janela (Largura)
set(handles.tDim2WinRec,'string',cLine{14}); % Dimensão 2 da janela (Altura)


load([spcodeDir '\bLangDef.tlx'],'-mat','AskDlg','MsgBox');  %Load Language File
sYN=questdlg([AskDlg.InputRoomGeometry ' ' cLine{1} '?'],AskDlg.ConfirmInput,AskDlg.Yes,AskDlg.No,AskDlg.Yes);
if strcmp(sYN,AskDlg.Yes) %if strcmp(sYN,'Yes')
    
    % Importa opções de telhado
    nSlope0=get(handles.tRatSlope0NewPrjRec,'Value');
    nSlope1=get(handles.tRatSlope1NewPrjRec,'Value');
    nSlope2=get(handles.tRatSlope2NewPrjRec,'Value');
    nSlope3=get(handles.tRatSlope3NewPrjRec,'Value');
    nSlope4=get(handles.tRatSlope4NewPrjRec,'Value');
    
    % Define cRoomGeome
    nNextRoom=str2double(cLine{1});
    cRoomGeom{nNextRoom,1}=str2double(cLine{1});
    cRoomGeom{nNextRoom,2}=cLine{2};
    cRoomGeom{nNextRoom,3}=str2double(cLine{3});
    cRoomGeom{nNextRoom,4}=str2double(cLine{4});
    cRoomGeom{nNextRoom,5}=str2double(cLine{5});
    cRoomGeom{nNextRoom,6}=str2double(cLine{6});
    cRoomGeom{nNextRoom,7}=str2double(cLine{7});
    cRoomGeom{nNextRoom,8}=str2double(cLine{8});
    cRoomGeom{nNextRoom,9}=str2double(cLine{9});
    cRoomGeom{nNextRoom,10}=str2double(cLine{10});
    cRoomGeom{nNextRoom,11}=str2double(cLine{11});
    cRoomGeom{nNextRoom,12}=str2double(cLine{12});
    cRoomGeom{nNextRoom,13}=str2double(cLine{13});
    cRoomGeom{nNextRoom,14}=str2double(cLine{14});


    % Salva cRoomGeom no arquivo
    sFileRoomGeom=[sInputDir '\bRoomGeom.tlx'];
    save(sFileRoomGeom,'-mat','cRoomGeom')

    % Cria cPlane
    sRoomNumber=fPut0(nNextRoom,3);
    sFilePl=[sInputDir '\bPlane' sRoomNumber '.tlx'];
    if ~exist(sFilePl,'file')
        % Modificação pelo tipo de inclinação do telhado
        if nSlope0==1 || nSlope1==1
            cPlane=fPrepPlan(cRoomGeom(nNextRoom,:));
            if isempty(cPlane)
                return
            end
        elseif nSlope2==1
            [cPlane,cWindowTop]=fPrepPlanSlope(cRoomGeom(nNextRoom,:),2); 
        elseif nSlope3==1
            [cPlane,cWindowTop]=fPrepPlanSlope(cRoomGeom(nNextRoom,:),3); 
        elseif nSlope4==1
            [cPlane,cWindowTop]=fPrepPlanSlope(cRoomGeom(nNextRoom,:),4); 
        end
        save(sFilePl,'-mat','cPlane')
    end

    % Cria cMat
    sRoomNumber=fPut0(nNextRoom,3);
    sFileMat=[sInputDir '\bMat' sRoomNumber '.tlx'];
    if ~exist(sFileMat,'file')
        cMat=fPrepMat(sRoomNumber); 
        save(sFileMat,'-mat','cMat')
    end


    % Cria cWindow
    nWinPl=str2double(get(handles.tWindowPlaneRec,'string'));
    sRoomNumber=fPut0(nNextRoom,3);
    sFileWin=[sInputDir '\bWindow' sRoomNumber '.tlx'];
    if ~exist(sFileWin,'file') 
        if nWinPl>0
            cWindow=fPrepWin(cRoomGeom(nNextRoom,:));
            cWindow{1,4}=str2double(handles.tWindowType.String);
            cWindow=fUpdateWindow(cWindow,nNextRoom); % Atualiza matriz de janelas 
            fFrameWindow(cWindow,sRoomNumber); % Cria o Frame da Janela  
            load(sFilePl,'-mat','cPlane');
            nPlan=size(cPlane,1)-3;
            cWindow{1,9}=nPlan:nPlan+3; %salva a posição da janela no arquivo de planos 
            save(sFileWin,'-mat','cWindow')
%         elseif nWinPl==0
%             load([spcodeDir '\bLangDef.tlx'],'-mat','WarnDlg');  %Load Language File
%             warndlg(WarnDlg.NoWindowWasAutomaticCreatedItMustBeDoneIn)
        end
    end

    
    % Cria cWindow de topo caso o plano seja inclinado. 
    if nSlope2==1 || nSlope3==1 || nSlope4==1    
        nNextWin=size(cWindow,1)+1; %Número da janela
        cWindowTop{1}=nNextWin;

        %Atualiza cWindow
        cWindow{nNextWin,1}=nNextWin;
        cWindow{nNextWin,2}=cWindowTop{2};
        cWindow{nNextWin,3}=cWindowTop{3};
        cWindow{nNextWin,4}=cWindowTop{4};
        cWindow{nNextWin,5}(1)=cWindowTop{5}(1);
        cWindow{nNextWin,5}(2)=cWindowTop{5}(2);	
        cWindow{nNextWin,5}(3)=cWindowTop{5}(3);
        cWindow{nNextWin,6}(1)=cWindowTop{6}(1);
        cWindow{nNextWin,6}(2)=cWindowTop{6}(2);	
        cWindow{nNextWin,6}(3)=cWindowTop{6}(3);
        cWindow{nNextWin,7}(1)=cWindowTop{7}(1);
        cWindow{nNextWin,7}(2)=cWindowTop{7}(2);	
        cWindow{nNextWin,7}(3)=cWindowTop{7}(3);
        cWindow{nNextWin,8}(1)=cWindowTop{8}(1);
        cWindow{nNextWin,8}(2)=cWindowTop{8}(2);	
        cWindow{nNextWin,8}(3)=cWindowTop{8}(3);

        cWindow=fNewWindow(cWindow); %Generates the outside window
        cWindow=fUpdateWindow(cWindow,nNextRoom); %% update window's array
        fFrameWindow(cWindow,sRoomNumber); % create frame window planes
        load(sFilePl,'-mat','cPlane');
        nPlan=size(cPlane,1)-3;
        cWindow{nNextWin,9}=nPlan:nPlan+3; %salva a posição da janela no arquivo de planos 
        save(sFileWin,'-mat','cWindow')
    end

    % Cria city parameters (se não existir)
    sFileCity= [sInputDir '\bCity.tlx'];
    sFilePar= [sInputDir '\bCityParam.tlx'];
    if exist(sFilePar,'file') || exist(sFileCity,'file')
        fCreateCity;
    end

    % Cria parâmetros de solo (se não existir)
    sFileGrd=[sInputDir '\bGrdParam.tlx'];
    if ~exist(sFileGrd,'file')
        cGrdParam={0.2,15}; nGrdType=2; aGrdRef=0.2; nGrdDiv=6; nGrdLen=5; nGrdAng=15;
        % save Room Geometry in binary file bGrdParam
        save(sFileGrd,'-mat','cGrdParam','nGrdType','aGrdRef','nGrdDiv','nGrdLen','nGrdAng')
    end

    % Cria bRoom %%%%
    % Corrige matriz de materiais
    for iMat=1:size(cMat,1)
        for jMat=2:5
            aMat(iMat,jMat-1)=cMat{iMat,jMat};
        end
    end
    aRoomMat=cumsum(aMat,2);
    
    % converts cPlane->aPlane
    aPlane(:,6:7)=0; % default-> neither window nor patch
    cRot={}; aWin=[]; aPat=[]; aPtWin=[];
    for iPl=1:size(cPlane,1)
        for jPl=4:7 % points
            for kPl=1:3 % (1=x,2=y,3=z)
                aPtPl(iPl,jPl-3,kPl)=cPlane{iPl,jPl}(kPl);
            end
        end
        % direct cosines/ test point on a plane:
        [aDirTmp, lOk]=fDirCos(aPtPl(iPl,:,1),aPtPl(iPl,:,2),aPtPl(iPl,:,3),iPl);   % rcc 3.17
        if ~lOk
            return
        end
        cRotTmp=fStartRot(aDirTmp);  % rotation matrices
        cRot=[cRot; cRotTmp];  % rotation matrices Accum 

        aPlane(iPl,1:4)=aDirTmp; % direction cosines
        aPlane(iPl,5)=cPlane{iPl,2};%type

        % search Planes with window and/or patch and put their/its number/s
        % (it might be done by callback )
        %edges:
        nX1=min(aPtPl(iPl,:,1));nX2=max(aPtPl(iPl,:,1));
        nY1=min(aPtPl(iPl,:,2));nY2=max(aPtPl(iPl,:,2));
        nZ1=min(aPtPl(iPl,:,3));nZ2=max(aPtPl(iPl,:,3));
        aPlane(iPl,8)=nX1;  aPlane(iPl,9)=nX2;
        aPlane(iPl,10)=nY1;  aPlane(iPl,11)=nY2;
        aPlane(iPl,12)=nZ1;  aPlane(iPl,13)=nZ2;
        % assess area:
        aPtPlL=squeeze(aPtPl(iPl,:,:))*cRot{iPl,2}; % local cordinates (points of polygon)
        aPlane(iPl,14)=polyarea(aPtPlL(:,1),aPtPlL(:,2));
        % cPlane{iPl,8}=polyarea(aPtWinL(:,1),aPtWinL(:,2)); % area
    end
    
    for iGeom=3:size(cRoomGeom,2)
        aRoomGeom(1,iGeom-2)=cRoomGeom{nNextRoom,iGeom};
    end
    
    cRoom={aRoomMat aPlane aWin aPat aRoomGeom aPtPl aPtWin};%room parameters
    % save parameters in binary file bRoom[RoomNumber]:
    sFile=[sInputDir '\bRoom' num2str(nNextRoom) '.tlx'];
    save(sFile,'-mat','cRoom','cRot') 
    
    % Realiza a verificação dos arquivos gerados
    if nWinPl>0  % só roda o setup se tiver janela
        fRoomSetUp(nNextRoom);
        % run setup ground
        fSetGrd2(nNextRoom);
    end
    
    % Abre projeto
    set(handles.tDeleteProject,'UserData',[nNextRoom 1]);
    
    %Mostra número do projeto
    set(handles.tRoomNum,'String',num2str(nNextRoom));

end

set(handles.tPanNewProject,'Visible','off');
set(handles.tPanProj,'Visible','on');

%Abre Lista de Projetos
fOpenProject(hObject,eventdata,handles,false)

% Destrava as outras abas
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');
set(handles.tPanShadingButton,'Enable','on');

%Reseta Campos
fClearFieldsNewRecPrj(handles);

% Mostra informações de projeto
% Importa numero do projeto
nRoomNum=nNextRoom;
sRoomNum=fPut0(nRoomNum,3);
sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; %nome do arquivo de planos
%   Abre arquivos de plano
if exist(sFilePl,'file')==2
    load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
    return
end

% Quantidade de planos
nSizePlanes=size(cPlane,1); %Tamanho do arquivo de planos
set(handles.tInfoPrjPlanes,'String',nSizePlanes);

% Última modificação
cFile={'bPlane','bMat','bWindow','bGrdZone2-r','bRoom','bVis'};
nTFile=length(cFile);

for i=1:nTFile
    sFile=[sInputDir '\' cFile{i} sRoomNum '.tlx'];
    if exist(sFile,'file')
        aFileInfo=dir(sFile);
        aTimeData{i}=aFileInfo.date;
    end
end

% Limpa campos vazios antes

aLastTime=sort(aTimeData(~cellfun('isempty',aTimeData)));
sLastTime=aLastTime{end};
set(handles.tInfoPrjTime,'String',sLastTime); 

% Abre Projeto
fOpenProject(hObject,eventdata,handles,true) % Abre o Arquivo de planos

% Mensagem de criação
load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Load Language File
uiwait(msgbox(MsgBox.NewProjetCreated));


% Callback de previsualização da dimensão 
function tDimPrev_Callback(hObject, eventdata, handles)
% hObject    handle to tDimXRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tDimXRec as text
%        str2double(get(hObject,'String')) returns contents of tDimXRec as a double
fRoomPreviewPrj(hObject,eventdata,handles);

% Calback de previsualização do plano da janela
function tWindowPlaneRec_Callback(hObject, eventdata, handles)
% hObject    handle to tWindowPlaneRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tWindowPlaneRec as text
%        str2double(get(hObject,'String')) returns contents of tWindowPlaneRec as a double

global spcodeDir

%Verifica se e possível criar o plano
if get(handles.tRatSlope0NewPrjRec,'Value')==0
    if str2double(get(handles.tWindowPlaneRec,'String'))==2 || str2double(get(handles.tWindowPlaneRec,'String'))==8
        set(handles.tWindowPlaneRec,'String','5');
        fRoomPreviewPrj(hObject,eventdata,handles);
        load([spcodeDir '\bLangDef.tlx'],'-mat','WarnDlg');  %Load Language File
        warndlg(WarnDlg.CanNotCreateAWindowOnASlantedPlane);
    else
        fRoomPreviewPrj(hObject,eventdata,handles);
    end
else
    fRoomPreviewPrj(hObject,eventdata,handles);
end

% --- Executes on button press in tCancelNewPrjRec.
function tCancelNewPrjRec_Callback(hObject, eventdata, handles)
% hObject    handle to tCancelNewPrjRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global sInputDir spcodeDir

% Verifica se foram criados projetos, se não não volta e apresenta erro
sFilePl=[sInputDir '\bPlane001.tlx'];
if exist(sFilePl,'file') %Se existe
    set(handles.tPanNewProject,'Visible','off');
    set(handles.tPanProj,'Visible','on');
    fOpenProject(hObject,eventdata,handles,true)
    
    % Destrava as outras abas
    set(handles.tPanDataButton,'Enable','on');
    set(handles.tPanVisButton,'Enable','on');
    set(handles.tPanWinButton,'Enable','on');
    set(handles.tPanMaterialButton,'Enable','on');
    set(handles.tPanElementButton,'Enable','on');
    set(handles.tPanShadingButton,'Enable','on');
else % Se não existe
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg(ErrorDlg.PleaseCreateRoomGeometry);
    return
end

%Limpa Campos
fClearFieldsNewRecPrj(handles);

% --- Executes on button press in tRatSlope0NewPrjRec.
function tRatSlope0NewPrjRec_Callback(hObject, eventdata, handles)
% hObject    handle to tRatSlope0NewPrjRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tRatSlope0NewPrjRec

set(handles.tDimZcRec,'String','0');
set(handles.tDimZcRec,'Enable','off');

fRoomPreviewPrj(hObject,eventdata,handles);

% --- Executes on button press in tRatSlope1NewPrjRec.
function tRatSlope1NewPrjRec_Callback(hObject, eventdata, handles)
% hObject    handle to tRatSlope1NewPrjRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tRatSlope1NewPrjRec

set(handles.tDimZcRec,'Enable','on');
if str2double(get(handles.tDimZcRec,'String'))==0
    set(handles.tDimZcRec,'String','30');
end
fRoomPreviewPrj(hObject,eventdata,handles);

% --- Executes on button press in tRatSlope2NewPrjRec.
function tRatSlope2NewPrjRec_Callback(hObject, eventdata, handles)
% hObject    handle to tRatSlope2NewPrjRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tRatSlope2NewPrjRec

set(handles.tDimZcRec,'Enable','on');
if str2double(get(handles.tDimZcRec,'String'))==0
    set(handles.tDimZcRec,'String','30');
end
fRoomPreviewPrj(hObject,eventdata,handles);

% --- Executes on button press in tRatSlope3NewPrjRec.
function tRatSlope3NewPrjRec_Callback(hObject, eventdata, handles)
% hObject    handle to tRatSlope3NewPrjRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tRatSlope3NewPrjRec

set(handles.tDimZcRec,'Enable','on');
if str2double(get(handles.tDimZcRec,'String'))==0
    set(handles.tDimZcRec,'String','30');
end
fRoomPreviewPrj(hObject,eventdata,handles);

% --- Executes on button press in tRatSlope4NewPrjRec.
function tRatSlope4NewPrjRec_Callback(hObject, eventdata, handles)
% hObject    handle to tRatSlope4NewPrjRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tRatSlope4NewPrjRec

set(handles.tDimZcRec,'Enable','on');
if str2double(get(handles.tDimZcRec,'String'))==0
    set(handles.tDimZcRec,'String','30');
end
fRoomPreviewPrj(hObject,eventdata,handles);

% --- Executes when entered data in editable cell(s) in tTableProject.
function tTableProject_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tTableProject (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

global sInputDir

%Importa Informação da tela
aData=get(handles.tTableProject,'Data');

%Abre arquivo de Geometria de Projetos
sFileRoomGeom=[sInputDir '\bRoomGeom.tlx'];
load(sFileRoomGeom,'-mat','cRoomGeom');
  
% Coloca Nova Descrição  
cRoomGeom{eventdata.Indices(1),2}=aData{eventdata.Indices(1),2};

%Salva Arquivo
sFileRoomGeom=[sInputDir '\bRoomGeom.tlx'];
save(sFileRoomGeom,'-mat','cRoomGeom')

%Exibe projeto
tTableProject_CellSelectionCallback(hObject, eventdata, handles)


%~~~~~~~~~~~~~~~~ FUNÇÕES DA TAB DE PLANOS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% --- Executes on button press in tNewLine.
function tNewLine_Callback(hObject, eventdata, handles)
% hObject    handle to tNewLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Cria nova linha na planilha de dados
% Autor: Pedro 2017

% Atualizações: 
% 2016.02.12 v. 8.0 - Pedro - Tipo Corrigido para o novo campo de tipo de plano
% 2017.09.04 v. 8.0 - Pedro - Limpa e melhora comentários
% 2017.09.05 v. 8.0 - Pedro - Retira loops para ciação de arquivo de
% visualização, retira tabela invertida, insere função para descer o scrol
% da tabela para o novo plano, tira cPlane do global
% 2017.10.15 v8 - Pedro - Desabilita botão de criar novo plano ao abrir
% novos campos. Acrescenta alteraçao de grupo para o noov plano
% 2017.10.16 v8 - Pedro - Revisão OK

global spcodeDir sInputDir

% Inporta número do projeto
nRoomNum=str2double(get(handles.tRoomNum,'String'));
if isnumeric(nRoomNum)
    sRoomNum=fPut0(nRoomNum,3);
    sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx'];
else %Erro! sem número de projeto
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.PleaseInputRoomNumber ' (E0095)']);	
    return
end

%Abre arquivos de plano
if exist(sFilePl,'file')==2
    load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
    return
end

% Erro caso cPlane não exista no arquivo
if exist('cPlane','var')==0
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.cPlaneNotFoundIn ' ' sFilePl ' (E0087)']); 
    return
end

% Erro caso cPlane esteja vazio no arquivo
if isempty(cPlane)
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cPlaneIsEmptyFile ' '  sFilePl ' ' ErrorDlg.MightBeCorrupted ' (E0098)'];	
    errordlg(sMens);
    return
end

[nTPl,~]=size(cPlane); % Número de planos existentes 
aData=get(handles.tTablePlanes,'Data');

%Verifica a qual grupo pertencerá os novos planos
nGroup=max(cellfun(@max,aData(:,3)))+1;

% Cria e insere nova linha vazia 
aNewData={(nTPl+1),-(nTPl+1),nGroup,'',[],[],[],[],[],[],[],[],[],[],[],[]}; % Add one empty line to the uitable
aData=[aData;aNewData];

%Exibe a tabela com a nova linha vazia 
set(handles.tTablePlanes,'Data',aData)

%Desce a visualização para a linha criada (Java e nova função:findjobj)
jScrollpane=findjobj(handles.tTablePlanes);
scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
jScrollpane.getVerticalScrollBar.setValue(scrollMax);   % Coloca o Scroll na posição Máxima

% Habilita botões 
set(handles.tSaveNewPl,'Enable','on');
set(handles.tSaveDoublePl,'Enable','on');   
set(handles.tCancelNewPlane,'Enable','on');
set(handles.tPanDataButton,'Enable','on');

% Desabilita botões 
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanElementButton,'Enable','off');
set(handles.tPanShadingButton,'Enable','off');
set(handles.tGoToPlane,'Enable','off');
set(handles.tNewLine,'Enable','off');
set(handles.tDeletePlane,'Enable','off');
set(handles.tCreateFace,'Enable','off');

% --- Executes on button press in tSaveNewPl.
function tSaveNewPl_Callback(hObject, eventdata, handles)
% hObject    handle to tSaveNewPl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Salva novo plano simples
% Autor: Pedro 2017

% Atualizações:
% 2014.03.10 v 7.1.5 Beta - Multilanguage - Pedro
% 2016.02.12 v. 8.0 - Pedro - Tipo Corrigido para o novo campo de tipo de plano
% 2016.30.03 v. 7.4 - Orestes - Adaptando para o Scroll
% 2017.09.04 v. 8.0 - Pedro - Limpa e melhora comentários
% 2017.09.05 v. 8.0 - Pedro - Corrige tabela invertida, exibe tipo novo de
% planos, tira cPlane/cVis do global
% 2017.10.16 v8 - Pedro - Revisão OK

global  sInputDir spcodeDir  

% Inporta número do projeto
nRoomNum=str2double(get(handles.tRoomNum,'String'));
if isnumeric(nRoomNum)
    sRoomNum=fPut0(nRoomNum,3);
    sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx'];
else %Erro! sem número de projeto
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.PleaseInputRoomNumber ' (E0095)']);	
    return
end

%Abre arquivos de plano
if exist(sFilePl,'file')==2
    load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
    return
end

% Erro caso cPlane não exista no arquivo
if exist('cPlane','var')==0
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.cPlaneNotFoundIn ' ' sFilePl ' (E0087)']); 
    return
end

% Erro caso cPlane esteja vazio no arquivo
if isempty(cPlane)
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cPlaneIsEmptyFile ' '  sFilePl ' ' ErrorDlg.MightBeCorrupted ' (E0098)'];	
    errordlg(sMens);
    return
end

%Importa dados dos planos existentes e do novo plano inserido
aData=get(handles.tTablePlanes,'Data');
[nTPl,~]=size(cPlane); % Número de planos que ja existem 
nNextPl=nTPl + 1; % Número do novo plano

%Verificaçao de campos vazios
nFieldsEmpty=sum(sum(cellfun(@isempty,aData(:,:))));
nFieldsNan1=sum(sum(isnan(cellfun(@str2num,aData(:,5:end)))));
nFieldsNan2=sum(sum(cellfun(@isnan,aData(:,1:3))));

if nFieldsEmpty==0 && nFieldsNan1==0 && nFieldsNan2==0
    aType=aData{nNextPl,2};
    %Tipo Antigo
    if aData{nNextPl,2}<0
        aOldType=-1;
    elseif aData{nNextPl,2}==0
        aOldType=0;
    else
        aOldType=1;
    end
    cDesc=aData{nNextPl,4}; % Descrição do Plano 
    nGroup=aData{nNextPl,3}; % Descrição do Plano 
    aP1=[str2double(aData{nNextPl,5}),str2double(aData{nNextPl,6}),str2double(aData{nNextPl,7})]; % X, Y e Z 1
    aP2=[str2double(aData{nNextPl,8}),str2double(aData{nNextPl,9}),str2double(aData{nNextPl,10})]; % X, Y e Z 2
    aP3=[str2double(aData{nNextPl,11}),str2double(aData{nNextPl,12}),str2double(aData{nNextPl,13})]; % X, Y e Z 3
    aP4=[str2double(aData{nNextPl,14}),str2double(aData{nNextPl,15}),str2double(aData{nNextPl,16})]; % X, Y e Z 4

    cNewPlane={nNextPl,aType,cDesc,aP1,aP2,aP3,aP4,aOldType,nGroup}; % Salva o novo plano em uma célula
    cPlane=[cPlane;cNewPlane]; % Acrescenta o novo plano no arquivo de planos original 
 
    % Atualiza arquido de Características dos materiais
    sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];
    if exist(sFileMat,'file')==0
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([sFileMat ' ' ErrorDlg.NotFound ' (E0072)'])
        return
    else
    load(sFileMat,'-mat','cMat');
        if exist('cMat','var')==1
            [nNMat, ~]=size(cMat);% Pedro
            if nNMat~=nTPl
                load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
                errordlg([ErrorDlg.FileErrorPlaneAndMaterialFilesDoNotMatch ' (E0109)'])
                return
            end
        else
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([ErrorDlg.cMatNotFound ' (E0071)'])
        return
        end
    end
    cMat{nNextPl,1}=nNextPl;
    nRD=0;    nRS=0;    nTD=0;    nTS=0;
    if cPlane{nNextPl,2} < 0 % Opaco
        nRD=0.5; % Refletência difusa padrão 
    elseif cPlane{nNextPl,2} == 0 % Plano Imaginário
        nTS=1;
    elseif cPlane{nNextPl,2} == 1 % Vidro padrão 
        nRS=0.1;nTS=0.85;
    end		
    cMat{nNextPl,2}=nRD; % Refletância difusa 
    cMat{nNextPl,3}=nRS; % Refletância especular 
    cMat{nNextPl,4}=nTD; % Transmitância difusa 
    cMat{nNextPl,5}=nTS; % Transmitância especular 
    
    % Atualiza bRoom %%%%%%%%%%%
    sFileRoom=[sInputDir '\bRoom' sRoomNum '.tlx'];
    if exist(sFileRoom,'file')==0
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg(['\bRoom' sRoomNum '.tlx' ' ' ErrorDlg.NotFound ' (E0072)'])
        return
    else
        load(sFileRoom,'-mat','cRot','cRoom');
    end
    
    % Corrige matriz de materiais
    aRoomMat=cRoom{1};
    for jMat=2:5
        aMat(1,jMat-1)=cMat{nNextPl,jMat};
    end
    aRoomMt=cumsum(aMat,2);
    aRoomMat(nNextPl,:)=aRoomMt;
    
    % converts cPlane->aPlane
    aPlane=cRoom{2};
    aPlane(nNextPl,6:7)=0; % default-> neither window nor patch
    for jPl=4:7 % points
        for kPl=1:3 % (1=x,2=y,3=z)
            aPtPl(nNextPl,jPl-3,kPl)=cPlane{nNextPl,jPl}(kPl);
        end
    end
    % direct cosines/ test point on a plane:
    [aDirTmp, lOk]=fDirCos(aPtPl(nNextPl,:,1),aPtPl(nNextPl,:,2),aPtPl(nNextPl,:,3),nNextPl);   % rcc 3.17
    if ~lOk
        return
    end
    cRotTmp=fStartRot(aDirTmp);  % rotation matrices
    cRot=[cRot; cRotTmp];  % rotation matrices Accum 

    aPlane(nNextPl,1:4)=aDirTmp; % direction cosines
    aPlane(nNextPl,5)=cPlane{nNextPl,2};%type

    %edges:
    nX1=min(aPtPl(nNextPl,:,1));nX2=max(aPtPl(nNextPl,:,1));
    nY1=min(aPtPl(nNextPl,:,2));nY2=max(aPtPl(nNextPl,:,2));
    nZ1=min(aPtPl(nNextPl,:,3));nZ2=max(aPtPl(nNextPl,:,3));
    aPlane(nNextPl,8)=nX1;  aPlane(nNextPl,9)=nX2;
    aPlane(nNextPl,10)=nY1;  aPlane(nNextPl,11)=nY2;
    aPlane(nNextPl,12)=nZ1;  aPlane(nNextPl,13)=nZ2;
    % assess area:
    aPtPlL=squeeze(aPtPl(nNextPl,:,:))*cRot{nNextPl,2}; % local cordinates (points of polygon)
    aPlane(nNextPl,14)=polyarea(aPtPlL(:,1),aPtPlL(:,2));
    
    cRoom{1}=aRoomMat;
    cRoom{2}=aPlane;
    cRoom{6}=aPtPl; %#ok<*NASGU>
    % Fim da Correção de bRoom %%%%%
    
    %Salva novo arquivo de planos e de visualização
    save(sFileRoom,'-mat','cRoom','cRot') 
    save(sFilePl,'-mat','cPlane')
    save(sFileMat,'-mat','cMat')
    
    % Desabilita botões 
    set(handles.tSaveNewPl,'Enable','off');
    set(handles.tSaveDoublePl,'Enable','off');   
    set(handles.tCancelNewPlane,'Enable','off');

    % Habilita botões 
    set(handles.tPanVisButton,'Enable','on');
    set(handles.tPanMaterialButton,'Enable','on');
    set(handles.tPanPrjButton,'Enable','on');
    set(handles.tPanWinButton,'Enable','on');
    set(handles.tPanElementButton,'Enable','on');
    set(handles.tPanShadingButton,'Enable','on');
    set(handles.tGoToPlane,'Enable','on');
    set(handles.tNewLine,'Enable','on');
    set(handles.tDeletePlane,'Enable','on');
    set(handles.tCreateFace,'Enable','on');
    set(handles.tPanDataButton,'Enable','on');
    
    % Atualiza dados exibidos para o plano criado
    fUpdateData(handles,nNextPl,true)
    
    % Atualiza Visualização
    fUpdatePlanePreview(handles,nNextPl,true,false)
    load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Abre Arquivo de Idioma
    msgbox(MsgBox.NewPlaneSavedSuccessfully);
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Abre Arquivo de Idioma
    errordlg(MsgBox.UnableToSaveNewPlanInvalidFields);
end  

% --- Executes on button press in tSaveDoublePl_Callback.
function tSaveDoublePl_Callback(hObject, eventdata, handles)
% Salva novo plano duplo
% Autor: Pedro 2017

% Atualizações:
% hObject    handle to tSaveNewPl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 2014.03.10 v 7.1.5 Beta - Multilanguage - Pedro
% 2016.02.12 v. 8.0 - Pedro - Tipo Corrigido para o novo campo de tipo de plano
% 2016.02.26 v. 8.0 - Pedro - Inserida a opção de criação de planos multiplos
% 2017.09.04 v. 8.0 - Pedro - Limpa e melhora comentários
% 2017.09.05 v. 8.0 - Pedro - Corrige tabela invertida, retira do global cPlane/cVis
% 2017.10.16 v8.0 - Pedro - Revisão OK

global sInputDir spcodeDir 

aData=get(handles.tTablePlanes,'Data');

%Abre arquivos de plano
nRoomNum= str2double(get(handles.tRoomNum,'String')); 
sRoomNum=fPut0(nRoomNum,3);
sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx'];
if exist(sFilePl,'file')==2
    load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
    return
end

% Erro caso cPlane não exista no arquivo
if exist('cPlane','var')==0
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.cPlaneNotFoundIn ' ' sFilePl ' (E0087)']); 
    return
end

% Erro caso cPlane esteja vazio no arquivo
if isempty(cPlane)
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cPlaneIsEmptyFile ' '  sFilePl ' ' ErrorDlg.MightBeCorrupted ' (E0098)'];	
    errordlg(sMens);
    return
end

[nTPl,~]=size(cPlane); % Número de planos existentes
nNextPl=nTPl+1; % Número do novo plano

%Confirma a criação do novo plano duplo 
load([spcodeDir '\bLangDef.tlx'],'-mat','AskDlg');  %Abre Arquivo de Idioma
sSN=questdlg([AskDlg.InputPlanes ' ' num2str(nNextPl) '-' num2str(nNextPl+1) '?'],AskDlg.ConfirmInput,AskDlg.Yes,AskDlg.No,AskDlg.No);

%Verificaçao de campos vazios
nFieldsEmpty=sum(sum(cellfun(@isempty,aData(:,:))));
nFieldsNan1=sum(sum(isnan(cellfun(@str2num,aData(:,5:end)))));
nFieldsNan2=sum(sum(cellfun(@isnan,aData(:,1:3))));

%se a respostra for 'sim'
if strcmp(sSN,AskDlg.Yes)
    if nFieldsEmpty==0 && nFieldsNan1==0 && nFieldsNan2==0 % Se alguma coordenada for vazia não salva

        aType=aData{nNextPl,2};
        %Tipo Antigo
        if aData{nNextPl,2}<0
            aOldType=-1;
        elseif aData{nNextPl,2}==0
            aOldType=0;
        else
            aOldType=1;
        end
        cDesc=aData{nNextPl,4}; % Descrição do Plano 
        nGroup=aData{nNextPl,3}; % Descrição do Plano 
        aP1=[str2double(aData{nNextPl,5}),str2double(aData{nNextPl,6}),str2double(aData{nNextPl,7})]; % X, Y e Z 1
        aP2=[str2double(aData{nNextPl,8}),str2double(aData{nNextPl,9}),str2double(aData{nNextPl,10})]; % X, Y e Z 2
        aP3=[str2double(aData{nNextPl,11}),str2double(aData{nNextPl,12}),str2double(aData{nNextPl,13})]; % X, Y e Z 3
        aP4=[str2double(aData{nNextPl,14}),str2double(aData{nNextPl,15}),str2double(aData{nNextPl,16})]; % X, Y e Z 4

        cNewPlane1={nNextPl,aType,cDesc,aP1,aP2,aP3,aP4,aOldType,nGroup}; % Salva novo plano em uma célula
        cNewPlane2={nNextPl+1,aType,[cDesc ' - op'],aP1,aP4,aP3,aP2,aOldType,nGroup}; % Salva novo plano oposto em outra célula 
        
        %Salvando plano 1 
        
        cPlane = [cPlane ; cNewPlane1]; % Acrescenta o novo plano à matriz de planos 

        % Atualiza arquivo de características dos materiais 
        sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];
        if exist(sFileMat,'file')==0
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg([sFileMat ' ' ErrorDlg.NotFound ' (E0072)'])
            return
        else
        load(sFileMat,'-mat','cMat')
            if exist('cMat','var')==1
                [nNMat, ~]=size(cMat);  %Pedro
                if nNMat~=nTPl
                    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
                    errordlg([ErrorDlg.FileErrorPlaneAndMaterialFilesDoNotMatch ' (E0109)'])
                    return
                end
            else
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg([ErrorDlg.cMatNotFound ' (E0071)'])
            return
            end
        end
        cMat{nNextPl,1}=nNextPl;
        nRD=0;
        nRS=0;
        nTD=0;
        nTS=0;
        if cPlane{nNextPl,2} < 0 % Opaco
            nRD=0.5; % Refletência difusa padrão 
        elseif cPlane{nNextPl,2} == 0 % Plano Imaginário
            nTS=1;
        elseif cPlane{nNextPl,2} == 1 % Vidro padrão 
            nRS=0.1;nTS=0.85;
        end		
        cMat{nNextPl,2}=nRD; % Refletância difusa 
        cMat{nNextPl,3}=nRS; % Refletância especular 
        cMat{nNextPl,4}=nTD; % Transmitância difusa 
        cMat{nNextPl,5}=nTS; % Transmitância especular
        
        % Atualiza bRoom %%%%%%%%%%%
        sFileRoom=[sInputDir '\bRoom' sRoomNum '.tlx'];
        if exist(sFileRoom,'file')==0
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg(['\bRoom' sRoomNum '.tlx' ' ' ErrorDlg.NotFound ' (E0072)'])
            return
        else
            load(sFileRoom,'-mat','cRot','cRoom');
        end

        % Corrige matriz de materiais
        aRoomMat=cRoom{1};
        for jMat=2:5
            aMat(1,jMat-1)=cMat{nNextPl,jMat};
        end
        aRoomMt=cumsum(aMat,2);
        aRoomMat(nNextPl,:)=aRoomMt;

        % converts cPlane->aPlane
        aPlane=cRoom{2};
        aPlane(nNextPl,6:7)=0; % default-> neither window nor patch
        for jPl=4:7 % points
            for kPl=1:3 % (1=x,2=y,3=z)
                aPtPl(nNextPl,jPl-3,kPl)=cPlane{nNextPl,jPl}(kPl);
            end
        end
        % direct cosines/ test point on a plane:
        [aDirTmp, lOk]=fDirCos(aPtPl(nNextPl,:,1),aPtPl(nNextPl,:,2),aPtPl(nNextPl,:,3),nNextPl);   % rcc 3.17
        if ~lOk
            return
        end
        cRotTmp=fStartRot(aDirTmp);  % rotation matrices
        cRot=[cRot; cRotTmp];  % rotation matrices Accum 

        aPlane(nNextPl,1:4)=aDirTmp; % direction cosines
        aPlane(nNextPl,5)=cPlane{nNextPl,2};%type

        %edges:
        nX1=min(aPtPl(nNextPl,:,1));nX2=max(aPtPl(nNextPl,:,1));
        nY1=min(aPtPl(nNextPl,:,2));nY2=max(aPtPl(nNextPl,:,2));
        nZ1=min(aPtPl(nNextPl,:,3));nZ2=max(aPtPl(nNextPl,:,3));
        aPlane(nNextPl,8)=nX1;  aPlane(nNextPl,9)=nX2;
        aPlane(nNextPl,10)=nY1;  aPlane(nNextPl,11)=nY2;
        aPlane(nNextPl,12)=nZ1;  aPlane(nNextPl,13)=nZ2;
        % assess area:
        aPtPlL=squeeze(aPtPl(nNextPl,:,:))*cRot{nNextPl,2}; % local cordinates (points of polygon)
        aPlane(nNextPl,14)=polyarea(aPtPlL(:,1),aPtPlL(:,2));

        cRoom{1}=aRoomMat;
        cRoom{2}=aPlane;
        cRoom{6}=aPtPl;
        % Fim da Correção de bRoom %%%%%

        %Salva novo arquivo de planos e de visualização
        save(sFileRoom,'-mat','cRoom','cRot') 
        save(sFilePl,'-mat','cPlane')
        save(sFileMat,'-mat','cMat')
        
        %Salvando plano 2
        
        [nTPl,~] = size(cPlane); % Número de planos existentes
        cPlane = [cPlane ; cNewPlane2]; % Acrescenta o novo plano à matriz de planos
               
        % Atualiza arquivo de características dos materiais 
        nRoomNum= str2double(get(handles.tRoomNum,'String')); 
        sRoomNum=fPut0(nRoomNum,3);
        
        sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx'];
        sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];
        
        if exist(sFileMat,'file')==0
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg([sFileMat ' ' ErrorDlg.NotFound ' (E0072)'])
            return
        else
        load(sFileMat,'-mat','cMat')
            if exist('cMat','var')==1
                [nNMat, ~]=size(cMat);
                if nNMat~=nTPl
                    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
                    errordlg([ErrorDlg.FileErrorPlaneAndMaterialFilesDoNotMatch ' (E0109)'])
                    return
                end
            else
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg([ErrorDlg.cMatNotFound ' (E0071)'])
            return
            end
        end
        cMat{nNextPl+1,1}=nNextPl+1;
        nRD=0;
        nRS=0;
        nTD=0;
        nTS=0;
        if cPlane{nNextPl,2} < 0 % Opaco
            nRD=0.5; % Refletência difusa padrão 
        elseif cPlane{nNextPl,2} == 0 % Plano Imaginário
            nTS=1;
        elseif cPlane{nNextPl,2} == 1 % Vidro padrão 
            nRS=0.1;nTS=0.85;
        end		
        cMat{nNextPl+1,2}=nRD; % Refletância difusa 
        cMat{nNextPl+1,3}=nRS; % Refletância especular 
        cMat{nNextPl+1,4}=nTD; % Transmitância difusa 
        cMat{nNextPl+1,5}=nTS;% Transmitância especular 
        
        % Atualiza bRoom %%%%%%%%%%%
        sFileRoom=[sInputDir '\bRoom' sRoomNum '.tlx'];
        if exist(sFileRoom,'file')==0
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg(['\bRoom' sRoomNum '.tlx' ' ' ErrorDlg.NotFound ' (E0072)'])
            return
        else
            load(sFileRoom,'-mat','cRot','cRoom');
        end

        % Corrige matriz de materiais
        aRoomMat=cRoom{1};
        for jMat=2:5
            aMat(1,jMat-1)=cMat{nNextPl+1,jMat};
        end
        aRoomMt=cumsum(aMat,2);
        aRoomMat(nNextPl+1,:)=aRoomMt;

        % converts cPlane->aPlane
        aPlane=cRoom{2};
        aPlane(nNextPl+1,6:7)=0; % default-> neither window nor patch
        for jPl=4:7 % points
            for kPl=1:3 % (1=x,2=y,3=z)
                aPtPl(nNextPl+1,jPl-3,kPl)=cPlane{nNextPl+1,jPl}(kPl);
            end
        end
        % direct cosines/ test point on a plane:
        [aDirTmp, lOk]=fDirCos(aPtPl(nNextPl+1,:,1),aPtPl(nNextPl+1,:,2),aPtPl(nNextPl+1,:,3),nNextPl+1);   % rcc 3.17
        if ~lOk
            return
        end
        cRotTmp=fStartRot(aDirTmp);  % rotation matrices
        cRot=[cRot; cRotTmp];  % rotation matrices Accum 

        aPlane(nNextPl+1,1:4)=aDirTmp; % direction cosines
        aPlane(nNextPl+1,5)=cPlane{nNextPl+1,2};%type

        %edges:
        nX1=min(aPtPl(nNextPl+1,:,1));nX2=max(aPtPl(nNextPl+1,:,1));
        nY1=min(aPtPl(nNextPl+1,:,2));nY2=max(aPtPl(nNextPl+1,:,2));
        nZ1=min(aPtPl(nNextPl+1,:,3));nZ2=max(aPtPl(nNextPl+1,:,3));
        aPlane(nNextPl+1,8)=nX1;  aPlane(nNextPl+1,9)=nX2;
        aPlane(nNextPl+1,10)=nY1;  aPlane(nNextPl+1,11)=nY2;
        aPlane(nNextPl+1,12)=nZ1;  aPlane(nNextPl+1,13)=nZ2;
        % assess area:
        aPtPlL=squeeze(aPtPl(nNextPl+1,:,:))*cRot{nNextPl+1,2}; % local cordinates (points of polygon)
        aPlane(nNextPl+1,14)=polyarea(aPtPlL(:,1),aPtPlL(:,2));

        cRoom{1}=aRoomMat;
        cRoom{2}=aPlane;
        cRoom{6}=aPtPl;
        % Fim da Correção de bRoom %%%%%

        %Salva novo arquivo de planos e de visualização
        save(sFileRoom,'-mat','cRoom','cRot') 
        save(sFilePl,'-mat','cPlane')
        save(sFileMat,'-mat','cMat')
        
        % Desabilita botões 
        set(handles.tSaveNewPl,'Enable','off');
        set(handles.tSaveDoublePl,'Enable','off');   
        set(handles.tCancelNewPlane,'Enable','off');

        % Habilita botões 
        set(handles.tPanVisButton,'Enable','on');
        set(handles.tPanMaterialButton,'Enable','on');
        set(handles.tPanPrjButton,'Enable','on');
        set(handles.tPanWinButton,'Enable','on');
        set(handles.tPanElementButton,'Enable','on');
        set(handles.tPanShadingButton,'Enable','on');
        set(handles.tGoToPlane,'Enable','on');
        set(handles.tNewLine,'Enable','on');
        set(handles.tDeletePlane,'Enable','on');
        set(handles.tCreateFace,'Enable','on');
        set(handles.tPanDataButton,'Enable','on');

        % Atualiza dados exibidos para o plano criado
        fUpdateData(handles,[nNextPl nNextPl+1],true)

        % Atualiza Visualização
        fUpdatePlanePreview(handles,[nNextPl nNextPl+1],true,false)
           
        load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Abre Arquivo de Idioma
        msgbox(MsgBox.NewPlaneSavedSuccessfully);
    end
end

% --- Executes on button press in tCreateFace.
function tCreateFace_Callback(hObject, eventdata, handles)
% Cria Face Oposta do Plano selecionado
% Autor: Pedro 2017

% Atualizações:
% 2014.03.11 v 7.1.5 Beta - Multilanguage - Pedro
% 2016.02.12 v. 8.0 - Pedro - Tipo Corrigido para o novo campo de tipo de plano
% 2017.09.05 v. 8.0 - Pedro - Limpa e melhora comentários, retira
% cVis/cPlane do global
% 2017.09.06 v. 8.0 - Pedro - Tira o campo de cigitar planos. apaga agora
% os planos selecionados na tabela
% 2017.10.16 v8 - Pedro - Revisão OK

global sInputDir spcodeDir 

% Importa número do projeto
nRoomNum= str2double(get(handles.tRoomNum,'String'));
if isnumeric(nRoomNum)
    sRoomNum=fPut0(nRoomNum,3);
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.PleaseInputRoomNumber ' (E0095)']);
    return
end

%Abre arquivos de plano
sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx'];
if exist(sFilePl,'file')==2
    load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
    return
end

% Erro caso cPlane não exista no arquivo
if exist('cPlane','var')==0
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.cPlaneNotFoundIn ' ' sFilePl ' (E0087)']); 
    return
end

% Erro caso cPlane esteja vazio no arquivo
if isempty(cPlane)
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cPlaneIsEmptyFile ' '  sFilePl ' ' ErrorDlg.MightBeCorrupted ' (E0098)'];	
    errordlg(sMens);
    return
end

%Importa e verifica número do plano para gerar a face oposta
nOpositeNum=get(handles.tDeletePlane,'UserData');
aPlanesOp=nOpositeNum(:,1);
[nOp1,~]=size(nOpositeNum);
nOpositeNum1=nOpositeNum(1,1);
nOpositeNum2=nOpositeNum(nOp1,1);
% aPlaneNum=cell2mat(cPlane(:,1));
nTPlane=length(cPlane);

%Verifica se o número solicitado é válido
if nOpositeNum1<16 || nOpositeNum2<16
  load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
  errordlg([ErrorDlg.Planes1To15HaveNoNeedToCreateOtherFace ' (E0110)'])
  return
end
if nOpositeNum1>nTPlane || nOpositeNum2>nTPlane
  load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
  errordlg([ErrorDlg.PlaneNumberOutOfRange ' (E0111)'])
  return
end
if nOpositeNum1>nOpositeNum2
  load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
  errordlg([ErrorDlg.Limit1BiggerLimit2 ' (E0105)'])
  return
end

%Confirmação da operação
cDesc=(cPlane(:,3));
if nOpositeNum1==nOpositeNum2
  load([spcodeDir '\bLangDef.tlx'],'-mat','AskDlg');  %Abre Arquivo de Idioma
  sSN=questdlg([AskDlg.CreateOppositeFaceForPlane ' ' num2str(nOpositeNum1) ' - ' cDesc{nOpositeNum1} ' ?'],AskDlg.ConfirmCreate,AskDlg.Yes,AskDlg.No,AskDlg.No);
else
  load([spcodeDir '\bLangDef.tlx'],'-mat','AskDlg');  %Abre Arquivo de Idioma
  sSN=questdlg([AskDlg.CreateOppositeFacesForPlanesFrom ' [' num2str(nOpositeNum1) ' - ' cDesc{nOpositeNum1} '] ' AskDlg.To ' [' num2str(nOpositeNum2) ' - ' cDesc{nOpositeNum2}  ']  ?'],AskDlg.ConfirmCreate,AskDlg.Yes,AskDlg.No,AskDlg.No);
end

aData=get(handles.tTablePlanes,'Data');
% Se a reposta é 'Sim'
if strcmp(sSN,AskDlg.Yes)   
    %Importa tabela de dados
    for k=1:size(aPlanesOp,1)
        nPl=aPlanesOp(k);
        [nTPl,~]=size(cPlane); % Número de planos já existentes
        nNextPl=nTPl+1; % Número do novo plano
        aType=aData{nPl,2};
        %Tipo Antigo
        if aData{nPl,2}<0
            aOldType=-1;
        elseif aData{nPl,2}==0
            aOldType=0;
        else
            aOldType=1;
        end
        cDesc=aData{nPl,4}; % Descrição do Plano 
        nGroup=aData{nPl,3}; % Descrição do Plano 
        aP1=[str2double(aData{nPl,5}),str2double(aData{nPl,6}),str2double(aData{nPl,7})]; % X, Y e Z 1
        aP2=[str2double(aData{nPl,8}),str2double(aData{nPl,9}),str2double(aData{nPl,10})]; % X, Y e Z 2
        aP3=[str2double(aData{nPl,11}),str2double(aData{nPl,12}),str2double(aData{nPl,13})]; % X, Y e Z 3
        aP4=[str2double(aData{nPl,14}),str2double(aData{nPl,15}),str2double(aData{nPl,16})]; % X, Y e Z 4

        cNewPlane={nNextPl,aType,[cDesc ' - op'],aP1,aP4,aP3,aP2,aOldType,nGroup}; % Salva o novo plano em uma celula

        cPlane=[cPlane;cNewPlane]; % Adiciona o plano novo na celula principal

        % Carrega os nomes dos arquivos
        sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx'];
        sFileMat=[sInputDir '\bMat' sRoomNum '.tlx']; 

        % Atualiza o arquivo de Características dos Materiais
        if exist(sFileMat,'file')==0
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg([sFileMat ' ' ErrorDlg.NotFound ' (E0072)'])
            return
        else
        load(sFileMat,'-mat','cMat')
            if exist('cMat','var')==1
                [nNMat, ~]=size(cMat);
                if nNMat~=nTPl
                    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
                    errordlg([ErrorDlg.FileErrorPlaneAndMaterialFilesDoNotMatch ' (E0109)'])
                    return
                end
            else
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg([ErrorDlg.cMatNotFound ' (E0071)'])
            return
            end
        end

        cMat{nNextPl,1}=nNextPl;
        nRD=0;        nRS=0;        nTD=0;        nTS=0;

        if cPlane{nNextPl,2} < 0 % Opaco
            nRD=0.5; % Refletência difusa padrão 
        elseif cPlane{nNextPl,2} == 0 % Plano Imaginário
            nTS=1;
        elseif cPlane{nNextPl,2} == 1 % Vidro padrão 
            nRS=0.1;nTS=0.85;
        end		
        cMat{nNextPl,2}=nRD; % Refletância difusa 
        cMat{nNextPl,3}=nRS; % Refletância especular 
        cMat{nNextPl,4}=nTD; % Transmitância difusa 
        cMat{nNextPl,5}=nTS; % Transmitância especular
        
        % Atualiza bRoom %%%%%%%%%%%
        sFileRoom=[sInputDir '\bRoom' sRoomNum '.tlx'];
        if exist(sFileRoom,'file')==0
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg(['\bRoom' sRoomNum '.tlx' ' ' ErrorDlg.NotFound ' (E0072)'])
            return
        else
            load(sFileRoom,'-mat','cRot','cRoom');
        end

        % Corrige matriz de materiais
        aRoomMat=cRoom{1};
        for jMat=2:5
            aMat(1,jMat-1)=cMat{nNextPl,jMat};
        end
        aRoomMt=cumsum(aMat,2);
        aRoomMat(nNextPl,:)=aRoomMt;

        % converts cPlane->aPlane
        aPlane=cRoom{2};
        aPlane(nNextPl,6:7)=0; % default-> neither window nor patch
        for jPl=4:7 % points
            for kPl=1:3 % (1=x,2=y,3=z)
                aPtPl(nNextPl,jPl-3,kPl)=cPlane{nNextPl,jPl}(kPl);
            end
        end
        % direct cosines/ test point on a plane:
        [aDirTmp, lOk]=fDirCos(aPtPl(nNextPl,:,1),aPtPl(nNextPl,:,2),aPtPl(nNextPl,:,3),nNextPl);   % rcc 3.17
        if ~lOk
            return
        end
        cRotTmp=fStartRot(aDirTmp);  % rotation matrices
        cRot=[cRot; cRotTmp];  % rotation matrices Accum 

        aPlane(nNextPl,1:4)=aDirTmp; % direction cosines
        aPlane(nNextPl,5)=cPlane{nNextPl,2};%type

        %edges:
        nX1=min(aPtPl(nNextPl,:,1));nX2=max(aPtPl(nNextPl,:,1));
        nY1=min(aPtPl(nNextPl,:,2));nY2=max(aPtPl(nNextPl,:,2));
        nZ1=min(aPtPl(nNextPl,:,3));nZ2=max(aPtPl(nNextPl,:,3));
        aPlane(nNextPl,8)=nX1;  aPlane(nNextPl,9)=nX2;
        aPlane(nNextPl,10)=nY1;  aPlane(nNextPl,11)=nY2;
        aPlane(nNextPl,12)=nZ1;  aPlane(nNextPl,13)=nZ2;
        % assess area:
        aPtPlL=squeeze(aPtPl(nNextPl,:,:))*cRot{nNextPl,2}; % local cordinates (points of polygon)
        aPlane(nNextPl,14)=polyarea(aPtPlL(:,1),aPtPlL(:,2));

        cRoom{1}=aRoomMat;
        cRoom{2}=aPlane;
        cRoom{6}=aPtPl;
        % Fim da Correção de bRoom %%%%%

        %Salva novo arquivo de planos e de visualização
        save(sFileRoom,'-mat','cRoom','cRot')

        %Salva novos arquivos
        save(sFilePl,'-mat','cPlane')
        save(sFileMat,'-mat','cMat')
        
        % Exibe os dados do novo plano na tela
        aNewData={nNextPl,aType,nGroup,[cDesc ' - op'],aP1(1),aP1(2),aP1(3),aP2(1),aP2(2),aP2(3),aP3(1),aP3(2),aP3(3),aP4(1),aP4(2),aP4(3)}; % Add one empty line to the uitable
        aData=[aData;aNewData];
        
        
    end
    %Limpa o registro de células e deixa os botões em off
    set(handles.tDeletePlane,'UserData',[]);
    set(handles.tDeletePlane,'Enable','off');
    set(handles.tCreateFace,'Enable','off'); 
   
    %Exibe a tabela com a nova linha vazia 
    set(handles.tTablePlanes,'Data',aData)
    
    % Atualiza dados exibidos para o plano criado
    fUpdateData(handles,nNextPl,true)
    
    % Atualiza Visualização
    fUpdatePlanePreview(handles,nNextPl,true,false)
    
    load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Abre Arquivo de Idioma
    uiwait(msgbox(MsgBox.NewPlaneSavedSuccessfully));
end

% --- Executes on button press in tDeletePlane.
function tDeletePlane_Callback(hObject, eventdata, handles)
% Apaga Plano selecionado
% Autor: Pedro 2017

% Atualizações:
% 2014.03.10 v 7.1.5 Beta - Multilanguage - Pedro
% 2017.09.04 v. 8.0 - Pedro - Limpa e melhora comentários
% 2017.09.05 v. 8.0 - Pedro - Tira cPlane,cVis do global
% 2017.09.06 v. 8.0 - Pedro - Tira o campo de digitar planos. apaga agora
% os planos selecionados na tabela
%2017.10.16 v8 - Pedro - Revisão OK

global sInputDir spcodeDir

% Inporta número do projeto
nRoomNum=str2double(get(handles.tRoomNum,'String'));
if isnumeric(nRoomNum)
    sRoomNum=fPut0(nRoomNum,3);
    sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx'];
else %Erro! sem número de projeto
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.PleaseInputRoomNumber ' (E0095)']);	
    return
end

%Importa número de planos a apagar
nDeleteNum=get(handles.tDeletePlane,'UserData');
[nDel1,~]=size(nDeleteNum);
nDeleteNum1=nDeleteNum(1,1); %Quantidade de loops
nDeleteNum2=nDeleteNum(nDel1,1); %Quantidade de planos

%Abre arquivos de plano
if exist(sFilePl,'file')==2
    load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
    %     errordlg([sFilePl ' not found']);
    return
end

% Erro caso cPlane não exista no arquivo
if exist('cPlane','var')==0
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.cPlaneNotFoundIn ' ' sFilePl ' (E0087)']); 
    return
end

% Erro caso cPlane esteja vazio no arquivo
if isempty(cPlane)
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cPlaneIsEmptyFile ' '  sFilePl ' ' ErrorDlg.MightBeCorrupted ' (E0098)'];	
    errordlg(sMens);
    return
end

%Carrega números e descrições dos planos já existentes
aPlaneNum=cell2mat(cPlane(:,1));
cDesc=(cPlane(:,3));
nTPlane=length(aPlaneNum);

% Verificação para não apagar os planos padrão ou um plano inexistente
if nDeleteNum1<16 || nDeleteNum2<16
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.Planes1To15CannotBeDeleted ' (E0103)'])
  return
end

%Conformação de planos a apagar
if nDeleteNum1==nDeleteNum2
    load([spcodeDir '\bLangDef.tlx'],'-mat','AskDlg');  %Abre Arquivo de Idioma
    sSN=questdlg([AskDlg.DeletePlane ' ' num2str(nDeleteNum1) ' - ' cDesc{nDeleteNum1} ' ?'],AskDlg.ConfirmDelete,AskDlg.Yes,AskDlg.No,AskDlg.No);
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','AskDlg');  %Abre Arquivo de Idioma
    sSN=questdlg([AskDlg.DeletePlanesFrom '[' num2str(nDeleteNum1) ' - ' cDesc{nDeleteNum1} '] ' AskDlg.To ' [' num2str(nDeleteNum2) ' - ' cDesc{nDeleteNum2}  ']  ?'],AskDlg.ConfirmDelete,AskDlg.Yes,AskDlg.No,AskDlg.No);
end

%Se a resposta for 'sim' apaga os planos
if strcmp(sSN,AskDlg.Yes)  %se strcmp(sSN,'Yes')
    % Testa se o plano pertence a alguma janela
    sFileWin=[sInputDir '\bWindow' sRoomNum '.tlx'];
    if exist(sFileWin,'file')==2
        load(sFileWin,'-mat','cWindow') % cWindow
    else
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([ErrorDlg.File ' ' sFileWin ' ' ErrorDlg.NotFound ' (E0107)']);
        return;
    end
    nTWin=size(cWindow,1); %Pedro
    aPlWin=[];
    
    for k=1:2:nTWin
        aPlWin=[aPlWin cWindow{k,9}]; %Pedro
    end
    for k=nDeleteNum1:nDeleteNum2
        aFind=find(aPlWin==k,1);
        if ~isempty(aFind)
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg([ErrorDlg.Plane ' ' num2str(k) ' ' ErrorDlg.IsConnectToOneWindowWhenDeletesWindowTropLuxDeletesAllConc])
            set(handles.tDeleteNum1,'string','');set(handles.tDeletePlanes,'string','');
            return
        end
    end
    nDif=nDeleteNum2-nDeleteNum1+1;

    for k=1:2:nTWin
        if cWindow{k,9}(1)>nDeleteNum2
            cWindow{k,9}=cWindow{k,9}-nDif; %Pedro
        end
    end
    save(sFileWin,'-mat','cWindow')

    % Apaga Planos
    cPlane(nDeleteNum1:nDeleteNum2,:)=[];
    for k=nDeleteNum1:(nTPlane-(nDif))
        if cPlane{k,2}<0
            cPlane{k,2}=cPlane{k,2}+(nDif);
        elseif cPlane{k,2}>0
            cPlane{k,2}=cPlane{k,2}-(nDif);
        end % if ==0 do nothing
        cPlane{k,1}=k;
    end
    save(sFilePl,'-mat','cPlane')
    
    % Corrige o arquivo de características dos materiais
    sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];
    load(sFileMat,'-mat','cMat');
    cMat(nDeleteNum1:nDeleteNum2,:)=[];
    for k=nDeleteNum1:(nTPlane-(nDeleteNum2-nDeleteNum1+1))
        cMat{k,1}=k;
    end
    save(sFileMat,'-mat','cMat')
    
    % Carrega informações da visualização
    sFileVis=[sInputDir '\bVis' sRoomNum '.tlx'];
    if exist(sFileVis,'file')==0 %Se não existe arquivo de visualização
        cVis=cPlane(:,1);
        cVis(:,2:4)={0.5};  % Define toda superfície como cinza
        cVis(:,5)={0.7}; % Define Transparência em 30% 
        save(sFileVis,'-mat','cVis')
    else
        load(sFileVis,'-mat','cVis'); % Carrega: cVis
    end
    if exist('cVis','var')==0
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        sMens=[ErrorDlg.cVisNotFoundIn ' '  sFile ' (E0157)'];	
        errordlg(sMens);return
    end
    if isempty(cVis)
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        sMens=[ErrorDlg.cVisIsEmptyFile ' '  sFile ' ' ErrorDlg.MightBeCorrupted ' (E0158)'];	
        errordlg(sMens);
        return
    end
    
    %Corrige o arquivo de visualização
    cVis=cPlane(:,1);
    cVis(:,2:4)={0.5};  % Define toda superfície como cinza 
    cVis(:,5)={0.7};  %define transparência de 30%  
    save(sFileVis,'-mat','cVis')
    
    %Limpa o registro de células e deixa os botões em off
    set(handles.tDeletePlane,'UserData',[]);
    set(handles.tDeletePlane,'Enable','off');
    set(handles.tCreateFace,'Enable','off'); 
end

% Atualiza dados exibidos para o plano criado
fUpdateData(handles,0,false)

% Atualiza Visualização
fUpdatePlanePreview(handles,-[nDeleteNum1:nDeleteNum2],true,false) %#ok<NBRAK>

% --- Executes when entered data in editable cell(s) in tTablePlanes.
function tTablePlanes_CellEditCallback(hObject, eventdata, handles)
% Salva dado e atualiza visualização caso a tabela de planos seja alterada
% Autor: Pedro 2017

% Atualizações:
% 2014.03.10 v 7.1.5 Beta - Multilanguage - Pedro
% 2016.02.12 v. 8.0 - Pedro - Inserido um campo em cPlane, no final, para a
% nova ordem de tipo. antes haviam tipos<0, 0 e >1..agora os tipossão -1, 0 e numéricos positivos
% 2017.09.02 v. 8.0 - Pedro - Limpa e melhora comentários
% 2017.09.02 v. 8.0 - Pedro - Corrige tabela invertida, salva e exibe tpanshadingtype
% novos de plano, tira cPlane do global
% 2017.09.12 v.8.0 - Pedro - Insere campo 'Grupo' nos planos 
% 2017.10.14 v8 - Pedro - Melhora verificaçao de campos vazios
% 2017.10.14 v8 - Muda para salvar automático caso a cálula seja alterada
% 2017.10.16 v8 - Pedro - Revisão OK

global sInputDir spcodeDir

%Verifica se há alterações na tabela
nPrevData=eventdata.PreviousData;
nNowData=eventdata.NewData;

%Verifica se é String ou número do campo alterado
if ischar(nNowData)
    iIn=strcmp(nPrevData,nNowData);
else
    if nPrevData~=nNowData
        iIn=false;
    else
        iIn=true;
    end
end

if ~iIn
    %Verifica se a opção de criar novo plano está ativada
    nNewPl=get(handles.tSaveNewPl,'Enable');

    if strcmp(nNewPl,'on') %Novo Plano sendo criado!

        aData=get(handles.tTablePlanes,'Data');

        % Verifica trava de plano transparente 
        if eventdata.Indices(2)==2
            if nNowData>0
                load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Load Language File
                uiwait(msgbox(MsgBox.NotPossibleCreateTransparentPlanes));
                aData{eventdata.Indices(1),eventdata.Indices(2)}=eventdata.PreviousData;   
                %Exibe dados dos materiais
                set(handles.tTablePlanes,'Data',aData);
                return
            end
        end

        %Verifica se todos os dados foram preenchidos
        nFieldsEmpty=sum(sum(cellfun(@isempty,aData(:,:))));
        if nFieldsEmpty==0
            nFieldsNan=sum(sum(isnan(str2double(aData(:,5:end)))));
            if nFieldsNan==0
                % Exibe plano sendo criado
                nNewPlane=size(aData,1);
                fUpdatePlanePreview(handles,nNewPlane,false,false)
            end
        end

    else  
        %Importa dados do projeto
        nRoomNum=str2double(get(handles.tRoomNum,'String'));
        if isnumeric(nRoomNum)  
            sRoomNum=fPut0(nRoomNum,3);
            sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; 
        else %Erro - Inserir número do projeto
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma 
            errordlg([ErrorDlg.PleaseInputRoomNumber ' (E0095)']);	
            return
        end

        % Lê campos na tela
        aData=get(handles.tTablePlanes,'Data');
        
        % Verifica trava de plano transparente 
        if eventdata.Indices(2)==2
            if nNowData>0
                load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Load Language File
                uiwait(msgbox(MsgBox.NotPossibleCreateTransparentPlanes));
                aData{eventdata.Indices(1),eventdata.Indices(2)}=eventdata.PreviousData;   
                %Exibe dados dos materiais
                set(handles.tTablePlanes,'Data',aData);
                return
            end
        end

        %Verificaçao de campos vazios
        nFieldsEmpty=sum(sum(cellfun(@isempty,aData(:,:))));
        nFieldsNan1=sum(sum(isnan(cellfun(@str2num,aData(:,5:end)))));
        nFieldsNan2=sum(sum(cellfun(@isnan,aData(:,1:3))));

        if nFieldsEmpty==0 && nFieldsNan1==0 && nFieldsNan2==0

            %Abre arquivos de plano
            if exist(sFilePl,'file')==2
                load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
            else
                load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
                errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
                return
            end

            % Erro caso cPlane não exista no arquivo
            if exist('cPlane','var')==0
                load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
                errordlg([ErrorDlg.cPlaneNotFoundIn ' ' sFilePl ' (E0087)']); 
                return
            end

            % Erro caso cPlane esteja vazio no arquivo
            if isempty(cPlane)
                load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
                sMens=[ErrorDlg.cPlaneIsEmptyFile ' '  sFilePl ' ' ErrorDlg.MightBeCorrupted ' (E0098)'];	
                errordlg(sMens);
                return
            end

            % Muda apenas dado alterado
            nRow=eventdata.Indices(1);
            nColumn=eventdata.Indices(2);

            %Testa se os campos estão com ponto, se com virgula os conserta
            if nColumn~=3
                aData{nRow,nColumn}=fChDecPoint(aData{nRow,nColumn});
            end

            %Salva o Dado do plano
            cLine{1}=nRow; % Número do plano 
            cLine{2}=aData{nRow,2}; % Tipo Novo
            cLine{3}=aData{nRow,4}; % Descrição
            cLine{4}=aData{nRow,5}; % X1
            cLine{5}=aData{nRow,6}; % Y1
            cLine{6}=aData{nRow,7}; % Z1
            cLine{7}=aData{nRow,8}; % X2
            cLine{8}=aData{nRow,9}; % Y2
            cLine{9}=aData{nRow,10}; % Z2
            cLine{10}=aData{nRow,11}; % X3
            cLine{11}=aData{nRow,12}; % Y3
            cLine{12}=aData{nRow,13}; % Z3
            cLine{13}=aData{nRow,14}; % X4
            cLine{14}=aData{nRow,15}; % Y4
            cLine{15}=aData{nRow,16}; % Z4
            %Tipo Antigo
            if aData{nRow,2}<0
                cLine{16}=-1;
            elseif aData{nRow,2}==0
                cLine{16}=0;
            else
                cLine{16}=1;
            end
            cLine{17}=aData{nRow,3}; %Grupo

            %Corrige caso o número do plano negativo não seja compatível
            if cLine{2}~=0 && cLine{2}<0
                if abs(cLine{2})/cLine{1}~=1 %Diferente! Coloca tipo igual ao número, se for negativo
                    cLine{2}=str2double(['-' num2str(cLine{1})]);
                end
            end

            %Salva os dados em cPlane
            cPlane{nRow,2}=cLine{2};  %Tipo
            cPlane{nRow,3}=cLine{3};  %Descrição
            cPlane{nRow,4}(1)=str2double(cLine{4});
            cPlane{nRow,4}(2)=str2double(cLine{5});
            cPlane{nRow,4}(3)=str2double(cLine{6});
            cPlane{nRow,5}(1)=str2double(cLine{7});
            cPlane{nRow,5}(2)=str2double(cLine{8});
            cPlane{nRow,5}(3)=str2double(cLine{9});  
            cPlane{nRow,6}(1)=str2double(cLine{10});
            cPlane{nRow,6}(2)=str2double(cLine{11});
            cPlane{nRow,6}(3)=str2double(cLine{12});
            cPlane{nRow,7}(1)=str2double(cLine{13});
            cPlane{nRow,7}(2)=str2double(cLine{14});
            cPlane{nRow,7}(3)=str2double(cLine{15}); 
            cPlane{nRow,8}=cLine{16};   % Tipo Antigo
            cPlane{nRow,9}=cLine{17};   % Grupo

            % Redefine o 'ground plane' para limites infinitos
            cPlane{13,4}(1:2)=[realmax realmax ];
            cPlane{13,5}(1:2)=[-realmax realmax ];
            cPlane{13,6}(1:2)=[-realmax -realmax ];
            cPlane{13,7}(1:2)=[realmax -realmax ]; 

            % Salva cPlane
            save(sFilePl,'-mat','cPlane')

            % Atualiza Plano Alterado
            fUpdatePlanePreview(handles,nRow,true,true);

        else
            %Campo inválido

            nRow=eventdata.Indices(1);
            nColumn=eventdata.Indices(2);

            %Testa se os campos estão com ponto, se com virgula os conserta
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg([ErrorDlg.Error ', ' aData{nRow,nColumn} ' ' ErrorDlg.IsNotValidInThisField ' (E0099)'])
            return
        end
    end
end

% --- Executes when selected cell(s) is changed in tTablePlanes.
function tTablePlanes_CellSelectionCallback(hObject, eventdata, handles)
% Salva posição de seleção da tabela de planos e realça plano selecionado
% Autor: Pedro 2017

% Atualizações:
% 2017.09.06 - Pedro - Armazena células selecionadas
% 2017.09.13 v.8.0 - Pedro - Substitui método de verificação de céuloas
% vazias, aumentando a velocidade
% 2017.10.16 v8 - Pedro - Corrige verificação de campos vazios
% 2017.10.16 v8 - Pedro - Revisão OK

% Traz dados da tabela
aData=get(handles.tTablePlanes,'Data');
aCellEmpty=sum(sum(cellfun(@isempty,aData)));

%Verifica se a função de criar novo plano está ativada
nNewPl=get(handles.tSaveNewPl,'Enable');

if strcmp(nNewPl,'on')==0 %Nao é novo plano
    if aCellEmpty==0
        try
            rows=eventdata.Indices(1,1);
            columns=eventdata.Indices(1,2);
            nPosition=[rows columns];
            nPosition=aData{nPosition(1),1};
            nLineOld=get(handles.tDeletePlane,'UserData');
            set(handles.tDeletePlane,'UserData',eventdata.Indices);

            %Verificaçao de campos vazios
            nFieldsEmpty=sum(sum(cellfun(@isempty,aData(:,:))));
            nFieldsNan1=sum(sum(isnan(cellfun(@str2num,aData(:,5:end)))));
            nFieldsNan2=sum(sum(cellfun(@isnan,aData(:,1:3))));

            if nFieldsEmpty==0 && nFieldsNan1==0 && nFieldsNan2==0
                if exist('nPosition','var')==0 || isempty(eventdata)==0
                    nPosition=nPosition(1);
                end
                %Verifica se mudou de linha
                if isempty(nLineOld) % Primeira vez que a guide foi aberta
                    fUpdatePlanePreview(handles,nPosition,false,false); % Preview PEDRO 2016
                else
                    if nLineOld(1)~=eventdata.Indices(1,1) %Mudou de plano
                        fUpdatePlanePreview(handles,nLineOld(1),true,false); % Preview PEDRO 2016
                        fUpdatePlanePreview(handles,nPosition,false,false); % Preview PEDRO 2016
                    else %Informações atualizadas
                        fUpdatePlanePreview(handles,nPosition,false,false); % Preview PEDRO 2016
                    end
                end     
            end
        catch
            %Nada a fazer
        end
        set(handles.tDeletePlane,'Enable','on');
        set(handles.tCreateFace,'Enable','on');
    end
end
    

function tGoToPlane_Callback(hObject, eventdata, handles)
% hObject    handle to tGoToPlane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tGoToPlane as text
%        str2double(get(hObject,'String')) returns contents of tGoToPlane as a double

%Desce a visualização para a linha criada (Java e nova função:findjobj)
jScrollpane=findjobj(handles.tTablePlanes);
scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
nData=size(get(handles.tTablePlanes,'Data'),1);
nGoTo=str2double(get(handles.tGoToPlane,'String'));
nPos=(scrollMax/nData)*(nGoTo-1);
jScrollpane.getVerticalScrollBar.setValue(floor(nPos));   % Coloca o Scroll na posição

%Limpa Campo
set(handles.tGoToPlane,'String','');

% --- Executes on button press in tCancelNewPlane.
function tCancelNewPlane_Callback(hObject, eventdata, handles)
% hObject    handle to tCancelNewPlane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nLineOld=size(get(handles.tTablePlanes,'Data'),1);

fUpdateData(handles,1,false)

fUpdatePlanePreview(handles,-nLineOld(1),false,false); 

% Desabilita botões 
set(handles.tSaveNewPl,'Enable','off');
set(handles.tSaveDoublePl,'Enable','off');   
set(handles.tCancelNewPlane,'Enable','off');

% Habilita botões 
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');
set(handles.tPanShadingButton,'Enable','on');
set(handles.tGoToPlane,'Enable','on');
set(handles.tNewLine,'Enable','on');
set(handles.tDeletePlane,'Enable','on');
set(handles.tCreateFace,'Enable','on');
set(handles.tPanDataButton,'Enable','on');

%~~~~~~~~~~~~~~~~ FUNÇÕES DA TAB DE VISUALIZAÇAO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% --- Executes on button press in tVisDestacColor.
function tVisDestacColor_Callback(hObject,eventdata,handles)
% hObject    handle to tRorate3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nRGB=uisetcolor;
set(handles.tVisDestacColor,'BackgroundColor',nRGB)

% --- Executes on button press in tVisPrevColour.
function tVisPrevColour_Callback(hObject, eventdata, handles)
% hObject    handle to tVisPrevColour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tVisPrevColour
set(handles.tVisPrevColour,'Value',1);
set(handles.tVisPrevBW,'Value',0);
cla(handles.tAxesPreview);
fRoomPreview(handles);

% --- Executes on button press in tVisPrevBW.
function tVisPrevBW_Callback(hObject, eventdata, handles)
% hObject    handle to tVisPrevBW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tVisPrevBW
set(handles.tVisPrevColour,'Value',0);
set(handles.tVisPrevBW,'Value',1);
cla(handles.tAxesPreview);
fRoomPreview(handles);

% --- Executes on button press in tVisPrevSolid.
function tVisPrevSolid_Callback(hObject, eventdata, handles)
% hObject    handle to tVisPrevSolid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tVisPrevSolid
set(handles.tVisPrevSolid,'Value',1);
set(handles.tVisPrevWired,'Value',0);
cla(handles.tAxesPreview);
fRoomPreview(handles);

% --- Executes on button press in tVisPrevWired.
function tVisPrevWired_Callback(hObject, eventdata, handles)
% hObject    handle to tVisPrevWired (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tVisPrevWired
set(handles.tVisPrevSolid,'Value',0);
set(handles.tVisPrevWired,'Value',1);
cla(handles.tAxesPreview);
fRoomPreview(handles);

% --- Executes when selected cell(s) is changed in tTableVis.
function tTableVis_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tTableVis (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
% 2017.05.09 v.8.0 - Pedro - Criada
%2017.09.05 v.8.0 - Pedro - Tirado nPosition do global, Corrigido tipo de nPosition

global sInputDir

%traz dados da tabela
nRoomNum=get(handles.tRoomNum,'String');
sRoomNum=fPut0(nRoomNum,3);

if ~isempty(eventdata.Indices)
    % Se for selecionada a cor do plano, abre seleção de cor
    nCol=eventdata.Indices(1,2);
    nRow=eventdata.Indices(1,1);
    if nCol==3

        nRGB=uisetcolor; 

        % Salva cor
        sFileVis=[sInputDir '\bVis' sRoomNum '.tlx'];
        load(sFileVis,'-mat','cVis'); % Carrega Arquivo de visualização existente
        if exist('cVis','var')==0
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            sMens=[ErrorDlg.cVisNotFoundIn ' '  sFile ' (E0157)'];	
            errordlg(sMens);
            return
        end
        if isempty(cVis)
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            sMens=[ErrorDlg.cVisIsEmptyFile ' '  sFile ' ' ErrorDlg.MightBeCorrupted ' (E0158)'];	
            errordlg(sMens);
            return
        end     

        cVis{nRow,2}=nRGB(1); 
        cVis{nRow,3}=nRGB(2);
        cVis{nRow,4}=nRGB(3);  
        save(sFileVis,'-mat','cVis')

        % Atualiza a tabela
        aVisNow=get(handles.tTableVis,'Data');
        nColor=[nRGB(1) nRGB(2) nRGB(3)];
        nColor=dec2hex(round(nColor*255),2)'; nColor = ['#';nColor(:)]';
        aVisNow{nRow,3}=strcat('<html><body bgcolor="',nColor,'">','................');
        set(handles.tTableVis,'Data',aVisNow);

        fUpdatePlanePreview(handles,nRow,true,false);
    end
end

% Dá destaque no plano selecionado
% Traz dados da tabela
aData=get(handles.tTablePlanes,'Data');
try
    if nCol~=3
        rows=eventdata.Indices(1,1);
        columns=eventdata.Indices(1,2);
        nPosition=[rows columns];
        nPosition=aData{nPosition(1),1};
        nLineOld=get(handles.tVisRunBatch,'UserData');
        set(handles.tVisRunBatch,'UserData',eventdata.Indices);

        %Verificaçao de campos vazios
        nFieldsEmpty=sum(sum(cellfun(@isempty,aData(:,:))));
        nFieldsNan1=sum(sum(isnan(cellfun(@str2num,aData(:,5:end)))));
        nFieldsNan2=sum(sum(cellfun(@isnan,aData(:,1:3))));

        if nFieldsEmpty==0 && nFieldsNan1==0 && nFieldsNan2==0
            if exist('nPosition','var')==0 || isempty(eventdata)==0
                nPosition=nPosition(1);
            end
            %Verifica se mudou de linha
            if isempty(nLineOld) % Primeira vez que a guide foi aberta
                fUpdatePlanePreview(handles,nPosition,false,false); % Preview PEDRO 2016
            else
                if nLineOld(1)~=eventdata.Indices(1,1) %Mudou de plano
                    fUpdatePlanePreview(handles,nLineOld(1),true,false); % Preview PEDRO 2016
                    fUpdatePlanePreview(handles,nPosition,false,false); % Preview PEDRO 2016
                else %Informações atualizadas
                    fUpdatePlanePreview(handles,nPosition,false,false); % Preview PEDRO 2016
                end
            end     
        end
    end
catch
    %Nada a fazer
end

% --- Executes when entered data in editable cell(s) in tTableVis.
function tTableVis_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tTableVis (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

global sInputDir

%traz dados da tabela
aData=get(handles.tTableVis,'Data');
nRoomNum=get(handles.tRoomNum,'String');
sRoomNum=fPut0(nRoomNum,3);
% Se for selecionada a cor do plano, abre seleção de cor
nCol=eventdata.Indices(2);
nRow=eventdata.Indices(1);

if nCol==4 %Atualiza Transparência
    
    sFileVis=[sInputDir '\bVis' sRoomNum '.tlx'];
    load(sFileVis,'-mat','cVis'); % Carrega Arquivo de visualização existente
    if exist('cVis','var')==0
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        sMens=[ErrorDlg.cVisNotFoundIn ' '  sFile ' (E0157)'];	
        errordlg(sMens);
        return
    end
    if isempty(cVis)
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        sMens=[ErrorDlg.cVisIsEmptyFile ' '  sFile ' ' ErrorDlg.MightBeCorrupted ' (E0158)'];	
        errordlg(sMens);
        return
    end     
    
    cVis(nRow,5)=aData(nRow,nCol); 
    save(sFileVis,'-mat','cVis')
       
    fUpdatePlanePreview(handles,nRow,true,false);
end

% --- Executes on button press in tVisColorBatch.
function tVisColorBatch_Callback(hObject, eventdata, handles)
% hObject    handle to tVisColorBatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nRGB=uisetcolor;
set(handles.tVisColorBatch,'BackgroundColor',nRGB)

% --- Executes on button press in tVisRunBatch.
function tVisRunBatch_Callback(hObject, eventdata, handles)
% hObject    handle to tVisRunBatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 2017.09.13 v.8.0 - Pedro 

global sInputDir spcodeDir

%traz dados da tabela
aDataVis=get(handles.tTableVis,'Data');
[nVisShow,~]=size(aDataVis);
aCellEmpty=sum(sum(cellfun(@isempty,aDataVis)));

%Importa dados do projeto
nRoomNum=str2double(get(handles.tRoomNum,'String'));
sRoomNum=fPut0(nRoomNum,3);

if aCellEmpty==0
    %Importa e verifica número do plano para gerar a face oposta
    nPlVisNum=get(handles.tVisRunBatch,'UserData');
    if ~isempty(nPlVisNum)
        [nOp1,~]=size(nPlVisNum);
        nPlVisNum1=nPlVisNum(1,1);
        nPlVisNum2=nPlVisNum(nOp1,1);

        %Verifica se os valores são sequenciais
        if nPlVisNum2-nPlVisNum1~=nOp1-1
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            errordlg(ErrorDlg.PlanesNeedToBeSequential);
            return
        end

        % Carrega informações da visualização
        sFileVis=[sInputDir '\bVis' sRoomNum '.tlx'];
        load(sFileVis,'-mat','cVis'); % Carrega Arquivo de visualização existente

        if exist('cVis','var')==0
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            sMens=[ErrorDlg.cVisNotFoundIn ' '  sFile ' (E0157)'];	
            errordlg(sMens);return
        end
        if isempty(cVis)
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
            sMens=[ErrorDlg.cVisIsEmptyFile ' '  sFile ' ' ErrorDlg.MightBeCorrupted ' (E0158)'];	
            errordlg(sMens);
            return
        end 

        for k=1:nVisShow %Loop nos planos exibidos, salvando dados 

            %Se for os selecionados, muda, se não mantém o original
            nPlanes=nPlVisNum1:nPlVisNum2;
            nColor=get(handles.tVisColorBatch,'BackgroundColor');
            nTrans=str2double(get(handles.tVisTransBatch,'String'));
            if ismember(k,nPlanes)

                %Salva os dados em cPlane
                cVis{k,2}=nColor(1);  % Cor R
                cVis{k,3}=nColor(2);  % Cor R
                cVis{k,4}=nColor(3);  % Cor G
                cVis{k,5}=nTrans;  % Transparência
            end
        end

        % Salva cVis
        save(sFileVis,'-mat','cVis')
        
        nPlanes=nPlVisNum(1,1):nPlVisNum(end,1);
        
        % Atualiza dados na tabela
        fUpdateData(handles,nPlanes,false)
        
        % Visualiza
        fUpdatePlanePreview(handles,nPlanes,true,false);

        load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Abre Arquivo de Idioma
        msgbox(MsgBox.SavedData,MsgBox.Saved)
    end
end

function tVisGoTo_Callback(hObject, eventdata, handles)
% hObject    handle to tVisGoTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tVisGoTo as text
%        str2double(get(hObject,'String')) returns contents of tVisGoTo as a double

%Desce a visualização para a linha criada (Java e nova função:findjobj)
jScrollpane=findjobj(handles.tTableVis);
scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
nData=size(get(handles.tTablePlanes,'Data'),1);
nGoToVis=str2double(get(handles.tVisGoTo,'String'));
nPos=(scrollMax/nData)*(nGoToVis-1);
jScrollpane.getVerticalScrollBar.setValue(floor(nPos));   % Coloca o Scroll na posição 

% --- Executes on button press in ttVisDestacColor.
function ttVisDestacColor_Callback(hObject, eventdata, handles)
% hObject    handle to ttVisDestacColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ttVisDestacColor

nDest=get(handles.ttVisDestacColor,'Value');
if nDest==1
    set(handles.tVisDestacColor,'Visible','on');
else
    set(handles.tVisDestacColor,'Visible','off');
end


%~~~~~~~~~~~~~~~~ FUNÇÕES DA TAB DE JANELAS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% --- Executes on button press in tNewWin.
function tNewWin_Callback(hObject, eventdata, handles)
% hObject    handle to tNewWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sInputDir spcodeDir

nRoomNum=str2double(get(handles.tRoomNum,'string'));
if isnan(nRoomNum)
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([ErrorDlg.PleaseInputRoomNumber ' (E0095)']);
    return
end

% Torna tabela editavel
set(handles.tTableWin,'ColumnEditable',logical([0 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1]));

sRoomNum=fPut0(nRoomNum,3);

%Vefirica bWindow
sFileWin=[sInputDir '\bWindow' sRoomNum '.tlx'];
if exist(sFileWin,'file')
    load(sFileWin,'-mat','cWindow'); % % load file
    if ~exist('cWindow','var')
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cWindowNotFoundIn ' ' sFileWin ' (E0080)']);
        return
    end
    if isempty(cWindow)
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cWindowIsEmptyFile ' '  sFileWin ' ' ErrorDlg.MightBeCorrupted ' (E0112)']);
        return
    end
end

%Verifica bPlane
sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx'];
if exist(sFilePl,'file')
    load(sFilePl,'-mat','cPlane');
    if ~exist('cPlane','var')
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cPlaneNotFoundIn ' ' sFilePl ' (E0077)'],ErrorDlg.FileError);
        return
    end
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([ErrorDlg.Error ' ' sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);
    return
end


if exist('cWindow','var')
    nTWin=size(cWindow,1);
    aDataWin=get(handles.tTableWin,'Data');
    
    % Cria e insere nova linha vazia
    aNewDataWin={(nTWin+1),1,5,'',[],[],[],[],[],[],[],[],[],[],[],[]}; % Add one empty line to the uitable
    aDataWin=[aDataWin;aNewDataWin];
    
    %Exibe a tabela com a nova linha vazia
    set(handles.tTableWin,'Data',aDataWin)
    
    %Desce a visualização para a linha criada (Java e nova função:findjobj)
    jScrollpane=findjobj(handles.tTableWin);
    scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
    jScrollpane.getVerticalScrollBar.setValue(scrollMax);   % Coloca o Scroll na posição Máxima
else
   aDataWin=get(handles.tTableWin,'Data');
    
    % Cria e insere nova linha vazia
    aNewDataWin={(1),1,5,'',[],[],[],[],[],[],[],[],[],[],[],[]}; % Add one empty line to the uitable
    aDataWin=[aDataWin;aNewDataWin];
    
    %Exibe a tabela com a nova linha vazia
    set(handles.tTableWin,'Data',aDataWin)
end

% Habilita botões 
set(handles.tSaveNewWin,'enable','on')
set(handles.tCancelNewWin,'enable','on')

% Desabilita botões 
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanElementButton,'Enable','off');
set(handles.tPanShadingButton,'Enable','off');
set(handles.tGoToWin,'Enable','off');
set(handles.tNewWin,'Enable','off');
set(handles.tDeleteWin,'Enable','off');

% --- Executes on button press in tDeleteWin.
function tDeleteWin_Callback(hObject, eventdata, handles)
% hObject    handle to tDeleteWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir sInputDir

nRoomNum=str2double(get(handles.tRoomNum,'String'));
if isnan(nRoomNum)
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([ErrorDlg.PleaseInputRoomNumber ' (E0095)']);
    return
end

sRoomNum=fPut0(nRoomNum,3);
sFileWin=[sInputDir '\bWindow' sRoomNum '.tlx'];
load(sFileWin,'-mat','cWindow');
% nTWin=size(cWindow,1);

nDeleteNum=get(handles.tDeletePlane,'UserData');

if(mod(nDeleteNum(1),2)==0) %verifica se o numero e par
    nPos = nDeleteNum(1) - 1; %posiçao da janela para ser deletada
else
    nPos = nDeleteNum(1);
end

load([spcodeDir '\bLangDef.tlx'],'-mat','AskDlg');  %Load Language File
sSN=questdlg([AskDlg.DeleteWindow ' ' num2str(nPos) '-' num2str(nPos+1) ' ?'],AskDlg.ConfirmDelete,AskDlg.Yes,AskDlg.No,AskDlg.No);
if strcmp(sSN,AskDlg.Yes) %if strcmp(sSN,'Yes')
    aDel = cWindow{nPos,9};  %posiçoes no arquivo de plano para serem deletadas
    sFilePl =[sInputDir '\bPlane' sRoomNum '.tlx'];
    if exist(sFilePl,'file')
        load(sFilePl,'-mat','cPlane') %% get aPlane
        if exist('cPlane','var')
            cPlane(aDel,:)=[];
            nTam = size(cPlane,1);
            if(aDel(1)<=nTam) %Corrige Coluna dos Numeros
                for k=aDel(1):nTam
                    cPlane{k,1}=cPlane{k,1}-4;
                    if cPlane{k,2}<0
                        cPlane{k,2}=cPlane{k,2}+4;
                    end
                end
            end
        end
    end
    
    sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];
    if exist(sFileMat,'file')
        load(sFileMat,'-mat','cMat')
        if exist('cMat','var')
            cMat(aDel,:)=[];
            nTam = size(cMat,1);
            if(aDel(1)<=nTam)
                for k=aDel(1):nTam
                    cMat{k,1}=cMat{k,1}-4;
                end
            end
%             nNMat=size(cMat,1);
        end
    end
    
    cWindow([nPos nPos+1],:)=[]; %deleta planos impar+par
    
    nTam = size(cWindow,1);
    if (nPos<=nTam)
        for k=nPos:nTam
            if(mod(k,2)==1)
                cWindow{k,9}=cWindow{k,9}-4;
            end
            cWindow{k,1}=cWindow{k,1}-2;
        end
    end
    if isempty(cWindow)
        delete(sFileWin)
    else
        save(sFileWin,'-mat','cWindow')
    end
    save(sFilePl,'-mat','cPlane')
    save(sFileMat,'-mat','cMat')
end

fOpenProject(hObject,eventdata,handles,true) % Abre o Arquivo para visualizar

% --- Executes on button press in tSaveNewWin.
function tSaveNewWin_Callback(hObject, eventdata, handles)
% hObject    handle to tSaveNewWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir sInputDir nPlan %Variavel que diz a primeira posicao da janela no arquivo de planos - brpm
%Não tirei do global a variável nPlan pois não sei exatamente onde é salva - Orestes

% Verifica se 
nRoomNum=str2double(get(handles.tRoomNum,'String'));

% Importa dos valores da tabela da tela
aDataWin=get(handles.tTableWin,'Data'); 
[nWinNum, ~]=size(aDataWin);

sRoomNum=fPut0(nRoomNum,3);

% Carrega bWindow
sFileWin=[sInputDir '\bWindow' sRoomNum '.tlx'];
if exist(sFileWin,'file')
    load(sFileWin,'-mat','cWindow'); % % load file
    if ~exist('cWindow','var')
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cWindowNotFoundIn ' ' sFileWin ' (E0080)']);
        return
    end
    if isempty(cWindow)
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cWindowIsEmptyFile ' '  sFileWin ' ' ErrorDlg.MightBeCorrupted ' (E0112)']);
        return
    end
else
    cWindow=[];
end

% Define as características da janela
if isempty(cWindow)
   nTWin = 0;
else
    nTWin=size(cWindow,1); %% number of planes filed
end
nNextPl=nTWin+1;
cLine{1}=num2str(aDataWin{nWinNum,1}); %Número
cLine{2}=num2str(aDataWin{nWinNum,3}); %Plano
cLine{3}='0'; % eval(['get(handles.tNext' sNextPl ',''string'')']);
cLine{4}=num2str(aDataWin{nWinNum,2}); %Tipo
cLine{5}=num2str(aDataWin{nWinNum,5}); %X1
cLine{6}=num2str(aDataWin{nWinNum,6}); %Y1
cLine{7}=num2str(aDataWin{nWinNum,7}); %Z1
cLine{8}=num2str(aDataWin{nWinNum,8}); %X2
cLine{9}=num2str(aDataWin{nWinNum,9}); %Y2
cLine{10}=num2str(aDataWin{nWinNum,10}); %Z2
cLine{11}=num2str(aDataWin{nWinNum,11}); %X3
cLine{12}=num2str(aDataWin{nWinNum,12}); %Y3
cLine{13}=num2str(aDataWin{nWinNum,13}); %Z3
cLine{14}=num2str(aDataWin{nWinNum,14}); %X4
cLine{15}=num2str(aDataWin{nWinNum,15}); %Y4
cLine{16}=num2str(aDataWin{nWinNum,16}); %Z4

% Verifica se a janela está voltada para o mesmo lado do plano
% Vetor diretor da janela
aV1Win=[aDataWin{nWinNum,8}-aDataWin{nWinNum,5} aDataWin{nWinNum,9}-aDataWin{nWinNum,6} aDataWin{nWinNum,10}-aDataWin{nWinNum,7}];
aV2Win=[aDataWin{nWinNum,11}-aDataWin{nWinNum,5} aDataWin{nWinNum,12}-aDataWin{nWinNum,6} aDataWin{nWinNum,13}-aDataWin{nWinNum,7}];
aVWin=cross(aV1Win,aV2Win)/norm(cross(aV1Win,aV2Win));

% Vetor Diretor do Plano que contém a janela
%Abre arquivos de plano
sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx'];
if exist(sFilePl,'file')==2
    load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
    return
end
nPla=aDataWin{nWinNum,3};
aV1Pl=[cPlane{nPla,4}(1)-cPlane{nPla,5}(1) cPlane{nPla,4}(2)-cPlane{nPla,5}(2) cPlane{nPla,4}(3)-cPlane{nPla,5}(3)];
aV2Pl=[cPlane{nPla,4}(1)-cPlane{nPla,6}(1) cPlane{nPla,4}(2)-cPlane{nPla,6}(2) cPlane{nPla,4}(3)-cPlane{nPla,6}(3)];
aVPla=cross(aV1Pl,aV2Pl)/norm(cross(aV1Pl,aV2Pl));

if sum(aVPla~=aVWin)>0 % Inverter!
    cLine{14}=num2str(aDataWin{nWinNum,8}); %X2
    cLine{15}=num2str(aDataWin{nWinNum,9}); %Y2
    cLine{16}=num2str(aDataWin{nWinNum,10}); %Z2
    cLine{8}=num2str(aDataWin{nWinNum,14}); %X4
    cLine{9}=num2str(aDataWin{nWinNum,15}); %Y4
    cLine{10}=num2str(aDataWin{nWinNum,16}); %Z4
end

for k=1:16
  cLine{k}=fChDecPoint(cLine{k}); %Checa se tem vírgula e troca pra ponto
  if isempty(str2double(cLine{k}))
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([ErrorDlg.Error '! ' cLine{k} ' ' ErrorDlg.IsNotValidInThisField ' (E0099)'])
    return
  end
end


load([spcodeDir '\bLangDef.tlx'],'-mat','AskDlg');  %Load Language File
sSN=questdlg([AskDlg.InputWindow ' ' num2str(nNextPl) '-' num2str(nNextPl+1) ' ?'],AskDlg.ConfirmInput,AskDlg.Yes,AskDlg.No,AskDlg.Yes);
if strcmp(sSN,AskDlg.Yes)
   cWindow{nNextPl,1}=str2double(cLine{1});
   cWindow{nNextPl,2}=str2double(cLine{2});
   cWindow{nNextPl,3}=str2double(cLine{3});
   cWindow{nNextPl,4}=str2double(cLine{4});
   cWindow{nNextPl,5}(1)=str2double(cLine{5});
   cWindow{nNextPl,5}(2)=str2double(cLine{6});	
   cWindow{nNextPl,5}(3)=str2double(cLine{7});
   cWindow{nNextPl,6}(1)=str2double(cLine{8});
   cWindow{nNextPl,6}(2)=str2double(cLine{9});	
   cWindow{nNextPl,6}(3)=str2double(cLine{10});
   cWindow{nNextPl,7}(1)=str2double(cLine{11});
   cWindow{nNextPl,7}(2)=str2double(cLine{12});	
   cWindow{nNextPl,7}(3)=str2double(cLine{13});
   cWindow{nNextPl,8}(1)=str2double(cLine{14});
   cWindow{nNextPl,8}(2)=str2double(cLine{15});	
   cWindow{nNextPl,8}(3)=str2double(cLine{16});
   
   %Final actions !!!!!!
   
   cWindow=fNewWindow(cWindow); %Generates the outside window
   cWindow=fUpdateWindow(cWindow,nRoomNum); %% update window's array
   fFrameWindow(cWindow,sRoomNum); % create frame window planes
   
   cWindow{nNextPl,9}=nPlan:nPlan+3; % %salva a posição da janela no arquivo de planos
   
   save(sFileWin,'-mat','cWindow');
   %Fills the next line
   
   fOpenProject(hObject,eventdata,handles,true) % Abre o Arquivo para visualizar
   
end

% Atualiza bRoom %%%%%%%%%%%
sFileRoom=[sInputDir '\bRoom' sRoomNum '.tlx'];
if exist(sFileRoom,'file')==0
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg(['\bRoom' sRoomNum '.tlx' ' ' ErrorDlg.NotFound ' (E0072)'])
    return
else
    load(sFileRoom,'-mat','cRot','cRoom');
end

%Abre arquivos de plano
sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx'];
if exist(sFilePl,'file')==2
    load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
    return
end

% converts cPlane->aPlane
for nNextPl=nPlan:nPlan+3
    for jPl=4:7 % points
        for kPl=1:3 % (1=x,2=y,3=z)
            aPtPl(nNextPl,jPl-3,kPl)=cPlane{nNextPl,jPl}(kPl);
        end
    end
    % direct cosines/ test point on a plane:
    [aDirTmp, lOk]=fDirCos(aPtPl(nNextPl,:,1),aPtPl(nNextPl,:,2),aPtPl(nNextPl,:,3),nNextPl);   % rcc 3.17
    if ~lOk
        return
    end
    cRotTmp=fStartRot(aDirTmp);  % rotation matrices
    cRot=[cRot; cRotTmp];  % rotation matrices Accum 
end

save(sFileRoom,'-mat','cRoom','cRot') 

% Realiza a verificação dos arquivos gerados
fRoomSetUp(str2double(sRoomNum));

%Habilita botões
set(handles.tSaveNewWin,'enable','off')
set(handles.tNewWin,'enable','on')
set(handles.tDeleteWin,'enable','on')
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');
set(handles.tPanShadingButton,'Enable','on');
set(handles.tGoToWin,'Enable','on');
set(handles.tNewWin,'Enable','on');
set(handles.tDeleteWin,'Enable','on');

% Torna tabela não editavel
set(handles.tTableWin,'ColumnEditable',logical([0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]));

% --- Executes when entered data in editable cell(s) in tTableWin.
function tTableWin_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tTableWin (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% --- Executes when selected cell(s) is changed in tTableWin.
function tTableWin_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tTableWin (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

global sInputDir

try
    aData=get(handles.tTableWin,'Data');
    aCellEmpty=sum(sum(cellfun(@isempty,aData)));

    %Verifica se a função de criar nova janela está ativada
    nNewWin=get(handles.tSaveNewWin,'Enable');
    if strcmp(nNewWin,'on')==0
        if aCellEmpty==0
            nRows=eventdata.Indices(1,1);
            nLineOld=get(handles.tDeleteWin,'UserData'); %Janela Anterior
            set(handles.tDeleteWin,'UserData',eventdata.Indices);

            % Verificaçao de campos vazios
            nFieldsEmpty=sum(sum(cellfun(@isempty,aData(:,:))));
            nFieldsNan1=sum(sum(isnan(cellfun(@str2num,aData(:,5:end)))));
            nFieldsNan2=sum(sum(cellfun(@isnan,aData(:,1:3))));

            if nFieldsEmpty==0 && nFieldsNan1==0 && nFieldsNan2==0
                % Planos da caixa da janela
                nRoomNum=str2double(get(handles.tRoomNum,'String'));
                sRoomNum=fPut0(nRoomNum,3);
                sFileWin=[sInputDir '\bWindow' sRoomNum '.tlx'];
                load(sFileWin,'-mat','cWindow');
                % Verifica se mudou de linha
                if isempty(nLineOld) % Primeira vez que a guide foi aberta
                    if mod(nRows,2)==1 %ímpar
                        nWinNew=nRows;
                    else %par
                        nWinNew=nRows-1;
                    end
                    aPlanesWin=cWindow{nWinNew,9}; 
                    fUpdatePlanePreview(handles,aPlanesWin,false,false); % Preview PEDRO 2016
                else
                    if mod(nRows,2)==1 %ímpar
                        nWinNew=nRows;
                    else %par
                        nWinNew=nRows-1;
                    end
                    aPlanesWinNew=cWindow{nWinNew,9};
                    if mod(nLineOld(1),2)==1 %ímpar
                        nWinOld=nLineOld(1);
                    else %par
                        nWinOld=nLineOld(1)-1;
                    end
                    aPlanesWinOld=cWindow{nWinOld,9}; %posiçoes no arquivo de plano 
                    fUpdatePlanePreview(handles,aPlanesWinOld,true,false); % Preview PEDRO 2016
                    fUpdatePlanePreview(handles,aPlanesWinNew,false,false); % Preview PEDRO 2016
                end     
            end
            set(handles.tDeletePlane,'Enable','on');
            set(handles.tCreateFace,'Enable','on');
        end
    end
catch
    % Nada a fazer
end

try
    if aCellEmpty==0
        set(handles.tDeletePlane,'UserData',eventdata.Indices);    
    end
catch
    % Nada a fazer
end


function tGoToWin_Callback(hObject, eventdata, handles)
% hObject    handle to tGoToWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tGoToWin as text
%        str2double(get(hObject,'String')) returns contents of tGoToWin as a double

%Desce a visualização para a linha criada (Java e nova função:findjobj)
jScrollpane=findjobj(handles.tTableWin);
scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
nDataWin=size(get(handles.tTableWin,'Data'),1);
nGoTo=str2double(get(handles.tGoToWin,'String'));
nPos=(scrollMax/nDataWin)*(nGoTo-1);
jScrollpane.getVerticalScrollBar.setValue(floor(nPos));   % Coloca o Scroll na posição


% --- Executes on button press in tCancelNewWin.
function tCancelNewWin_Callback(hObject, eventdata, handles)
% hObject    handle to tCancelNewWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aDataWin=get(handles.tTableWin,'Data');
aDataWin=aDataWin(1:end-1,:);
set(handles.tTableWin,'Data',aDataWin);

fUpdatePlanePreview(handles,[],true,false); % Preview

% Desabilita botões 
set(handles.tSaveNewWin,'Enable','off');
set(handles.tCancelNewWin,'Enable','off');

% Habilita botões 
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');
set(handles.tPanShadingButton,'Enable','on');
set(handles.tGoToWin,'Enable','on');
set(handles.tNewWin,'Enable','on');
set(handles.tDeleteWin,'Enable','on');


%~~~~~~~~~~~~~~~~ FUNÇÕES DA TAB DE MATERIAIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% --- Executes when entered data in editable cell(s) in tTableMat.
function tTableMat_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tTableMat (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir sInputDir

aDataMat=get(handles.tTableMat,'Data');
[nTMat,~]=size(aDataMat);

% Verifica trava de transmitancia
if eventdata.Indices(2)==6 || eventdata.Indices(2)==7
        load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Load Language File
    uiwait(msgbox(MsgBox.NotPossibleChangeTransmittance));
    aDataMat{eventdata.Indices(1),eventdata.Indices(2)}=eventdata.PreviousData;   
    %Exibe dados dos materiais
    set(handles.tTableMat,'Data',aDataMat);
    return
end

nRoomNum= str2double(get(handles.tRoomNum,'String'));
if isnumeric(nRoomNum)
  sRoomNum=fPut0(nRoomNum,3);
  sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
	errordlg([ErrorDlg.PleaseInputRoomNumber ' (E0095)']);	
    return
end

for k=1:nTMat
   cLine{1}=aDataMat{k,1};
   cLine{2}=str2double(aDataMat{k,4});
   cLine{3}=str2double(aDataMat{k,5});
   cLine{4}=str2double(aDataMat{k,6});
   cLine{5}=str2double(aDataMat{k,7});
   
   %test if new numeric fields were filled with comma instead of point
   % and change it
   for m=1:5
       cLine{m}=fChDecPoint(cLine{m});
       if isempty(cLine{m})
           load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
           errordlg([ErrorDlg.Error ', ' cLine{m} ' ' ErrorDlg.IsNotValidInThisField ' (E0099)' m])
           return
       end
       cMat{k,m}=cLine{m};
   end
   
   % test for data consistence (RD+RS+TD+TS)<1
   if (cMat{k,2}+cMat{k,3}+cMat{k,4}+cMat{k,5})>1 % v3.07 allow ==1
       load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
       errordlg([ErrorDlg.ErrorInMaterialCharacteristicsForPlane ' ' num2str(k) ' (E0100)'])
       return
   end  
end

save(sFileMat,'-mat','cMat')

% save ground parameter (reflectance) % v3.0
sFileGrd=[sInputDir '\bGrdParam.tlx'];
if exist(sFileGrd,'file')
	load(sFileGrd,'-mat','cGrdParam','nGrdType','aGrdRef','nGrdDiv','nGrdLen','nGrdAng')
else
	nGrdType=2;	nGrdDiv=6; nGrdLen=5; nGrdAng=15;
end
aGrdRef=cMat{13,2};  % only diffuse
cGrdParam={aGrdRef,nGrdAng}; 
% save Room Geometry in binary file bGrdParam
save(sFileGrd,'-mat','cGrdParam','nGrdType','aGrdRef','nGrdDiv','nGrdLen','nGrdAng')

tTableMat_CellSelectionCallback(hObject, eventdata, handles)

% Callback Go To
function ttMaterialGoTo_Callback(hObject, eventdata, handles)
% hObject    handle to ttMaterialGoTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Desce a visualização para a linha criada (Java e nova função:findjobj)
jScrollpane=findjobj(handles.tTableMat);
scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
nData=size(get(handles.tTableMat,'Data'),1);
nGoTo=str2double(get(handles.ttMaterialGoTo,'String'));
nPos=(scrollMax/nData)*(nGoTo-1);
jScrollpane.getVerticalScrollBar.setValue(floor(nPos));   % Coloca o Scroll na posição

%Limpa Campo
set(handles.ttMaterialGoTo,'String','');


% --- Executes on button press in tMaterialRunCharacteristics.
function tMaterialRunCharacteristics_Callback(hObject, eventdata, handles)
% hObject    handle to tMaterialRunCharacteristics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global sInputDir

nRoomNum=str2double(get(handles.tRoomNum,'String'));
sRoomNum=fPut0(nRoomNum,3);
sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];
load(sFileMat,'-mat','cMat')

% Importa Célula selecionada
nPlaneList=get(handles.tReflTable,'UserData');

for nP=1:size(nPlaneList,1)
    nPlane=nPlaneList(nP,1);
    %Importa valor da Difusa e da Especular
    nTransSpec=str2double(get(handles.tMaterialTransSpecValue,'String'));
    nReflSpec=str2double(get(handles.tMaterialReflSpecValue,'String'));
    nReflDif=str2double(get(handles.tMaterialReflDifValue,'String'));
    nTransDif=str2double(get(handles.tMaterialTransDifValue,'String'));

    cMat{nPlane(1),2}=nReflDif; %Refletância Difusa
    cMat{nPlane(1),3}=nReflSpec; %Refletância especular
    cMat{nPlane(1),4}=nTransDif; %Transmitancia Difusa
    cMat{nPlane(1),5}=nTransSpec; %Transmitância Especular


    % save new cMat
    save(sFileMat,'-mat','cMat');

    %Set nas informações 
    aDataMat=get(handles.tTableMat,'Data');
    nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
    aDataMat{nPlane(1),4}=eval(['sprintf(''%2.' nDec 'f'', cMat{nPlane(1),2})']); %Refletância Difusa
    aDataMat{nPlane(1),5}=eval(['sprintf(''%2.' nDec 'f'', cMat{nPlane(1),3})']); %Refletância Difusa;
    aDataMat{nPlane(1),6}=eval(['sprintf(''%2.' nDec 'f'', cMat{nPlane(1),4})']); %Transmitância Difusa
    aDataMat{nPlane(1),7}=eval(['sprintf(''%2.' nDec 'f'', cMat{nPlane(1),5})']); %Transmitância Especular
    
    %Exibe dados dos materiais
    set(handles.tTableMat,'Data',aDataMat)

    % save ground parameter (reflectance) % v3.0
    sFileGrd=[sInputDir '\bGrdParam.tlx'];
    if exist(sFileGrd,'file')
        load(sFileGrd,'-mat','cGrdParam','nGrdType','aGrdRef','nGrdDiv','nGrdLen','nGrdAng')
    else
        nGrdType=2; 
        nGrdDiv=6; 
        nGrdLen=5; 
        nGrdAng=15;
    end
    aGrdRef=cMat{13,2};  % only diffuse
    cGrdParam={aGrdRef,nGrdAng}; 
    % save Room Geometry in binary file bGrdParam
    save(sFileGrd,'-mat','cGrdParam','nGrdType','aGrdRef','nGrdDiv','nGrdLen','nGrdAng')
end

%Limpa Projeto
try
    nLineOld=get(handles.tDeletePlane,'UserData');
    fUpdatePlanePreview(handles,nLineOld(1),true,false); % Preview 
catch
end


% --- Executes on slider movement.
function tMaterialTransReflSlider_Callback(hObject, eventdata, handles)
% hObject    handle to tMaterialTransReflSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Valor do Slider
nSliderValue=get(handles.tMaterialTransReflSlider,'Value');

% Importa Valores
nTransValue=str2double(get(handles.tMaterialTransValue,'String'));
nReflValue=str2double(get(handles.tMaterialReflValue,'String'));
nTotTransRefl=nTransValue+nReflValue;

%Set nos valores
set(handles.tMaterialTransValue,'String',num2str((1-nSliderValue)*nTotTransRefl,2));
set(handles.tMaterialReflValue,'String',num2str(nSliderValue*nTotTransRefl,2));

%Trava em caso de apenas refletância ou apenas Transmitância
if nSliderValue==0 % Só transmitância
    set(handles.tMaterialReflDifValue,'Enable','off');
    set(handles.tMaterialReflSlider,'Enable','off');
    set(handles.tMaterialReflSpecValue,'Enable','off');
    set(handles.tMaterialTransDifValue,'Enable','on');
    set(handles.tMaterialTransSlider,'Enable','on');
    set(handles.tMaterialTransSpecValue,'Enable','on');
elseif nSliderValue==1 % Só Refletância
    set(handles.tMaterialTransDifValue,'Enable','off');
    set(handles.tMaterialTransSlider,'Enable','off');
    set(handles.tMaterialTransSpecValue,'Enable','off');
    set(handles.tMaterialReflDifValue,'Enable','on');
    set(handles.tMaterialReflSlider,'Enable','on');
    set(handles.tMaterialReflSpecValue,'Enable','on');
else %Ambos, habilita tudo
    set(handles.tMaterialTransDifValue,'Enable','on');
    set(handles.tMaterialTransSlider,'Enable','on');
    set(handles.tMaterialTransSpecValue,'Enable','on');
    set(handles.tMaterialReflDifValue,'Enable','on');
    set(handles.tMaterialReflSlider,'Enable','on');
    set(handles.tMaterialReflSpecValue,'Enable','on');
end

%Corrige os Slides de transmitância e Refletância
tMaterialTransSlider_Callback(hObject, eventdata, handles);
tMaterialReflSlider_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function tMaterialTransReflSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tMaterialTransReflSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function tMaterialTransValue_Callback(hObject, eventdata, handles)
% hObject    handle to tMaterialTransValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tMaterialTransValue as text
%        str2double(get(hObject,'String')) returns contents of tMaterialTransValue as a double

% Importa Valores
nTransValue=str2double(get(handles.tMaterialTransValue,'String'));
nReflValue=str2double(get(handles.tMaterialReflValue,'String'));
nTotReflTrans=nTransValue+nReflValue;

% Verifica se o valor é maior que um ou menor que zero
if nTransValue>1
    nTransValue=1;
    nReflValue=0;
elseif nTransValue<0 
    nTransValue=0;
    nReflValue=1;
elseif nTransValue+nReflValue>1
    nTransValue=1-nReflValue;
end

%Set nos valores
set(handles.tMaterialTransValue,'String',num2str(nTransValue,2));
set(handles.tMaterialReflValue,'String',num2str(nReflValue,2));
set(handles.tMaterialTransReflSlider,'Value',nReflValue/(nReflValue+nTransValue),'SliderStep',[1/(nTotReflTrans*100) 10/(nTotReflTrans*100)]);

%Trava em caso de apenas refletância ou apenas Transmitância
if nReflValue==0 % Só transmitância
    set(handles.tMaterialReflDifValue,'Enable','off');
    set(handles.tMaterialReflSlider,'Enable','off');
    set(handles.tMaterialReflSpecValue,'Enable','off');
    set(handles.tMaterialTransDifValue,'Enable','on');
    set(handles.tMaterialTransSlider,'Enable','on');
    set(handles.tMaterialTransSpecValue,'Enable','on');
elseif nTransValue==0 % Só Refletância
    set(handles.tMaterialTransDifValue,'Enable','off');
    set(handles.tMaterialTransSlider,'Enable','off');
    set(handles.tMaterialTransSpecValue,'Enable','off');
    set(handles.tMaterialReflDifValue,'Enable','on');
    set(handles.tMaterialReflSlider,'Enable','on');
    set(handles.tMaterialReflSpecValue,'Enable','on');
else %Ambos, habilita tudo
    set(handles.tMaterialTransDifValue,'Enable','on');
    set(handles.tMaterialTransSlider,'Enable','on');
    set(handles.tMaterialTransSpecValue,'Enable','on');
    set(handles.tMaterialReflDifValue,'Enable','on');
    set(handles.tMaterialReflSlider,'Enable','on');
    set(handles.tMaterialReflSpecValue,'Enable','on');
end

%Corrige os Slides de transmitância e Refletância
tMaterialTransSlider_Callback(hObject, eventdata, handles);
tMaterialReflSlider_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function tMaterialTransValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tMaterialTransValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tMaterialReflValue_Callback(hObject, eventdata, handles)
% hObject    handle to tMaterialReflValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tMaterialReflValue as text
%        str2double(get(hObject,'String')) returns contents of tMaterialReflValue as a double

% Importa Valores
nTransValue=str2double(get(handles.tMaterialTransValue,'String'));
nReflValue=str2double(get(handles.tMaterialReflValue,'String'));
nTotReflTrans=nTransValue+nReflValue;

% Verifica se o valor é maior que um ou menor que zero
if nReflValue>1
    nTransValue=0;
    nReflValue=1;
elseif nReflValue<0
    nTransValue=1;
    nReflValue=0;
elseif nTransValue+nReflValue>1
    nTransValue=1-nReflValue;
end

%Set nos valores
set(handles.tMaterialTransValue,'String',num2str(nTransValue,2));
set(handles.tMaterialReflValue,'String',num2str(nReflValue,2));
set(handles.tMaterialTransReflSlider,'Value',nReflValue/(nReflValue+nTransValue),'SliderStep',[1/(nTotReflTrans*100) 10/(nTotReflTrans*100)]);

%Trava em caso de apenas refletância ou apenas Transmitância
if nTransValue==0 % Só Refletância
    set(handles.tMaterialTransDifValue,'Enable','off');
    set(handles.tMaterialTransSlider,'Enable','off');
    set(handles.tMaterialTransSpecValue,'Enable','off');
    set(handles.tMaterialReflDifValue,'Enable','on');
    set(handles.tMaterialReflSlider,'Enable','on');
    set(handles.tMaterialReflSpecValue,'Enable','on');
elseif nReflValue==0 % Só Transmitância
    set(handles.tMaterialTransDifValue,'Enable','on');
    set(handles.tMaterialTransSlider,'Enable','on');
    set(handles.tMaterialTransSpecValue,'Enable','on');
    set(handles.tMaterialReflDifValue,'Enable','off');
    set(handles.tMaterialReflSlider,'Enable','off');
    set(handles.tMaterialReflSpecValue,'Enable','off');
else %Ambos, habilita tudo
    set(handles.tMaterialTransDifValue,'Enable','on');
    set(handles.tMaterialTransSlider,'Enable','on');
    set(handles.tMaterialTransSpecValue,'Enable','on');
    set(handles.tMaterialReflDifValue,'Enable','on');
    set(handles.tMaterialReflSlider,'Enable','on');
    set(handles.tMaterialReflSpecValue,'Enable','on');
end

%Corrige os Slides de transmitância e Refletância
tMaterialTransSlider_Callback(hObject, eventdata, handles);
tMaterialReflSlider_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function tMaterialReflValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tMaterialReflValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function tMaterialTransSlider_Callback(hObject, eventdata, handles)
% hObject    handle to tMaterialTransSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Importa valor de transmitância
nTrans=str2double(get(handles.tMaterialTransValue,'String'));

%Importa Posiçao do Slider
nSliderPos=get(handles.tMaterialTransSlider,'Value');

% Set nos valores
set(handles.tMaterialTransDifValue,'String',num2str(nTrans*(nSliderPos),2));
set(handles.tMaterialTransSpecValue,'String',num2str(nTrans*(1-nSliderPos),2));

% --- Executes during object creation, after setting all properties.
function tMaterialTransSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tMaterialTransSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function tMaterialTransDifValue_Callback(hObject, eventdata, handles)
% hObject    handle to tMaterialTransDifValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tMaterialTransDifValue as text
%        str2double(get(hObject,'String')) returns contents of tMaterialTransDifValue as a double

%Importa valor da Difusa e da Especular
nTrans=str2double(get(handles.tMaterialTransValue,'String'));
nRefl=str2double(get(handles.tMaterialReflValue,'String'));
nTransDif=str2double(get(handles.tMaterialTransDifValue,'String'));
nTransSpec=str2double(get(handles.tMaterialTransSpecValue,'String'));

% Verifica se não ultrapassa o valor total
if nTransDif+nTransSpec+nRefl>1
    nTransDif=nTrans;
    nTransSpec=0;
end

% Calcula a Transmitância total
nTrans=nTransDif+nTransSpec;

if nTrans>0
    % Set no Slider
    set(handles.tMaterialTransSlider,'Value',nTransDif/nTrans,'SliderStep',[1/(nTrans*100) 10/(nTrans*100)])
    %Set nos valores
    set(handles.tMaterialTransDifValue,'String',num2str(nTransDif,2));
    set(handles.tMaterialTransSpecValue,'String',num2str(nTransSpec,2));
    set(handles.tMaterialTransValue,'String',num2str(nTrans));
end

% Corrige Slider Total
tMaterialTransValue_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tMaterialTransDifValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tMaterialTransDifValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tMaterialReflDifValue_Callback(hObject, eventdata, handles)
% hObject    handle to tMaterialReflDifValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tMaterialReflDifValue as text
%        str2double(get(hObject,'String')) returns contents of tMaterialReflDifValue as a double

%Importa valor da Difusa e da Especular
nTrans=str2double(get(handles.tMaterialTransValue,'String'));
nRefl=str2double(get(handles.tMaterialReflValue,'String'));
nReflDif=str2double(get(handles.tMaterialReflDifValue,'String'));
nReflSpec=str2double(get(handles.tMaterialReflSpecValue,'String'));

% Verifica se não ultrapassa o valor total
if nReflDif+nReflSpec+nTrans>1
    nReflDif=nRefl;
    nReflSpec=0;
end

% Calcula a Refletância total
nRefl=nReflDif+nReflSpec;

% Set no Slider
set(handles.tMaterialReflSlider,'Value',nReflDif/nRefl,'SliderStep',[1/(nRefl*100) 10/(nRefl*100)])
%Set nos valores
set(handles.tMaterialReflDifValue,'String',num2str(nReflDif,2));
set(handles.tMaterialReflSpecValue,'String',num2str(nReflSpec,2));
set(handles.tMaterialReflValue,'String',num2str(nRefl));

% Corrige Slider Total
tMaterialReflValue_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tMaterialReflDifValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tMaterialReflDifValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tMaterialTransSpecValue_Callback(hObject, eventdata, handles)
% hObject    handle to tMaterialTransSpecValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tMaterialTransSpecValue as text
%        str2double(get(hObject,'String')) returns contents of tMaterialTransSpecValue as a double

%Importa valor da Difusa e da Especular
nTrans=str2double(get(handles.tMaterialTransValue,'String'));
nRefl=str2double(get(handles.tMaterialReflValue,'String'));
nTransDif=str2double(get(handles.tMaterialTransDifValue,'String'));
nTransSpec=str2double(get(handles.tMaterialTransSpecValue,'String'));

% Verifica se o valor é maior que um ou menor que zero
if nTransDif+nTransSpec+nRefl>1
    nTransDif=0;
    nTransSpec=nTrans;
end

% Calcula a Transmitância total
nTrans=nTransDif+nTransSpec;

% Set no Slider
set(handles.tMaterialTransSlider,'Value',nTransDif/nTrans,'SliderStep',[1/(nTrans*100) 10/(nTrans*100)])
%Set nos valores
set(handles.tMaterialTransDifValue,'String',num2str(nTransDif,2));
set(handles.tMaterialTransSpecValue,'String',num2str(nTransSpec,2));
set(handles.tMaterialTransValue,'String',num2str(nTrans));

% Corrige Slider Total
tMaterialTransValue_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tMaterialTransSpecValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tMaterialTransSpecValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tMaterialReflSpecValue_Callback(hObject, eventdata, handles)
% hObject    handle to tMaterialReflSpecValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tMaterialReflSpecValue as text
%        str2double(get(hObject,'String')) returns contents of tMaterialReflSpecValue as a double

%Importa valor da Difusa e da Especular
nTrans=str2double(get(handles.tMaterialTransValue,'String'));
nRefl=str2double(get(handles.tMaterialReflValue,'String'));
nReflDif=str2double(get(handles.tMaterialReflDifValue,'String'));
nReflSpec=str2double(get(handles.tMaterialReflSpecValue,'String'));

% Verifica se não ultrapassa o valor total
if nReflDif+nReflSpec+nTrans>1
    nReflDif=0;
    nReflSpec=nRefl;
end

% Calcula a Refletância total
nRefl=nReflDif+nReflSpec;

% Set no Slider
set(handles.tMaterialReflSlider,'Value',nReflDif/nRefl,'SliderStep',[1/(nRefl*100) 10/(nRefl*100)])
%Set nos valores
set(handles.tMaterialReflDifValue,'String',num2str(nReflDif,2));
set(handles.tMaterialReflSpecValue,'String',num2str(nReflSpec,2));
set(handles.tMaterialReflValue,'String',num2str(nRefl));

% Corrige Slider Total
tMaterialReflValue_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tMaterialReflSpecValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tMaterialReflSpecValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function tMaterialReflSlider_Callback(hObject, eventdata, handles)
% hObject    handle to tMaterialReflSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Importa valor de refletancia
nRefl=str2double(get(handles.tMaterialReflValue,'String'));

%Importa Posiçao do Slider
nSliderPos=get(handles.tMaterialReflSlider,'Value');

% Set nos valores
set(handles.tMaterialReflDifValue,'String',num2str(nRefl*(nSliderPos),2));
set(handles.tMaterialReflSpecValue,'String',num2str(nRefl*(1-nSliderPos),2));

% --- Executes during object creation, after setting all properties.
function tMaterialReflSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tMaterialReflSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in tMaterialSave.
function tMaterialSave_Callback(hObject, eventdata, handles)
% hObject    handle to tMaterialSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes when selected cell(s) is changed in tTableMat.
function tTableMat_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tTableMat (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

% Traz dados da tabela
aData=get(handles.tTablePlanes,'Data');
aDataMat=get(handles.tTableMat,'Data');

try
    nLine=eventdata.Indices(1,1);
    nColumns=eventdata.Indices(1,2);
    nPosition=[nLine nColumns];
    nPosition=aData{nPosition(1),1};
    nLineOld=get(handles.tReflTable,'UserData');
    set(handles.tReflTable,'UserData',eventdata.Indices);

    %Verificaçao de campos vazios
    nFieldsEmpty=sum(sum(cellfun(@isempty,aData(:,:))));
    nFieldsNan1=sum(sum(isnan(cellfun(@str2num,aData(:,5:end)))));
    nFieldsNan2=sum(sum(cellfun(@isnan,aData(:,1:3))));

    if nFieldsEmpty==0 && nFieldsNan1==0 && nFieldsNan2==0
        if exist('nPosition','var')==0 || isempty(eventdata)==0
            nPosition=nPosition(1);
        end
        %Verifica se mudou de linha
        if isempty(nLineOld) % Primeira vez que a guide foi aberta
            fUpdatePlanePreview(handles,nPosition,false,false); % Preview PEDRO 2016
        else
            if nLineOld(1)~=eventdata.Indices(1,1) %Mudou de plano
                fUpdatePlanePreview(handles,nLineOld(1),true,false); % Preview PEDRO 2016
                fUpdatePlanePreview(handles,nPosition,false,false); % Preview PEDRO 2016
            else %Informações atualizadas
                fUpdatePlanePreview(handles,nPosition,false,false); % Preview PEDRO 2016
            end
        end     
    end
catch
    %Nada a fazer
end
% 
% try 
%     %Exporta dados
%     nReflDif=aDataMat{nLine,4};
%     nReflSpec=aDataMat{nLine,5};
%     nTransDif=aDataMat{nLine,6};
%     nTransSpec=aDataMat{nLine,7};
%     set(handles.tMaterialReflDifValue,'String',nReflDif);
%     set(handles.tMaterialReflSpecValue,'String',nReflSpec);
%     set(handles.tMaterialTransDifValue,'String',nTransDif);
%     set(handles.tMaterialTransSpecValue,'String',nTransSpec);
% 
%     % Set nos sliders
%     set(handles.tMaterialTransValue,'String',num2str(str2double(nTransDif)+str2double(nTransSpec)));
%     set(handles.tMaterialReflValue,'String',num2str(str2double(nReflDif)+str2double(nReflSpec)));
%     tMaterialTransValue_Callback(hObject, eventdata, handles)
%     tMaterialReflValue_Callback(hObject, eventdata, handles)
% catch
%         %Nada a fazer
% end


%~~~~~~~~~~~~~~~~ FUNÇÕES AUXILIARES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Restaura Campos de projeto novo alterados  
function fClearFieldsNewRecPrj(handles)
set(handles.tDimXRec,'string','6');
set(handles.tDimYRec,'string','6');
set(handles.tDimZRec,'string','3');
set(handles.tDimZcRec,'string','0');
set(handles.tRatSlope1NewPrjRec,'value',0);
set(handles.tRatSlope2NewPrjRec,'value',0);
set(handles.tRatSlope3NewPrjRec,'value',0);
set(handles.tRatSlope4NewPrjRec,'value',0);
set(handles.tRatSlope0NewPrjRec,'value',1);
set(handles.tWindowPlaneRec,'string','5');
set(handles.tDim1WinRec,'string','6');
set(handles.tDim2WinRec,'string','1');
set(handles.tFloorDimRec,'string','0.00');
set(handles.tWallTickRec,'string','0.15');
set(handles.tCeilingTickRec,'string','0.15');
set(handles.tFloorTickRec,'string','0.15');
set(handles.tWorkplaneDimRec,'string','0.75');

%Visualização completa, desenhando todos os planos
function fRoomPreview(handles,nPosition)
% Preview Completo. Desenha todos os planos
% Código extraido de wVis tOpenFile_Callback cria cVis se ele ainda não existir
% 2017.09.04 v. 8.0 - Pedro - Limpa e melhora comentários
% 2017.09.05 v. 8.0 - Pedro - Passa nPosition pela função, tirando do global
% 2017.09.05 v. 8.0 - Pedro - Tira cPlane, cDesc e cVis do global
% 2017.09.13 v.8.0 - Pedro - Utiliza informações de visualização exibidas na tela
% 2017.10.11 v8.0 - Pedro - Reduz loops de plotagem, aumentando a rapidez

global spcodeDir sInputDir 

load([spcodeDir '\bLangDef.tlx'],'-mat','GuiSet');  %Abre Arquivo de Idioma

% Importa número do projeto
nRoomNum= str2double(get(handles.tRoomNum,'String'));
if isnumeric(nRoomNum)
    sRoomNum=fPut0(nRoomNum,3);
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.PleaseInputRoomNumber ' (E0095)']);
    return
end

%Abre arquivos de plano
sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx'];
if exist(sFilePl,'file')==2
    load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
    return
end

% Erro caso cPlane não exista no arquivo
if exist('cPlane','var')==0
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.cPlaneNotFoundIn ' ' sFilePl ' (E0087)']); 
    return
end

% Erro caso cPlane esteja vazio no arquivo
if isempty(cPlane)
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cPlaneIsEmptyFile ' '  sFilePl ' ' ErrorDlg.MightBeCorrupted ' (E0098)'];	
    errordlg(sMens);
    return
end

%Carrega daods dos planos
cData=get(handles.tTablePlanes,'Data');
[nTotPla,~]=size(cData);  % lê o número de planos para comparar com o arquivo de visualização (nTotPl==nTotVis)

% Carrega informações da visualização
aDataVis=get(handles.tTableVis,'Data');
for k=1:nTotPla %Loop nos planos exibidos, salvando dados 
    nColor=aDataVis{k,3};
    nPosColor=find(nColor=='#');
    nColor=hex2rgb(nColor(nPosColor:nPosColor+6));
    cVis{k,1}=k;
    cVis{k,2}=nColor(1);  % Cor R
    cVis{k,3}=nColor(2);  % Cor G
    cVis{k,4}=nColor(3);  % Cor B
    cVis{k,5}=aDataVis{k,4};  % Transparência
end

[nTotVis,~]=size(cVis); % lê o número de planos para comparar com o arquivo de visualização (nTotPl==nTotVis)

% Verifica compatibilidade dos arquivos
if nTotVis>nTotPla
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  % Abre Arquivo de Idioma
    errordlg([ErrorDlg.VisualizationFileCorrupted ' (E0159)']);
    return  
elseif nTotVis<nTotPla % Inclui novos planos com valores padrão
    cDataPreview={nTotPla};
    cVis(nTotVis+1:nTotPla,1)=cDataPreview;
    cVis(nTotVis+1:nTotPla,2:4)={0.5}; % Define toda superfície como cinza
    cVis(nTotVis+1:nTotPla,5)={0.2}; % Define transparência = 20%  (OBS: value should be inverted to 1=transparency 0=opaque)
end

%Identifica o tipo de visualização
nCol=get(handles.tVisPrevColour,'Value');
if nCol==0 %Preto e Branco
    lCor=0;
    sColor=zeros(nTotPla+1,3);
else %Colorido
    lCor=1;
    sColor = cell2mat([cVis(:,2) cVis(:,3) cVis(:,4)]);
end
nTy=get(handles.tVisPrevSolid,'Value');
if nTy==0 %Sólido
    lTipo=0;
else %Estrutura de Arame
    lTipo=1;
    Trans = cell2mat(cVis(:,5));
    Trans=1-Trans; % inverte
end

aV=cData(:,5:16);
aV=cellfun(@str2num,aV(:,:));


% Redefine 'Ground' para plotagem:
nExt=3; % Define quantos métros além dos planos externos máximos será exibido [after: defined by user !?]
nXMax=max(max(aV([1:12 14:end],[1 4 7 10])));
nXMin=min(min(aV([1:12 14:end],[1 4 7 10])));
nYMax=max(max(aV([1:12 14:end],[2 5 8 11])));
nYMin=min(min(aV([1:12 14:end],[2 5 8 11])));
aV(13,[1 10])=nXMax+nExt;
aV(13,[4 7])=nXMin-nExt;
aV(13,[2 5])=nYMax+nExt;
aV(13,[8 11])=nYMin-nExt;

% Prepara matriz para plotagem 
nTotPl = size(cData,1);
aVX=aV(:,1:3:end);
aVY=aV(:,2:3:end);
aVZ=aV(:,3:3:end);
aVX(:,5)=aVX(:,1);
aVY(:,5)=aVY(:,1);
aVZ(:,5)=aVZ(:,1);
axes(handles.tAxesPreview)

% Desenha Perspectiva 3d
% Limpa Tela
cla;

%Identifica a cor do plano selecionado 
aColorD=get(handles.tVisDestacColor,'BackgroundColor');
% Identifica se p usuário quer destaque
nDestCol=get(handles.ttVisDestacColor,'Value');

if exist('nPosition','var')==1
    if nDestCol==1
        sColor(nPosition,1:3)=aColorD(1:3);
    end
end

hold on
fGirar(1)

for iPl=[1:12 16:nTotPl] %Planos 2-12 e 16-final
    if lTipo == 0
        plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'Color',sColor(iPl,:),'Tag',num2str(cData{iPl,1}))
    else
        fill3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),sColor(iPl,:),'FaceAlpha',Trans(iPl,:),'Tag',num2str(cData{iPl,1}))
    end
end

iPl=13; % Solo
if lCor
    plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'-.','Color',sColor(iPl,:),'Tag',num2str(cData{iPl,1}))
else
    plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'-.','Color',sColor(iPl,:),'Tag',num2str(cData{iPl,1}))
end

for iPl=14  %% Plano de trabalho
  if lCor
    plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'--','Color',sColor(iPl,:),'Tag',num2str(cData{iPl,1}))
  else
    plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'--','Color',sColor(iPl,:),'Tag',num2str(cData{iPl,1}))
  end
end

% Desenha Seta de destaque
if exist('nPosition','var')
    if nDestCol==1
        for iPl=1:nTotPl
            if iPl==nPosition
                %Acha Centroide do Plano
                nX=mean([aVX(iPl,1) aVX(iPl,2) aVX(iPl,3) aVX(iPl,4)]);
                nY=mean([aVY(iPl,1) aVY(iPl,2) aVY(iPl,3) aVY(iPl,4)]);
                nZ=mean([aVZ(iPl,1) aVZ(iPl,2) aVZ(iPl,3) aVZ(iPl,4)]);
                nVector=cross([aVX(iPl,3)-aVX(iPl,2) aVY(iPl,3)-aVY(iPl,2) aVZ(iPl,3)-aVZ(iPl,2)],[aVX(iPl,1)-aVX(iPl,2) aVY(iPl,1)-aVY(iPl,2) aVZ(iPl,1)-aVZ(iPl,2)]);
                nNormVec=norm(nVector);
                nCosDir=nVector/nNormVec;
                quiver3(nX,nY,nZ,nCosDir(1),nCosDir(2),nCosDir(3),'LineWidth',3,'Color',get(handles.tVisDestacColor,'BackgroundColor'),'MaxHeadSize',3,'AutoScaleFactor',1.5,'Tag','0');
            end
        end
    end
end

% Set na quantidade de elementos plotados
nPlotChild=handles.tAxesPreview.Children;
nPlotSize=size(nPlotChild,1);
set(handles.tVisPlotSize,'String',num2str(nPlotSize));

axis equal

set(get(gca,'XLabel'),'String','X','FontWeight','bold','FontSize',12)
set(get(gca,'YLabel'),'String','Y','FontWeight','bold','FontSize',12)
set(get(gca,'ZLabel'),'String','N','FontWeight','bold','FontSize',12)

%Visualização de novo projeto, para a tab de novos projetos
function fRoomPreviewPrj(hObject,eventdata,handles)
% Pedro
% Pré-Visualiza Novo Projeto

global spcodeDir

%Importa Dados
cLine{1}=num2str(str2double(get(handles.tProjectQt2,'String'))+1); %Número do Projeto
cLine{2}=get(handles.tDescRec,'string'); % Descrição do projeto
cLine{3}=get(handles.tDimXRec,'string'); % Dimensão X
cLine{4}=get(handles.tDimYRec,'string'); % Dimensão Y
cLine{5}=get(handles.tDimZRec,'string'); % Dimensão Z
cLine{6}=get(handles.tDimZcRec,'string'); % Dimensão Zc
cLine{7}=get(handles.tWorkplaneDimRec,'string'); % Altura do plano de trabalho
cLine{8}=get(handles.tFloorDimRec,'string'); % Altura do piso
cLine{9}=get(handles.tWallTickRec,'string'); % Espessura da parede
cLine{10}=get(handles.tCeilingTickRec,'string'); % Espessura do teto
cLine{11}=get(handles.tFloorTickRec,'string'); % Espessura do piso
cLine{12}=get(handles.tWindowPlaneRec,'string'); % Plano da janela
cLine{13}=get(handles.tDim1WinRec,'string'); % Dimensão 1 da janela (Largura)
cLine{14}=get(handles.tDim2WinRec,'string'); % Dimensão 2 da janela (Altura)

% Verifica se algum campo é vazio e Testa se os campo estão preenchidos corretamente
for nF=1:14
    if isempty(cLine{nF})
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([ErrorDlg.NewRoomGeometryNotProperlyDefined ' (E0113)'])
        return
    end
    if nF>2
        cLine{nF}=fChDecPoint(cLine{nF});
        if isempty(str2double(cLine{nF})) && (nF <= (nParLine-3)) %%% allows empty windows
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
            errordlg([ErrorDlg.Error ' ' cLine{k} ' ' ErrorDlg.IsNotValidInThisField ' (E0099)'])
            return
        end
    end
end

% Testa se dimensões da janela são compativeis com X,Y,Z 
% Corrigido para mudanças automáticas caso a janela não caiba no plano
if strfind('12',cLine{12}) %% piso 1 ou teto 2   Axis Z
    if str2double(cLine{13})>str2double(cLine{3})     % Dim1 > X
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim1 ' (' cLine{13} 'm) > ' ErrorDlg.AxisXDimension ' (' cLine{3} 'm)'  ' (E0114)'])
        uiwait;
        cLine{3}=cLine{13};
    end
    if str2double(cLine{14})>str2double(cLine{4})     % Dim2 > Y
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim2 ' (' cLine{14} 'm) > ' ErrorDlg.AxisYDimension ' (' cLine{4} 'm)' ' (E0114)'])
        uiwait;
        cLine{4}=cLine{14} ; 
    end  
elseif strfind('34',cLine{12})  %% parede 3 ou 4  Axis X
    if str2double(cLine{13})>str2double(cLine{3})     % Dim1 > X
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim1 ' (' cLine{13} 'm) > ' ErrorDlg.AxisXDimension ' (' cLine{3} 'm)' ' (E0114)'])
        uiwait;
        cLine{3}=cLine{13};
    end
    if str2double(cLine{14})>str2double(cLine{5})     % Dim2 > Z
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim2 ' (' cLine{14} 'm) > ' ErrorDlg.AxisZDimension ' (' cLine{5} 'm)' ' (E0114)'])
        uiwait;
        cLine{5}=cLine{14};
    end   
elseif strfind('56',cLine{12})  %% parede 5 ou 6  Axis Y
    if str2double(cLine{13})>str2double(cLine{4})     % Dim1 > Y
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim1 ' (' cLine{13} 'm) > ' ErrorDlg.AxisYDimension ' (' cLine{4} 'm)' ' (E0114)'])
        uiwait;
        cLine{4}=cLine{13};
    end
    if str2double(cLine{14})>str2double(cLine{5})     % Dim2 > Z
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.ErrorWindowDim2 ' (' cLine{14} 'm) > ' ErrorDlg.AxisZDimension ' (' cLine{5} 'm)' ' (E0114)'])
        uiwait;
        cLine{5}=cLine{14};
    end   
elseif strfind(' 0',cLine{12})
    cLine{12}='0';
    cLine{13}='0';
    cLine{14}='0';
else % Erro
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([ErrorDlg.ErrorPlane ' ' cLine{12} ' ' ErrorDlg.IsNotValidInThisField ' (E0115)'])
    return
end

% Dá Set nas opções corrigdas
% set(handles.tProjectQt2,'String',cLine{1}); %Número do Projeto
set(handles.tDescRec,'string',cLine{2}); % Descrição do projeto
set(handles.tDimXRec,'string',cLine{3}); % Dimensão X
set(handles.tDimYRec,'string',cLine{4}); % Dimensão Y
set(handles.tDimZRec,'string',cLine{5}); % Dimensão Z
set(handles.tDimZcRec,'string',cLine{6}); % Inclinação
set(handles.tWorkplaneDimRec,'string',cLine{7}); % Altura do plano de trabalho
set(handles.tFloorDimRec,'string',cLine{8}); % Altura do piso
set(handles.tWallTickRec,'string',cLine{9}); % Espessura da parede
set(handles.tCeilingTickRec,'string',cLine{10}); % Espessura do teto
set(handles.tFloorTickRec,'string',cLine{11}); % Espessura do piso
set(handles.tWindowPlaneRec,'string',cLine{12}); % Plano da janela
set(handles.tDim1WinRec,'string',cLine{13}); % Dimensão 1 da janela (Largura)
set(handles.tDim2WinRec,'string',cLine{14}); % Dimensão 2 da janela (Altura)

% Define ambiente de visualização
cRoomGeom{1,1}=str2double(cLine{1});
cRoomGeom{1,2}=cLine{2};
cRoomGeom{1,3}=str2double(cLine{3});
cRoomGeom{1,4}=str2double(cLine{4});
cRoomGeom{1,5}=str2double(cLine{5});
cRoomGeom{1,6}=str2double(cLine{6});
cRoomGeom{1,7}=str2double(cLine{7});
cRoomGeom{1,8}=str2double(cLine{8});
cRoomGeom{1,9}=str2double(cLine{9});
cRoomGeom{1,10}=str2double(cLine{10});
cRoomGeom{1,11}=str2double(cLine{11});
cRoomGeom{1,12}=str2double(cLine{12});
cRoomGeom{1,13}=str2double(cLine{13});
cRoomGeom{1,14}=str2double(cLine{14});

% Importa valores de inclinaçao
nSlope0=get(handles.tRatSlope0NewPrjRec,'Value');
nSlope1=get(handles.tRatSlope1NewPrjRec,'Value');
nSlope2=get(handles.tRatSlope2NewPrjRec,'Value');
nSlope3=get(handles.tRatSlope3NewPrjRec,'Value');
nSlope4=get(handles.tRatSlope4NewPrjRec,'Value');

if nSlope0==1 || nSlope1==1 %Teto Plano ou teto com uma água
    
    % Cria cPlane
    cPlane=fPrepPlan(cRoomGeom(1,:));
    if isempty(cPlane)
        return
    end

    % Cria cMat
    [nTPl, ~]=size(cPlane);
    for k=1:nTPl
        cMat{k,1}=k;
        cMat{k,2}=0.5;
        cMat{k,3}=0;
        cMat{k,4}=0;
        cMat{k,5}=0;
    end
    cMat{13,2}=0.2; % Solo  (might be parameter)
    cMat{14,2}=0;cMat{14,5}=1;  % Plano de Trabalho
    cMat{15,2}=0;cMat{15,5}=1;  % Plano de Trabalho
    
    if str2double(cLine{12})>0 %Tem janela, Cria!
        % Cria cWindow
        cWindow=fPrepWin(cRoomGeom(1,:));
        % Atualiza cPlane e cMat com a janela
        iWin=1; iPlW=1;
        % Gera o frame da janela
        load([spcodeDir '\bLangDef.tlx'],'-mat','Legend');  %Load Language File
        cDescPl{iPlW}=[Legend.FrameWindow ' ' num2str(iWin) '/' num2str(iWin+1) ' - ' num2str(iPlW)];
        aPtW(iPlW,1,1:3)=cWindow{iWin,5};
        aPtW(iPlW,2,1:3)=cWindow{iWin+1,5};
        aPtW(iPlW,3,1:3)=cWindow{iWin+1,6};
        aPtW(iPlW,4,1:3)=cWindow{iWin,8};
        iPlW=2;	
        cDescPl{iPlW}=[Legend.FrameWindow ' ' num2str(iWin) '/' num2str(iWin+1) ' - ' num2str(iPlW)];
        aPtW(iPlW,1,1:3)=cWindow{iWin,6};
        aPtW(iPlW,2,1:3)=cWindow{iWin,7};
        aPtW(iPlW,3,1:3)=cWindow{iWin+1,7};
        aPtW(iPlW,4,1:3)=cWindow{iWin+1,8};
        iPlW=3;	
        cDescPl{iPlW}=[Legend.FrameWindow ' ' num2str(iWin) '/' num2str(iWin+1) ' - ' num2str(iPlW)];
        aPtW(iPlW,1,1:3)=cWindow{iWin,7};
        aPtW(iPlW,2,1:3)=cWindow{iWin,8};
        aPtW(iPlW,3,1:3)=cWindow{iWin+1,6};
        aPtW(iPlW,4,1:3)=cWindow{iWin+1,7};
        iPlW=4;	
        cDescPl{iPlW}=[Legend.FrameWindow ' ' num2str(iWin) '/' num2str(iWin+1) ' - ' num2str(iPlW)];
        aPtW(iPlW,1,1:3)=cWindow{iWin,6};
        aPtW(iPlW,2,1:3)=cWindow{iWin+1,8};
        aPtW(iPlW,3,1:3)=cWindow{iWin+1,5};
        aPtW(iPlW,4,1:3)=cWindow{iWin,5};

        % Converte em cPlane
        [nNPl,~]=size(cPlane);
        for iPl=1:4
            cPlane{nNPl+iPl,1}=nNPl+iPl;
            cPlane{nNPl+iPl,2}=-(nNPl+iPl);
            cPlane{nNPl+iPl,3}=cDescPl{iPl};
            for j=1:3
                cPlane{nNPl+iPl,4}(j)=aPtW(iPl,1,j);
                cPlane{nNPl+iPl,5}(j)=aPtW(iPl,2,j);
                cPlane{nNPl+iPl,6}(j)=aPtW(iPl,3,j);
                cPlane{nNPl+iPl,7}(j)=aPtW(iPl,4,j);
            end
            % Mais um campo para a nova configuração de tpanshadingtype
            cPlane{nNPl+iPl,8}=-1;  % PEDRO 2016
        end

        % Atualiza cMat
        [nNMat,~]=size(cMat);
        for iMat=1:4
          cMat{nNMat+iMat,1}=nNMat+iMat;
          cMat{nNMat+iMat,2}=0.5;
          cMat{nNMat+iMat,3}=0;
          cMat{nNMat+iMat,4}=0;
          cMat{nNMat+iMat,5}=0;
        end
    end
elseif nSlope2==1 || nSlope3==1 || nSlope4==1 % Mais aguas
    
    % Cria cPlane
    if nSlope2==1
        [cPlane,~]=fPrepPlanSlope(cRoomGeom(1,:),2);
    elseif nSlope3==1
        [cPlane,~]=fPrepPlanSlope(cRoomGeom(1,:),3);
    elseif nSlope4==1
        [cPlane,~]=fPrepPlanSlope(cRoomGeom(1,:),4);
    end
    if isempty(cPlane)
        return
    end

    % Cria cMat
    [nTPl, ~]=size(cPlane);
    for k=1:nTPl
        cMat{k,1}=k;
        cMat{k,2}=0.5;
        cMat{k,3}=0;
        cMat{k,4}=0;
        cMat{k,5}=0;
    end
    cMat{13,2}=0.2; % Solo  (might be parameter)
    cMat{14,2}=0;cMat{14,5}=1;  
    cMat{15,2}=0;cMat{15,5}=1; 
    
    if str2double(cLine{12})>0
        % Cria cWindow
        cWindow=fPrepWin(cRoomGeom(1,:));
        % Atualiza cPlane e cMat com a janela
        iWin=1; iPlW=1;
        % Gera o frame da janela
        load([spcodeDir '\bLangDef.tlx'],'-mat','Legend');  %Load Language File
        cDescPl{iPlW}=[Legend.FrameWindow ' ' num2str(iWin) '/' num2str(iWin+1) ' - ' num2str(iPlW)];
        aPtW(iPlW,1,1:3)=cWindow{iWin,5};
        aPtW(iPlW,2,1:3)=cWindow{iWin+1,5};
        aPtW(iPlW,3,1:3)=cWindow{iWin+1,6};
        aPtW(iPlW,4,1:3)=cWindow{iWin,8};
        iPlW=2;	
        cDescPl{iPlW}=[Legend.FrameWindow ' ' num2str(iWin) '/' num2str(iWin+1) ' - ' num2str(iPlW)];
        aPtW(iPlW,1,1:3)=cWindow{iWin,6};
        aPtW(iPlW,2,1:3)=cWindow{iWin,7};
        aPtW(iPlW,3,1:3)=cWindow{iWin+1,7};
        aPtW(iPlW,4,1:3)=cWindow{iWin+1,8};
        iPlW=3;	
        cDescPl{iPlW}=[Legend.FrameWindow ' ' num2str(iWin) '/' num2str(iWin+1) ' - ' num2str(iPlW)];
        aPtW(iPlW,1,1:3)=cWindow{iWin,7};
        aPtW(iPlW,2,1:3)=cWindow{iWin,8};
        aPtW(iPlW,3,1:3)=cWindow{iWin+1,6};
        aPtW(iPlW,4,1:3)=cWindow{iWin+1,7};
        iPlW=4;	
        cDescPl{iPlW}=[Legend.FrameWindow ' ' num2str(iWin) '/' num2str(iWin+1) ' - ' num2str(iPlW)];
        aPtW(iPlW,1,1:3)=cWindow{iWin,6};
        aPtW(iPlW,2,1:3)=cWindow{iWin+1,8};
        aPtW(iPlW,3,1:3)=cWindow{iWin+1,5};
        aPtW(iPlW,4,1:3)=cWindow{iWin,5};

        % Converte em cPlane
        [nNPl,~]=size(cPlane);
        for iPl=1:4
            cPlane{nNPl+iPl,1}=nNPl+iPl;
            cPlane{nNPl+iPl,2}=-(nNPl+iPl);
            cPlane{nNPl+iPl,3}=cDescPl{iPl};
            for j=1:3
                cPlane{nNPl+iPl,4}(j)=aPtW(iPl,1,j);
                cPlane{nNPl+iPl,5}(j)=aPtW(iPl,2,j);
                cPlane{nNPl+iPl,6}(j)=aPtW(iPl,3,j);
                cPlane{nNPl+iPl,7}(j)=aPtW(iPl,4,j);
            end
            % Mais um campo para a nova configuração de tpanshadingtype
            cPlane{nNPl+iPl,8}=-1;  % PEDRO 2016
        end

        % Atualiza cMat
        [nNMat,~]=size(cMat);
        for iMat=1:4
          cMat{nNMat+iMat,1}=nNMat+iMat;
          cMat{nNMat+iMat,2}=0.5;
          cMat{nNMat+iMat,3}=0;
          cMat{nNMat+iMat,4}=0;
          cMat{nNMat+iMat,5}=0;
        end
    end
end

% Exibe Pré-Visualização

% Cria cVis
cVis=cPlane(:,1);
cVis(:,2:4)={0.5};  % Define toda superfície como cinza
cVis(:,5)={0.7}; % Define Transparência em 30% 
    
% Converte cPlanes em cData 
[nTPl,~]=size(cPlane); % Número de planos no arquivo
aData=cell(nTPl,15); % Cria matriz vazia de dados

for k=1:nTPl % Isola as coordenadas e a descrição de cala plano e cria a matriz de dados para exibição 
    
    aData{k,1}=cPlane{k,1}; %Número
    aData{k,2}=cPlane{k,2}; %Tipo
    aData{k,3}=1; 
    aData{k,4}=cPlane{k,3}; % Descrição
    aData{k,5}=cPlane{k,4}(1);
    aData{k,6}=cPlane{k,4}(2);
    aData{k,7}=cPlane{k,4}(3);
    aData{k,8}=cPlane{k,5}(1);
    aData{k,9}=cPlane{k,5}(2);
    aData{k,10}=cPlane{k,5}(3);
    aData{k,11}=cPlane{k,6}(1);
    aData{k,12}=cPlane{k,6}(2);
    aData{k,13}=cPlane{k,6}(3);
    aData{k,14}=cPlane{k,7}(1);
    aData{k,15}=cPlane{k,7}(2);
    aData{k,16}=cPlane{k,7}(3);  
end

%Carrega daods dos planos
[nTotPla,~]=size(aData);  % lê o número de planos para comparar com o arquivo de visualização (nTotPl==nTotVis)

load([spcodeDir '\bLangDef.tlx'],'-mat','GuiSet');  %Abre Arquivo de Idioma

% Identifica o tipo de visualização
% Preto e Branco
lCor=get(handles.tVisPrevColour,'Value');
% Estrutura de Arame
lTipo=get(handles.tVisPrevSolid,'Value');

if lCor == 0 % 0=Preto e branco, 1=colorido
    sColor=zeros(nTotPla+1,3);
else
    sColor = cell2mat([cVis(:,2) cVis(:,3) cVis(:,4)]);
end

if lTipo == 1
    Trans = cell2mat(cVis(:,5));
    Trans=1-Trans; % inverte
end

aV=cell2mat(aData(:,5:16));
% aV=cellfun(@str2num,aV);

% Redefine 'Ground' para plotagem:
nExt=3; % Define quantos métros além dos planos externos máximos será exibido [after: defined by user !?]
nXMax=max(max(aV([1:12 14:end],[1 4 7 10])));
nXMin=min(min(aV([1:12 14:end],[1 4 7 10])));
nYMax=max(max(aV([1:12 14:end],[2 5 8 11])));
nYMin=min(min(aV([1:12 14:end],[2 5 8 11])));
aV(13,[1 10])=nXMax+nExt;
aV(13,[4 7])=nXMin-nExt;
aV(13,[2 5])=nYMax+nExt;
aV(13,[8 11])=nYMin-nExt;

% Prepara matriz para plotagem 
nTotPl = size(aData,1);
aVX=aV(:,1:3:end);
aVY=aV(:,2:3:end);
aVZ=aV(:,3:3:end);
aVX(:,5)=aVX(:,1);
aVY(:,5)=aVY(:,1);
aVZ(:,5)=aVZ(:,1);
axes(handles.tAxesPreview)

% Desenha Perspectiva 3d
%Limpa Tela
cla;
hold on

for iPl=[1:12 16:nTotPl] %Planos 2-12 e 16-final
    if lTipo == 0
        plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'Color',sColor(iPl,:))
    else
        fill3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),sColor(iPl,:),'FaceAlpha',Trans(iPl,:))
    end
end

iPl=13; % Solo
if lCor
    plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'-.','Color',sColor(iPl,:))
else
    plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'-.','Color',sColor(iPl,:))
end

for iPl=14  %% Plano de trabalho
  if lCor
    plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'--','Color',sColor(iPl,:))
  else
    plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'--','Color',sColor(iPl,:))
  end
end

axis equal

set(get(gca,'XLabel'),'String','X','FontWeight','bold','FontSize',12)
set(get(gca,'YLabel'),'String','Y','FontWeight','bold','FontSize',12)
set(get(gca,'ZLabel'),'String','N','FontWeight','bold','FontSize',12)

%Visualização de novo dispositivo de proteção, para a tab de dispositivos
function fRoomPreviewShadeDev(hObject,eventdata,handles)
% Pré-Visualiza elemento de proteção solar
% Código extraido de wVis tOpenFile_Callback cria cVis se ele ainda não existir
% 2017.09.04 v. 8.0 - Pedro - Limpa e melhora comentários
% 2017.09.05 v. 8.0 - Pedro - Passa nPosition pela função, tirando do global
% 2017.09.05 v. 8.0 - Pedro - Tira cPlane, cDesc e cVis do global
% 2017.09.13 v.8.0 - Pedro - Utiliza informações de visualização exibidas na tela
% 2017.10.11 v8.0 - Pedro - Atualiza função para apagar os planos da
% pré-visualização anterior (Caso existam), manter apenas os planos já
% existentes e criar os novos planos para visualização, em vez de toda vez
% desenhar todos os planos
% 2017.10.13 v8.0 - Pedro - Insere opção de pré-visualização de prateleiras
% de luz, brises e toldos
% 2017.11.14 v8.0 - Pedro - Insere opção de Louvre

global spcodeDir 

load([spcodeDir '\bLangDef.tlx'],'-mat','GuiSet');  %Abre Arquivo de Idioma

% Gera coordenadas dos planos
sElementOverhang=get(handles.tPanOverhang,'Visible');
sElementLightshelf=get(handles.tPanLightshelf,'Visible');
sElementLouvre=get(handles.tPanLouvre,'Visible');
sElementCanopy=get(handles.tPanCanopy,'Visible');
if strcmp(sElementOverhang,'on') % Marquise
    % Pontos
    aPts=str2double(get(handles.tOverhangPoints,'Data'));

    %Verifica se está vazia a tabela de pontos
    aEmpty=sum(sum(isempty(aPts)));
    if aEmpty>0
        return
    end
        
    %Importa Informações da tela 
    nSlopeAngle=str2double(get(handles.tOverhangSlopeAngle,'String'));
    nLSlat=str2double(get(handles.tOverhangSlatLength,'String'));
    nTSlat=str2double(get(handles.tOverhangSlatTickness,'String'));
    
    aPlanePrev=fCreateOverhang(num2cell(aPts),nSlopeAngle,nLSlat,nTSlat,0,0);
elseif strcmp(sElementLightshelf,'on') % Prateleira de Luz
    aPts=str2double(get(handles.tLightshelfPoints,'Data'));

    %Verifica se está vazia a tabela de pontos
    aEmpty=sum(sum(isempty(aPts)));
    if aEmpty>0
        return
    end
        
    %Importa Informações da tela 
    nSlopeAngle=str2double(get(handles.tLightshelfSlopeAngle,'String'));
    nLSlat=str2double(get(handles.tLightshelfSlatLength,'String'));
    nTSlat=str2double(get(handles.tLightshelfSlatTickness,'String'));
    nTDistSlat=str2double(get(handles.tLightshelfTopDistance,'String'));
    nInProjSlat=str2double(get(handles.tLightshelfInProjection,'String'));
    
    aPlanePrev=fCreateLightshelf(num2cell(aPts),nSlopeAngle,nLSlat,nTSlat,nTDistSlat,nInProjSlat);
elseif strcmp(sElementLouvre,'on') % Brise
    % Pontos
    aPts=str2double(get(handles.tLouvrePoints,'Data'));

    %Verifica se está vazia a tabela de pontos
    aEmpty=sum(sum(isempty(aPts)));
    if aEmpty>0
        return
    end
    
    %Importa Informações da tela 
    nLSlat=get(handles.tLouvreSlatLength,'UserData');
    nESlat={0;0};  
    nProj=get(handles.tLouvreAxisProjection,'UserData');
    nASlat=get(handles.tLouvreSlatAngle,'UserData');
    nTSlat=get(handles.tLouvreSlatTickness,'UserData');
    nNSlat=get(handles.tLouvreSlatQuantity,'UserData');
    
    %tipos de brises
    nBriseH=get(handles.tLouvreTypeHorizontalCh,'Value');
    nBriseV=get(handles.tLouvreTypeVerticalCh,'Value');
    if nBriseH==1 && nBriseV==1
        nHVType=0;
    elseif nBriseH==1
        nHVType=1;
    else
        nHVType=2;
    end
    
    set(gcf,'pointer','watch');
    aPlanePrev=fCreateLouvre(handles,aPts,nLSlat,nESlat,nProj,nASlat,nTSlat,nNSlat,{0;0},nHVType);
    set(gcf,'pointer','arrow');
elseif strcmp(sElementCanopy,'on') % Toldo
    % Pontos
    aPts=str2double(get(handles.tCanopyPoints,'Data'));

    %Verifica se está vazia a tabela de pontos
    aEmpty=sum(sum(isempty(aPts)));
    if aEmpty>0
        return
    end
          
    %Importa Informações da tela 
    nTotalLength=str2double(get(handles.tCanopyTotalLength,'String'));
    nCurveRadius=str2double(get(handles.tCanopyCurveRadius,'String'));
    nDiscretization=str2double(get(handles.tCanopyDiscretization,'String'));
    nTopDistance=str2double(get(handles.tCanopyTopDistance,'String'));
    nSideIncrement=str2double(get(handles.tCanopySideIncrement,'String'));
    
    aPlanePrev=fCreateCanopy(aPts,nTotalLength-nCurveRadius,nCurveRadius,nDiscretization,nTopDistance,nSideIncrement);
end

%Carrega dados dos planos
aData=get(handles.tTablePlanes,'Data');
[nTotPla,~]=size(aData);

% Insere nos dados atuais os novos planos para pré-visualização
nSizePrev=size(aPlanePrev,1);
for nP=1:nSizePrev
    aData{nTotPla+nP,1}=nTotPla+nP;
    aData{nTotPla+nP,2}=-(nTotPla+nP);
    aData{nTotPla+nP,3}=1;
    aData{nTotPla+nP,4}='Preview';
    aData{nTotPla+nP,5}=num2str(aPlanePrev{nP,1}(1)); aData{nTotPla+nP,6}=num2str(aPlanePrev{nP,1}(2)); aData{nTotPla+nP,7}=num2str(aPlanePrev{nP,1}(3));
    aData{nTotPla+nP,8}=num2str(aPlanePrev{nP,2}(1)); aData{nTotPla+nP,9}=num2str(aPlanePrev{nP,2}(2)); aData{nTotPla+nP,10}=num2str(aPlanePrev{nP,2}(3));
    aData{nTotPla+nP,11}=num2str(aPlanePrev{nP,3}(1)); aData{nTotPla+nP,12}=num2str(aPlanePrev{nP,3}(2)); aData{nTotPla+nP,13}=num2str(aPlanePrev{nP,3}(3));
    aData{nTotPla+nP,14}=num2str(aPlanePrev{nP,4}(1)); aData{nTotPla+nP,15}=num2str(aPlanePrev{nP,4}(2)); aData{nTotPla+nP,16}=num2str(aPlanePrev{nP,4}(3));
end

[nTotPlaPr,~]=size(aData);  % lê o número de planos para comparar com o arquivo de visualização (nTotPl==nTotVis)

% Carrega informações da visualização
aDataVis=get(handles.tTableVis,'Data');
for k=1:nTotPla %Loop nos planos exibidos, salvando dados 
    nColor=aDataVis{k,3};
    nPosColor=find(nColor=='#');
    nColor=hex2rgb(nColor(nPosColor:nPosColor+6));
    cVis{k,1}=k;
    cVis{k,2}=nColor(1);  % Cor R
    cVis{k,3}=nColor(2);  % Cor G
    cVis{k,4}=nColor(3);  % Cor B
    cVis{k,5}=aDataVis{k,4};  % Transparência
end

[nTotVis,~]=size(cVis); % lê o número de planos para comparar com o arquivo de visualização (nTotPl==nTotVis)

% Verifica compatibilidade dos arquivos
if nTotVis>nTotPlaPr
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  % Abre Arquivo de Idioma
    errordlg([ErrorDlg.VisualizationFileCorrupted ' (E0159)']);
    return  
elseif nTotVis<nTotPlaPr % Inclui novos planos com valores padrão
    cDataPreview={nTotPlaPr};
    cVis(nTotVis+1:nTotPlaPr,1)=cDataPreview;
    cVis(nTotVis+1:nTotPlaPr,2:4)={0.5}; % Define toda superfície como cinza
    cVis(nTotVis+1:nTotPlaPr,5)={0.2}; % Define transparência = 20%  (OBS: value should be inverted to 1=transparency 0=opaque)
end

%Identifica o tipo de visualização
nCol=get(handles.tVisPrevColour,'Value');
if nCol==0 %Preto e Branco
    lCor=0;
    sColor=zeros(nTotPlaPr+1,3);
else %Colorido
    lCor=1;
    sColor=cell2mat([cVis(:,2) cVis(:,3) cVis(:,4)]);
end
nTy=get(handles.tVisPrevSolid,'Value');
if nTy==0 %Sólido
    lTipo=0;
else %Estrutura de Arame
    lTipo=1;
    Trans = cell2mat(cVis(:,5));
    Trans=1-Trans; % inverte
end

aV=aData(:,5:16);
aV=cellfun(@str2num,aV(:,:));

% Redefine 'Ground' para plotagem:
nExt=3; % Define quantos métros além dos planos externos máximos será exibido [after: defined by user !?]
nXMax=max(max(aV([1:12 14:end],[1 4 7 10])));
nXMin=min(min(aV([1:12 14:end],[1 4 7 10])));
nYMax=max(max(aV([1:12 14:end],[2 5 8 11])));
nYMin=min(min(aV([1:12 14:end],[2 5 8 11])));
aV(13,[1 10])=nXMax+nExt;
aV(13,[4 7])=nXMin-nExt;
aV(13,[2 5])=nYMax+nExt;
aV(13,[8 11])=nYMin-nExt;

% Prepara matriz para plotagem 
nTotPl = size(aData,1);
aVX=aV(:,1:3:end);
aVY=aV(:,2:3:end);
aVZ=aV(:,3:3:end);
aVX(:,5)=aVX(:,1);
aVY(:,5)=aVY(:,1);
aVZ(:,5)=aVZ(:,1);
axes(handles.tAxesPreview)

% Desenha Perspectiva 3d
% Se existirem planos de pré-visualização anteriores, apaga-os

aPrevChild=handles.tAxesPreview.Children;
nSizePreviewNow=size(aPrevChild,1);
nSizePreviewOrig=str2double(get(handles.tVisPlotSize,'String'));

if nSizePreviewNow>nSizePreviewOrig %Já há pré-visualização sendo exibida
    % Apagar pre-visualização anterior
    for nD=nSizePreviewOrig+1:nSizePreviewNow
        delete(handles.tAxesPreview.Children(1));
    end
end

for iPl=nTotPla+1:nTotPl  %Planos adicionais
  if lCor
    if lTipo == 0
      plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'Color',sColor(iPl,:),'Tag',num2str(aData{iPl,1}))
    else
      fill3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),sColor(iPl,:),'FaceAlpha',Trans(iPl,:),'Tag',num2str(aData{iPl,1}))
    end
  else
    if lTipo == 0
      plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'Color',sColor(iPl,:),'Tag',num2str(aData{iPl,1}))
    else
      fill3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),sColor(iPl,:),'FaceAlpha',Trans(iPl,:),'Tag',num2str(aData{iPl,1}))
    end
  end
end

axis equal

set(get(gca,'XLabel'),'String','X','FontWeight','bold','FontSize',12)
set(get(gca,'YLabel'),'String','Y','FontWeight','bold','FontSize',12)
set(get(gca,'ZLabel'),'String','N','FontWeight','bold','FontSize',12)

% Pré visualização de Elementos
function fRoomPreviewElement(hObject,eventdata,handles,aPlane)
% Pré-Visualiza elemento 
% Código extraido de wVis tOpenFile_Callback cria cVis se ele ainda não existir

%Carrega dados dos planos
aData=get(handles.tTablePlanes,'Data');
[nTotPla,~]=size(aData);

% Insere nos dados atuais os novos planos para pré-isualização
nSizePrev=size(aPlane,1);
for nP=1:nSizePrev
    aData{nTotPla+nP,1}=nTotPla+nP;
    aData{nTotPla+nP,2}=-(nTotPla+nP);
    aData{nTotPla+nP,3}=1;
    aData{nTotPla+nP,4}='Preview';
    aData{nTotPla+nP,5}=num2str(aPlane{nP,1}(1)); aData{nTotPla+nP,6}=num2str(aPlane{nP,1}(2)); aData{nTotPla+nP,7}=num2str(aPlane{nP,1}(3));
    aData{nTotPla+nP,8}=num2str(aPlane{nP,2}(1)); aData{nTotPla+nP,9}=num2str(aPlane{nP,2}(2)); aData{nTotPla+nP,10}=num2str(aPlane{nP,2}(3));
    aData{nTotPla+nP,11}=num2str(aPlane{nP,3}(1)); aData{nTotPla+nP,12}=num2str(aPlane{nP,3}(2)); aData{nTotPla+nP,13}=num2str(aPlane{nP,3}(3));
    aData{nTotPla+nP,14}=num2str(aPlane{nP,4}(1)); aData{nTotPla+nP,15}=num2str(aPlane{nP,4}(2)); aData{nTotPla+nP,16}=num2str(aPlane{nP,4}(3));
end

[nTotPlaPr,~]=size(aData);  % lê o número de planos para comparar com o arquivo de visualização (nTotPl==nTotVis)

% Carrega informações da visualização
aDataVis=get(handles.tTableVis,'Data');
for k=1:nTotPla %Loop nos planos exibidos, salvando dados 
    nColor=aDataVis{k,3};
    nPosColor=find(nColor=='#');
    nColor=hex2rgb(nColor(nPosColor:nPosColor+6));
    cVis{k,1}=k;
    cVis{k,2}=nColor(1);  % Cor R
    cVis{k,3}=nColor(2);  % Cor G
    cVis{k,4}=nColor(3);  % Cor B
    cVis{k,5}=aDataVis{k,4};  % Transparência
end

[nTotVis,~]=size(cVis); % lê o número de planos para comparar com o arquivo de visualização (nTotPl==nTotVis)

% Verifica compatibilidade dos arquivos
if nTotVis>nTotPlaPr
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  % Abre Arquivo de Idioma
    errordlg([ErrorDlg.VisualizationFileCorrupted ' (E0159)']);
    return  
elseif nTotVis<nTotPlaPr % Inclui novos planos com valores padrão
    cDataPreview={nTotPlaPr};
    cVis(nTotVis+1:nTotPlaPr,1)=cDataPreview;
    cVis(nTotVis+1:nTotPlaPr,2:4)={0.5}; % Define toda superfície como cinza
    cVis(nTotVis+1:nTotPlaPr,5)={0.2}; % Define transparência = 20%  (OBS: value should be inverted to 1=transparency 0=opaque)
end

%Identifica o tipo de visualização
nCol=get(handles.tVisPrevColour,'Value');
if nCol==0 %Preto e Branco
    lCor=0;
    sColor=zeros(nTotPlaPr+1,3);
else %Colorido
    lCor=1;
    sColor=cell2mat([cVis(:,2) cVis(:,3) cVis(:,4)]);
end
nTy=get(handles.tVisPrevSolid,'Value');
if nTy==0 %Sólido
    lTipo=0;
else %Estrutura de Arame
    lTipo=1;
    Trans = cell2mat(cVis(:,5));
    Trans=1-Trans; % inverte
end

aV=aData(:,5:16);
aV=cellfun(@str2num,aV);

% Redefine 'Ground' para plotagem:
nExt=3; % Define quantos métros além dos planos externos máximos será exibido [after: defined by user !?]
nXMax=max(max(aV([1:12 14:end],[1 4 7 10])));
nXMin=min(min(aV([1:12 14:end],[1 4 7 10])));
nYMax=max(max(aV([1:12 14:end],[2 5 8 11])));
nYMin=min(min(aV([1:12 14:end],[2 5 8 11])));
aV(13,[1 10])=nXMax+nExt;
aV(13,[4 7])=nXMin-nExt;
aV(13,[2 5])=nYMax+nExt;
aV(13,[8 11])=nYMin-nExt;

% Prepara matriz para plotagem 
nTotPl = size(aData,1);
aVX=aV(:,1:3:end);
aVY=aV(:,2:3:end);
aVZ=aV(:,3:3:end);
aVX(:,5)=aVX(:,1);
aVY(:,5)=aVY(:,1);
aVZ(:,5)=aVZ(:,1);
axes(handles.tAxesPreview)

% Desenha Perspectiva 3d
% Se existirem planos de pré-visualização anteriores, apaga-os

aPrevChild=handles.tAxesPreview.Children;
nSizePreviewNow=size(aPrevChild,1);
nSizePreviewOrig=str2double(get(handles.tVisPlotSize,'String'));

if nSizePreviewNow>nSizePreviewOrig %Já há pré-visualização sendo exibida
    % Apagar pre-visualização anterior
    for nD=nSizePreviewOrig+1:nSizePreviewNow
        delete(handles.tAxesPreview.Children(1));
    end
end

for iPl=16:nTotPl  %Planos adicionais
  if lCor
    if lTipo == 0
      plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'Color',sColor(iPl,:),'Tag',num2str(aData{iPl,1}))
    else
      fill3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),sColor(iPl,:),'FaceAlpha',Trans(iPl,:),'Tag',num2str(aData{iPl,1}))
    end
  else
    if lTipo == 0
      plot3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),'Color',sColor(iPl,:),'Tag',num2str(aData{iPl,1}))
    else
      fill3(aVX(iPl,:),aVY(iPl,:),aVZ(iPl,:),sColor(iPl,:),'FaceAlpha',Trans(iPl,:),'Tag',num2str(aData{iPl,1}))
    end
  end
end

axis equal

set(get(gca,'XLabel'),'String','X','FontWeight','bold','FontSize',12)
set(get(gca,'YLabel'),'String','Y','FontWeight','bold','FontSize',12)
set(get(gca,'ZLabel'),'String','N','FontWeight','bold','FontSize',12)

%Abre Dados globais ao carregar projeto, e chama fRoomPreview para desenhar
function fOpenProject(hObject,eventdata,handles,sMens)
% 2014.03.10 v 7.1.5 Beta - Multilanguage - Pedro
% 2016.02.12 v. 8.0 - Pedro - Inserido um campo em cPlane, no final, para a
% nova ordem de tipo. antes haviam tipos<0, 0 e >1..agora os tipossão -1, 0 e numéricos positivos
% 2017.09.02 v. 8.0 - Pedro - Limpa e melhora comentários; mudança na matriz que exibe os dados
% 2017.09.05 v.8.0 - Pedro - Corrige tabela invertida, exibe novo tipo de plano, Tira cPlane do global
% 2017.09.12 v.8.0 - Pedro - Insere campo 'Grupo' nos planos 
% 2017.09.13 v.8.0 - Pedro - Insere guia de projetos
% 2017.09.22 v8.0 - Pedfro/Orestes - Atualiza para abrir arquivo de janelas
% 2017.09.27 v8.0 - Pedro - Corrige numeração de projetos quando um novo projeto é criado

global sInputDir spcodeDir 

% Carrega Arquivo de geometria
sFileRoomGeom='bRoomGeom.tlx';
if exist([sInputDir '\' sFileRoomGeom],'file')
    load([sInputDir '\' sFileRoomGeom],'-mat','cRoomGeom')
    [nTRoom,~]=size(cRoomGeom); 
else % Nenhum projeto criado!
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');
    close(gcf)
    errordlg(ErrorDlg.bRoomGeommatNotFound)
    return
end
  
if isempty(cRoomGeom) %Não foi criado nenhum projeto
    set(handles.tProjectQt2,'String','0');
    set(handles.tProjectQt1,'String','0');
    % Exibir tabela vazia, apenas com os títulos das colunas 
else %Carregar arquivo
    %Separa dados
    set(handles.tProjectQt2,'String',num2str(nTRoom));
    set(handles.tProjectQt1,'String',num2str(nTRoom));
    
    %Loop nos projetos
    aDataPl=get(handles.tTableProject,'Data');
    nSizePr=size(aDataPl,1);
    if nSizePr~=nTRoom || isempty(aDataPl{1})
        for nP=1:nTRoom
            aDataPrj{nP,1}=cRoomGeom{nP,1}; % %Número do Projeto
            aDataPrj{nP,2}=cRoomGeom{nP,2}; %Descrição 
            aDataPrj{nP,3}=cRoomGeom{nP,3}; %X 
            aDataPrj{nP,4}=cRoomGeom{nP,4}; %Y 
            aDataPrj{nP,5}=cRoomGeom{nP,5}; %Z
            aDataPrj{nP,6}=cRoomGeom{nP,6}; %Zc 
            aDataPrj{nP,7}=1; %Águas
            aDataPrj{nP,11}=cRoomGeom{nP,7}; %cWP 
            aDataPrj{nP,12}=cRoomGeom{nP,8}; %cFH
            aDataPrj{nP,13}=cRoomGeom{nP,9}; %cWT
            aDataPrj{nP,14}=cRoomGeom{nP,10}; %cCT
            aDataPrj{nP,15}=cRoomGeom{nP,11}; %cFT
            aDataPrj{nP,8}=cRoomGeom{nP,12}; %cWinPl
            aDataPrj{nP,9}=cRoomGeom{nP,13}; %cWinH
            aDataPrj{nP,10}=cRoomGeom{nP,14}; %cWinV
        end

        % Verifica se a lista de projetos precisa ser atualizada
        set(handles.tTableProject,'Data',aDataPrj);
    end
end

%Abre arquivos de plano
nRoomNum=str2double(get(handles.tRoomNum,'String'));
sRoomNum=fPut0(nRoomNum,3);
sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; %nome do arquivo de planos
if isnan(nRoomNum)|| isempty(nRoomNum) % se o campo de projeto está vazio, abre pelo arquivo de planos %Novo Projeto!
    set(handles.tRoomNum,'String','1');
    nRoomNum=str2double(get(handles.tRoomNum,'String'));
    sRoomNum=fPut0(nRoomNum,3);
    sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; %nome do arquivo de planos
    load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
else %O campo de projeto está preenchido
    if exist(sFilePl,'file')==2
        load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
    else
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
        return
    end
end

% Erro caso cPlane não exista no arquivo
if exist('cPlane','var')==0
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.cPlaneNotFoundIn ' ' sFilePl ' (E0087)']); 
    return
end

% Erro caso cPlane esteja vazio no arquivo
if isempty(cPlane) %#ok<*NODEF>
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cPlaneIsEmptyFile ' '  sFilePl ' ' ErrorDlg.MightBeCorrupted ' (E0098)'];	
    errordlg(sMens);
    return
end

% alteração para computar a nova metodologia de tiposde planos - PEDRO 2016
aPlaneNum=cell2mat(cPlane(:,1));
% PEDRO 2016- Testa se o arquivo de cPlane Já está configurado para o novo tipo de planos 
nTPlane=size(cPlane,2);
if nTPlane==7 % Cria o novo campo
    nTPlane=length(aPlaneNum);
    for k=1:nTPlane
        if cPlane{k,2}<0
            cPlane{k,8}=-1; %#ok<*AGROW>
        elseif cPlane{k,2}==0
            cPlane{k,8}=0;
        else
            cPlane{k,8}=1;
        end
    end
    save(sFilePl,'-mat','cPlane');
end

%Pedro 2017 - Testa se o arquivo já possui o campo de grupos, se não o cria
nTPlane=size(cPlane,2);
if nTPlane==8 % Cria o novo campo
    nTPlane=length(aPlaneNum);
    for k=1:nTPlane
        cPlane{k,9}=1; %#ok<*AGROW>
    end
    save(sFilePl,'-mat','cPlane');
end

% Carrega informações da visualização
sFileVis=[sInputDir '\bVis' sRoomNum '.tlx'];
if exist(sFileVis,'file')==0 %Se não existe arquivo de visualização
    cVis=cPlane(:,1);
    cVis(:,2:4)={0.5};  % Define toda superfície como cinza
    cVis(:,5)={0.7}; % Define Transparência em 30% 
    save(sFileVis,'-mat','cVis')
else
    load(sFileVis,'-mat','cVis'); % Carrega: cVis
end
if exist('cVis','var')==0
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cVisNotFoundIn ' '  sFile ' (E0157)'];	
    errordlg(sMens);return
end
if isempty(cVis)
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cVisIsEmptyFile ' '  sFile ' ' ErrorDlg.MightBeCorrupted ' (E0158)'];	
    errordlg(sMens);
    return
end

% Verifica compatibilidade dos arquivos de planos e de visualização
[nTotPla,~]=size(cPlane);  % lê o número de planos para comparar com o arquivo de visualização (nTotPl==nTotVis)
[nTotVis,~]=size(cVis); % lê o número de planos para comparar com o arquivo de visualização (nTotPl==nTotVis)
if nTotVis<nTotPla % Inclui novos planos com valores padrão
    for nPlV=nTotVis+1:nTotPla
        cVis(nPlV,1)={nPlV};
    end
    cVis(nTotVis+1:nTotPla,2:4)={0.5}; % Define toda superfície como cinza
    cVis(nTotVis+1:nTotPla,5)={0.2}; % Define transparência = 20%  (OBS: value should be inverted to 1=transparency 0=opaque)
    % Salva Arquivo 
    save(sFileVis,'-mat','cVis')
end


% Novo formato de exibição - ORESTES 2016
[nTPl,~]=size(cPlane); % Número de planos no arquivo
aData=cell(nTPl,15); % Cria matriz vazia de dados
aDataVis1=cell(nTPl,3); % Cria matriz vazia de dados de visualização

for k=1:nTPl % Isola as coordenadas e a descrição de cala plano e cria a matriz de dados para exibição 
    
    aData{k,1}=cPlane{k,1}; %Número
    aData{k,2}=cPlane{k,2}; %Tipo
    %Se a descrição estiver vazia, insere um campo genérico
    if isempty(cPlane{k,9}) 
        aData{k,3}=1; 
    else
        aData{k,3}=cPlane{k,9}; %Grupo
    end
    aData{k,4}=cPlane{k,3}; % Descrição
    
    % Importa casas decimais
    nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
    aData{k,5}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(1))']);
    aData{k,6}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(2))']);
    aData{k,7}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(3))']);
    aData{k,8}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(1))']);
    aData{k,9}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(2))']);
    aData{k,10}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(3))']);
    aData{k,11}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(1))']);
    aData{k,12}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(2))']);
    aData{k,13}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(3))']);
    aData{k,14}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(1))']);
    aData{k,15}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(2))']);
    aData{k,16}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(3))']);
    nColw=35;
    aColWidth={25,30,39,135,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw};

    
    %Matriz de visualização
    aDataVis1{k,1}=num2str(cVis{k,1}); %Número
    aDataVis1{k,2}=cPlane{k,3}; %Descrição
    nColor=[cVis{k,2} cVis{k,3} cVis{k,4}];
    nColor=dec2hex(round(nColor*255),2)'; nColor = ['#';nColor(:)]';
    aDataVis1{k,3}=strcat('<html><body bgcolor="',nColor,'">','................');
    aDataVis1{k,4}=cVis{k,5}; % Transparência
end

% Abre arquivos de Janelas
sFileWin=[sInputDir '\bWindow' sRoomNum '.tlx']; %nome do arquivo de janelas

if exist(sFileWin,'file')
    load(sFileWin,'-mat','cWindow'); % % load file
    if ~exist('cWindow','var')
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cWindowNotFoundIn ' ' sFileWin ' (E0080)']);
        return
    end
    if isempty(cWindow) %#ok<*USENS>
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cWindowIsEmptyFile ' '  sFileWin ' ' ErrorDlg.MightBeCorrupted ' (E0112)']);
        return
    end
    
    nTWin=size(cWindow,1);
    
    if nTWin>0
        for i=1:2:nTWin
            nPos(i)=cWindow{i,2}; 
            nPos(i+1)=cWindow{i+1,2};
        end
        for i=1:nTWin
            wDesc{i}=cPlane{nPos(i),3};
        end
    end
   
   for k=1:nTWin
       aDataWin{k,1}=cWindow{k,1}; %Número
       aDataWin{k,2}=cWindow{k,4}; %Tipo
       aDataWin{k,3}=cWindow{k,2}; %Plano
       aDataWin{k,4}=wDesc{k}; %Descrição do plano
       
       aDataWin{k,5}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,5}(1))']); %X1
       aDataWin{k,6}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,5}(2))']); %Y1
       aDataWin{k,7}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,5}(3))']); %Z1
       aDataWin{k,8}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,6}(1))']); %X2
       aDataWin{k,9}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,6}(2))']); %Y2
       aDataWin{k,10}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,6}(3))']); %Z2
       aDataWin{k,11}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,7}(1))']); %X3
       aDataWin{k,12}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,7}(2))']); %Y3
       aDataWin{k,13}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,7}(3))']); %Z3
       aDataWin{k,14}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,8}(1))']); %X4
       aDataWin{k,15}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,8}(2))']); %Y4
       aDataWin{k,16}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,8}(3))']); %Z4
   end
   
else
    if sMens
        load([spcodeDir '\bLangDef.tlx'],'-mat','WarnDlg');  %Load Language File
        uiwait(warndlg(WarnDlg.NoWindowWasAutomaticCreatedItMustBeDoneIn));
    end
    aDataWin=[];
end

% Abre arquivos de características dos materiais
sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];

if ~exist(sFileMat,'file') ||  isnan(nRoomNum) || isempty(nRoomNum)
    load([spcodeDir '\bLangDef.tlx'],'-mat','UiGet');  %Load Language File
	[sFileMat,~]=uigetfile('bMat*.tlx',UiGet.MaterialFiles);
	if exist(sFileMat,'file') %#ok<ALIGN>
        load(sFileMat,'-mat','cMat'); %Carrega arquivo
    else
        return
    end  
  sRoomNum=sFileMat(end-6:end-4);% get last 3 numbers
  set(handles.tRoomNum,'string',sRoomNum)
else
  load(sFileMat,'-mat','cMat') %Carrega arquivo
end
if ~exist('cMat','var')
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([ErrorDlg.cMatNotFoundIn ' ' sFileMat ' (E0071)']); 
    return
end
if isempty(cMat) 
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([ErrorDlg.cMatIsEmptyFile ' '  sFileMat ' ' ErrorDlg.MightBeCorrupted ' (E0097)']);	
    return
end

[nTMat,~]=size(cMat); %Tamanho da variável
cDesc=(cPlane(:,3));

for k=1:nTMat
    aDataMat{k,1}=cMat{k,1}; % %Número
    aDataMat{k,2}=cDesc{k}; %Descriçao
    aDataMat{k,3}=[]; %Cor
        aDataMat{k,4}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,2})']); %Refletância Difusa
        aDataMat{k,5}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,3})']); %Refletância Especular
        aDataMat{k,6}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,4})']); %Transmitância Difusa
        aDataMat{k,7}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,5})']); %Transmitância Especular
end

%Exibe dados de janealas
set(handles.tTableWin,'Data',aDataWin)

%Exibe dados dos planos
set(handles.tTablePlanes,'Data',aData,'ColumnWidth',aColWidth) % Carrega a tabela com os dados 

%Exibe Dados da Visualização
set(handles.tTableVis,'Data',aDataVis1)

%Exibe dados dos materiais
set(handles.tTableMat,'Data',aDataMat)

% Torna tabela de janelas não editavel
set(handles.tTableWin,'ColumnEditable',logical([0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]));

fRoomPreview(handles); % Preview PEDRO 2016

% Atualiza visualização com planos apagados ou modificados
function fUpdatePlanePreview(handles,nP,iNew,iUpDt)
% Atualiza exibição caso algum dado de planos ou de visualização tenha sido
% alterado ou esteja sendo criado
% Inputs:   Handles
%           nP - Vetor de planos (se apagados, devem vir negativos)
%           iNew - Lógico (1=Novo Plano, 0=Mesmos planos)
%           
% Autor: Pedro
% 2017.10.15 v8 - Pedro - Atualiza também planos apagados

axes(handles.tAxesPreview);
nDes=get(handles.ttVisDestacColor,'Value');

if isempty(nP) %reset na visualização
    aChildrenNow=handles.tAxesPreview.Children;

    % Atualiza informações do plano alterado
    aData=get(handles.tTablePlanes,'Data');
    aDataVis=get(handles.tTableVis,'Data');

    nObj=findobj(aChildrenNow,'Type','Quiver');
    nSizeObj=size(nObj,1);
    for nO=1:nSizeObj
        nP(nO)=str2double(nObj(nO).Tag);
    end
    
    
    
    % Realiza operação nos planos
    for nPlaneNum=nP %Loop na quantidade de planos criados

        % Cria Matriz de Visualização
        nColor=aDataVis{nPlaneNum,3};
        nPosColor=find(nColor=='#');
        nColor=hex2rgb(nColor(nPosColor:nPosColor+6));
        cVis{1,1}=nPlaneNum;
        cVis{1,2}=nColor(1);  % Cor R
        cVis{1,3}=nColor(2);  % Cor G
        cVis{1,4}=nColor(3);  % Cor B
        cVis{1,5}=aDataVis{nPlaneNum,4};  % Transparência
 
        % Identifica o tipo de visualização
        nCol=get(handles.tVisPrevColour,'Value');
        if nCol==0 %Preto e Branco
            sColor=zeros(1,3);
        else %Colorido
            sColor=cell2mat([cVis(:,2) cVis(:,3) cVis(:,4)]);
        end
        nTy=get(handles.tVisPrevSolid,'Value');
        if nTy==0 %Sólido
            lTipo=0;
        else %Estrutura de Arame
            lTipo=1;
            Trans=cell2mat(cVis(:,5));
            Trans=1-Trans; % inverte
        end
        
        % Redefine 'Ground' para plotagem:
        aV=aData(:,5:16);
        aV=cellfun(@str2num,aV(:,:));

        % Prepara matriz para plotagem 
        aVX=aV(:,1:3:end);
        aVY=aV(:,2:3:end);
        aVZ=aV(:,3:3:end);
        aVX(:,5)=aVX(:,1);
        aVY(:,5)=aVY(:,1);
        aVZ(:,5)=aVZ(:,1);

        % Cria novo
        if nPlaneNum~=13
            if lTipo == 0
                % Apaga o plano e a seta
                delete(findobj(aChildrenNow,'Type','Line','-and','Tag',num2str(nPlaneNum)));
                delete(findobj(aChildrenNow,'Type','Quiver','-and','Tag',num2str(nPlaneNum)));
                % Desenha Novo
                plot3(aVX(nPlaneNum,:),aVY(nPlaneNum,:),aVZ(nPlaneNum,:),'Color',sColor(1,:),'Tag',num2str(aData{nPlaneNum,1}));
            else
                % Apaga o plano e a seta
                delete(findobj(aChildrenNow,'Type','Patch','-and','Tag',num2str(nPlaneNum)));
                delete(findobj(aChildrenNow,'Type','Quiver','-and','Tag',num2str(nPlaneNum)));
                % Desenha Novo
                fill3(aVX(nPlaneNum,:),aVY(nPlaneNum,:),aVZ(nPlaneNum,:),sColor(1,:),'FaceAlpha',Trans(1,:),'Tag',num2str(aData{nPlaneNum,1}));
            end
        end
    end 
elseif nP<0 %Planos apagados
    nDelPlanes=size(nP,2);
    for nD=1:nDelPlanes %Loop na quantidade de planos apagados
        nPlaneNum=-nP(nD);
        aTagsPl=get(handles.tAxesPreview.Children,'Tag');
        aTagsPl=cellfun(@str2num,aTagsPl);
        aFindPl=aTagsPl';
        
        % Encontra posição do plano no Children
        nPos=find(aFindPl==nPlaneNum);

        % Apaga Plano 
        delete(handles.tAxesPreview.Children(nPos)); %#ok<FNDSB>
        
        %Verifica se tem vetor e apaga
        nPosQ=find(aFindPl==0);
        % Apaga Seta, Caso exista
        if ~isempty(nPosQ)
            delete(handles.tAxesPreview.Children(nPosQ))
        end
      
    end
else %Planos Criados ou alterados
    if nDes==1
        aChildrenNow=handles.tAxesPreview.Children;

        % Atualiza informações do plano alterado
        aData=get(handles.tTablePlanes,'Data');
        aDataVis=get(handles.tTableVis,'Data');
        
        if iUpDt
            % Corrige visualização dos dados na linha 
            % Importa casas decimais
            nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
            aData{nP,5}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,5}))']);
            aData{nP,6}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,6}))']);
            aData{nP,7}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,7}))']);
            aData{nP,8}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,8}))']);
            aData{nP,9}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,9}))']);
            aData{nP,10}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,10}))']);
            aData{nP,11}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,11}))']);
            aData{nP,12}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,12}))']);
            aData{nP,13}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,13}))']);
            aData{nP,14}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,14}))']);
            aData{nP,15}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,15}))']);
            aData{nP,16}=eval(['sprintf(''%2.' nDec 'f'', str2double(aData{nP,16}))']); 

            %Exibe dados dos planos
            set(handles.tTablePlanes,'Data',aData);
            
            %Mantém Scrol na Posição
            jScrollpane=findjobj(handles.tTablePlanes);
            scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
            nData=size(get(handles.tTablePlanes,'Data'),1);
            nPos=(scrollMax/nData)*(nP-1);
            jScrollpane.getVerticalScrollBar.setValue(floor(nPos));   % Coloca o Scroll na posição
        end

        % Realiza operação nos planos
        for nPlaneNum=nP %Loop na quantidade de planos criados

            % Cria Matriz de Visualização
            if iNew %Novo plano já criado
                nColor=aDataVis{nPlaneNum,3};
                nPosColor=find(nColor=='#');
                nColor=hex2rgb(nColor(nPosColor:nPosColor+6));
                cVis{1,1}=nPlaneNum;
                cVis{1,2}=nColor(1);  % Cor R
                cVis{1,3}=nColor(2);  % Cor G
                cVis{1,4}=nColor(3);  % Cor B
                cVis{1,5}=aDataVis{nPlaneNum,4};  % Transparência
            else % Novo plano sendo pré-visualizado na criação ou destacado
                nColor=get(handles.tVisDestacColor,'BackgroundColor');
                cVis{1,1}=nPlaneNum;
                cVis{1,2}=nColor(1);  % Cor R
                cVis{1,3}=nColor(2);  % Cor G
                cVis{1,4}=nColor(3);  % Cor B
                cVis{1,5}=0.2;  % Transparência
            end

            % Identifica o tipo de visualização
            nCol=get(handles.tVisPrevColour,'Value');
            if nCol==0 %Preto e Branco
                if iNew
                    sColor=zeros(1,3);
                else
                    sColor=cell2mat([cVis(:,2) cVis(:,3) cVis(:,4)]);
                end
            else %Colorido
                sColor=cell2mat([cVis(:,2) cVis(:,3) cVis(:,4)]);
            end
            nTy=get(handles.tVisPrevSolid,'Value');
            if nTy==0 %Sólido
                lTipo=0;
            else %Estrutura de Arame
                lTipo=1;
                Trans=cell2mat(cVis(:,5));
                Trans=1-Trans; % inverte
            end

            % Redefine 'Ground' para plotagem:
            aV=aData(:,5:16);
            aV=cellfun(@str2num,aV(:,:));

            % Prepara matriz para plotagem 
            aVX=aV(:,1:3:end);
            aVY=aV(:,2:3:end);
            aVZ=aV(:,3:3:end);
            aVX(:,5)=aVX(:,1);
            aVY(:,5)=aVY(:,1);
            aVZ(:,5)=aVZ(:,1);

            % Cria novo
            if nPlaneNum~=13
                if lTipo == 0
                    % Apaga o plano e a seta
                    delete(findobj(aChildrenNow,'Type','Line','-and','Tag',num2str(nPlaneNum)));
                    delete(findobj(aChildrenNow,'Type','Quiver','-and','Tag',num2str(nPlaneNum)));
                    %Desenha novo
                    plot3(aVX(nPlaneNum,:),aVY(nPlaneNum,:),aVZ(nPlaneNum,:),'Color',sColor(1,:),'Tag',num2str(aData{nPlaneNum,1}));
                else
                    % Apaga o plano e a seta
                    delete(findobj(aChildrenNow,'Type','Patch','-and','Tag',num2str(nPlaneNum)));
                    delete(findobj(aChildrenNow,'Type','Quiver','-and','Tag',num2str(nPlaneNum)));
                    % Desenha Novo
                    fill3(aVX(nPlaneNum,:),aVY(nPlaneNum,:),aVZ(nPlaneNum,:),sColor(1,:),'FaceAlpha',Trans(1,:),'Tag',num2str(aData{nPlaneNum,1}));
                end

                % Desenha seta de direção
                if ~iNew
                    %Acha Centroide do Plano
                    nX=mean([aVX(nPlaneNum,1) aVX(nPlaneNum,2) aVX(nPlaneNum,3) aVX(nPlaneNum,4)]);
                    nY=mean([aVY(nPlaneNum,1) aVY(nPlaneNum,2) aVY(nPlaneNum,3) aVY(nPlaneNum,4)]);
                    nZ=mean([aVZ(nPlaneNum,1) aVZ(nPlaneNum,2) aVZ(nPlaneNum,3) aVZ(nPlaneNum,4)]);
                    nVector=cross([aVX(nPlaneNum,3)-aVX(nPlaneNum,2) aVY(nPlaneNum,3)-aVY(nPlaneNum,2) aVZ(nPlaneNum,3)-aVZ(nPlaneNum,2)],[aVX(nPlaneNum,1)-aVX(nPlaneNum,2) aVY(nPlaneNum,1)-aVY(nPlaneNum,2) aVZ(nPlaneNum,1)-aVZ(nPlaneNum,2)]);
                    nNormVec=norm(nVector);
                    nCosDir=nVector/nNormVec;
                    quiver3(nX,nY,nZ,nCosDir(1),nCosDir(2),nCosDir(3),'LineWidth',3,'Color',get(handles.tVisDestacColor,'BackgroundColor'),'MaxHeadSize',3,'AutoScaleFactor',1.5,'Tag',num2str(aData{nPlaneNum,1}));
                end
            end
        end
    end
end

% Set na quantidade de elementos plotados
nPlotChild=handles.tAxesPreview.Children;
nPlotSize=size(nPlotChild,1);
set(handles.tVisPlotSize,'String',num2str(nPlotSize));

%Cria Lista para seleção de Janelas
function cListWin=fWinList(sRoom)
% Cria matriz com os nomes das janelas
% Adaptado de fChooseWindow
% choose window number from cRoomGeom
% 2007.10.17 v 3.09
% rcc
% 2014.04.02 v 7.1.8 Beta - Multilanguage - Pedro
% 2017.08.24 v8 rcc

global spcodeDir sInputDir

sFileWin=[sInputDir '\bWindow' sRoom '.tlx'];
sFilePl=[sInputDir '\bPlane' sRoom '.tlx'];
if exist(sFileWin,'file')
	load(sFileWin,'-mat','cWindow');
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
	errordlg([sFileWin ' ' ErrorDlg.NotFound ' (E0107)'])
	return
end
if exist(sFilePl,'file')
    load(sFilePl,'-mat','cPlane');
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)'])
    set(nTFig,'String','')
    return
end
p=0; % posição na celula de janelas
load([spcodeDir '\bLangDef.tlx'],'-mat','ListDlg');  %Load Language File
for k=1:2:size(cWindow,1) % % percorre janelas impares
    p=p+1;
    cListWin{p}=[ListDlg.Window ' ' fPut0(cell2mat(cWindow(k,1)),3) ' ' ListDlg.OnPlane ' ' fPut0(cell2mat(cWindow(k,2)),3) ' - ' cPlane{cWindow{k,2},3}]; % % grava dados da janela
end

 % Atualiza dados da exibição (apenas os dados, não a visualização)
function fUpdateData(handles,nPlanes,iNew)
% Atualiza dados da exibiçao após criar ou apagar elementos
% Baseada em fOpenProject
% Autor: Pedro 2017

% Atualizações:

global sInputDir spcodeDir 

% Importa Dados exibidos
aPlaneNow=get(handles.tTablePlanes,'Data');
aMatNow=get(handles.tTableMat,'Data');
aVisNow=get(handles.tTableVis,'Data');

% Abre arquivos de plano
nRoomNum=str2double(get(handles.tRoomNum,'String'));
sRoomNum=fPut0(nRoomNum,3);
sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; %nome do arquivo de planos

if exist(sFilePl,'file')==2
    load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
else
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
    return
end

% Erro caso cPlane não exista no arquivo
if exist('cPlane','var')==0
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    errordlg([ErrorDlg.cPlaneNotFoundIn ' ' sFilePl ' (E0087)']); 
    return
end

% Erro caso cPlane esteja vazio no arquivo
if isempty(cPlane) %#ok<*NODEF>
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cPlaneIsEmptyFile ' '  sFilePl ' ' ErrorDlg.MightBeCorrupted ' (E0098)'];	
    errordlg(sMens);
    return
end

% Abre arquivos de visualização
sFileVis=[sInputDir '\bVis' sRoomNum '.tlx'];
if exist(sFileVis,'file')==0 %Se não existe arquivo de visualização
    cVis=cPlane(:,1); 
    cVis(:,2:4)={0.5};  % Define toda superfície como cinza
    cVis(:,5)={0.7}; % Define Transparência em 30% 
    save(sFileVis,'-mat','cVis')
else
    load(sFileVis,'-mat','cVis'); % Carrega: cVis
end

% Erro caso cVis não exista no arquivo
if exist('cVis','var')==0
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cVisNotFoundIn ' '  sFile ' (E0157)'];	
    errordlg(sMens);
    return
end

% Erro caso cVis esteja vazio no arquivo
if isempty(cVis)
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
    sMens=[ErrorDlg.cVisIsEmptyFile ' '  sFile ' ' ErrorDlg.MightBeCorrupted ' (E0158)'];	
    errordlg(sMens);
    return
end

% Abre arquivos de características dos materiais
sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];
if ~exist(sFileMat,'file') 
    load([spcodeDir '\bLangDef.tlx'],'-mat','UiGet');  %Load Language File
	[sFileMat,~]=uigetfile('bMat*.tlx',UiGet.MaterialFiles);
	if exist(sFileMat,'file') %#ok<ALIGN>
        load(sFileMat,'-mat','cMat'); %Carrega arquivo
    else
        return
    end  
    sRoomNum=sFileMat(end-6:end-4);% get last 3 numbers
    set(handles.tRoomNum,'string',sRoomNum)
else
    load(sFileMat,'-mat','cMat') %Carrega arquivo
end
if ~exist('cMat','var')
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([ErrorDlg.cMatNotFoundIn ' ' sFileMat ' (E0071)']); 
    return
end
if isempty(cMat) 
    load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
    errordlg([ErrorDlg.cMatIsEmptyFile ' '  sFileMat ' ' ErrorDlg.MightBeCorrupted ' (E0097)']);	
    return
end

% Verifica compatibilidade dos arquivos de planos e de visualização
[nTotPla,~]=size(cPlane);  % lê o número de planos para comparar com o arquivo de visualização (nTotPl==nTotVis)
[nTotVis,~]=size(cVis); % lê o número de planos para comparar com o arquivo de visualização (nTotPl==nTotVis)
if nTotVis<nTotPla % Inclui novos planos com valores padrão
    for nPlV=nTotVis+1:nTotPla
        cVis(nPlV,1)={nPlV};
    end
    cVis(nTotVis+1:nTotPla,2:4)={0.5}; % Define toda superfície como cinza
    cVis(nTotVis+1:nTotPla,5)={0.2}; % Define transparência = 20%  (OBS: value should be inverted to 1=transparency 0=opaque)
    save(sFileVis,'-mat','cVis');
end

% Verifica a situação e define qual o tipo de atualização
if size(aPlaneNow,1)~=size(aMatNow,1) %Novo Plano foi criado! precisa inserir o novo plano em materiais e em visualização
    cDescMat=(cPlane(:,3));
    if iNew
        for k=nPlanes % Isola as coordenadas e a descrição de cada plano e cria a matriz de dados para exibição 
            aPlaneNow{k,1}=cPlane{k,1}; %Número
            aPlaneNow{k,2}=cPlane{k,2}; %Tipo
            %Se a descrição estiver vazia, insere um campo genérico
            if isempty(cPlane{k,9}) 
                aPlaneNow{k,3}=1; 
            else
                aPlaneNow{k,3}=cPlane{k,9}; %Grupo
            end
            aPlaneNow{k,4}=cPlane{k,3}; % Descrição
            nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
            aPlaneNow{k,5}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(1))']);
            aPlaneNow{k,6}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(2))']);
            aPlaneNow{k,7}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(3))']);
            aPlaneNow{k,8}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(1))']);
            aPlaneNow{k,9}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(2))']);
            aPlaneNow{k,10}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(3))']);
            aPlaneNow{k,11}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(1))']);
            aPlaneNow{k,12}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(2))']);
            aPlaneNow{k,13}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(3))']);
            aPlaneNow{k,14}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(1))']);
            aPlaneNow{k,15}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(2))']);
            aPlaneNow{k,16}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(3))']);

            %Matriz de visualização
            aVisNow{k,1}=num2str(cVis{k,1}); %Número
            aVisNow{k,2}=cPlane{k,3}; %Descrição
            nColor=[cVis{k,2} cVis{k,3} cVis{k,4}];
            nColor=dec2hex(round(nColor*255),2)'; nColor = ['#';nColor(:)]';
            aVisNow{k,3}=strcat('<html><body bgcolor="',nColor,'">','................');
            aVisNow{k,4}=cVis{k,5}; % Transparência

            % matriz de materiais
            aMatNow{k,1}=cMat{k,1}; % %Número
            aMatNow{k,2}=cDescMat{k}; %Descriçao
            aMatNow{k,3}=[]; %Cor
            nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
            aMatNow{k,4}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,2})']); %Refletância Difusa
            aMatNow{k,5}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,3})']); %Refletância Especular
            aMatNow{k,6}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,4})']); %Transmitância Difusa
            aMatNow{k,7}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,5})']); %Transmitância Especular
        end
    else %Cancelada criação de novo plano
        
        % Corrige tabelas de planos, visualizaçao e características
        [nTPl,~]=size(cPlane); % Número de planos no arquivo
        aPlaneNow=cell(nTPl,15); % Cria matriz vazia de dados
        aVisNow=cell(nTPl,3); % Cria matriz vazia de dados de visualização
        aMatNow=cell(nTPl,3); % Cria matriz vazia de dados de visualização

        for k=1:nTPl % Isola as coordenadas e a descrição de cala plano e cria a matriz de dados para exibição 

            aPlaneNow{k,1}=cPlane{k,1}; %Número
            aPlaneNow{k,2}=cPlane{k,2}; %Tipo
            %Se a descrição estiver vazia, insere um campo genérico
            if isempty(cPlane{k,9}) 
                aPlaneNow{k,3}=1; 
            else
                aPlaneNow{k,3}=cPlane{k,9}; %Grupo
            end
            aPlaneNow{k,4}=cPlane{k,3}; % Descrição
            nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
            aPlaneNow{k,5}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(1))']);
            aPlaneNow{k,6}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(2))']);
            aPlaneNow{k,7}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(3))']);
            aPlaneNow{k,8}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(1))']);
            aPlaneNow{k,9}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(2))']);
            aPlaneNow{k,10}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(3))']);
            aPlaneNow{k,11}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(1))']);
            aPlaneNow{k,12}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(2))']);
            aPlaneNow{k,13}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(3))']);
            aPlaneNow{k,14}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(1))']);
            aPlaneNow{k,15}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(2))']);
            aPlaneNow{k,16}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(3))']);

            %Matriz de visualização
            aVisNow{k,1}=num2str(cVis{k,1}); %Número
            aVisNow{k,2}=cPlane{k,3}; %Descrição
            nColor=[cVis{k,2} cVis{k,3} cVis{k,4}];
            nColor=dec2hex(round(nColor*255),2)'; nColor = ['#';nColor(:)]';
            aVisNow{k,3}=strcat('<html><body bgcolor="',nColor,'">','................');
            aVisNow{k,4}=cVis{k,5}; % Transparência

            aMatNow{k,1}=cMat{k,1}; %Número
            aMatNow{k,2}=cDescMat{k}; %Descriçao
            aMatNow{k,3}=[]; %Cor
            nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
            aMatNow{k,4}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,2})']); %Refletância Difusa
            aMatNow{k,5}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,3})']); %Refletância Especular
            aMatNow{k,6}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,4})']); %Transmitância Difusa
            aMatNow{k,7}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,5})']); %Transmitância Especular
            
            
        end
    end
    
    % %Exibe dados dos planos
    set(handles.tTablePlanes,'Data',aPlaneNow)
    
    % Vai para a última linha 
    %Desce a visualização para a linha criada (Java e nova função:findjobj)
    jScrollpane=findjobj(handles.tTablePlanes);
    scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
    jScrollpane.getVerticalScrollBar.setValue(scrollMax);   % Coloca o Scroll na posição

    %Exibe Dados da Visualização
    set(handles.tTableVis,'Data',aVisNow)

    %Exibe dados dos materiais
    set(handles.tTableMat,'Data',aMatNow)
else %Plano foi apagado ou editado
    cDescMat=(cPlane(:,3));
    if iNew
        for k=nPlanes % Isola as coordenadas e a descrição de cada plano e cria a matriz de dados para exibição 
            aPlaneNow{k,1}=cPlane{k,1}; %Número
            aPlaneNow{k,2}=cPlane{k,2}; %Tipo
            %Se a descrição estiver vazia, insere um campo genérico
            if isempty(cPlane{k,9}) 
                aPlaneNow{k,3}=1; 
            else
                aPlaneNow{k,3}=cPlane{k,9}; %Grupo
            end
            aPlaneNow{k,4}=cPlane{k,3}; % Descrição
            
            nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
            aPlaneNow{k,5}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(1))']);
            aPlaneNow{k,6}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(2))']);
            aPlaneNow{k,7}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(3))']);
            aPlaneNow{k,8}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(1))']);
            aPlaneNow{k,9}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(2))']);
            aPlaneNow{k,10}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(3))']);
            aPlaneNow{k,11}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(1))']);
            aPlaneNow{k,12}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(2))']);
            aPlaneNow{k,13}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(3))']);
            aPlaneNow{k,14}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(1))']);
            aPlaneNow{k,15}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(2))']);
            aPlaneNow{k,16}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(3))']); 
            
            
            %Matriz de visualização
            aVisNow{k,1}=num2str(cVis{k,1}); %Número
            aVisNow{k,2}=cPlane{k,3}; %Descrição
            nColor=[cVis{k,2} cVis{k,3} cVis{k,4}];
            nColor=dec2hex(round(nColor*255),2)'; nColor = ['#';nColor(:)]';
            aVisNow{k,3}=strcat('<html><body bgcolor="',nColor,'">','................');
            aVisNow{k,4}=cVis{k,5}; % Transparência

            % matriz de materiais
            aMatNow{k,1}=cMat{k,1}; %Número
            aMatNow{k,2}=cDescMat{k}; %Descriçao
            aMatNow{k,3}=[]; %Cor
            aMatNow{k,4}=cMat{k,2}; %Refletância Difusa
            aMatNow{k,5}=cMat{k,3}; %Refletância Especular
            aMatNow{k,6}=cMat{k,4}; %Transmitância Difusa
            aMatNow{k,7}=cMat{k,5}; %Transmitância Especular
        end
    else %Planos Apagados
        
        % Corrige tabelas de planos, visualizaçao e características
        [nTPl,~]=size(cPlane); % Número de planos no arquivo
        aPlaneNow=cell(nTPl,15); % Cria matriz vazia de dados
        aVisNow=cell(nTPl,3); % Cria matriz vazia de dados de visualização
        aMatNow=cell(nTPl,3); % Cria matriz vazia de dados de visualização

        for k=1:nTPl % Isola as coordenadas e a descrição de cala plano e cria a matriz de dados para exibição 

            aPlaneNow{k,1}=cPlane{k,1}; %Número
            aPlaneNow{k,2}=cPlane{k,2}; %Tipo
            %Se a descrição estiver vazia, insere um campo genérico
            if isempty(cPlane{k,9}) 
                aPlaneNow{k,3}=1; 
            else
                aPlaneNow{k,3}=cPlane{k,9}; %Grupo
            end
            aPlaneNow{k,4}=cPlane{k,3}; % Descrição
            nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
            aPlaneNow{k,5}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(1))']);
            aPlaneNow{k,6}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(2))']);
            aPlaneNow{k,7}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(3))']);
            aPlaneNow{k,8}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(1))']);
            aPlaneNow{k,9}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(2))']);
            aPlaneNow{k,10}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(3))']);
            aPlaneNow{k,11}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(1))']);
            aPlaneNow{k,12}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(2))']);
            aPlaneNow{k,13}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(3))']);
            aPlaneNow{k,14}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(1))']);
            aPlaneNow{k,15}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(2))']);
            aPlaneNow{k,16}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(3))']); 

            %Matriz de visualização
            aVisNow{k,1}=num2str(cVis{k,1}); %Número
            aVisNow{k,2}=cPlane{k,3}; %Descrição
            nColor=[cVis{k,2} cVis{k,3} cVis{k,4}];
            nColor=dec2hex(round(nColor*255),2)'; nColor = ['#';nColor(:)]';
            aVisNow{k,3}=strcat('<html><body bgcolor="',nColor,'">','................');
            aVisNow{k,4}=cVis{k,5}; % Transparência

            aMatNow{k,1}=cMat{k,1}; %Número
            aMatNow{k,2}=cDescMat{k}; %Descriçao
            aMatNow{k,3}=[]; %Cor
            nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
            aMatNow{k,4}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,2})']); %Refletância Difusa
            aMatNow{k,5}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,3})']); %Refletância Especular
            aMatNow{k,6}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,4})']); %Transmitância Difusa
            aMatNow{k,7}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,5})']); %Transmitância Especular
        end
    end
    % %Exibe dados dos planos
    set(handles.tTablePlanes,'Data',aPlaneNow)

    %Exibe Dados da Visualização
    set(handles.tTableVis,'Data',aVisNow)

    %Exibe dados dos materiais
    set(handles.tTableMat,'Data',aMatNow)
    
end

function fCutOfAngleSlatLengthLouvre(handles)

nType=get(handles.ttLouvreTypeProperties,'UserData');

if get(handles.ttLouvreSlatLengthBut,'Value')==1 % Calcula o Cut of Angle

    nLSlat=get(handles.tLouvreSlatLength,'UserData');
    nASlat=get(handles.tLouvreSlatAngle,'UserData');
    nTSlat=get(handles.tLouvreSlatTickness,'UserData');
    nNSlat=get(handles.tLouvreSlatQuantity,'UserData');
    aPlane=str2double(get(handles.tLouvrePoints,'Data'));

    %Define variaveis em função da posição
    nLSlat=nLSlat{nType}; 
    nTSlat=nTSlat{nType}; 
    nASlat=nASlat{nType}*3.1415/180;
    nNSlat=nNSlat{nType};

    % Rotaciona os pontos em torno do ângulo
    nXl=(-nLSlat/2)*cos(nASlat)-(-nTSlat/2)*sin(nASlat);
    nYl=(-nLSlat/2)*sin(nASlat)+(-nTSlat/2)*cos(nASlat);
    nX2=(nLSlat/2)*cos(nASlat)-(nTSlat/2)*sin(nASlat);
    nY2=(nLSlat/2)*sin(nASlat)+(nTSlat/2)*cos(nASlat);

    % Distância entre eixos de slat
    if nType>0 % Vertical ou Horizontal
        if nType==2 %Vertical
            aPointsRot(1,1)=aPlane(4,1); aPointsRot(1,2)=aPlane(4,2); aPointsRot(1,3)=aPlane(4,3);
            aPointsRot(2,1)=aPlane(1,1); aPointsRot(2,2)=aPlane(1,2); aPointsRot(2,3)=aPlane(1,3);
            aPointsRot(3,1)=aPlane(2,1); aPointsRot(3,2)=aPlane(2,2); aPointsRot(3,3)=aPlane(2,3);
            aPointsRot(4,1)=aPlane(3,1); aPointsRot(4,2)=aPlane(3,2); aPointsRot(4,3)=aPlane(3,3);
            aPlane=aPointsRot;
        end

        %Corrige matriz de pontos
        aPlaneF=[aPlane(1,:) aPlane(2,:) aPlane(3,:) aPlane(4,:)];

        %Cálculo do espaçamento entre slats
        aPoints=[aPlaneF(1,1:3);aPlaneF(1,4:6)];
        nDistS=pdist(aPoints); %Dsitancia Horizontal
        nSlats=nDistS/(nNSlat-1); %Distancia entre slats
    end

    nY2=nY2-nSlats;

    %Vetor vertical
    nVV=[nXl-nX2 nYl-nY2 0];

    %Vetor Horizontal
    nVH=[-1 0 0];

    nCutOfangle=atan2d(norm(cross(nVV,nVH)),dot(nVV,nVH));
    
    if nCutOfangle<0
        nCutOfangle=0;
    end

    % Salva valor e reexibe a visualização
    nLouvreCutOfAngleO=get(handles.tLouvreCutOfAngle,'UserData');
    nLouvreCutOfAngleO{nType,1}=nCutOfangle;
    set(handles.tLouvreCutOfAngle,'UserData',nLouvreCutOfAngleO,'String',num2str(round(nCutOfangle,2)));
else % Calcula o Slat Length

    nLouvreCutOfAngleO=get(handles.tLouvreCutOfAngle,'UserData');
    nLouvreCutOfAngle=nLouvreCutOfAngleO{nType,1};
    
%     nLSlat=get(handles.tLouvreSlatLength,'UserData');
    nASlat=get(handles.tLouvreSlatAngle,'UserData');
    nTSlat=get(handles.tLouvreSlatTickness,'UserData');
    nNSlat=get(handles.tLouvreSlatQuantity,'UserData');
    aPlane=cell2mat(get(handles.tLouvrePoints,'Data'));

    %Define variaveis em função da posição
    nTSlat=nTSlat{nType}; 
    nASlat=nASlat{nType}*3.1415/180;
    nNSlat=nNSlat{nType};

    % Distância entre eixos de slat
    if nType>0 % Vertical ou Horizontal
        if nType==2 %Vertical
            aPointsRot(1,1)=aPlane(4,1); aPointsRot(1,2)=aPlane(4,2); aPointsRot(1,3)=aPlane(4,3);
            aPointsRot(2,1)=aPlane(1,1); aPointsRot(2,2)=aPlane(1,2); aPointsRot(2,3)=aPlane(1,3);
            aPointsRot(3,1)=aPlane(2,1); aPointsRot(3,2)=aPlane(2,2); aPointsRot(3,3)=aPlane(2,3);
            aPointsRot(4,1)=aPlane(3,1); aPointsRot(4,2)=aPlane(3,2); aPointsRot(4,3)=aPlane(3,3);
            aPlane=aPointsRot;
        end

        %Corrige matriz de pontos
        aPlaneF=[aPlane(1,:) aPlane(2,:) aPlane(3,:) aPlane(4,:)];

        %Cálculo do espaçamento entre slats
        aPoints=[aPlaneF(1,1:3);aPlaneF(1,4:6)];
        nDistS=pdist(aPoints); %Dsitancia Horizontal
        nSlats=nDistS/(nNSlat-1); %Distancia entre slats
    end
    
    syms L
    nXl=(-L/2)*cos(nASlat)-(-nTSlat/2)*sin(nASlat);
    nYl=(-L/2)*sin(nASlat)+(-nTSlat/2)*cos(nASlat);
    nX2=(L/2)*cos(nASlat)-(nTSlat/2)*sin(nASlat);
    nY2=(L/2)*sin(nASlat)+(nTSlat/2)*cos(nASlat)-nSlats;
%     nX3=(-L/2)*cos(nASlat)-(nTSlat/2)*sin(nASlat);
    nY3=(-L/2)*sin(nASlat)+(nTSlat/2)*cos(nASlat)-nSlats;
    
    % Determina o ponto mais alto do slat inferior
    if nASlat==0 %Horizontal
        %Vetor vertical
        nVV=[nXl-nX2 nYl-nY2 0];
    elseif nASlat>0 % Lado positivo mais alto, fica com 2
        %Vetor vertical
        nVV=[nXl-nX2 nYl-nY2 0];
    else % Lado negativo mais alto, fica com 3
        %Vetor vertical
        nVV=[nXl-nX2 nYl-nY3 0];
    end
    
    %Vetor Horizontal
    nVH=[-1 0 0];
    
    yEqua=atan2d(norm(cross(nVV,nVH)),dot(nVV,nVH))==nLouvreCutOfAngle;
    nSlatLength=vpasolve(yEqua,L);
    
    
    if isempty(nSlatLength)
        warndlg('Error');
        return
        
    end

    % Salva valor e reexibe a visualização
    nLouvreSlatLengthO=get(handles.tLouvreSlatLength,'UserData');
    nLouvreSlatLengthO{nType,1}=double(nSlatLength);
    set(handles.tLouvreSlatLength,'UserData',nLouvreSlatLengthO,'String',num2str(round(double(nSlatLength),2)));
end


function fClearFieldsCreatePrism(handles)
global spcodeDir
set(handles.tElPrismOx,'string','0');
set(handles.tElPrismOz,'string','0');
set(handles.tElPrismOy,'string','0');
set(handles.tElPrismSizeX,'string','1');
set(handles.tElPrismSizeY,'string','1');
set(handles.tElPrismSizeZ,'string','1');
set(handles.tElPrismChXaY,'value',0);
set(handles.tElPrismAngXaY,'string','0');
set(handles.tElPrismChXaZ,'value',0);
set(handles.tElPrismAngXaZ,'string','0');
set(handles.tElPrismChYaX,'value',0);
set(handles.tElPrismAngYaX,'string',0);
set(handles.tElPrismChYaZ,'value',0);
set(handles.tElPrismAngYaZ,'string','0')
set(handles.tElPrismChZaX,'value',0);
set(handles.tElPrismAngZaX,'string','0');
set(handles.tElPrismChZaY,'value',0);
set(handles.tElPrismAngZaY,'string','0');
set(handles.tElPrismBaseElement,'value',1);
set(handles.tElPrismTopElement,'value',1)
set(handles.tElPrismSideElement,'value',1)
load([spcodeDir '\bLangDef.tlx'],'-mat','InputDlg');  %Load Language File
set(handles.ttElPrismElementName,'string',InputDlg.Element);


function fClearFieldsCreateCilynder(handles)
global spcodeDir
set(handles.tElCilynderTy,'string','0');
set(handles.tElCilynderTz,'string','1');
set(handles.tElCilynderTx,'string','0');
load([spcodeDir '\bLangDef.tlx'],'-mat','InputDlg');  %Load Language File
set(handles.tElCilynderElementName,'string',InputDlg.Element);
set(handles.tElCilynderSideElement,'value',1);
set(handles.tElCilynderTopElement,'value',1);
set(handles.tElCilynderBaseElement,'value',1);
set(handles.tElCilynderDiameter,'string','1');
set(handles.tElCilynderDivisions,'string','8');
set(handles.tElCilynderOy,'string',0');
set(handles.tElCilynderOz,'string',0');
set(handles.tElCilynderOx,'string',0');
set(handles.ttElCilynderTruncHeight,'string','0');
set(handles.tElCilynderTruncHeight,'value',0);


function fClearFieldsCreateSphere(handles)
global spcodeDir
set(handles.tElSphereOx,'string','3');
set(handles.tElSphereOz,'string','2');
set(handles.tElSphereOy,'string','3');
set(handles.tElSphereParalels,'string','8');
set(handles.tElSphereDiameter,'string','1');
set(handles.tElSphereBottonElement,'value',1);
set(handles.tElSphereTopElement,'value',1);
load([spcodeDir '\bLangDef.tlx'],'-mat','InputDlg');  %Load Language File
set(handles.tElSphereElementName,'String',InputDlg.Element);
set(handles.tElSphereMeridians,'string','8');


%~~~~~~~~~~~~~~~~ FUNÇÕES DA TAB DE PROTETORES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% --- Executes on button press in tOverhangButton.
function tOverhangButton_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Configura tabs
set(handles.tPanOverhang,'Visible','on');
set(handles.tPanLightshelf,'Visible','off');
set(handles.tPanLouvre,'Visible','off');
set(handles.tPanCanopy,'Visible','off');

% Abre janela
tOverhangImportWindow_Callback(hObject, eventdata, handles);

%Travar as outras abas
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');
set(handles.tPanElementButton,'Enable','off');

% --- Executes on button press in tLightshelfButton.
function tLightshelfButton_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Configura tabs
set(handles.tPanOverhang,'Visible','off');
set(handles.tPanLightshelf,'Visible','on');
set(handles.tPanLouvre,'Visible','off');
set(handles.tPanCanopy,'Visible','off');

% Abre janela
tLightshelfImportWindow_Callback(hObject, eventdata, handles);

%Travar as outras abas
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');
set(handles.tPanElementButton,'Enable','off');

% --- Executes on button press in tLouvreButton.
function tLouvreButton_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spcodeDir
load([spcodeDir '\bLangDef.tlx'],'-mat','Legend');  %Load Language File

% Configura tabs
set(handles.tPanOverhang,'Visible','off');
set(handles.tPanLightshelf,'Visible','off');
set(handles.tPanLouvre,'Visible','on','Title',Legend.Louvre,'UserData',1);
set(handles.tPanCanopy,'Visible','off');

%Travar as outras abas
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');
set(handles.tPanElementButton,'Enable','off');

% Salva no UserData dos campos os padrões de horizontal e vertical
set(handles.tLouvreName,'UserData',{Legend.HLouvre;Legend.VLouvre},'String',Legend.HLouvre);
set(handles.tLouvreAxisProjection,'UserData',{0;0},'String','0');
set(handles.tLouvreSlatLength,'UserData',{0.15;0.15},'String','0.15');
set(handles.tLouvreSlatTickness,'UserData',{0;0},'String','0');
set(handles.tLouvreCutOfAngle,'UserData',{20;20},'String','20');
set(handles.tLouvreSlatAngle,'UserData',{0;0},'String','0');
set(handles.tLouvreSlatQuantity,'UserData',{5;10},'String','5');

% Set no horizontal
set(handles.tLouvreTypeVertical,'Enable','off');
set(handles.tLouvreTypeHorizontal,'Enable','on');
set(handles.ttLouvreTypeProperties,'String',Legend.HorizontalProperties,'UserData',1);
set(handles.tLouvreTypeHorizontalCh,'Value',1);
set(handles.tLouvreTypeVerticalCh,'Value',0);

% Set nos botões
set(handles.tLouvreTypeHorizontal,'String',Legend.Horizontal);
set(handles.tLouvreTypeVertical,'String',Legend.Vertical);
set(handles.tLouvreImportPlane,'Visible','on');

% Abre janela
tLouvreImportWindow_Callback(hObject, eventdata, handles)

%Corrige campo do ângulo de corte
fCutOfAngleSlatLengthLouvre(handles)

% --- Executes on button press in tCanopyButton.
function tCanopyButton_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Configura tabs
set(handles.tPanOverhang,'Visible','off');
set(handles.tPanLightshelf,'Visible','off');
set(handles.tPanLouvre,'Visible','off');
set(handles.tPanCanopy,'Visible','on');

% Abre janela
tCanopyImportWindow_Callback(hObject, eventdata, handles);

%Travar as outras abas
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');
set(handles.tPanElementButton,'Enable','off');


function tOverhangCutOfAngle_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangCutOfAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mantém fixo o Slope Angle e muda o Slat Length

% Verifica o valor e compatibiliza com o comprimeito da marquise
% Carrega dados dos planos
aWinPoints=get(handles.tOverhangPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

% Carrega o valor do ângulo
nCutOfAngle=str2double(get(handles.tOverhangCutOfAngle,'String'))*pi/180;
nSlopeAngle=str2double(get(handles.tOverhangSlopeAngle,'String'))*pi/180;

%Coordenadas dos pontos de referência
% nXP1=aWinPoints{1,1};   nYP1=aWinPoints{1,2};   nZP1=aWinPoints{1,3};
nXP2=aWinPoints{2,1};   nYP2=aWinPoints{2,2};   nZP2=aWinPoints{2,3};
nXP3=aWinPoints{3,1};   nYP3=aWinPoints{3,2};   nZP3=aWinPoints{3,3};

% Distância Vertical
nDist=pdist([str2double(nXP2),str2double(nYP2),str2double(nZP2);str2double(nXP3),str2double(nYP3),str2double(nZP3)],'euclidean');
nLSlat=(nDist*tan(nCutOfAngle))/(cos(nSlopeAngle)+sin(nSlopeAngle)*tan(nCutOfAngle));

% Exibe comprimento para o ângulo determinado
set(handles.tOverhangSlatLength,'String',num2str(nLSlat))

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tOverhangCancelCreate.
function tOverhangCancelCreate_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangCancelCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Se existirem planos de pré-visualização anteriores, apaga-os

aPrevChild=handles.tAxesPreview.Children;
nSizePreviewNow=size(aPrevChild,1);
nSizePreviewOrig=str2double(get(handles.tVisPlotSize,'String'));

if nSizePreviewNow>nSizePreviewOrig %Já há pré-visualização sendo exibida
    % Apagar pre-visualização anterior
    for nD=nSizePreviewOrig+1:nSizePreviewNow
        delete(handles.tAxesPreview.Children(1));
    end
end

%Limpa tabela de Pontos
aDataCl=[];
set(handles.tOverhangPoints,'Data',aDataCl);

% Reseta variáveis
set(handles.tOverhangCutOfAngle,'String','20');
set(handles.tOverhangSlopeAngle,'String','0');
set(handles.tOverhangSlatLength,'String','1');
set(handles.tOverhangSlatTickness,'String','0');

%Travar as outras abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');

% Apara Tab
set(handles.tPanOverhang,'Visible','off');

% --- Executes on button press in tOverhangCreate.
function tOverhangCreate_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Load Language File

% Pontos
aPts=get(handles.tOverhangPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aPts)));
if aEmpty>0
    return
end

%Importa Informações da tela 
% nCutOffAngle=str2double(get(handles.tOverhangCutOfAngle,'String'));
nSlopeAngle=str2double(get(handles.tOverhangSlopeAngle,'String'));
nLSlat=str2double(get(handles.tOverhangSlatLength,'String'));
nTSlat=str2double(get(handles.tOverhangSlatTickness,'String'));
sName=get(handles.tOverhangName,'String');

%Cria planos da marquise
aPlane=fCreateOverhang(aPts,nSlopeAngle,nLSlat,nTSlat,0,0);
nRoom=str2double(get(handles.tRoomNum,'String'));
nSizePlanes=size(aPlane,1);

%Verifica a qual grupo pertencerá os novos planos
aDataPoins=get(handles.tTablePlanes,'Data');
nGroup=max(cellfun(@max,aDataPoins(:,3)))+1;

%Cria Planos
for nP=1:nSizePlanes
    aVert=aPlane(nP,:);
    fPutNewSinglePlane(nRoom,aVert,sName,nGroup);
end

%Atualiza a exibição com os novos planos criados
nSizeData=size(aDataPoins,1);
nPlanes=nSizeData+1:nSizeData+nSizePlanes;
fUpdateData(handles,nPlanes,true);

sMens=[MsgBox.OverhangCreated];
msgbox(sMens)

%Limpa tabela de Pontos
aDataCl=[];
set(handles.tOverhangPoints,'Data',aDataCl);

% Reseta variáveis
set(handles.tOverhangCutOfAngle,'String','20');
set(handles.tOverhangSlopeAngle,'String','0');
set(handles.tOverhangSlatLength,'String','1');
set(handles.tOverhangSlatTickness,'String','0');

%Travar as outras abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');

% Apara Tab
set(handles.tPanOverhang,'Visible','off');

% --- Executes on button press in tImportPointOverhang.
function tOverhangImportPlane_Callback(hObject, eventdata, handles)
% hObject    handle to tImportPointCanopy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spcodeDir

% Gera lista
cData=get(handles.tTablePlanes,'Data');
nSizeData=size(cData,1);
for nL=1:nSizeData
    aList{nL}=cData{nL,4};
end

% Pergunta o Plano
load([spcodeDir '\bLangDef.tlx'],'-mat','Title');  %Load Language File
[nPl,~]=listdlg('Name',Title.ChoosePlane,'PromptString',Title.ChoosePlane,'selectionmode','single','listsize',[250 140],'liststring',aList); % cria lista para escolha da janela

%Gera matriz de pontos
aPoints{1,1}=cData{nPl,5}; aPoints{1,2}=cData{nPl,6}; aPoints{1,3}=cData{nPl,7};
aPoints{2,1}=cData{nPl,8}; aPoints{2,2}=cData{nPl,9}; aPoints{2,3}=cData{nPl,10};
aPoints{3,1}=cData{nPl,11}; aPoints{3,2}=cData{nPl,12}; aPoints{3,3}=cData{nPl,13};
aPoints{4,1}=cData{nPl,14}; aPoints{4,2}=cData{nPl,15}; aPoints{4,3}=cData{nPl,16};

% Verifica se a marquise esta para cima
%Importa Informações da tela     
aPlanePrev=fCreateOverhang(aPoints,0,1,0,0,0);

% Vetor da direção da marquise
nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
nVecOver=cross(nVec2,nVec1);

while nVecOver(3)<=0
    aPointsRot{1,1}=aPoints{4,1}; aPointsRot{1,2}=aPoints{4,2}; aPointsRot{1,3}=aPoints{4,3};
    aPointsRot{2,1}=aPoints{1,1}; aPointsRot{2,2}=aPoints{1,2}; aPointsRot{2,3}=aPoints{1,3};
    aPointsRot{3,1}=aPoints{2,1}; aPointsRot{3,2}=aPoints{2,2}; aPointsRot{3,3}=aPoints{2,3};
    aPointsRot{4,1}=aPoints{3,1}; aPointsRot{4,2}=aPoints{3,2}; aPointsRot{4,3}=aPoints{3,3};

    aPoints=aPointsRot;

    %Importa Informações da tela     
    aPlanePrev=fCreateOverhang(aPoints,0,1,0,0,0);

    % Vetor da direção da marquise
    nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
    nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
    nVecOver=cross(nVec2,nVec1);
end

set(handles.tOverhangPoints,'Data',aPoints);

%Corrige o Cut Of Angle
tOverhangSlatLength_Callback(hObject, eventdata, handles)

%Gera a visualização
fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tOverhangRotatePointsUp.
function tOverhangRotatePointsUp_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangRotatePointsUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPoints=get(handles.tOverhangPoints,'Data');

aPointsRot{1,1}=aPoints{2,1}; aPointsRot{1,2}=aPoints{2,2}; aPointsRot{1,3}=aPoints{2,3};
aPointsRot{2,1}=aPoints{3,1}; aPointsRot{2,2}=aPoints{3,2}; aPointsRot{2,3}=aPoints{3,3};
aPointsRot{3,1}=aPoints{4,1}; aPointsRot{3,2}=aPoints{4,2}; aPointsRot{3,3}=aPoints{4,3};
aPointsRot{4,1}=aPoints{1,1}; aPointsRot{4,2}=aPoints{1,2}; aPointsRot{4,3}=aPoints{1,3};

set(handles.tOverhangPoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tOverhangRotatePointsDown.
function tOverhangRotatePointsDown_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangRotatePointsDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPoints=get(handles.tOverhangPoints,'Data');

aPointsRot{1,1}=aPoints{4,1}; aPointsRot{1,2}=aPoints{4,2}; aPointsRot{1,3}=aPoints{4,3};
aPointsRot{2,1}=aPoints{1,1}; aPointsRot{2,2}=aPoints{1,2}; aPointsRot{2,3}=aPoints{1,3};
aPointsRot{3,1}=aPoints{2,1}; aPointsRot{3,2}=aPoints{2,2}; aPointsRot{3,3}=aPoints{2,3};
aPointsRot{4,1}=aPoints{3,1}; aPointsRot{4,2}=aPoints{3,2}; aPointsRot{4,3}=aPoints{3,3};

set(handles.tOverhangPoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tOverhangImportWindow.
function tOverhangImportWindow_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangImportWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','Title','GuiSet');  %Load Language File

% Importa dados das Janelas
cData=get(handles.tTableWin,'Data');
nSizeData=size(cData,1);
% cria lista para escolha da janela
nPos=1;
for nL=1:2:nSizeData
    aList{nPos}=[GuiSet.WindowInPlanes ' '  num2str(cData{nL,3}) '&' num2str(cData{nL+1,3})];
    nPos=nPos+1;
end

%Escolha da Janela
[nPl,~]=listdlg('Name',Title.ChooseWindow,'PromptString',Title.ChooseWindow,'selectionmode','single','listsize',[250 140],'liststring',aList); 

% Determina Plano
nPl=((nPl-1)*2)+2;
%Gera matriz de pontos
try 
    aPoints{4,1}=cData{nPl,5}; aPoints{4,2}=cData{nPl,6}; aPoints{4,3}=cData{nPl,7};
    aPoints{1,1}=cData{nPl,8}; aPoints{1,2}=cData{nPl,9}; aPoints{1,3}=cData{nPl,10};
    aPoints{2,1}=cData{nPl,11}; aPoints{2,2}=cData{nPl,12}; aPoints{2,3}=cData{nPl,13};
    aPoints{3,1}=cData{nPl,14}; aPoints{3,2}=cData{nPl,15}; aPoints{3,3}=cData{nPl,16};

    %Importa Informações da tela     
    aPlanePrev=fCreateOverhang(aPoints,0,1,0,0,0);
    
    % Vetor da direção da marquise
    nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
    nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
    nVecOver=cross(nVec2,nVec1);
        
    while nVecOver(3)<=0
        aPointsRot{1,1}=aPoints{4,1}; aPointsRot{1,2}=aPoints{4,2}; aPointsRot{1,3}=aPoints{4,3};
        aPointsRot{2,1}=aPoints{1,1}; aPointsRot{2,2}=aPoints{1,2}; aPointsRot{2,3}=aPoints{1,3};
        aPointsRot{3,1}=aPoints{2,1}; aPointsRot{3,2}=aPoints{2,2}; aPointsRot{3,3}=aPoints{2,3};
        aPointsRot{4,1}=aPoints{3,1}; aPointsRot{4,2}=aPoints{3,2}; aPointsRot{4,3}=aPoints{3,3};

        aPoints=aPointsRot;
        
        %Importa Informações da tela     
        aPlanePrev=fCreateOverhang(aPoints,0,1,0,0,0);

        % Vetor da direção da marquise
        nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
        nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
        nVecOver=cross(nVec2,nVec1);
    end
       
    set(handles.tOverhangPoints,'Data',aPoints);

    fRoomPreviewShadeDev(hObject,eventdata,handles);
    
catch
end

% --- Executes on button press in tOverhangRotatePointsInvert.
function tOverhangRotatePointsInvert_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangRotatePointsInvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aPoints=get(handles.tOverhangPoints,'Data');

aPointsRot{1,1}=aPoints{1,1}; aPointsRot{1,2}=aPoints{1,2}; aPointsRot{1,3}=aPoints{1,3};
aPointsRot{2,1}=aPoints{4,1}; aPointsRot{2,2}=aPoints{4,2}; aPointsRot{2,3}=aPoints{4,3};
aPointsRot{3,1}=aPoints{3,1}; aPointsRot{3,2}=aPoints{3,2}; aPointsRot{3,3}=aPoints{3,3};
aPointsRot{4,1}=aPoints{2,1}; aPointsRot{4,2}=aPoints{2,2}; aPointsRot{4,3}=aPoints{2,3};

set(handles.tOverhangPoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);


function tOverhangSlopeAngle_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangSlopeAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mantém fixo o Cut Of Angle e modifica o Slat Length

% Verifica o valor e compatibiliza com o comprimeito da marquise
% Carrega dados dos planos
aWinPoints=get(handles.tOverhangPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

% Carrega o valor dos ângulos
nCutOfAngle=str2double(get(handles.tOverhangCutOfAngle,'String'))*pi/180;
nSlopeAngle=str2double(get(handles.tOverhangSlopeAngle,'String'))*pi/180;

%Coordenadas dos pontos de referência
% nXP1=aWinPoints{1,1};   nYP1=aWinPoints{1,2};   nZP1=aWinPoints{1,3};
nXP2=aWinPoints{2,1};   nYP2=aWinPoints{2,2};   nZP2=aWinPoints{2,3};
nXP3=aWinPoints{3,1};   nYP3=aWinPoints{3,2};   nZP3=aWinPoints{3,3};

% Distância Vertical
nDist=pdist([str2double(nXP2),str2double(nYP2),str2double(nZP2);str2double(nXP3),str2double(nYP3),str2double(nZP3)],'euclidean');
nLSlat=(nDist*tan(nCutOfAngle))/(cos(nSlopeAngle)+sin(nSlopeAngle)*tan(nCutOfAngle));

% Exibe comprimento para o ângulo determinado
set(handles.tOverhangSlatLength,'String',num2str(nLSlat))

fRoomPreviewShadeDev(hObject,eventdata,handles);


function tOverhangSlatLength_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangSlatLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mantém fixo o slope Angle e muda o Cut Of Angle

% Verifica o valor e compatibiliza com o comprimeito da marquise
% Carrega dados dos planos
aWinPoints=get(handles.tOverhangPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

% Carrega o valor do comprimento
nLSlat=str2double(get(handles.tOverhangSlatLength,'String'));
nSlopeAngle=str2double(get(handles.tOverhangSlopeAngle,'String'))*pi/180;

%Coordenadas dos pontos de referência
% nXP1=aWinPoints{1,1};   nYP1=aWinPoints{1,2};   nZP1=aWinPoints{1,3};
nXP2=aWinPoints{2,1};   nYP2=aWinPoints{2,2};   nZP2=aWinPoints{2,3};
nXP3=aWinPoints{3,1};   nYP3=aWinPoints{3,2};   nZP3=aWinPoints{3,3};

% Distância Vertical
nDist=pdist([str2double(nXP2),str2double(nYP2),str2double(nZP2);str2double(nXP3),str2double(nYP3),str2double(nZP3)],'euclidean');
nCutOfAngle=(atan((nLSlat*cos(nSlopeAngle))/(nDist-nLSlat*sin(nSlopeAngle))))*180/pi;

% Exibe comprimento para o ângulo determinado
set(handles.tOverhangCutOfAngle,'String',num2str(nCutOfAngle))

fRoomPreviewShadeDev(hObject,eventdata,handles);


function tOverhangSlatTickness_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangSlatTickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tOverhangSlatTickness as text
%        str2double(get(hObject,'String')) returns contents of tOverhangSlatTickness as a double

% Carrega dados dos planos
aWinPoints=get(handles.tOverhangPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tOverhangCutOfAngleBut.
function tOverhangCutOfAngleBut_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangCutOfAngleBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tOverhangCutOfAngleBut

% Modifica os campos de edição
set(handles.tOverhangCutOfAngle,'Enable','On');
set(handles.tOverhangSlatLength,'Enable','Off');
set(handles.tOverhangCutOfAngleBut,'Value',1);
set(handles.ttOverhangSlatLengthOverhangBut,'Value',0);

tOverhangSlatLength_Callback(hObject, eventdata, handles)

% --- Executes on button press in ttOverhangSlatLengthOverhangBut.
function ttOverhangSlatLengthOverhangBut_Callback(hObject, eventdata, handles)
% hObject    handle to ttOverhangSlatLengthOverhangBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ttOverhangSlatLengthOverhangBut

% Modifica os campos de edição
set(handles.tOverhangCutOfAngle,'Enable','Off');
set(handles.tOverhangSlatLength,'Enable','On');
set(handles.tOverhangCutOfAngleBut,'Value',0);
set(handles.ttOverhangSlatLengthOverhangBut,'Value',1);

tOverhangCutOfAngle_Callback(hObject, eventdata, handles)

% --- Executes when entered data in editable cell(s) in tOverhangPoints.
function tOverhangPoints_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tOverhangPoints (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

fRoomPreviewShadeDev(hObject,eventdata,handles);


function tLightshelfCutOfAngle_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to tLightshelfCutOfAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Muda o slat Length e mantém fixo o restante das variáveis

% Verifica o valor e compatibiliza com o comprimeito da Prateleira de Luz
% Carrega dados dos planos
aWinPoints=get(handles.tLightshelfPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

% Carrega o valor das outras variáveis
nCutOfAngle=str2double(get(handles.tLightshelfCutOfAngle,'String'))*pi/180;
nSlopeAngle=str2double(get(handles.tLightshelfSlopeAngle,'String'))*pi/180;
nTopDist=str2double(get(handles.tLightshelfTopDistance,'String'));
nInProj=str2double(get(handles.tLightshelfInProjection,'String'));
nSlatLength=str2double(get(handles.tLightshelfSlatLength,'String'));


%Coordenadas dos pontos de referência
% nXP1=aWinPoints{1,1};   nYP1=aWinPoints{1,2};   nZP1=aWinPoints{1,3};
nXP2=aWinPoints{2,1};   nYP2=aWinPoints{2,2};   nZP2=aWinPoints{2,3};
nXP3=aWinPoints{3,1};   nYP3=aWinPoints{3,2};   nZP3=aWinPoints{3,3};

% Distância Vertical
nDist=pdist([str2double(nXP2),str2double(nYP2),str2double(nZP2);str2double(nXP3),str2double(nYP3),str2double(nZP3)],'euclidean');
nLSlat=((nDist-nTopDist)*tan(nCutOfAngle)/(cos(nSlopeAngle)+sin(nSlopeAngle)*tan(nCutOfAngle)))+nInProj;

% Exibe comprimento para o ângulo determinado
set(handles.tLightshelfSlatLength,'String',num2str(nLSlat))

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function tLightshelfCutOfAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLightshelfCutOfAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLightshelfSlopeAngle_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfSlopeAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Verifica o valor e compatibiliza com o comprimeito da Prateleira de Luz
% Carrega dados dos planos
aWinPoints=get(handles.tLightshelfPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

%Verifica qual campo mudar
if get(handles.ttLightshelfCutOfAngleBut,'Value')==1
    tLightshelfCutOfAngle_Callback(hObject, eventdata, handles)
else
    tLightshelfSlatLength_Callback(hObject, eventdata, handles)
end

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function tLightshelfSlopeAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLightshelfSlopeAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLightshelfSlatLength_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfSlatLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Muda o cut of angle e mantém fixo o restante das variáveis

% Verifica o valor e compatibiliza com o comprimeito da Prateleira de Luz
% Carrega dados dos planos
aWinPoints=get(handles.tLightshelfPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

% Carrega o valor das outras variáveis
nSlopeAngle=str2double(get(handles.tLightshelfSlopeAngle,'String'))*pi/180;
nLSlat=str2double(get(handles.tLightshelfSlatLength,'String'));
nTopSlat=str2double(get(handles.tLightshelfTopDistance,'String'));
nInSlat=str2double(get(handles.tLightshelfInProjection,'String'));

%Coordenadas dos pontos de referência
% nXP1=aWinPoints{1,1};   nYP1=aWinPoints{1,2};   nZP1=aWinPoints{1,3};
nXP2=aWinPoints{2,1};   nYP2=aWinPoints{2,2};   nZP2=aWinPoints{2,3};
nXP3=aWinPoints{3,1};   nYP3=aWinPoints{3,2};   nZP3=aWinPoints{3,3};

% Distância Vertical
nDist=pdist([str2double(nXP2),str2double(nYP2),str2double(nZP2);str2double(nXP3),str2double(nYP3),str2double(nZP3)],'euclidean');
nCutOfAngle=atan((nDist-nTopSlat-(nLSlat-nInSlat)*sin(nSlopeAngle))/((nLSlat-nInSlat)*cos(nSlopeAngle)))*180/pi;

% Exibe comprimento para o ângulo determinado
set(handles.tLightshelfCutOfAngle,'String',num2str(nCutOfAngle))

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function tLightshelfSlatLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLightshelfSlatLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLightshelfSlatTickness_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfSlatTickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Verifica o valor e compatibiliza com o comprimeito da Prateleira de Luz
% Carrega dados dos planos
aWinPoints=get(handles.tLightshelfPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

%Verifica qual campo mudar
if get(handles.ttLightshelfCutOfAngleBut,'Value')==1
    tLightshelfCutOfAngle_Callback(hObject, eventdata, handles)
else
    tLightshelfSlatLength_Callback(hObject, eventdata, handles)
end

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function tLightshelfSlatTickness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLightshelfSlatTickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tLightshelfCreate.
function tLightshelfCreate_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','InputDlg','MsgBox');  %Load Language File

% Pontos
aPts=get(handles.tLightshelfPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aPts)));
if aEmpty>0
    return
end

%Importa Informações da tela 
nSlopeAngle=str2double(get(handles.tLightshelfSlopeAngle,'String'));
nLSlat=str2double(get(handles.tLightshelfSlatLength,'String'));
nTSlat=str2double(get(handles.tLightshelfSlatTickness,'String'));
nTopDist=str2double(get(handles.tLightshelfTopDistance,'String'));
nInProj=str2double(get(handles.tLightshelfInProjection,'String'));
sName=get(handles.tLightshelfName,'String');

%Cria planos da marquise
aPlane=fCreateLightshelf(aPts,nSlopeAngle,nLSlat,nTSlat,nTopDist,nInProj);
nRoom=str2double(get(handles.tRoomNum,'String'));
nSizePlanes=size(aPlane,1);

%Verifica a qual grupo pertencerá os novos planos
aDataPoins=get(handles.tTablePlanes,'Data');
nGroup=max(cellfun(@max,aDataPoins(:,3)))+1;

for nP=1:nSizePlanes
    aVert=aPlane(nP,:);
    fPutNewSinglePlane(nRoom,aVert,sName,nGroup);
end

%Atualiza a exibição com os novos planos criados
nSizeData=size(aDataPoins,1);
nPlanes=nSizeData+1:nSizeData+nSizePlanes;
fUpdateData(handles,nPlanes,true);

sMens=[MsgBox.LightshelfCreated];
msgbox(sMens)

%Limpa tabela de Pontos
aDataCl=[];
set(handles.tLightshelfPoints,'Data',aDataCl);

% Reseta variáveis
set(handles.tLightshelfCutOfAngle,'String','20');
set(handles.tLightshelfSlopeAngle,'String','0');
set(handles.tLightshelfSlatLength,'String','1');
set(handles.tLightshelfSlatTickness,'String','0.0');
set(handles.tLightshelfTopDistance,'String','0.2');
set(handles.tLightshelfInProjection,'String','0.2');

%Travar as outras abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');

% Apara Tab
set(handles.tPanLightshelf,'Visible','off');

% --- Executes on button press in tLightshelfCancelCreate.
function tLightshelfCancelCreate_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfCancelCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPrevChild=handles.tAxesPreview.Children;
nSizePreviewNow=size(aPrevChild,1);
nSizePreviewOrig=str2double(get(handles.tVisPlotSize,'String'));

if nSizePreviewNow>nSizePreviewOrig %Já há pré-visualização sendo exibida
    % Apagar pre-visualização anterior
    for nD=nSizePreviewOrig+1:nSizePreviewNow
        delete(handles.tAxesPreview.Children(1));
    end
end

% Limpa tabela de Pontos
aDataCl=[];
set(handles.tLightshelfPoints,'Data',aDataCl);

% Reseta variáveis
set(handles.tLightshelfCutOfAngle,'String','20');
set(handles.tLightshelfSlopeAngle,'String','0');
set(handles.tLightshelfSlatLength,'String','1');
set(handles.tLightshelfSlatTickness,'String','0.0');
set(handles.tLightshelfTopDistance,'String','0.2');
set(handles.tLightshelfInProjection,'String','0.2');

%Travar as outras abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');

% Apara Tab
set(handles.tPanLightshelf,'Visible','off');

% --- Executes on button press in tLightshelfImportPlane.
function tLightshelfImportPlane_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfImportPlane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spcodeDir

cData=get(handles.tTablePlanes,'Data');
nSizeData=size(cData,1);
for nL=1:nSizeData
    aList{nL}=cData{nL,4};
end

load([spcodeDir '\bLangDef.tlx'],'-mat','Title');  %Load Language File
[nPl,~]=listdlg('Name',Title.ChoosePlane,'PromptString',Title.ChoosePlane,'selectionmode','single','listsize',[250 140],'liststring',aList); % cria lista para escolha da janela

%Gera matriz de pontos
aPoints{1,1}=cData{nPl,5}; aPoints{1,2}=cData{nPl,6}; aPoints{1,3}=cData{nPl,7};
aPoints{2,1}=cData{nPl,8}; aPoints{2,2}=cData{nPl,9}; aPoints{2,3}=cData{nPl,10};
aPoints{3,1}=cData{nPl,11}; aPoints{3,2}=cData{nPl,12}; aPoints{3,3}=cData{nPl,13};
aPoints{4,1}=cData{nPl,14}; aPoints{4,2}=cData{nPl,15}; aPoints{4,3}=cData{nPl,16};

% Vetor da direção da prateleira
aPlanePrev=fCreateLightshelf(aPoints,0,1,0,0,0);
nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
nVecOver=cross(nVec2,nVec1);

% Verifica se a prateleira está para cima
while nVecOver(3)<=0
    aPointsRot{1,1}=aPoints{4,1}; aPointsRot{1,2}=aPoints{4,2}; aPointsRot{1,3}=aPoints{4,3};
    aPointsRot{2,1}=aPoints{1,1}; aPointsRot{2,2}=aPoints{1,2}; aPointsRot{2,3}=aPoints{1,3};
    aPointsRot{3,1}=aPoints{2,1}; aPointsRot{3,2}=aPoints{2,2}; aPointsRot{3,3}=aPoints{2,3};
    aPointsRot{4,1}=aPoints{3,1}; aPointsRot{4,2}=aPoints{3,2}; aPointsRot{4,3}=aPoints{3,3};

    aPoints=aPointsRot;

    %Importa Informações da tela     
    aPlanePrev=fCreateLightshelf(aPoints,0,1,0,0,0);

    % Vetor da direção da marquise
    nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
    nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
    nVecOver=cross(nVec2,nVec1);
end

set(handles.tLightshelfPoints,'Data',aPoints);

%Gera a visualização
fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tLightshelfRotatePointsUp.
function tLightshelfRotatePointsUp_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfRotatePointsUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPoints=get(handles.tLightshelfPoints,'Data');

aPointsRot{1,1}=aPoints{2,1}; aPointsRot{1,2}=aPoints{2,2}; aPointsRot{1,3}=aPoints{2,3};
aPointsRot{2,1}=aPoints{3,1}; aPointsRot{2,2}=aPoints{3,2}; aPointsRot{2,3}=aPoints{3,3};
aPointsRot{3,1}=aPoints{4,1}; aPointsRot{3,2}=aPoints{4,2}; aPointsRot{3,3}=aPoints{4,3};
aPointsRot{4,1}=aPoints{1,1}; aPointsRot{4,2}=aPoints{1,2}; aPointsRot{4,3}=aPoints{1,3};

set(handles.tLightshelfPoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tLightshelfRotatePointsDown.
function tLightshelfRotatePointsDown_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfRotatePointsDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPoints=get(handles.tLightshelfPoints,'Data');

aPointsRot{1,1}=aPoints{4,1}; aPointsRot{1,2}=aPoints{4,2}; aPointsRot{1,3}=aPoints{4,3};
aPointsRot{2,1}=aPoints{1,1}; aPointsRot{2,2}=aPoints{1,2}; aPointsRot{2,3}=aPoints{1,3};
aPointsRot{3,1}=aPoints{2,1}; aPointsRot{3,2}=aPoints{2,2}; aPointsRot{3,3}=aPoints{2,3};
aPointsRot{4,1}=aPoints{3,1}; aPointsRot{4,2}=aPoints{3,2}; aPointsRot{4,3}=aPoints{3,3};

set(handles.tLightshelfPoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tLightshelfImportWindow.
function tLightshelfImportWindow_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfImportWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','Title','GuiSet');  %Load Language File

% Importa dados das Janelas
cData=get(handles.tTableWin,'Data');
nSizeData=size(cData,1);
% cria lista para escolha da janela
nPos=1;
for nL=1:2:nSizeData
    aList{nPos}=[GuiSet.WindowInPlanes ' '  num2str(cData{nL,3}) '&' num2str(cData{nL+1,3})];
    nPos=nPos+1;
end

%Escolha da Janela
[nPl,~]=listdlg('Name',Title.ChooseWindow,'PromptString',Title.ChooseWindow,'selectionmode','single','listsize',[250 140],'liststring',aList); 

% Determina Plano
nPl=((nPl-1)*2)+2;
%Gera matriz de pontos
aPoints{4,1}=cData{nPl,5}; aPoints{4,2}=cData{nPl,6}; aPoints{4,3}=cData{nPl,7};
aPoints{1,1}=cData{nPl,8}; aPoints{1,2}=cData{nPl,9}; aPoints{1,3}=cData{nPl,10};
aPoints{2,1}=cData{nPl,11}; aPoints{2,2}=cData{nPl,12}; aPoints{2,3}=cData{nPl,13};
aPoints{3,1}=cData{nPl,14}; aPoints{3,2}=cData{nPl,15}; aPoints{3,3}=cData{nPl,16};

% Vetor da direção da prateleira
aPlanePrev=fCreateLightshelf(aPoints,0,1,0,0,0);
nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
nVecOver=cross(nVec2,nVec1);

% Verifica se a prateleira está para cima
while nVecOver(3)<=0
    aPointsRot{1,1}=aPoints{4,1}; aPointsRot{1,2}=aPoints{4,2}; aPointsRot{1,3}=aPoints{4,3};
    aPointsRot{2,1}=aPoints{1,1}; aPointsRot{2,2}=aPoints{1,2}; aPointsRot{2,3}=aPoints{1,3};
    aPointsRot{3,1}=aPoints{2,1}; aPointsRot{3,2}=aPoints{2,2}; aPointsRot{3,3}=aPoints{2,3};
    aPointsRot{4,1}=aPoints{3,1}; aPointsRot{4,2}=aPoints{3,2}; aPointsRot{4,3}=aPoints{3,3};

    aPoints=aPointsRot;

    %Importa Informações da tela     
    aPlanePrev=fCreateLightshelf(aPoints,0,1,0,0,0);

    % Vetor da direção da marquise
    nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
    nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
    nVecOver=cross(nVec2,nVec1);
end

set(handles.tLightshelfPoints,'Data',aPoints);

fRoomPreviewShadeDev(hObject,eventdata,handles);


% --- Executes on button press in tLightshelfRotatePointsInvert.
function tLightshelfRotatePointsInvert_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfRotatePointsInvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPoints=get(handles.tLightshelfPoints,'Data');

aPointsRot{1,1}=aPoints{1,1}; aPointsRot{1,2}=aPoints{1,2}; aPointsRot{1,3}=aPoints{1,3};
aPointsRot{2,1}=aPoints{4,1}; aPointsRot{2,2}=aPoints{4,2}; aPointsRot{2,3}=aPoints{4,3};
aPointsRot{3,1}=aPoints{3,1}; aPointsRot{3,2}=aPoints{3,2}; aPointsRot{3,3}=aPoints{3,3};
aPointsRot{4,1}=aPoints{2,1}; aPointsRot{4,2}=aPoints{2,2}; aPointsRot{4,3}=aPoints{2,3};

set(handles.tLightshelfPoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes when entered data in editable cell(s) in tLightshelfPoints.
function tLightshelfPoints_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tLightshelfPoints (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

function tLightshelfTopDistance_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfTopDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Verifica o valor e compatibiliza com o comprimeito da Prateleira de Luz
% Carrega dados dos planos
aWinPoints=get(handles.tLightshelfPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

%Verifica qual campo mudar
if get(handles.ttLightshelfCutOfAngleBut,'Value')==1
    tLightshelfCutOfAngle_Callback(hObject, eventdata, handles)
else
    tLightshelfSlatLength_Callback(hObject, eventdata, handles)
end

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function tLightshelfTopDistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLightshelfTopDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ttLightshelfCutOfAngleBut.
function ttLightshelfCutOfAngleBut_Callback(hObject, eventdata, handles)
% hObject    handle to ttLightshelfCutOfAngleBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ttLightshelfCutOfAngleBut

% Modifica os campos de edição
set(handles.tLightshelfCutOfAngle,'Enable','On');
set(handles.tLightshelfSlatLength,'Enable','Off');
set(handles.ttLightshelfCutOfAngleBut,'Value',1);
set(handles.ttLightshelfSlatLengthBut,'Value',0);

tLightshelfSlatLength_Callback(hObject, eventdata, handles)

% --- Executes on button press in ttLightshelfSlatLengthBut.
function ttLightshelfSlatLengthBut_Callback(hObject, eventdata, handles)
% hObject    handle to ttLightshelfSlatLengthBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ttLightshelfSlatLengthBut

% Modifica os campos de edição
set(handles.tLightshelfCutOfAngle,'Enable','Off');
set(handles.tLightshelfSlatLength,'Enable','On');
set(handles.ttLightshelfCutOfAngleBut,'Value',0);
set(handles.ttLightshelfSlatLengthBut,'Value',1);

tLightshelfCutOfAngle_Callback(hObject, eventdata, handles)


function tLightshelfInProjection_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfInProjection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Verifica o valor e compatibiliza com o comprimeito da Prateleira de Luz
% Carrega dados dos planos
aWinPoints=get(handles.tLightshelfPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

%Verifica qual campo mudar
if get(handles.ttLightshelfCutOfAngleBut,'Value')==1
    tLightshelfCutOfAngle_Callback(hObject, eventdata, handles)
else
    tLightshelfSlatLength_Callback(hObject, eventdata, handles)
end

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function tLightshelfInProjection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLightshelfInProjection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tCanopyCurveRadius_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyCurveRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tCanopyCurveRadius as text
%        str2double(get(hObject,'String')) returns contents of tCanopyCurveRadius as a double
aWinPoints=get(handles.tCanopyPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

fRoomPreviewShadeDev(hObject,eventdata,handles);


function tCanopyDiscretization_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyDiscretization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tCanopyDiscretization as text
%        str2double(get(hObject,'String')) returns contents of tCanopyDiscretization as a double
aWinPoints=get(handles.tCanopyPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

fRoomPreviewShadeDev(hObject,eventdata,handles);


function tCanopyTopDistance_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyTopDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tCanopyTopDistance as text
%        str2double(get(hObject,'String')) returns contents of tCanopyTopDistance as a double
aWinPoints=get(handles.tCanopyPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tCanopyImportPlane.
function tCanopyImportPlane_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyImportPlane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spcodeDir

cData=get(handles.tTablePlanes,'Data');
nSizeData=size(cData,1);
for nL=1:nSizeData
    aList{nL}=cData{nL,4};
end
load([spcodeDir '\bLangDef.tlx'],'-mat','Title');  %Load Language File
[nPl,~]=listdlg('Name',Title.ChoosePlane,'PromptString',Title.ChoosePlane,'selectionmode','single','listsize',[250 140],'liststring',aList); % cria lista para escolha da janela

%Gera matriz de pontos
aPoints{1,1}=cData{nPl,5}; aPoints{1,2}=cData{nPl,6}; aPoints{1,3}=cData{nPl,7};
aPoints{2,1}=cData{nPl,8}; aPoints{2,2}=cData{nPl,9}; aPoints{2,3}=cData{nPl,10};
aPoints{3,1}=cData{nPl,11}; aPoints{3,2}=cData{nPl,12}; aPoints{3,3}=cData{nPl,13};
aPoints{4,1}=cData{nPl,14}; aPoints{4,2}=cData{nPl,15}; aPoints{4,3}=cData{nPl,16};

% Verifica se a marquise esta para cima
%Importa Informações da tela     
aPlanePrev=fCreateLightshelf(aPoints,0,1,0,0,0);

% Vetor da direção da marquise
nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
nVecOver=cross(nVec2,nVec1);

while nVecOver(3)<=0
    aPointsRot{1,1}=aPoints{4,1}; aPointsRot{1,2}=aPoints{4,2}; aPointsRot{1,3}=aPoints{4,3};
    aPointsRot{2,1}=aPoints{1,1}; aPointsRot{2,2}=aPoints{1,2}; aPointsRot{2,3}=aPoints{1,3};
    aPointsRot{3,1}=aPoints{2,1}; aPointsRot{3,2}=aPoints{2,2}; aPointsRot{3,3}=aPoints{2,3};
    aPointsRot{4,1}=aPoints{3,1}; aPointsRot{4,2}=aPoints{3,2}; aPointsRot{4,3}=aPoints{3,3};

    aPoints=aPointsRot;

    %Importa Informações da tela     
    aPlanePrev=fCreateOverhang(aPoints,0,1,0,0,0);

    % Vetor da direção da marquise
    nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
    nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
    nVecOver=cross(nVec2,nVec1);
end

set(handles.tCanopyPoints,'Data',aPoints);

%Gera a visualização
fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tCanopyRotatePointsUp.
function tCanopyRotatePointsUp_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyRotatePointsUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPoints=get(handles.tCanopyPoints,'Data');

aPointsRot{1,1}=aPoints{2,1}; aPointsRot{1,2}=aPoints{2,2}; aPointsRot{1,3}=aPoints{2,3};
aPointsRot{2,1}=aPoints{3,1}; aPointsRot{2,2}=aPoints{3,2}; aPointsRot{2,3}=aPoints{3,3};
aPointsRot{3,1}=aPoints{4,1}; aPointsRot{3,2}=aPoints{4,2}; aPointsRot{3,3}=aPoints{4,3};
aPointsRot{4,1}=aPoints{1,1}; aPointsRot{4,2}=aPoints{1,2}; aPointsRot{4,3}=aPoints{1,3};

set(handles.tCanopyPoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tCanopyRotatePointsDown.
function tCanopyRotatePointsDown_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyRotatePointsDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPoints=get(handles.tCanopyPoints,'Data');

aPointsRot{1,1}=aPoints{4,1}; aPointsRot{1,2}=aPoints{4,2}; aPointsRot{1,3}=aPoints{4,3};
aPointsRot{2,1}=aPoints{1,1}; aPointsRot{2,2}=aPoints{1,2}; aPointsRot{2,3}=aPoints{1,3};
aPointsRot{3,1}=aPoints{2,1}; aPointsRot{3,2}=aPoints{2,2}; aPointsRot{3,3}=aPoints{2,3};
aPointsRot{4,1}=aPoints{3,1}; aPointsRot{4,2}=aPoints{3,2}; aPointsRot{4,3}=aPoints{3,3};

set(handles.tCanopyPoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tCanopyImportWindow.
function tCanopyImportWindow_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyImportWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','Title','GuiSet');  %Load Language File

% Importa dados das Janelas
cData=get(handles.tTableWin,'Data');
nSizeData=size(cData,1);
% cria lista para escolha da janela
nPos=1;
for nL=1:2:nSizeData
    aList{nPos}=[GuiSet.WindowInPlanes ' '  num2str(cData{nL,3}) '&' num2str(cData{nL+1,3})];
    nPos=nPos+1;
end

%Escolha da Janela
[nPl,~]=listdlg('Name',Title.ChooseWindow,'PromptString',Title.ChooseWindow,'selectionmode','single','listsize',[250 140],'liststring',aList); 

% Determina Plano
nPl=((nPl-1)*2)+2;
%Gera matriz de pontos
aPoints{4,1}=cData{nPl,5}; aPoints{4,2}=cData{nPl,6}; aPoints{4,3}=cData{nPl,7};
aPoints{1,1}=cData{nPl,8}; aPoints{1,2}=cData{nPl,9}; aPoints{1,3}=cData{nPl,10};
aPoints{2,1}=cData{nPl,11}; aPoints{2,2}=cData{nPl,12}; aPoints{2,3}=cData{nPl,13};
aPoints{3,1}=cData{nPl,14}; aPoints{3,2}=cData{nPl,15}; aPoints{3,3}=cData{nPl,16};

% Vetor da direção do Toldo
aPlanePrev=fCreateLightshelf(aPoints,0,1,0,0,0);
nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
nVecOver=cross(nVec2,nVec1);

% Verifica se a prateleira está para cima
while nVecOver(3)<=0
    aPointsRot{1,1}=aPoints{4,1}; aPointsRot{1,2}=aPoints{4,2}; aPointsRot{1,3}=aPoints{4,3};
    aPointsRot{2,1}=aPoints{1,1}; aPointsRot{2,2}=aPoints{1,2}; aPointsRot{2,3}=aPoints{1,3};
    aPointsRot{3,1}=aPoints{2,1}; aPointsRot{3,2}=aPoints{2,2}; aPointsRot{3,3}=aPoints{2,3};
    aPointsRot{4,1}=aPoints{3,1}; aPointsRot{4,2}=aPoints{3,2}; aPointsRot{4,3}=aPoints{3,3};

    aPoints=aPointsRot;

    %Importa Informações da tela     
    aPlanePrev=fCreateLightshelf(aPoints,0,1,0,0,0);

    % Vetor da direção da marquise
    nVec1=aPlanePrev{1,2}-aPlanePrev{1,1};
    nVec2=aPlanePrev{1,3}-aPlanePrev{1,1};
    nVecOver=cross(nVec2,nVec1);
end

set(handles.tCanopyPoints,'Data',aPoints);

fRoomPreviewShadeDev(hObject,eventdata,handles);
  

% --- Executes on button press in tCanopyRotatePointsInvert.
function tCanopyRotatePointsInvert_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyRotatePointsInvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPoints=get(handles.tCanopyPoints,'Data');

aPointsRot{1,1}=aPoints{1,1}; aPointsRot{1,2}=aPoints{1,2}; aPointsRot{1,3}=aPoints{1,3};
aPointsRot{2,1}=aPoints{4,1}; aPointsRot{2,2}=aPoints{4,2}; aPointsRot{2,3}=aPoints{4,3};
aPointsRot{3,1}=aPoints{3,1}; aPointsRot{3,2}=aPoints{3,2}; aPointsRot{3,3}=aPoints{3,3};
aPointsRot{4,1}=aPoints{2,1}; aPointsRot{4,2}=aPoints{2,2}; aPointsRot{4,3}=aPoints{2,3};

set(handles.tCanopyPoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tLouvreImportPlane.
function tLouvreImportPlane_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreImportPlane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spcodeDir

cData=get(handles.tTablePlanes,'Data');
nSizeData=size(cData,1);
for nL=1:nSizeData
    aList{nL}=cData{nL,4};
end
load([spcodeDir '\bLangDef.tlx'],'-mat','Title');  %Load Language File
[nPl,~]=listdlg('Name',Title.ChoosePlane,'PromptString',Title.ChoosePlane,'selectionmode','single','listsize',[250 140],'liststring',aList); % cria lista para escolha da janela

%Gera matriz de pontos
aPoints{1,1}=cData{nPl,5}; aPoints{1,2}=cData{nPl,6}; aPoints{1,3}=cData{nPl,7};
aPoints{2,1}=cData{nPl,8}; aPoints{2,2}=cData{nPl,9}; aPoints{2,3}=cData{nPl,10};
aPoints{3,1}=cData{nPl,11}; aPoints{3,2}=cData{nPl,12}; aPoints{3,3}=cData{nPl,13};
aPoints{4,1}=cData{nPl,14}; aPoints{4,2}=cData{nPl,15}; aPoints{4,3}=cData{nPl,16};

set(handles.tLouvrePoints,'Data',aPoints);
aPoints=str2double(aPoints);
%Verifica direção do plano
aPlaneF=[aPoints(1,:) aPoints(2,:) aPoints(3,:) aPoints(4,:)];
nVet=[(aPlaneF(1,4)-aPlaneF(1,1)),(aPlaneF(1,5)-aPlaneF(1,2)),(aPlaneF(1,6)-aPlaneF(1,3))];

if nVet(3)==0 % Vertical, deve rotacionar
    tLouvreRotatePointsDown_Callback(hObject, eventdata, handles)
end

%Gera a visualização
fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in ttLouvreSlatLengthBut.
function ttLouvreSlatLengthBut_Callback(hObject, eventdata, handles)
% hObject    handle to ttLouvreSlatLengthBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ttLouvreSlatLengthBut

% Modifica os campos de edição
set(handles.tLouvreCutOfAngle,'Enable','Off');
set(handles.tLouvreSlatLength,'Enable','On');
set(handles.ttLouvreCutOfAngleBut,'Value',0);
set(handles.ttLouvreSlatLengthBut,'Value',1);


function tLouvreSlatLength_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreSlatLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tLouvreSlatLength as text
%        str2double(get(hObject,'String')) returns contents of tLouvreSlatLength as a double

% Salva valor e reexibe a visualização
nType=get(handles.ttLouvreTypeProperties,'UserData');
nLouvreSlatLength=str2double(get(hObject,'String'));
nLouvreSlatLengthO=get(handles.tLouvreSlatLength,'UserData');
nLouvreSlatLengthO{nType,1}=nLouvreSlatLength;
set(handles.tLouvreSlatLength,'UserData',nLouvreSlatLengthO);

%Visualiza
fRoomPreviewShadeDev(hObject,eventdata,handles);

% Corrige campos
fCutOfAngleSlatLengthLouvre(handles)

% --- Executes during object creation, after setting all properties.
function tLouvreSlatLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreSlatLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ttLouvreCutOfAngleBut.
function ttLouvreCutOfAngleBut_Callback(hObject, eventdata, handles)
% hObject    handle to ttLouvreCutOfAngleBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ttLouvreCutOfAngleBut

% Modifica os campos de edição
set(handles.tLouvreCutOfAngle,'Enable','On');
set(handles.tLouvreSlatLength,'Enable','Off');
set(handles.ttLouvreCutOfAngleBut,'Value',1);
set(handles.ttLouvreSlatLengthBut,'Value',0);


function tLouvreCutOfAngle_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreCutOfAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tLouvreCutOfAngle as text
%        str2double(get(hObject,'String')) returns contents of tLouvreCutOfAngle as a double

% Salva valor e reexibe a visualização
nType=get(handles.ttLouvreTypeProperties,'UserData');
nLouvreCutOfAngle=str2double(get(hObject,'String'));
nLouvreCutOfAngleO=get(handles.tLouvreCutOfAngle,'UserData');
nLouvreCutOfAngleO{nType,1}=nLouvreCutOfAngle;
set(handles.tLouvreCutOfAngle,'UserData',nLouvreCutOfAngleO);

% Corrige campos
fCutOfAngleSlatLengthLouvre(handles)

%Visualiza
fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function tLouvreCutOfAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreCutOfAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when entered data in editable cell(s) in tLouvrePoints.
function tLouvrePoints_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tLouvrePoints (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tPergulaButton.
function tPergulaButton_Callback(hObject, eventdata, handles)
% hObject    handle to tPergulaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spcodeDir
load([spcodeDir '\bLangDef.tlx'],'-mat','Legend');  %Load Language File

%Verifica se ha janelas zenitais
% Verifica se é louvre ou pergula
cData=get(handles.tTableWin,'Data');
nSizeData=size(cData,1);
iFlag=false; 
for nL=1:nSizeData
    %Vetores do plano 
    aVet1=[(cData{nL,8}-cData{nL,5}),(cData{nL,9}-cData{nL,6}),(cData{nL,10}-cData{nL,7})]; %Horizontal (2-1)
    aVet2=[(cData{nL,14}-cData{nL,5}),(cData{nL,15}-cData{nL,6}),(cData{nL,16}-cData{nL,7})]; %Vertical (4-1)
    %Vetor Normal do Plano 
    aVetN=[(aVet1(2)*aVet2(3)-aVet2(2)*aVet1(3)),(aVet1(3)*aVet2(1)-aVet2(3)*aVet1(1)),(aVet1(1)*aVet2(2)-aVet2(1)*aVet1(2))];
    aVetN=aVetN/norm(aVetN);
    if aVetN(3)~=0
        iFlag=true;
    end
end

if ~iFlag
    return
end

% Configura tabs
set(handles.tPanOverhang,'Visible','off');
set(handles.tPanLightshelf,'Visible','off');
set(handles.tPanLouvre,'Visible','on','Title',Legend.Pergula,'UserData',2);
set(handles.tPanCanopy,'Visible','off');

%Travar as outras abas
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');
set(handles.tPanElementButton,'Enable','off');

% Salva no UserData dos campos os padrões de horizontal e vertical
set(handles.tLouvreName,'UserData',{Legend.D1Pergula;Legend.D2Pergula},'String',Legend.D1Pergula);
set(handles.tLouvreAxisProjection,'UserData',{0;0},'String','0');
set(handles.tLouvreSlatLength,'UserData',{0.15;0.15},'String','0.15');
set(handles.tLouvreSlatTickness,'UserData',{0;0},'String','0');
set(handles.tLouvreCutOfAngle,'UserData',{20;20},'String','20');
set(handles.tLouvreSlatAngle,'UserData',{0;0},'String','0');
set(handles.tLouvreSlatQuantity,'UserData',{5;10},'String','5');

% Set no horizontal
set(handles.tLouvreTypeVertical,'Enable','off');
set(handles.tLouvreTypeHorizontal,'Enable','on');
set(handles.ttLouvreTypeProperties,'String',Legend.Direction1Properties,'UserData',1);
set(handles.tLouvreTypeHorizontalCh,'Value',1,'String',Legend.D1Pergula);
set(handles.tLouvreTypeVerticalCh,'Value',0,'String',Legend.D2Pergula);

%Set nos botões de direção
set(handles.tLouvreTypeHorizontal,'String',Legend.Direction1);
set(handles.tLouvreTypeVertical,'String',Legend.Direction2);
set(handles.tLouvreImportPlane,'Visible','off');

% Abre janela
tLouvreImportWindow_Callback(hObject, eventdata, handles)

%Corrige campo do ângulo de corte
fCutOfAngleSlatLengthLouvre(handles)

% --- Executes on button press in tEmptyShading.
function tEmptyShading_Callback(hObject, eventdata, handles)
% hObject    handle to tEmptyShading (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function tOverhangName_Callback(hObject, eventdata, handles)
% hObject    handle to tOverhangName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tOverhangName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tOverhangName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLightshelfName_Callback(hObject, eventdata, handles)
% hObject    handle to tLightshelfName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tLightshelfName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLightshelfName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tCanopyTotalLength_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyTotalLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tCanopyTotalLength as text
%        str2double(get(hObject,'String')) returns contents of tCanopyTotalLength as a double
% Carrega dados dos planos
aWinPoints=get(handles.tCanopyPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

fRoomPreviewShadeDev(hObject,eventdata,handles);


function tCanopyDescription_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function tCanopySideIncrement_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopySideIncrement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tCanopySideIncrement as text
%        str2double(get(hObject,'String')) returns contents of tCanopySideIncrement as a double
aWinPoints=get(handles.tCanopyPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aWinPoints)));
if aEmpty>0
    return
end

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tCanopyCreateCancel.
function tCanopyCreateCancel_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyCreateCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPrevChild=handles.tAxesPreview.Children;
nSizePreviewNow=size(aPrevChild,1);
nSizePreviewOrig=str2double(get(handles.tVisPlotSize,'String'));

if nSizePreviewNow>nSizePreviewOrig %Já há pré-visualização sendo exibida
    % Apagar pre-visualização anterior
    for nD=nSizePreviewOrig+1:nSizePreviewNow
        delete(handles.tAxesPreview.Children(1));
    end
end

%Limpa tabela de Pontos
aDataCl=[];
set(handles.tCanopyPoints,'Data',aDataCl);

% Reseta variáveis
set(handles.tCanopyTotalLength,'String','1.2');
set(handles.tCanopyCurveRadius,'String','0.2');
set(handles.tCanopyDiscretization,'String','8');
set(handles.tCanopyTopDistance,'String','0');
set(handles.tCanopySideIncrement,'String','0.15');
    
%Travar as outras abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');

% Apara Tab
set(handles.tPanCanopy,'Visible','off');

% --- Executes on button press in tCanopyCreate.
function tCanopyCreate_Callback(hObject, eventdata, handles)
% hObject    handle to tCanopyCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','MsgBox');  %Load Language File

% Pontos
aPts=get(handles.tCanopyPoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aPts)));
if aEmpty>0
    return
end

%Importa Informações da tela 
nTotalLength=str2double(get(handles.tCanopyTotalLength,'String'));
nCurveRadius=str2double(get(handles.tCanopyCurveRadius,'String'));
nDiscretization=str2double(get(handles.tCanopyDiscretization,'String'));
nTopDistance=str2double(get(handles.tCanopyTopDistance,'String'));
nSideIncrement=str2double(get(handles.tCanopySideIncrement,'String'));
sName=get(handles.tCanopyDescription,'String');

aPlane=fCreateCanopy(aPts,nTotalLength-nCurveRadius,nCurveRadius,nDiscretization,nTopDistance,nSideIncrement);

nRoom=str2double(get(handles.tRoomNum,'String'));
nSizePlanes=size(aPlane,1);

%Verifica a qual grupo pertencerá os novos planos
aDataPoins=get(handles.tTablePlanes,'Data');
nGroup=max(cellfun(@max,aDataPoins(:,3)))+1;

%Cria Planos
for nP=1:nSizePlanes
    aVert=aPlane(nP,:);
    fPutNewSinglePlane(nRoom,aVert,sName,nGroup);
end

%Atualiza a exibição com os novos planos criados
nSizeData=size(aDataPoins,1);
nPlanes=nSizeData+1:nSizeData+nSizePlanes;
fUpdateData(handles,nPlanes,true);

sMens=MsgBox.CanopyCreated;
msgbox(sMens)

%Limpa tabela de Pontos
aDataCl=[];
set(handles.tCanopyPoints,'Data',aDataCl);

% Reseta variáveis
set(handles.tCanopyTotalLength,'String','1.2');
set(handles.tCanopyCurveRadius,'String','0.2');
set(handles.tCanopyDiscretization,'String','8');
set(handles.tCanopyTopDistance,'String','0');
set(handles.tCanopySideIncrement,'String','0.15');
    
%Travar as outras abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');

% Apara Tab
set(handles.tPanCanopy,'Visible','off');

% --- Executes during object creation, after setting all properties.
function tCanopyTotalLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tCanopyTotalLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLouvreName_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tLouvreName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLouvreAxisProjection_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreAxisProjection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tLouvreAxisProjection as text
%        str2double(get(hObject,'String')) returns contents of tLouvreAxisProjection as a double
% Salva valor e reexibe a visualização
nType=get(handles.ttLouvreTypeProperties,'UserData');
nLouvreAxisProjection=str2double(get(hObject,'String'));
nLouvreAxisProjectionO=get(handles.tLouvreAxisProjection,'UserData');
nLouvreAxisProjectionO{nType,1}=nLouvreAxisProjection;
set(handles.tLouvreAxisProjection,'UserData',nLouvreAxisProjectionO);

%Corrige o Cut Of Angle ou o Slat Lenght
tLouvreSlatLength_Callback(hObject, eventdata, handles)

%Visualiza
fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function tLouvreAxisProjection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreAxisProjection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tLouvreRotatePointsInvert.
function tLouvreRotatePointsInvert_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreRotatePointsInvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPoints=get(handles.tLouvrePoints,'Data');

aPointsRot{1,1}=aPoints{1,1}; aPointsRot{1,2}=aPoints{1,2}; aPointsRot{1,3}=aPoints{1,3};
aPointsRot{2,1}=aPoints{4,1}; aPointsRot{2,2}=aPoints{4,2}; aPointsRot{2,3}=aPoints{4,3};
aPointsRot{3,1}=aPoints{3,1}; aPointsRot{3,2}=aPoints{3,2}; aPointsRot{3,3}=aPoints{3,3};
aPointsRot{4,1}=aPoints{2,1}; aPointsRot{4,2}=aPoints{2,2}; aPointsRot{4,3}=aPoints{2,3};

set(handles.tLouvrePoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tLouvreImportWindow.
function tLouvreImportWindow_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreImportWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir

% Verifica se é louvre ou pergula
nType=get(handles.tPanLouvre,'UserData'); %1-louvre 2-pergula
load([spcodeDir '\bLangDef.tlx'],'-mat','Title','GuiSet');  %Load Language File

cData=get(handles.tTableWin,'Data');
nSizeData=size(cData,1);
nPos=1; aList=[]; nPosLouvre=1; nPosPergula=1;
for nL=1:2:nSizeData
    %Vetores do plano 
    aVet1=[(str2double(cData{nL,8})-str2double(cData{nL,5})),(str2double(cData{nL,9})-str2double(cData{nL,6})),(str2double(cData{nL,10})-str2double(cData{nL,7}))]; %Horizontal (2-1)
    aVet2=[(str2double(cData{nL,14})-str2double(cData{nL,5})),(str2double(cData{nL,15})-str2double(cData{nL,6})),(str2double(cData{nL,16})-str2double(cData{nL,7}))]; %Vertical (4-1)
    %Vetor Normal do Plano 
    aVetN=[(aVet1(2)*aVet2(3)-aVet2(2)*aVet1(3)),(aVet1(3)*aVet2(1)-aVet2(3)*aVet1(1)),(aVet1(1)*aVet2(2)-aVet2(1)*aVet1(2))];
    aVetN=aVetN/norm(aVetN);
    aPosPl(nPos,1)=nL;
    if nType==1 %Louvre
        if aVetN(3)~=1 && aVetN(3)~=-1
            aList{nPos}=[GuiSet.WindowInPlanes ' '  num2str(cData{nL,3}) '&' num2str(cData{nL+1,3})];
            aPosPl(nPos,2)=nPosLouvre;
            nPosLouvre=nPosLouvre+1;
            nPos=nPos+1;
        end
    else %Pergula
        if aVetN(3)==1 || aVetN(3)==-1
            aList{nPos}=[GuiSet.WindowInPlanes ' '  num2str(cData{nL,3}) '&' num2str(cData{nL+1,3})];
            aPosPl(nPos,2)=nPosPergula;
            nPosPergula=nPosPergula+1;
            nPos=nPos+1;
        end
    end   
end
    
%Escolha da Janela
[nChPl,~]=listdlg('Name',Title.ChooseWindow,'PromptString',Title.ChooseWindow,'selectionmode','single','listsize',[250 140],'liststring',aList);

% Determina Plano
nPl=aPosPl(aPosPl(:,2)==nChPl,1);

%Gera matriz de pontos
aPoints{4,1}=cData{nPl,5}; aPoints{4,2}=cData{nPl,6}; aPoints{4,3}=cData{nPl,7};
aPoints{1,1}=cData{nPl,8}; aPoints{1,2}=cData{nPl,9}; aPoints{1,3}=cData{nPl,10};
aPoints{2,1}=cData{nPl,11}; aPoints{2,2}=cData{nPl,12}; aPoints{2,3}=cData{nPl,13};
aPoints{3,1}=cData{nPl,14}; aPoints{3,2}=cData{nPl,15}; aPoints{3,3}=cData{nPl,16};

% Vetor da direção do Louvre
aPlanePrev=fCreateLouvre(handles,str2double(aPoints),{1;0},{0;0},{0;0},{0;0},{0;0},{2;0},{0;0},1);
if aPlanePrev{1,1}(3)~=aPlanePrev{1,2}(3) || aPlanePrev{1,1}(3)~=aPlanePrev{1,3}(3) || aPlanePrev{1,1}(3)~=aPlanePrev{1,4}(3)
    aPointsRot{1,1}=aPoints{4,1}; aPointsRot{1,2}=aPoints{4,2}; aPointsRot{1,3}=aPoints{4,3};
    aPointsRot{2,1}=aPoints{1,1}; aPointsRot{2,2}=aPoints{1,2}; aPointsRot{2,3}=aPoints{1,3};
    aPointsRot{3,1}=aPoints{2,1}; aPointsRot{3,2}=aPoints{2,2}; aPointsRot{3,3}=aPoints{2,3};
    aPointsRot{4,1}=aPoints{3,1}; aPointsRot{4,2}=aPoints{3,2}; aPointsRot{4,3}=aPoints{3,3};

    aPoints=aPointsRot;
end

set(handles.tLouvrePoints,'Data',aPoints);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tLouvreRotatePointsDown.
function tLouvreRotatePointsDown_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreRotatePointsDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPoints=get(handles.tLouvrePoints,'Data');

aPointsRot{1,1}=aPoints{4,1}; aPointsRot{1,2}=aPoints{4,2}; aPointsRot{1,3}=aPoints{4,3};
aPointsRot{2,1}=aPoints{1,1}; aPointsRot{2,2}=aPoints{1,2}; aPointsRot{2,3}=aPoints{1,3};
aPointsRot{3,1}=aPoints{2,1}; aPointsRot{3,2}=aPoints{2,2}; aPointsRot{3,3}=aPoints{2,3};
aPointsRot{4,1}=aPoints{3,1}; aPointsRot{4,2}=aPoints{3,2}; aPointsRot{4,3}=aPoints{3,3};

set(handles.tLouvrePoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tLouvreRotatePointsUp.
function tLouvreRotatePointsUp_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreRotatePointsUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPoints=get(handles.tLouvrePoints,'Data');

aPointsRot{1,1}=aPoints{2,1}; aPointsRot{1,2}=aPoints{2,2}; aPointsRot{1,3}=aPoints{2,3};
aPointsRot{2,1}=aPoints{3,1}; aPointsRot{2,2}=aPoints{3,2}; aPointsRot{2,3}=aPoints{3,3};
aPointsRot{3,1}=aPoints{4,1}; aPointsRot{3,2}=aPoints{4,2}; aPointsRot{3,3}=aPoints{4,3};
aPointsRot{4,1}=aPoints{1,1}; aPointsRot{4,2}=aPoints{1,2}; aPointsRot{4,3}=aPoints{1,3};

set(handles.tLouvrePoints,'Data',aPointsRot);

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tLouvreCreateCancel.
function tLouvreCreateCancel_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreCreateCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir

aPrevChild=handles.tAxesPreview.Children;
nSizePreviewNow=size(aPrevChild,1);
nSizePreviewOrig=str2double(get(handles.tVisPlotSize,'String'));

if nSizePreviewNow>nSizePreviewOrig %Já há pré-visualização sendo exibida
    % Apagar pre-visualização anterior
    for nD=nSizePreviewOrig+1:nSizePreviewNow
        delete(handles.tAxesPreview.Children(1));
    end
end

% Limpa tabela de Pontos
aDataCl=[];
set(handles.tLouvrePoints,'Data',aDataCl);

load([spcodeDir '\bLangDef.tlx'],'-mat','Legend');  %Load Language File

% Salva no UserData dos campos os padrões de horizontal e vertical
set(handles.tLouvreName,'UserData',{Legend.HLouvre;Legend.VLouvre},'String',Legend.HLouvre);
set(handles.tLouvreAxisProjection,'UserData',{0;0},'String','0');
set(handles.tLouvreSlatLength,'UserData',{0.15;0.15},'String','0.15');
set(handles.tLouvreSlatTickness,'UserData',{0;0},'String','0');
set(handles.tLouvreCutOfAngle,'UserData',{20;20},'String','20');
set(handles.tLouvreSlatAngle,'UserData',{0;0},'String','0');
set(handles.tLouvreSlatQuantity,'UserData',{5;10},'String','5');

% Set no horizontal
set(handles.tLouvreTypeVertical,'Enable','off');
set(handles.tLouvreTypeHorizontal,'Enable','on');
set(handles.ttLouvreTypeProperties,'String',Legend.HorizontalProperties,'UserData',1);
set(handles.tLouvreTypeHorizontalCh,'Value',1);
set(handles.tLouvreTypeVerticalCh,'Value',0);

%Travar as outras abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');

% Modifica os campos de edição
set(handles.tLouvreCutOfAngle,'Enable','Off');
set(handles.tLouvreSlatLength,'Enable','On');
set(handles.ttLouvreCutOfAngleBut,'Value',0);
set(handles.ttLouvreSlatLengthBut,'Value',1);

% Apaga Tab
set(handles.tPanLouvre,'Visible','off');

% --- Executes on button press in tLouvreCreate.
function tLouvreCreate_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','InputDlg','MsgBox','Legend');  %Load Language File

% Pontos
aPts=get(handles.tLouvrePoints,'Data');

%Verifica se está vazia a tabela de pontos
aEmpty=sum(sum(cellfun(@isempty,aPts)));
if aEmpty>0
    return
end

%Importa Informações da tela 
sName=get(handles.tLouvreName,'UserData');
nLSlat=get(handles.tLouvreSlatLength,'UserData');
nESlat={0;0};  
nProj=get(handles.tLouvreAxisProjection,'UserData');
nASlat=get(handles.tLouvreSlatAngle,'UserData');
nTSlat=get(handles.tLouvreSlatTickness,'UserData');
nNSlat=get(handles.tLouvreSlatQuantity,'UserData');

%Verifica a qual grupo pertencerá os novos planos
aDataPoins=get(handles.tTablePlanes,'Data');
nGroup=max(cellfun(@max,aDataPoins(:,3)))+1;
nRoom=str2double(get(handles.tRoomNum,'String'));

%tipos de brises
nBriseH=get(handles.tLouvreTypeHorizontalCh,'Value');
nBriseV=get(handles.tLouvreTypeVerticalCh,'Value');
if nBriseH==1 && nBriseV==1 % Ambos
    nHVType=0;
    [aPlane,nLh]=fCreateLouvre(handles,str2double(aPts),nLSlat,nESlat,nProj,nASlat,nTSlat,nNSlat,{0;0},nHVType);
    nSizePlanes=size(aPlane,1);
    %Cria Planos Horizontais
    for nP=1:nLh
        aVert=aPlane(nP,:);
        fPutNewSinglePlane(nRoom,aVert,sName{1},nGroup);
    end
    % Cria Planos Verticais
    for nP=nLh+1:nSizePlanes
        aVert=aPlane(nP,:);
        fPutNewSinglePlane(nRoom,aVert,sName{2},nGroup);
    end
elseif nBriseH==1
    nHVType=1;
    [aPlane]=fCreateLouvre(handles,str2double(aPts),nLSlat,nESlat,nProj,nASlat,nTSlat,nNSlat,{0;0},nHVType);
    nSizePlanes=size(aPlane,1);
    % Cria Planos Horizontais
    for nP=1:nSizePlanes
        aVert=aPlane(nP,:);
        fPutNewSinglePlane(nRoom,aVert,sName{1},nGroup);
    end
else
    nHVType=2;
    [aPlane]=fCreateLouvre(handles,str2double(aPts),nLSlat,nESlat,nProj,nASlat,nTSlat,nNSlat,{0;0},nHVType);
    nSizePlanes=size(aPlane,1);
    % Cria Planos Verticais
    for nP=1:nSizePlanes
        aVert=aPlane(nP,:);
        fPutNewSinglePlane(nRoom,aVert,sName{2},nGroup);
    end
end

%Atualiza a exibição com os novos planos criados
nSizeData=size(aDataPoins,1);
nPlanes=nSizeData+1:nSizeData+nSizePlanes;
fUpdateData(handles,nPlanes,true);

sNameTab=get(handles.tPanLouvre,'Title');
sMens=[sNameTab ' Created'];
msgbox(sMens)

% Limpa tabela de Pontos
aDataCl=[];
set(handles.tLouvrePoints,'Data',aDataCl);

% Salva no UserData dos campos os padrões de horizontal e vertical
set(handles.tLouvreName,'UserData',{Legend.HLouvre;Legend.VLouvre},'String',Legend.HLouvre);
set(handles.tLouvreAxisProjection,'UserData',{0;0},'String','0');
set(handles.tLouvreSlatLength,'UserData',{0.15;0.15},'String','0.15');
set(handles.tLouvreSlatTickness,'UserData',{0;0},'String','0');
set(handles.tLouvreCutOfAngle,'UserData',{20;20},'String','20');
set(handles.tLouvreSlatAngle,'UserData',{0;0},'String','0');
set(handles.tLouvreSlatQuantity,'UserData',{5;10},'String','5');

% Set no horizontal
set(handles.tLouvreTypeVertical,'Enable','off');
set(handles.tLouvreTypeHorizontal,'Enable','on');
set(handles.ttLouvreTypeProperties,'String',Legend.HorizontalProperties,'UserData',1);
set(handles.tLouvreTypeHorizontalCh,'Value',1);
set(handles.tLouvreTypeVerticalCh,'Value',0);

%Travar as outras abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');
set(handles.tPanElementButton,'Enable','on');

% Modifica os campos de edição
set(handles.tLouvreCutOfAngle,'Enable','Off');
set(handles.tLouvreSlatLength,'Enable','On');
set(handles.ttLouvreCutOfAngleBut,'Value',0);
set(handles.ttLouvreSlatLengthBut,'Value',1);

% Apaga Tab
set(handles.tPanLouvre,'Visible','off');


function tLouvreSlatTickness_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreSlatTickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tLouvreSlatTickness as text
%        str2double(get(hObject,'String')) returns contents of tLouvreSlatTickness as a double

% Salva valor e reexibe a visualização
nType=get(handles.ttLouvreTypeProperties,'UserData');
nLouvreSlatTickness=str2double(get(hObject,'String'));
nLouvreSlatTicknessO=get(handles.tLouvreSlatTickness,'UserData');
nLouvreSlatTicknessO{nType,1}=nLouvreSlatTickness;
set(handles.tLouvreSlatTickness,'UserData',nLouvreSlatTicknessO);

%Corrige o Cut Of Angle ou o Slat Lenght
% Corrige campos
fCutOfAngleSlatLengthLouvre(handles)

%Visualiza
fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function tLouvreSlatTickness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreSlatTickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLouvreSlatAngle_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreSlatAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tLouvreSlatAngle as text
%        str2double(get(hObject,'String')) returns contents of tLouvreSlatAngle as a double
% Salva valor e reexibe a visualização
nType=get(handles.ttLouvreTypeProperties,'UserData');
nLouvreSlatAngle=str2double(get(hObject,'String'));
nLouvreSlatAngleO=get(handles.tLouvreSlatAngle,'UserData');
nLouvreSlatAngleO{nType,1}=nLouvreSlatAngle;
set(handles.tLouvreSlatAngle,'UserData',nLouvreSlatAngleO);

% Corrige campos
fCutOfAngleSlatLengthLouvre(handles)

%Visualiza
fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function tLouvreSlatAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreSlatAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLouvreSlatQuantity_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreSlatQuantity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tLouvreSlatQuantity as text
%        str2double(get(hObject,'String')) returns contents of tLouvreSlatQuantity as a double

nType=get(handles.ttLouvreTypeProperties,'UserData');
nLouvreSlatQuantity=str2double(get(hObject,'String'));
nLouvreSlatQuantityO=get(handles.tLouvreSlatQuantity,'UserData');
nLouvreSlatQuantityO{nType,1}=nLouvreSlatQuantity;
set(handles.tLouvreSlatQuantity,'UserData',nLouvreSlatQuantityO);

%Corrige o Cut Of Angle ou o Slat Lenght
% Corrige campos
fCutOfAngleSlatLengthLouvre(handles)

%Visualiza
fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function tLouvreSlatQuantity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreSlatQuantity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit521_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit521 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLouvreIncrementUp_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreIncrementUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tLouvreIncrementUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreIncrementUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLouvreIncrementDown_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreIncrementDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tLouvreIncrementDown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreIncrementDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLouvreIncrementLeft_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreIncrementLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tLouvreIncrementLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreIncrementLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tLouvreIncrementRigth_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreIncrementRigth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tLouvreIncrementRigth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreIncrementRigth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tLouvreTypeHorizontalCh.
function tLouvreTypeHorizontalCh_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreTypeHorizontalCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tLouvreTypeHorizontalCh
global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','Legend');  %Load Language File

nLouvreHor=get(hObject,'Value');

if nLouvreHor==1
    set(handles.tLouvreTypeHorizontal,'Enable','on');
    set(handles.ttLouvreTypeProperties,'String',Legend.HorizontalProperties,'UserData',1);
    
    %set nas características salvas
    % Salva no UserData dos campos os padrões de horizontal e vertical
    sName=get(handles.tLouvreName,'UserData');
    nAxisProj=get(handles.tLouvreAxisProjection,'UserData');
    nSlatLength=get(handles.tLouvreSlatLength,'UserData');
    nSlatTickness=get(handles.tLouvreSlatTickness,'UserData');
    nCutOfAngle=get(handles.tLouvreCutOfAngle,'UserData');
    nSlatAngle=get(handles.tLouvreSlatAngle,'UserData');
    nSlatQuant=get(handles.tLouvreSlatQuantity,'UserData');
    
    set(handles.tLouvreName,'String',sName{1})
    set(handles.tLouvreAxisProjection,'String',num2str(nAxisProj{1}));
    set(handles.tLouvreSlatLength,'String',num2str(nSlatLength{1}));
    set(handles.tLouvreSlatTickness,'String',num2str(nSlatTickness{1}));
    set(handles.tLouvreCutOfAngle,'String',num2str(nCutOfAngle{1}));
    set(handles.tLouvreSlatAngle,'String',num2str(nSlatAngle{1}));
    set(handles.tLouvreSlatQuantity,'String',num2str(nSlatQuant{1}));
else
    % Ativa o outro, se estiver desativado
    set(handles.tLouvreTypeVertical,'Enable','on');
    set(handles.tLouvreTypeHorizontal,'Enable','off');
    set(handles.ttLouvreTypeProperties,'String',Legend.VerticalProperties,'UserData',2);
    set(handles.tLouvreTypeVerticalCh,'Value',1);
    
    %set nas características salvas
    % Salva no UserData dos campos os padrões de horizontal e vertical
    sName=get(handles.tLouvreName,'UserData');
    nAxisProj=get(handles.tLouvreAxisProjection,'UserData');
    nSlatLength=get(handles.tLouvreSlatLength,'UserData');
    nSlatTickness=get(handles.tLouvreSlatTickness,'UserData');
    nCutOfAngle=get(handles.tLouvreCutOfAngle,'UserData');
    nSlatAngle=get(handles.tLouvreSlatAngle,'UserData');
    nSlatQuant=get(handles.tLouvreSlatQuantity,'UserData');
    
    set(handles.tLouvreName,'String',sName{2})
    set(handles.tLouvreAxisProjection,'String',num2str(nAxisProj{2}));
    set(handles.tLouvreSlatLength,'String',num2str(nSlatLength{2}));
    set(handles.tLouvreSlatTickness,'String',num2str(nSlatTickness{2}));
    set(handles.tLouvreCutOfAngle,'String',num2str(nCutOfAngle{2}));
    set(handles.tLouvreSlatAngle,'String',num2str(nSlatAngle{2}));
    set(handles.tLouvreSlatQuantity,'String',num2str(nSlatQuant{2}));
end

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tLouvreTypeHorizontal.
function tLouvreTypeHorizontal_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreTypeHorizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','Legend');  %Load Language File

set(handles.tLouvreTypeHorizontal,'Enable','on');
set(handles.ttLouvreTypeProperties,'String',Legend.HorizontalProperties,'UserData',1);

%set nas características salvas
% Salva no UserData dos campos os padrões de horizontal e vertical
sName=get(handles.tLouvreName,'UserData');
nAxisProj=get(handles.tLouvreAxisProjection,'UserData');
nSlatLength=get(handles.tLouvreSlatLength,'UserData');
nSlatTickness=get(handles.tLouvreSlatTickness,'UserData');
nCutOfAngle=get(handles.tLouvreCutOfAngle,'UserData');
nSlatAngle=get(handles.tLouvreSlatAngle,'UserData');
nSlatQuant=get(handles.tLouvreSlatQuantity,'UserData');

set(handles.tLouvreName,'String',sName{1})
set(handles.tLouvreAxisProjection,'String',num2str(nAxisProj{1}));
set(handles.tLouvreSlatLength,'String',num2str(nSlatLength{1}));
set(handles.tLouvreSlatTickness,'String',num2str(nSlatTickness{1}));
set(handles.tLouvreCutOfAngle,'String',num2str(nCutOfAngle{1}));
set(handles.tLouvreSlatAngle,'String',num2str(nSlatAngle{1}));
set(handles.tLouvreSlatQuantity,'String',num2str(nSlatQuant{1}));

% --- Executes on button press in tLouvreTypeVerticalCh.
function tLouvreTypeVerticalCh_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreTypeVerticalCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tLouvreTypeVerticalCh
global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','Legend');  %Load Language File

nLouvreVert=get(hObject,'Value');

if nLouvreVert==1
    set(handles.tLouvreTypeVertical,'Enable','on');
    set(handles.ttLouvreTypeProperties,'String',Legend.VerticalProperties,'UserData',2);
    
    %set nas características salvas
    % Salva no UserData dos campos os padrões de horizontal e vertical
    sName=get(handles.tLouvreName,'UserData');
    nAxisProj=get(handles.tLouvreAxisProjection,'UserData');
    nSlatLength=get(handles.tLouvreSlatLength,'UserData');
    nSlatTickness=get(handles.tLouvreSlatTickness,'UserData');
    nCutOfAngle=get(handles.tLouvreCutOfAngle,'UserData');
    nSlatAngle=get(handles.tLouvreSlatAngle,'UserData');
    nSlatQuant=get(handles.tLouvreSlatQuantity,'UserData');
    
    set(handles.tLouvreName,'String',sName{2})
    set(handles.tLouvreAxisProjection,'String',num2str(nAxisProj{2}));
    set(handles.tLouvreSlatLength,'String',num2str(nSlatLength{2}));
    set(handles.tLouvreSlatTickness,'String',num2str(nSlatTickness{2}));
    set(handles.tLouvreCutOfAngle,'String',num2str(nCutOfAngle{2}));
    set(handles.tLouvreSlatAngle,'String',num2str(nSlatAngle{2}));
    set(handles.tLouvreSlatQuantity,'String',num2str(nSlatQuant{2}));
else
    % Ativa o outro, se estiver desativado
    set(handles.tLouvreTypeVertical,'Enable','off');
    set(handles.tLouvreTypeHorizontal,'Enable','on');
    set(handles.ttLouvreTypeProperties,'String',Legend.HorizontalProperties,'UserData',1);
    set(handles.tLouvreTypeHorizontalCh,'Value',1);
    
    %set nas características salvas
    % Salva no UserData dos campos os padrões de horizontal e vertical
    sName=get(handles.tLouvreName,'UserData');
    nAxisProj=get(handles.tLouvreAxisProjection,'UserData');
    nSlatLength=get(handles.tLouvreSlatLength,'UserData');
    nSlatTickness=get(handles.tLouvreSlatTickness,'UserData');
    nCutOfAngle=get(handles.tLouvreCutOfAngle,'UserData');
    nSlatAngle=get(handles.tLouvreSlatAngle,'UserData');
    nSlatQuant=get(handles.tLouvreSlatQuantity,'UserData');
    
    set(handles.tLouvreName,'String',sName{1})
    set(handles.tLouvreAxisProjection,'String',num2str(nAxisProj{1}));
    set(handles.tLouvreSlatLength,'String',num2str(nSlatLength{1}));
    set(handles.tLouvreSlatTickness,'String',num2str(nSlatTickness{1}));
    set(handles.tLouvreCutOfAngle,'String',num2str(nCutOfAngle{1}));
    set(handles.tLouvreSlatAngle,'String',num2str(nSlatAngle{1}));
    set(handles.tLouvreSlatQuantity,'String',num2str(nSlatQuant{1}));
end

fRoomPreviewShadeDev(hObject,eventdata,handles);

% --- Executes on button press in tLouvreTypeVertical.
function tLouvreTypeVertical_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreTypeVertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','Legend');  %Load Language File
set(handles.tLouvreTypeVertical,'Enable','on');
set(handles.ttLouvreTypeProperties,'String',Legend.VerticalProperties,'UserData',2);

%set nas características salvas
% Salva no UserData dos campos os padrões de horizontal e vertical
sName=get(handles.tLouvreName,'UserData');
nAxisProj=get(handles.tLouvreAxisProjection,'UserData');
nSlatLength=get(handles.tLouvreSlatLength,'UserData');
nSlatTickness=get(handles.tLouvreSlatTickness,'UserData');
nCutOfAngle=get(handles.tLouvreCutOfAngle,'UserData');
nSlatAngle=get(handles.tLouvreSlatAngle,'UserData');
nSlatQuant=get(handles.tLouvreSlatQuantity,'UserData');

set(handles.tLouvreName,'String',sName{2})
set(handles.tLouvreAxisProjection,'String',num2str(nAxisProj{2}));
set(handles.tLouvreSlatLength,'String',num2str(nSlatLength{2}));
set(handles.tLouvreSlatTickness,'String',num2str(nSlatTickness{2}));
set(handles.tLouvreCutOfAngle,'String',num2str(nCutOfAngle{2}));
set(handles.tLouvreSlatAngle,'String',num2str(nSlatAngle{2}));
set(handles.tLouvreSlatQuantity,'String',num2str(nSlatQuant{2}));

% --- Executes during object creation, after setting all properties.
function tLouvreTypeHorizontalCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLouvreTypeHorizontalCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in tLouvreRand.
function tLouvreRand_Callback(hObject, eventdata, handles)
% hObject    handle to tLouvreRand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tLouvreRand

nLouvreRand=get(hObject,'Value');

if nLouvreRand==1 %Aleatório
    set(handles.tLouvreSlatAngle,'Enable','off');
else
    % Nao Aleatório
    set(handles.tLouvreSlatAngle,'Enable','on');
end


%~~~~~~~~~~~~~~~~ FUNÇÕES DA TAB DE ELEMENTOS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


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
        nElCupboardOz =  nElCupboardOz_dot + (nElCupboardzizeZ * (n-1));
    end
    
    aOrigin=[nElCupboardOx nElCupboardOy nElCupboardOz];
    aDist=[nElCupboardzizeX nElCupboardzizeY nElCupboardzizeZ];

    %Cria o Elemento
    [aPlane]=fCreateTable(aOrigin,0,aDist);

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
[aPlane]=fCreateTable(aOrigin,0,aDist);

%Caso tenha 4 bases
aPeOrigin1=[nElTableOx nElTableOy 0];
aPeOrigin2=[nElTableOx + nElTableSizeX - nElTableSizeZ, nElTableOy, 0];
aPeOrigin3=[nElTableOx, nElTableOy + nElTableSizeY - nElTableSizeZ, 0];
aPeOrigin4=[nElTableOx + nElTableSizeX - nElTableSizeZ,  nElTableOy + nElTableSizeY - nElTableSizeZ, 0];

%cria a costa
aCostaOrigin=[nElTableOx, nElTableOy, nElTableOz + nElTableSizeZ];

%Padrão
[aPe1]=fCreateTable(aPeOrigin1,0,[0.1, 0.1 , nElTableOz]);
[aPe2]=fCreateTable(aPeOrigin2,0,[0.1, 0.1 , nElTableOz]);
[aPe3]=fCreateTable(aPeOrigin3,0,[0.1, 0.1 , nElTableOz]);
[aPe4]=fCreateTable(aPeOrigin4,0,[0.1, 0.1 , nElTableOz]);
[aCosta]=fCreateTable(aCostaOrigin,0,[nElTableSizeX, 0.1, nElTableOz + 0.2]);

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

nElTableXdist=str2double(get(handles.tElTableXdist,'String'));
nElTableYdist=str2double(get(handles.tElTableYdist,'String'));

nElTableSizeX=nElTableXdist/2;
nElTableSizeY=nElTableYdist/2;
nElTableSizeZ=str2double('0.2');

aOrigin=[nElTableOx nElTableOy nElTableOz];
aDist=[nElTableSizeX nElTableSizeY nElTableSizeZ];

%Cria o Elemento
[aPlane]=fCreateTable(aOrigin,0,aDist);

%Cria elemento da base

%Caso centralizado
aPeOrigin=[nElTableOx + nElTableSizeX/2 - nElTableSizeZ/2, nElTableOy + nElTableSizeY/2 - nElTableSizeZ/2, 0];

%Caso tenha 4 bases
aPeOrigin1=[nElTableOx nElTableOy 0];
aPeOrigin2=[nElTableOx + nElTableSizeX - nElTableSizeZ, nElTableOy, 0];
aPeOrigin3=[nElTableOx, nElTableOy + nElTableSizeY - nElTableSizeZ, 0];
aPeOrigin4=[nElTableOx + nElTableSizeX - nElTableSizeZ,  nElTableOy + nElTableSizeY - nElTableSizeZ, 0];

%central
[aPe]=fCreateTable(aPeOrigin,0,[0.2, 0.2 , nElTableOz]);

%Padrão
[aPe1]=fCreateTable(aPeOrigin1,0,[0.2, 0.2 , nElTableOz]);
[aPe2]=fCreateTable(aPeOrigin2,0,[0.2, 0.2 , nElTableOz]);
[aPe3]=fCreateTable(aPeOrigin3,0,[0.2, 0.2 , nElTableOz]);
[aPe4]=fCreateTable(aPeOrigin4,0,[0.2, 0.2 , nElTableOz]);

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

% --- Executes on button press in tElPrismButton.
function tElPrismButton_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Esconde demais tabs
set(handles.tPanElementCilynder,'Visible','off');
set(handles.tPanElementSphere,'Visible','off');
set(handles.tPanElementSphere,'Visible','off');
set(handles.tPanElementTable, 'Visible', 'off');

% Exibe tab
set(handles.tPanElementPrism,'Visible','on');

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
set(handles.tElPrismOx,'String',num2str(-20));
set(handles.tElPrismOy,'String',num2str(0));
set(handles.tElPrismOz,'String',num2str(0));
set(handles.tElPrismSizeX,'String',num2str(8));
set(handles.tElPrismSizeY,'String',num2str(8));
set(handles.tElPrismSizeZ,'String',num2str(24));
% set(handles.tElPrismOx,'String',num2str(str2double(aDataPlanes{14,8})/2));
% set(handles.tElPrismOy,'String',num2str(str2double(aDataPlanes{14,12})/2));
% set(handles.tElPrismOz,'String',num2str(str2double(aDataPlanes{14,7})));

% Pre visualiza
tElPrismSize_Callback(hObject, eventdata, handles)

%Travar as outras abas
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanShadingButton,'Enable','off');
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');

% --- Executes on button press in tElCilynderButton.
function tElCilynderButton_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Esconde demais tabs
set(handles.tPanElementPrism,'Visible','off');
set(handles.tPanElementSphere,'Visible','off');
set(handles.tPanElementSphere,'Visible','off');

% Exibe tab
set(handles.tPanElementCilynder,'Visible','on');

% Esconde opções de Truncamento
set(handles.ttElCilynderTruncHeight,'visible','off');
set(handles.tElCilynderTruncHeight,'visible','off');
set(handles.tElCilynderTruncUnit,'visible','off');

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
aDataPlanes=get(handles.tTablePlanes,'Data');
set(handles.tElCilynderOx,'String',num2str(-str2double(aDataPlanes{14,8})/2));
set(handles.tElCilynderOy,'String',num2str(str2double(aDataPlanes{14,12})/2));
set(handles.tElCilynderOz,'String',num2str(str2double(aDataPlanes{14,7})));
set(handles.tElCilynderTx,'String',num2str(-str2double(aDataPlanes{14,8})/2));
set(handles.tElCilynderTy,'String',num2str(str2double(aDataPlanes{14,12})/2));
set(handles.tElCilynderTz,'String',num2str(str2double(aDataPlanes{14,7})+1));

%Muda Nome da Tab
set(handles.tPanElementCilynder,'Title','Cilynder');

% Pre visualiza
tElCilynderSize_Callback(hObject, eventdata, handles)

%Travar as outras abas
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanShadingButton,'Enable','off');
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');

% --- Executes during object creation, after setting all properties.
function tElPrismOx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismOx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function tElPrismOz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismOz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function tElPrismOy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismOy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Callback de todos os campos de criaçao do elemento
function tElPrismSize_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElPrismSizeX as text
%        str2double(get(hObject,'String')) returns contents of tElPrismSizeX as a double

% Traz Dados 
nElPrismOx=str2double(get(handles.tElPrismOx,'String'));
nElPrismOy=str2double(get(handles.tElPrismOy,'String'));
nElPrismOz=str2double(get(handles.tElPrismOz,'String'));

nElPrismSizeX=str2double(get(handles.tElPrismSizeX,'String'));
nElPrismSizeY=str2double(get(handles.tElPrismSizeY,'String'));
nElPrismSizeZ=str2double(get(handles.tElPrismSizeZ,'String'));

nElPrismAngXaY=str2double(get(handles.tElPrismAngXaY,'String'));
nElPrismAngXaZ=str2double(get(handles.tElPrismAngXaZ,'String'));
nElPrismAngYaX=str2double(get(handles.tElPrismAngYaX,'String'));
nElPrismAngYaZ=str2double(get(handles.tElPrismAngYaZ,'String'));
nElPrismAngZaX=str2double(get(handles.tElPrismAngZaX,'String'));
nElPrismAngZaY=str2double(get(handles.tElPrismAngZaY,'String'));

aOrigin=[nElPrismOx nElPrismOy nElPrismOz];
aAngles=[nElPrismAngXaY nElPrismAngXaZ;nElPrismAngYaX nElPrismAngYaZ;nElPrismAngZaX nElPrismAngZaY];
aDist=[nElPrismSizeX nElPrismSizeY nElPrismSizeZ];

%Cria o Elemento
[aPlane]=fCreatePrism(aOrigin,aAngles,aDist);

% Identifica planos a serem visualizados 
aPlanePrev=[];
if get(handles.tElPrismBaseElement,'Value')==1 %Base
    nSize=size(aPlanePrev,1);
    for nP=1:4
        aPlanePrev{nSize+1,nP}=aPlane{1,nP};
    end
end
if get(handles.tElPrismTopElement,'Value')==1 %Topo
    nSize=size(aPlanePrev,1);
    for nP=1:4
        aPlanePrev{nSize+1,nP}=aPlane{2,nP};
    end
end
if get(handles.tElPrismSideElement,'Value')==1 %Lados
    nSize=size(aPlanePrev,1);
    for nP=1:4
        aPlanePrev{nSize+1,nP}=aPlane{3,nP};
        aPlanePrev{nSize+2,nP}=aPlane{4,nP};
        aPlanePrev{nSize+3,nP}=aPlane{5,nP};
        aPlanePrev{nSize+4,nP}=aPlane{6,nP};
    end
end

%Visualiza o Elemento
fRoomPreviewElement(hObject,eventdata,handles,aPlanePrev);

% --- Executes during object creation, after setting all properties.
function tElPrismSizeX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function tElPrismSizeY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismSizeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function tElPrismSizeZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismSizeZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tElPrismChXaY.
function tElPrismChXaY_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismChXaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tElPrismChXaY

% Verifica ação
nStat=get(hObject,'Value');

if nStat==1 %Ligou
   set(handles.tElPrismAngXaY,'Enable','on');
else % Desligou
   set(handles.tElPrismAngXaY,'Enable','off','String','0');  
end

tElPrismSize_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tElPrismAngXaY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismAngXaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tElPrismChXaZ.
function tElPrismChXaZ_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismChXaZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tElPrismChXaZ

nStat=get(hObject,'Value');

if nStat==1 %Ligou
   set(handles.tElPrismAngXaZ,'Enable','on');
else % Desligou
   set(handles.tElPrismAngXaZ,'Enable','off','String','0');  
end

tElPrismSize_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function tElPrismAngXaZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismAngXaZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tElPrismChYaX.
function tElPrismChYaX_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismChYaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tElPrismChYaX

nStat=get(hObject,'Value');

if nStat==1 %Ligou
   set(handles.tElPrismAngYaX,'Enable','on');
else % Desligou
   set(handles.tElPrismAngYaX,'Enable','off','String','0');  
end

tElPrismSize_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tElPrismAngYaX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismAngYaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tElPrismChYaZ.
function tElPrismChYaZ_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismChYaZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tElPrismChYaZ

nStat=get(hObject,'Value');

if nStat==1 %Ligou
   set(handles.tElPrismAngYaZ,'Enable','on');
else % Desligou
   set(handles.tElPrismAngYaZ,'Enable','off','String','0');  
end

tElPrismSize_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function tElPrismAngYaZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismAngYaZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tElPrismChZaX.
function tElPrismChZaX_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismChZaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tElPrismChZaX

nStat=get(hObject,'Value');

if nStat==1 %Ligou
   set(handles.tElPrismAngZaX,'Enable','on');
else % Desligou
   set(handles.tElPrismAngZaX,'Enable','off','String','0');  
end

tElPrismSize_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function tElPrismAngZaX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismAngZaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tElPrismChZaY.
function tElPrismChZaY_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismChZaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tElPrismChZaY

nStat=get(hObject,'Value');

if nStat==1 %Ligou
   set(handles.tElPrismAngZaY,'Enable','on');
else % Desligou
   set(handles.tElPrismAngZaY,'Enable','off','String','0');  
end

tElPrismSize_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function tElPrismAngZaY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElPrismAngZaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tElPrismBaseElement.
function tElPrismBaseElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismBaseElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in tElPrismTopElement.
function tElPrismTopElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismTopElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in tElPrismSideElement.
function tElPrismSideElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismSideElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in tElPrismCreateElement.
function tElPrismCreateElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismCreateElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','InputDlg','MsgBox');  %Load Language File

% Traz Dados 
nElPrismOx=str2double(get(handles.tElPrismOx,'String'));
nElPrismOy=str2double(get(handles.tElPrismOy,'String'));
nElPrismOz=str2double(get(handles.tElPrismOz,'String'));

nElPrismSizeX=str2double(get(handles.tElPrismSizeX,'String'));
nElPrismSizeY=str2double(get(handles.tElPrismSizeY,'String'));
nElPrismSizeZ=str2double(get(handles.tElPrismSizeZ,'String'));

nElPrismAngXaY=str2double(get(handles.tElPrismAngXaY,'String'));
nElPrismAngXaZ=str2double(get(handles.tElPrismAngXaZ,'String'));
nElPrismAngYaX=str2double(get(handles.tElPrismAngYaX,'String'));
nElPrismAngYaZ=str2double(get(handles.tElPrismAngYaZ,'String'));
nElPrismAngZaX=str2double(get(handles.tElPrismAngZaX,'String'));
nElPrismAngZaY=str2double(get(handles.tElPrismAngZaY,'String'));

aOrigin=[nElPrismOx nElPrismOy nElPrismOz];
aAngles=[nElPrismAngXaY nElPrismAngXaZ;nElPrismAngYaX nElPrismAngYaZ;nElPrismAngZaX nElPrismAngZaY];
aDist=[nElPrismSizeX nElPrismSizeY nElPrismSizeZ];

%Cria o Elemento
[aPlane]=fCreatePrism(aOrigin,aAngles,aDist);

% Identifica planos a serem visualizados 
aPlanePrev=[];
if get(handles.tElPrismBaseElement,'Value')==1 %Base
    nSize=size(aPlanePrev,1);
    for nP=1:4
        aPlanePrev{nSize+1,nP}=aPlane{1,nP};
    end
end
if get(handles.tElPrismTopElement,'Value')==1 %Topo
    nSize=size(aPlanePrev,1);
    for nP=1:4
        aPlanePrev{nSize+1,nP}=aPlane{2,nP};
    end
end
if get(handles.tElPrismSideElement,'Value')==1 %Lados
    nSize=size(aPlanePrev,1);
    for nP=1:4
        aPlanePrev{nSize+1,nP}=aPlane{3,nP};
        aPlanePrev{nSize+2,nP}=aPlane{4,nP};
        aPlanePrev{nSize+3,nP}=aPlane{5,nP};
        aPlanePrev{nSize+4,nP}=aPlane{6,nP};
    end
end

nRoom=str2double(get(handles.tRoomNum,'String'));
nSizePlanes=size(aPlanePrev,1);

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

%Atualiza a exibição com os novos planos criados
nSizeData=size(aDataPoins,1);
nPlanes=nSizeData+1:nSizeData+nSizePlanesNew;
fUpdateData(handles,nPlanes,true);

sMens=[MsgBox.ElementCreated];

uiwait(msgbox(sMens));

%Limpa Campos
fClearFieldsCreatePrism(handles)

% Apaga tab
set(handles.tPanElementPrism,'Visible','off');

%Destrava as Abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanShadingButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');

% --- Executes on button press in tElPrismCancelCreateElement.
function tElPrismCancelCreateElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismCancelCreateElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPrevChild=handles.tAxesPreview.Children;
nSizePreviewNow=size(aPrevChild,1);
nSizePreviewOrig=str2double(get(handles.tVisPlotSize,'String'));

if nSizePreviewNow>nSizePreviewOrig %Já há pré-visualização sendo exibida
    % Apagar pre-visualização anterior
    for nD=nSizePreviewOrig+1:nSizePreviewNow
        delete(handles.tAxesPreview.Children(1));
    end
end

%Limpa Campos
fClearFieldsCreatePrism(handles)

% Apaga tab
set(handles.tPanElementPrism,'Visible','off');

%Destrava as Abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanShadingButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');


function ttElPrismElementName_Callback(hObject, eventdata, handles)
% hObject    handle to ttElPrismElementName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function ttElPrismElementName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttElPrismElementName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElPrismSizeX_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in tElSphereButton.
function tElConeButton_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Esconde demais tabs
set(handles.tPanElementPrism,'Visible','off');
set(handles.tPanElementSphere,'Visible','off');

% Exibe tab
set(handles.tPanElementCilynder,'Visible','on');

% Visualiza opções de Truncamento
set(handles.ttElCilynderTruncHeight,'visible','on');
set(handles.tElCilynderTruncHeight,'visible','on');
set(handles.tElCilynderTruncUnit,'visible','on');

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
aDataPlanes=get(handles.tTablePlanes,'Data');
set(handles.tElCilynderOx,'String',num2str(-str2double(aDataPlanes{14,8})/2));
set(handles.tElCilynderOy,'String',num2str(str2double(aDataPlanes{14,12})/2));
set(handles.tElCilynderOz,'String',num2str(str2double(aDataPlanes{14,7})));
set(handles.tElCilynderTx,'String',num2str(-str2double(aDataPlanes{14,8})/2));
set(handles.tElCilynderTy,'String',num2str(str2double(aDataPlanes{14,12})/2));
set(handles.tElCilynderTz,'String',num2str(str2double(aDataPlanes{14,7})+1));


%Muda Nome da Tab
set(handles.tPanElementCilynder,'Title','Cone');

% Pre visualiza
tElCilynderSize_Callback(hObject, eventdata, handles)

%Travar as outras abas
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanShadingButton,'Enable','off');
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');

% --- Executes on button press in tElSphereButton.
function tElSphereButton_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Esconde demais tabs
set(handles.tPanElementPrism,'Visible','off');
set(handles.tPanElementCilynder,'Visible','off');

% Exibe tab
set(handles.tPanElementSphere,'Visible','on');

% Visualiza opções de Truncamento
set(handles.ttElCilynderTruncHeight,'visible','off');
set(handles.tElCilynderTruncHeight,'visible','off');
set(handles.tElCilynderTruncUnit,'visible','off');

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
aDataPlanes=get(handles.tTablePlanes,'Data');
set(handles.tElSphereOx,'String',num2str(-str2double(aDataPlanes{14,8})/2));
set(handles.tElSphereOy,'String',num2str(str2double(aDataPlanes{14,12})/2));
set(handles.tElSphereOz,'String',num2str(str2double(aDataPlanes{14,7})));

% Pre visualiza
tElSphereSize_Callback(hObject, eventdata, handles)

%Travar as outras abas
set(handles.tPanVisButton,'Enable','off');
set(handles.tPanWinButton,'Enable','off');
set(handles.tPanMaterialButton,'Enable','off');
set(handles.tPanShadingButton,'Enable','off');
set(handles.tPanDataButton,'Enable','off');
set(handles.tPanPrjButton,'Enable','off');

% --- Executes on button press in tElSphereButton.
function pushbutton183_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function tElCilynderSize_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderOx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElCilynderOx as text
%        str2double(get(hObject,'String')) returns contents of tElCilynderOx as a double

% Traz Dados 
nElCilynderOx=str2double(get(handles.tElCilynderOx,'String'));
nElCilynderOy=str2double(get(handles.tElCilynderOy,'String'));
nElCilynderOz=str2double(get(handles.tElCilynderOz,'String'));

nElCilynderTx=str2double(get(handles.tElCilynderTx,'String'));
nElCilynderTy=str2double(get(handles.tElCilynderTy,'String'));
nElCilynderTz=str2double(get(handles.tElCilynderTz,'String'));

nElCilynderDivisions=str2double(get(handles.tElCilynderDivisions,'String'));

nElCilynderDiameter=str2double(get(handles.tElCilynderDiameter,'String'));

nElCilynderTrunc=get(handles.tElCilynderTruncHeight,'Value');
nElCilOrCone=get(handles.tElCilynderTruncHeight,'visible');
nElCilynderTruncHeight=str2double(get(handles.ttElCilynderTruncHeight,'String'));


aOrigin=[nElCilynderOx nElCilynderOy nElCilynderOz];
aTop=[nElCilynderTx nElCilynderTy nElCilynderTz];

%Cria o Elemento
if strcmp(nElCilOrCone,'on') %cone
    [aPlane]=fCreateConeCylinder(aOrigin,aTop,nElCilynderDiameter,nElCilynderDivisions,nElCilynderTrunc,nElCilynderTruncHeight);
    
    % Identifica planos a serem visualizados 
    aPlanePrev=[];
    if get(handles.tElCilynderBaseElement,'Value')==1 %Base
        for nPl=0:1:nElCilynderDivisions-1
            nSize=size(aPlanePrev,1);
            for nP=1:4
                aPlanePrev{nSize+1,nP}=aPlane{end-nPl,nP};
            end
        end
    end
    if nElCilynderTrunc==1 %Truncado
        if get(handles.tElCilynderTopElement,'Value')==1 %Topo
            for nPl=nElCilynderDivisions:1:2*nElCilynderDivisions-1
                nSize=size(aPlanePrev,1);
                for nP=1:4
                    aPlanePrev{nSize+1,nP}=aPlane{end-nPl,nP};
                end
            end
        end
        if get(handles.tElCilynderSideElement,'Value')==1 %Lados
            nSizePl=size(aPlane,1);
            for nPl=1:nSizePl-2*nElCilynderDivisions
                nSize=size(aPlanePrev,1);
                for nP=1:4
                    aPlanePrev{nSize+1,nP}=aPlane{nPl,nP};
                end
            end
        end
    else
        if get(handles.tElCilynderSideElement,'Value')==1 %Lados
            nSizePl=size(aPlane,1);
            for nPl=1:nSizePl-nElCilynderDivisions
                nSize=size(aPlanePrev,1);
                for nP=1:4
                    aPlanePrev{nSize+1,nP}=aPlane{nPl,nP};
                end
            end
        end
    end
else
    [aPlane]=fCreateConeCylinder(aOrigin,aTop,nElCilynderDiameter,nElCilynderDivisions,2,nElCilynderTruncHeight);
    
    % Identifica planos a serem visualizados 
    aPlanePrev=[];
    if get(handles.tElCilynderBaseElement,'Value')==1 %Base
        for nPl=0:1:nElCilynderDivisions-1
            nSize=size(aPlanePrev,1);
            for nP=1:4
                aPlanePrev{nSize+1,nP}=aPlane{end-nPl,nP};
            end
        end
    end
    if get(handles.tElCilynderTopElement,'Value')==1 %Topo
        for nPl=nElCilynderDivisions:1:2*nElCilynderDivisions-1
            nSize=size(aPlanePrev,1);
            for nP=1:4
                aPlanePrev{nSize+1,nP}=aPlane{end-nPl,nP};
            end
        end
    end
    if get(handles.tElCilynderSideElement,'Value')==1 %Lados
        nSizePl=size(aPlane,1);
        for nPl=1:nSizePl-2*nElCilynderDivisions
            nSize=size(aPlanePrev,1);
            for nP=1:4
                aPlanePrev{nSize+1,nP}=aPlane{nPl,nP};
            end
        end
    end
end

%Visualiza o Elemento
fRoomPreviewElement(hObject,eventdata,handles,aPlanePrev);

% --- Executes during object creation, after setting all properties.
function tElCilynderOx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCilynderOx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElCilynderOz_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderOz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElCilynderOz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCilynderOz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElCilynderOy_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderOy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElCilynderOy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCilynderOy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElCilynderDivisions_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderDivisions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElCilynderDivisions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCilynderDivisions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElCilynderDiameter_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderDiameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElCilynderDiameter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCilynderDiameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tElCilynderTruncHeight.
function tElCilynderTruncHeight_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderTruncHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tElCilynderTruncHeight

nTrunc=get(hObject,'value');
if nTrunc==1 %Truncado
    set(handles.ttElCilynderTruncHeight,'enable','on');
else
    set(handles.ttElCilynderTruncHeight,'enable','off','string','0');
end

%Visualiza
tElCilynderSize_Callback(hObject, eventdata, handles)


function ttElCilynderTruncHeight_Callback(hObject, eventdata, handles)
% hObject    handle to ttElCilynderTruncHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function ttElCilynderTruncHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttElCilynderTruncHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tElCilynderBaseElement.
function tElCilynderBaseElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderBaseElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in tElCilynderTopElement.
function tElCilynderTopElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderTopElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in tElCilynderSideElement.
function tElCilynderSideElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderSideElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in tElCilynderCreateElement.
function tElCilynderCreateElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderCreateElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','InputDlg','MsgBox');  %Load Language File

% Traz Dados 
nElCilynderOx=str2double(get(handles.tElCilynderOx,'String'));
nElCilynderOy=str2double(get(handles.tElCilynderOy,'String'));
nElCilynderOz=str2double(get(handles.tElCilynderOz,'String'));

nElCilynderTx=str2double(get(handles.tElCilynderTx,'String'));
nElCilynderTy=str2double(get(handles.tElCilynderTy,'String'));
nElCilynderTz=str2double(get(handles.tElCilynderTz,'String'));

nElCilynderDivisions=str2double(get(handles.tElCilynderDivisions,'String'));

nElCilynderDiameter=str2double(get(handles.tElCilynderDiameter,'String'));

nElCilynderTrunc=get(handles.tElCilynderTruncHeight,'Value');
nElCilOrCone=get(handles.tElCilynderTruncHeight,'visible');
nElCilynderTruncHeight=str2double(get(handles.ttElCilynderTruncHeight,'String'));


aOrigin=[nElCilynderTx nElCilynderOy nElCilynderOz];
aTop=[nElCilynderOx nElCilynderTy nElCilynderTz];

%Cria o Elemento
if strcmp(nElCilOrCone,'on') %cone
    [aPlane]=fCreateConeCylinder(aOrigin,aTop,nElCilynderDiameter,nElCilynderDivisions,nElCilynderTrunc,nElCilynderTruncHeight);
    
    % Identifica planos a serem visualizados 
    aPlanePrev=[];
    if get(handles.tElCilynderBaseElement,'Value')==1 %Base
        for nPl=0:1:nElCilynderDivisions-1
            nSize=size(aPlanePrev,1);
            for nP=1:4
                aPlanePrev{nSize+1,nP}=aPlane{end-nPl,nP};
            end
        end
    end
    if nElCilynderTrunc==1 %Truncado
        if get(handles.tElCilynderTopElement,'Value')==1 %Topo
            for nPl=nElCilynderDivisions:1:2*nElCilynderDivisions-1
                nSize=size(aPlanePrev,1);
                for nP=1:4
                    aPlanePrev{nSize+1,nP}=aPlane{end-nPl,nP};
                end
            end
        end
        if get(handles.tElCilynderSideElement,'Value')==1 %Lados
            nSizePl=size(aPlane,1);
            for nPl=1:nSizePl-2*nElCilynderDivisions
                nSize=size(aPlanePrev,1);
                for nP=1:4
                    aPlanePrev{nSize+1,nP}=aPlane{nPl,nP};
                end
            end
        end
    else
        if get(handles.tElCilynderSideElement,'Value')==1 %Lados
            nSizePl=size(aPlane,1);
            for nPl=1:nSizePl-nElCilynderDivisions
                nSize=size(aPlanePrev,1);
                for nP=1:4
                    aPlanePrev{nSize+1,nP}=aPlane{nPl,nP};
                end
            end
        end
    end
else
    [aPlane]=fCreateConeCylinder(aOrigin,aTop,nElCilynderDiameter,nElCilynderDivisions,2,nElCilynderTruncHeight);
    
    % Identifica planos a serem visualizados 
    aPlanePrev=[];
    if get(handles.tElCilynderBaseElement,'Value')==1 %Base
        for nPl=0:1:nElCilynderDivisions-1
            nSize=size(aPlanePrev,1);
            for nP=1:4
                aPlanePrev{nSize+1,nP}=aPlane{end-nPl,nP};
            end
        end
    end
    if get(handles.tElCilynderTopElement,'Value')==1 %Topo
        for nPl=nElCilynderDivisions:1:2*nElCilynderDivisions-1
            nSize=size(aPlanePrev,1);
            for nP=1:4
                aPlanePrev{nSize+1,nP}=aPlane{end-nPl,nP};
            end
        end
    end
    if get(handles.tElCilynderSideElement,'Value')==1 %Lados
        nSizePl=size(aPlane,1);
        for nPl=1:nSizePl-2*nElCilynderDivisions
            nSize=size(aPlanePrev,1);
            for nP=1:4
                aPlanePrev{nSize+1,nP}=aPlane{nPl,nP};
            end
        end
    end
end

nRoom=str2double(get(handles.tRoomNum,'String'));
nSizePlanes=size(aPlanePrev,1);

%Verifica a qual grupo pertencerá os novos planos
aDataPoins=get(handles.tTablePlanes,'Data');
nGroup=max(cellfun(@max,aDataPoins(:,3)))+1;

%Insere Plano a Plano
for nP=1:nSizePlanes
    aVert=aPlanePrev(nP,:);
    fPutNewSinglePlane(nRoom,aVert,get(handles.ttElPrismElementName,'String'),nGroup);
end

%Atualiza a exibição com os novos planos criados
nSizeData=size(aDataPoins,1);
nPlanes=nSizeData+1:nSizeData+nSizePlanes;
fUpdateData(handles,nPlanes,true);

sMens=[MsgBox.ElementCreated];

uiwait(msgbox(sMens));

%Limpa Campos
fClearFieldsCreateCilynder(handles)

% Apaga tab
set(handles.tPanElementCilynder,'Visible','off');

%Travar as outras abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanShadingButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');

% --- Executes on button press in ttElCilynderCancelCreateElement.
function ttElCilynderCancelCreateElement_Callback(hObject, eventdata, handles)
% hObject    handle to ttElCilynderCancelCreateElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPrevChild=handles.tAxesPreview.Children;
nSizePreviewNow=size(aPrevChild,1);
nSizePreviewOrig=str2double(get(handles.tVisPlotSize,'String'));

if nSizePreviewNow>nSizePreviewOrig %Já há pré-visualização sendo exibida
    % Apagar pre-visualização anterior
    for nD=nSizePreviewOrig+1:nSizePreviewNow
        delete(handles.tAxesPreview.Children(1));
    end
end

%Limpa Campos
fClearFieldsCreateCilynder(handles)

% Apaga tab
set(handles.tPanElementCilynder,'Visible','off');

%Destrava as Abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanShadingButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');


function tElCilynderElementName_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderElementName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElCilynderElementName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCilynderElementName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElCilynderTy_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderTy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElCilynderTy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCilynderTy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElCilynderTz_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderTz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElCilynderTz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCilynderTz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElCilynderTx_Callback(hObject, eventdata, handles)
% hObject    handle to tElCilynderTx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElCilynderTx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCilynderTx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElSphereSize_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereOx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElSphereOx as text
%        str2double(get(hObject,'String')) returns contents of tElSphereOx as a double

% Traz Dados 
nElSphereOx=str2double(get(handles.tElSphereOx,'String'));
nElSphereOy=str2double(get(handles.tElSphereOy,'String'));
nElSphereOz=str2double(get(handles.tElSphereOz,'String'));

nElSphereMeridians=str2double(get(handles.tElSphereMeridians,'String'));
nElSphereParalels=str2double(get(handles.tElSphereParalels,'String'));
nElSphereDiameter=str2double(get(handles.tElSphereDiameter,'String'));

nElSphereTop=get(handles.tElSphereTopElement,'Value');
nElSphereBotton=get(handles.tElSphereBottonElement,'Value');

aOrigin=[nElSphereOx nElSphereOy nElSphereOz];

if nElSphereTop==0 && nElSphereBotton==1 %Apenas parte de Baixo
    [aPlane]=fCreateSphere(nElSphereParalels,nElSphereMeridians,nElSphereDiameter*0.5,aOrigin,2);
elseif nElSphereTop==1 && nElSphereBotton==0 %Apenas parte de Cima
    [aPlane]=fCreateSphere(nElSphereParalels,nElSphereMeridians,nElSphereDiameter*0.5,aOrigin,1);
else %Esfera Completa
    [aPlane]=fCreateSphere(nElSphereParalels,nElSphereMeridians,nElSphereDiameter*0.5,aOrigin,0);
end

% Cria o Elemento
% Identifica planos a serem visualizados 
aPlanePrev=[];
for nPl=1:1:size(aPlane,1)
    nSize=size(aPlanePrev,1);
    for nP=1:4
        aPlanePrev{nSize+1,nP}=aPlane{nPl,nP};
    end
end
    
%Visualiza o Elemento
fRoomPreviewElement(hObject,eventdata,handles,aPlanePrev);

% --- Executes during object creation, after setting all properties.
function tElSphereOx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElSphereOx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElSphereOz_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereOz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElSphereOz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElSphereOz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElSphereOy_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereOy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElSphereOy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElSphereOy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElSphereParalels_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereParalels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function tElSphereParalels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElSphereParalels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElSphereDiameter_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereDiameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElSphereDiameter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElSphereDiameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tElSphereBottonElement.
function tElSphereBottonElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereBottonElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in tElSphereTopElement.
function tElSphereTopElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereTopElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in tElSphereCreateElement.
function tElSphereCreateElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereCreateElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','InputDlg','MsgBox');  %Load Language File

% Traz Dados 
nElSphereOx=str2double(get(handles.tElSphereOx,'String'));
nElSphereOy=str2double(get(handles.tElSphereOy,'String'));
nElSphereOz=str2double(get(handles.tElSphereOz,'String'));

nElSphereMeridians=str2double(get(handles.tElSphereMeridians,'String'));
nElSphereParalels=str2double(get(handles.tElSphereParalels,'String'));
nElSphereDiameter=str2double(get(handles.tElSphereDiameter,'String'));

nElSphereTop=get(handles.tElSphereTopElement,'Value');
nElSphereBotton=get(handles.tElSphereBottonElement,'Value');

aOrigin=[nElSphereOx nElSphereOy nElSphereOz];

if nElSphereTop==0 && nElSphereBotton==1 %Apenas parte de Baixo
    [aPlane]=fCreateSphere(nElSphereParalels,nElSphereMeridians,nElSphereDiameter*0.5,aOrigin,2);
elseif nElSphereTop==1 && nElSphereBotton==0 %Apenas parte de Cima
    [aPlane]=fCreateSphere(nElSphereParalels,nElSphereMeridians,nElSphereDiameter*0.5,aOrigin,1);
else %Esfera Completa
    [aPlane]=fCreateSphere(nElSphereParalels,nElSphereMeridians,nElSphereDiameter*0.5,aOrigin,0);
end

% Cria o Elemento
% Identifica planos a serem visualizados 
aPlanePrev=[];
for nPl=1:1:size(aPlane,1)
    nSize=size(aPlanePrev,1);
    for nP=1:4
        aPlanePrev{nSize+1,nP}=aPlane{nPl,nP};
    end
end

nRoom=str2double(get(handles.tRoomNum,'String'));
nSizePlanes=size(aPlanePrev,1);

%Verifica a qual grupo pertencerá os novos planos
aDataPoins=get(handles.tTablePlanes,'Data');
nGroup=max(cellfun(@max,aDataPoins(:,3)))+1;

%Insere Plano a Plano
for nP=1:nSizePlanes
    aVert=aPlanePrev(nP,:);
    fPutNewSinglePlane(nRoom,aVert,get(handles.ttElPrismElementName,'String'),nGroup);
end

%Atualiza a exibição com os novos planos criados
nSizeData=size(aDataPoins,1);
nPlanes=nSizeData+1:nSizeData+nSizePlanes;
fUpdateData(handles,nPlanes,true);

sMens=[MsgBox.ElementCreated];

uiwait(msgbox(sMens));

%Limpa Campos
fClearFieldsCreateSphere(handles)

% Apaga tab
set(handles.tPanElementSphere,'Visible','off');

%Destrava as Abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanShadingButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');

% --- Executes on button press in tElSphereCancelCreateElement.
function tElSphereCancelCreateElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereCancelCreateElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

aPrevChild=handles.tAxesPreview.Children;
nSizePreviewNow=size(aPrevChild,1);
nSizePreviewOrig=str2double(get(handles.tVisPlotSize,'String'));

if nSizePreviewNow>nSizePreviewOrig %Já há pré-visualização sendo exibida
    % Apagar pre-visualização anterior
    for nD=nSizePreviewOrig+1:nSizePreviewNow
        delete(handles.tAxesPreview.Children(1));
    end
end

%Limpa Campos
fClearFieldsCreateSphere(handles)

% Apaga tab
set(handles.tPanElementSphere,'Visible','off');

%Destrava as Abas
set(handles.tPanVisButton,'Enable','on');
set(handles.tPanWinButton,'Enable','on');
set(handles.tPanMaterialButton,'Enable','on');
set(handles.tPanShadingButton,'Enable','on');
set(handles.tPanDataButton,'Enable','on');
set(handles.tPanPrjButton,'Enable','on');


function tElSphereElementName_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereElementName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElSphereElementName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElSphereElementName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tElSphereMeridians_Callback(hObject, eventdata, handles)
% hObject    handle to tElSphereMeridians (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function tElSphereMeridians_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElSphereMeridians (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function tPanElements_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tPanElements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in tDecDownPl.
function tDecDownPl_Callback(hObject, eventdata, handles)
% hObject    handle to tDecDownPl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sInputDir spcodeDir

% Numero de casas Decimais
nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
if nDec~=1 % Se for um, não faz nada

    nRoomNum=str2double(get(handles.tRoomNum,'String'));
    sRoomNum=fPut0(nRoomNum,3);
    sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; %nome do arquivo de planos
    if exist(sFilePl,'file')==2
        load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
    else
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
        return
    end

    % Novo formato de exibição - ORESTES 2016
    [nTPl,~]=size(cPlane); % Número de planos no arquivo
    aData=cell(nTPl,15); % Cria matriz vazia de dados
    nDec=num2str(str2double(nDec)-1);
    for k=1:nTPl % Isola as coordenadas e a descrição de cala plano e cria a matriz de dados para exibição 

        aData{k,1}=cPlane{k,1}; % %Número
        aData{k,2}=cPlane{k,2}; %Tipo
        %Se a descrição estiver vazia, insere um campo genérico
        if isempty(cPlane{k,9}) 
            aData{k,3}=1; 
        else
            aData{k,3}=cPlane{k,9}; %Grupo
        end
        aData{k,4}=cPlane{k,3}; % Descrição

        % Importa casas decimais
        aData{k,5}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(1))']);
        aData{k,6}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(2))']);
        aData{k,7}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(3))']);
        aData{k,8}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(1))']);
        aData{k,9}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(2))']);
        aData{k,10}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(3))']);
        aData{k,11}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(1))']);
        aData{k,12}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(2))']);
        aData{k,13}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(3))']);
        aData{k,14}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(1))']);
        aData{k,15}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(2))']);
        aData{k,16}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(3))']);
    end
    
    aColWiData=get(handles.tTablePlanes,'ColumnWidth');
    nColw=aColWiData{5}-6;
    aColWidth={25,30,39,135,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw};
    
    %Exibe dados dos planos
    set(handles.tTablePlanes,'Data',aData,'ColumnWidth',aColWidth) % Carrega a tabela com os dados 

    %Mantém Scrol na Posição
    jScrollpane=findjobj(handles.tTablePlanes);
    scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
    nData=size(get(handles.tTablePlanes,'Data'),1);
    nPos=(scrollMax/nData)*(size(aData,1)-1);
    jScrollpane.getVerticalScrollBar.setValue(floor(nPos));   % Coloca o Scroll na posição
    
    %Atualiza quantidade de campos salva
    set(handles.ttDecimalsPlane,'UserData',str2double(nDec));
end


% --- Executes on button press in tDecUpPl.
function tDecUpPl_Callback(hObject, eventdata, handles)
% hObject    handle to tDecUpPl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sInputDir spcodeDir

% Numero de casas Decimais
nDec=num2str(get(handles.ttDecimalsPlane,'UserData'));
if nDec~=1 % Se for um, não faz nada

    nRoomNum=str2double(get(handles.tRoomNum,'String'));
    sRoomNum=fPut0(nRoomNum,3);
    sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; %nome do arquivo de planos
    if exist(sFilePl,'file')==2
        load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
    else
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
        return
    end

    % Novo formato de exibição - ORESTES 2016
    [nTPl,~]=size(cPlane); % Número de planos no arquivo
    aData=cell(nTPl,15); % Cria matriz vazia de dados
    nDec=num2str(str2double(nDec)+1);
    for k=1:nTPl % Isola as coordenadas e a descrição de cala plano e cria a matriz de dados para exibição 

        aData{k,1}=cPlane{k,1}; %#ok<*IDISVAR> %Número
        aData{k,2}=cPlane{k,2}; %Tipo
        %Se a descrição estiver vazia, insere um campo genérico
        if isempty(cPlane{k,9}) 
            aData{k,3}=1; 
        else
            aData{k,3}=cPlane{k,9}; %Grupo
        end
        aData{k,4}=cPlane{k,3}; % Descrição

        % Importa casas decimais
        aData{k,5}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(1))']);
        aData{k,6}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(2))']);
        aData{k,7}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,4}(3))']);
        aData{k,8}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(1))']);
        aData{k,9}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(2))']);
        aData{k,10}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,5}(3))']);
        aData{k,11}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(1))']);
        aData{k,12}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(2))']);
        aData{k,13}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,6}(3))']);
        aData{k,14}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(1))']);
        aData{k,15}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(2))']);
        aData{k,16}=eval(['sprintf(''%2.' nDec 'f'', cPlane{k,7}(3))']);
    end
    
    aColWiData=get(handles.tTablePlanes,'ColumnWidth');
    nColw=aColWiData{5}+6;
    aColWidth={25,30,39,135,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw};
    
    %Exibe dados dos planos
    set(handles.tTablePlanes,'Data',aData,'ColumnWidth',aColWidth) % Carrega a tabela com os dados 

    %Mantém Scrol na Posição
    jScrollpane=findjobj(handles.tTablePlanes);
    scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
    nData=size(get(handles.tTablePlanes,'Data'),1);
    nPos=(scrollMax/nData)*(size(aData,1)-1);
    jScrollpane.getVerticalScrollBar.setValue(floor(nPos));   % Coloca o Scroll na posição
    
    %Atualiza quantidade de campos salva
    set(handles.ttDecimalsPlane,'UserData',str2double(nDec));
end


% --- Executes on button press in pushbutton225.
function pushbutton225_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton225 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton226.
function pushbutton226_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton226 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton227.
function pushbutton227_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton227 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton229.
function pushbutton229_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton229 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function tElTableOy_Callback(hObject, eventdata, handles)
% hObject    handle to tElTableOy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElTableOy as text
%        str2double(get(hObject,'String')) returns contents of tElTableOy as a double


% --- Executes during object creation, after setting all properties.
function tElTableOy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElTableOy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton44.
function radiobutton44_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton44



function edit543_Callback(hObject, eventdata, handles)
% hObject    handle to edit543 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit543 as text
%        str2double(get(hObject,'String')) returns contents of edit543 as a double


% --- Executes during object creation, after setting all properties.
function edit543_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit543 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit544_Callback(hObject, eventdata, handles)
% hObject    handle to edit544 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit544 as text
%        str2double(get(hObject,'String')) returns contents of edit544 as a double


% --- Executes during object creation, after setting all properties.
function edit544_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit544 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton45.
function radiobutton45_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton45


% --- Executes on button press in pushbutton231.
function pushbutton231_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton231 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton232.
function pushbutton232_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton232 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tElTableCreateElement.
function tElTableCreateElement_Callback(hObject, eventdata, handles)
% hObject    handle to tElPrismCreateElement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global spcodeDir

load([spcodeDir '\bLangDef.tlx'],'-mat','InputDlg','MsgBox');  %Load Language File

nElTableOx=str2double(get(handles.tElTableOx,'String'));
nElTableOy=str2double(get(handles.tElTableOy,'String'));
nElTableOz=str2double(get(handles.tElTableOz,'String'));

nElTableXdist=str2double(get(handles.tElTableXdist,'String'));
nElTableYdist=str2double(get(handles.tElTableYdist,'String'));

nElTableSizeX=nElTableXdist/2;
nElTableSizeY=nElTableYdist/2;
nElTableSizeZ=str2double('0.2');

aOrigin=[nElTableOx nElTableOy nElTableOz];
aDist=[nElTableSizeX nElTableSizeY nElTableSizeZ];

%Cria o Elemento
[aPlane]=fCreateTable(aOrigin,0,aDist);

%Cria elemento da base

%Caso centralizado
aPeOrigin=[nElTableOx + nElTableSizeX/2 - nElTableSizeZ/2, nElTableOy + nElTableSizeY/2 - nElTableSizeZ/2, 0];

%Caso tenha 4 bases
aPeOrigin1=[nElTableOx nElTableOy 0];
aPeOrigin2=[nElTableOx + nElTableSizeX - nElTableSizeZ, nElTableOy, 0];
aPeOrigin3=[nElTableOx, nElTableOy + nElTableSizeY - nElTableSizeZ, 0];
aPeOrigin4=[nElTableOx + nElTableSizeX - nElTableSizeZ,  nElTableOy + nElTableSizeY - nElTableSizeZ, 0];

%central
[aPe]=fCreateTable(aPeOrigin,0,[0.2, 0.2 , nElTableOz]);

%Padrão
[aPe1]=fCreateTable(aPeOrigin1,0,[0.2, 0.2 , nElTableOz]);
[aPe2]=fCreateTable(aPeOrigin2,0,[0.2, 0.2 , nElTableOz]);
[aPe3]=fCreateTable(aPeOrigin3,0,[0.2, 0.2 , nElTableOz]);
[aPe4]=fCreateTable(aPeOrigin4,0,[0.2, 0.2 , nElTableOz]);

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

%pre
nRoom=str2double(get(handles.tRoomNum,'String'));
nSizePlanes=size(aPlanePrev,1);
nSizePlanes2=size(aPePrev1,1);

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
    aVert=aPePrev1(nP,:);
    
    % Verifica se o plano possui area
    nW1=(((aVert{2}(2)-aVert{1}(2))*(aVert{3}(3)-aVert{1}(3)))-((aVert{3}(2)-aVert{1}(2))*(aVert{2}(3)-aVert{1}(3))));
    nW2=(((aVert{3}(1)-aVert{1}(1))*(aVert{2}(3)-aVert{1}(3)))-((aVert{2}(1)-aVert{1}(1))*(aVert{3}(3)-aVert{1}(3))));
    nW3=(((aVert{2}(1)-aVert{1}(1))*(aVert{3}(2)-aVert{1}(2)))-((aVert{3}(1)-aVert{1}(1))*(aVert{2}(2)-aVert{1}(2))));
    nR=sqrt(nW1*nW1+nW2*nW2+nW3*nW3);
    if nR~=0 %Não Colineares 
        fPutNewSinglePlane(nRoom,aVert,get(handles.ttElPrismElementName,'String'),nGroup);
        nSizePlanesNew2=nSizePlanesNew2+1;
    end
    
    aVert=aPePrev2(nP,:);
    
    % Verifica se o plano possui area
    nW1=(((aVert{2}(2)-aVert{1}(2))*(aVert{3}(3)-aVert{1}(3)))-((aVert{3}(2)-aVert{1}(2))*(aVert{2}(3)-aVert{1}(3))));
    nW2=(((aVert{3}(1)-aVert{1}(1))*(aVert{2}(3)-aVert{1}(3)))-((aVert{2}(1)-aVert{1}(1))*(aVert{3}(3)-aVert{1}(3))));
    nW3=(((aVert{2}(1)-aVert{1}(1))*(aVert{3}(2)-aVert{1}(2)))-((aVert{3}(1)-aVert{1}(1))*(aVert{2}(2)-aVert{1}(2))));
    nR=sqrt(nW1*nW1+nW2*nW2+nW3*nW3);
    if nR~=0 %Não Colineares 
        fPutNewSinglePlane(nRoom,aVert,get(handles.ttElPrismElementName,'String'),nGroup);
        nSizePlanesNew2=nSizePlanesNew2+1;
    end
    
    aVert=aPePrev3(nP,:);
    
    % Verifica se o plano possui area
    nW1=(((aVert{2}(2)-aVert{1}(2))*(aVert{3}(3)-aVert{1}(3)))-((aVert{3}(2)-aVert{1}(2))*(aVert{2}(3)-aVert{1}(3))));
    nW2=(((aVert{3}(1)-aVert{1}(1))*(aVert{2}(3)-aVert{1}(3)))-((aVert{2}(1)-aVert{1}(1))*(aVert{3}(3)-aVert{1}(3))));
    nW3=(((aVert{2}(1)-aVert{1}(1))*(aVert{3}(2)-aVert{1}(2)))-((aVert{3}(1)-aVert{1}(1))*(aVert{2}(2)-aVert{1}(2))));
    nR=sqrt(nW1*nW1+nW2*nW2+nW3*nW3);
    if nR~=0 %Não Colineares 
        fPutNewSinglePlane(nRoom,aVert,get(handles.ttElPrismElementName,'String'),nGroup);
        nSizePlanesNew2=nSizePlanesNew2+1;
    end
    
    aVert=aPePrev4(nP,:);
    
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

% --- Executes on button press in pushbutton234.
function pushbutton234_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton234 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton235.
function pushbutton235_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton235 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton236.
function pushbutton236_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton236 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton237.
function pushbutton237_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton237 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit545_Callback(hObject, eventdata, handles)
% hObject    handle to edit545 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit545 as text
%        str2double(get(hObject,'String')) returns contents of edit545 as a double


% --- Executes during object creation, after setting all properties.
function edit545_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit545 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit546_Callback(hObject, eventdata, handles)
% hObject    handle to edit546 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit546 as text
%        str2double(get(hObject,'String')) returns contents of edit546 as a double


% --- Executes during object creation, after setting all properties.
function edit546_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit546 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit547_Callback(hObject, eventdata, handles)
% hObject    handle to edit547 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit547 as text
%        str2double(get(hObject,'String')) returns contents of edit547 as a double


% --- Executes during object creation, after setting all properties.
function edit547_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit547 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit548_Callback(hObject, eventdata, handles)
% hObject    handle to edit548 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit548 as text
%        str2double(get(hObject,'String')) returns contents of edit548 as a double


% --- Executes during object creation, after setting all properties.
function edit548_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit548 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton238.
function pushbutton238_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton238 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton239.
function pushbutton239_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton239 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton240.
function pushbutton240_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton240 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton241.
function pushbutton241_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton241 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton242.
function pushbutton242_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton242 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton243.
function pushbutton243_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton243 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton244.
function pushbutton244_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton244 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton46.
function radiobutton46_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton46



function edit549_Callback(hObject, eventdata, handles)
% hObject    handle to edit549 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit549 as text
%        str2double(get(hObject,'String')) returns contents of edit549 as a double


% --- Executes during object creation, after setting all properties.
function edit549_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit549 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit550_Callback(hObject, eventdata, handles)
% hObject    handle to edit550 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit550 as text
%        str2double(get(hObject,'String')) returns contents of edit550 as a double


% --- Executes during object creation, after setting all properties.
function edit550_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit550 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton47.
function radiobutton47_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton47



function edit551_Callback(hObject, eventdata, handles)
% hObject    handle to edit551 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit551 as text
%        str2double(get(hObject,'String')) returns contents of edit551 as a double


% --- Executes during object creation, after setting all properties.
function edit551_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit551 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tElTableName_Callback(hObject, eventdata, handles)
% hObject    handle to tElTableName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElTableName as text
%        str2double(get(hObject,'String')) returns contents of tElTableName as a double


% --- Executes during object creation, after setting all properties.
function tElTableName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElTableName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit553_Callback(hObject, eventdata, handles)
% hObject    handle to edit553 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit553 as text
%        str2double(get(hObject,'String')) returns contents of edit553 as a double


% --- Executes during object creation, after setting all properties.
function edit553_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit553 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox38.
function checkbox38_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox38


% --- Executes on button press in pushbutton245.
function pushbutton245_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton245 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox39.
function checkbox39_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox39


% --- Executes on button press in pushbutton246.
function pushbutton246_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton246 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit554_Callback(hObject, eventdata, handles)
% hObject    handle to edit554 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit554 as text
%        str2double(get(hObject,'String')) returns contents of edit554 as a double


% --- Executes during object creation, after setting all properties.
function edit554_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit554 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton48.
function radiobutton48_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton48



function edit555_Callback(hObject, eventdata, handles)
% hObject    handle to edit555 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit555 as text
%        str2double(get(hObject,'String')) returns contents of edit555 as a double


% --- Executes during object creation, after setting all properties.
function edit555_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit555 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit556_Callback(hObject, eventdata, handles)
% hObject    handle to edit556 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit556 as text
%        str2double(get(hObject,'String')) returns contents of edit556 as a double


% --- Executes during object creation, after setting all properties.
function edit556_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit556 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton49.
function radiobutton49_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton49


% --- Executes on button press in pushbutton247.
function pushbutton247_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton247 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton248.
function pushbutton248_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton248 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton249.
function pushbutton249_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton249 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton250.
function pushbutton250_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton251.
function pushbutton251_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton251 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton252.
function pushbutton252_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton252 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton253.
function pushbutton253_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton253 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit557_Callback(hObject, eventdata, handles)
% hObject    handle to edit557 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit557 as text
%        str2double(get(hObject,'String')) returns contents of edit557 as a double


% --- Executes during object creation, after setting all properties.
function edit557_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit557 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit558_Callback(hObject, eventdata, handles)
% hObject    handle to edit558 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit558 as text
%        str2double(get(hObject,'String')) returns contents of edit558 as a double


% --- Executes during object creation, after setting all properties.
function edit558_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit558 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit559_Callback(hObject, eventdata, handles)
% hObject    handle to edit559 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit559 as text
%        str2double(get(hObject,'String')) returns contents of edit559 as a double


% --- Executes during object creation, after setting all properties.
function edit559_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit559 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit560_Callback(hObject, eventdata, handles)
% hObject    handle to edit560 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit560 as text
%        str2double(get(hObject,'String')) returns contents of edit560 as a double


% --- Executes during object creation, after setting all properties.
function edit560_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit560 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton254.
function pushbutton254_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton254 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit561_Callback(hObject, eventdata, handles)
% hObject    handle to edit561 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit561 as text
%        str2double(get(hObject,'String')) returns contents of edit561 as a double


% --- Executes during object creation, after setting all properties.
function edit561_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit561 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit562_Callback(hObject, eventdata, handles)
% hObject    handle to edit562 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit562 as text
%        str2double(get(hObject,'String')) returns contents of edit562 as a double


% --- Executes during object creation, after setting all properties.
function edit562_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit562 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit563_Callback(hObject, eventdata, handles)
% hObject    handle to edit563 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit563 as text
%        str2double(get(hObject,'String')) returns contents of edit563 as a double


% --- Executes during object creation, after setting all properties.
function edit563_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit563 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton255.
function pushbutton255_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton255 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton256.
function pushbutton256_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton256 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton257.
function pushbutton257_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton257 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton258.
function pushbutton258_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton258 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton259.
function pushbutton259_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton259 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit564_Callback(hObject, eventdata, handles)
% hObject    handle to edit564 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit564 as text
%        str2double(get(hObject,'String')) returns contents of edit564 as a double


% --- Executes during object creation, after setting all properties.
function edit564_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit564 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit565_Callback(hObject, eventdata, handles)
% hObject    handle to edit565 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit565 as text
%        str2double(get(hObject,'String')) returns contents of edit565 as a double


% --- Executes during object creation, after setting all properties.
function edit565_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit565 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton260.
function pushbutton260_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton260 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit566_Callback(hObject, eventdata, handles)
% hObject    handle to edit566 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit566 as text
%        str2double(get(hObject,'String')) returns contents of edit566 as a double


% --- Executes during object creation, after setting all properties.
function edit566_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit566 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton219.
function pushbutton219_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton219 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton220.
function pushbutton220_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton220 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton221.
function pushbutton221_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton221 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton222.
function pushbutton222_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton222 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton223.
function pushbutton223_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton223 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit529_Callback(hObject, eventdata, handles)
% hObject    handle to edit529 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit529 as text
%        str2double(get(hObject,'String')) returns contents of edit529 as a double


% --- Executes during object creation, after setting all properties.
function edit529_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit529 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton224.
function pushbutton224_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton224 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit530_Callback(hObject, eventdata, handles)
% hObject    handle to edit530 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit530 as text
%        str2double(get(hObject,'String')) returns contents of edit530 as a double


% --- Executes during object creation, after setting all properties.
function edit530_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit530 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit531_Callback(hObject, eventdata, handles)
% hObject    handle to edit531 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit531 as text
%        str2double(get(hObject,'String')) returns contents of edit531 as a double


% --- Executes during object creation, after setting all properties.
function edit531_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit531 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit532_Callback(hObject, eventdata, handles)
% hObject    handle to edit532 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit532 as text
%        str2double(get(hObject,'String')) returns contents of edit532 as a double


% --- Executes during object creation, after setting all properties.
function edit532_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit532 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit533_Callback(hObject, eventdata, handles)
% hObject    handle to edit533 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit533 as text
%        str2double(get(hObject,'String')) returns contents of edit533 as a double


% --- Executes during object creation, after setting all properties.
function edit533_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit533 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit534_Callback(hObject, eventdata, handles)
% hObject    handle to edit534 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit534 as text
%        str2double(get(hObject,'String')) returns contents of edit534 as a double


% --- Executes during object creation, after setting all properties.
function edit534_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit534 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit535_Callback(hObject, eventdata, handles)
% hObject    handle to edit535 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit535 as text
%        str2double(get(hObject,'String')) returns contents of edit535 as a double


% --- Executes during object creation, after setting all properties.
function edit535_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit535 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit536_Callback(hObject, eventdata, handles)
% hObject    handle to edit536 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit536 as text
%        str2double(get(hObject,'String')) returns contents of edit536 as a double


% --- Executes during object creation, after setting all properties.
function edit536_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit536 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit537_Callback(hObject, eventdata, handles)
% hObject    handle to edit537 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit537 as text
%        str2double(get(hObject,'String')) returns contents of edit537 as a double


% --- Executes during object creation, after setting all properties.
function edit537_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit537 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit538_Callback(hObject, eventdata, handles)
% hObject    handle to edit538 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit538 as text
%        str2double(get(hObject,'String')) returns contents of edit538 as a double


% --- Executes during object creation, after setting all properties.
function edit538_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit538 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit539_Callback(hObject, eventdata, handles)
% hObject    handle to edit539 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit539 as text
%        str2double(get(hObject,'String')) returns contents of edit539 as a double


% --- Executes during object creation, after setting all properties.
function edit539_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit539 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tElTableOx_Callback(hObject, eventdata, handles)
% hObject    handle to tElTableOx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElTableOx as text
%        str2double(get(hObject,'String')) returns contents of tElTableOx as a double


% --- Executes during object creation, after setting all properties.
function tElTableOx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElTableOx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tElTableOz_Callback(hObject, eventdata, handles)
% hObject    handle to tElTableOz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElTableOz as text
%        str2double(get(hObject,'String')) returns contents of tElTableOz as a double


% --- Executes during object creation, after setting all properties.
function tElTableOz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElTableOz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tToolbar.
function tToolbar_Callback(hObject, eventdata, handles)
% hObject    handle to tToolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nCol=get(handles.tToolbar,'BackgroundColor');

if nCol(1)==0.94
    %Exibe toolbar da câmera
    axes(handles.tAxesPreview)
    cameratoolbar('Show');
    set(handles.tToolbar,'BackgroundColor',[1 1 1]);
else
    %Exibe toolbar da câmera
    axes(handles.tAxesPreview)
    cameratoolbar('Hide');
    set(handles.tToolbar,'BackgroundColor',[0.94 0.94 0.94]);
end




% --- Executes on button press in tDecDownWin.
function tDecDownWin_Callback(hObject, eventdata, handles)
% hObject    handle to tDecDownWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sInputDir spcodeDir

% Numero de casas Decimais
nDec=num2str(get(handles.ttDecimalsWin,'UserData'));
if nDec~=1 % Se for um, não faz nada
    % Abre arquivos de planos
    nRoomNum=str2double(get(handles.tRoomNum,'String'));
    sRoomNum=fPut0(nRoomNum,3);
    sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; %nome do arquivo de planos
    if exist(sFilePl,'file')==2
        load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
    else
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
        return
    end
    
    % Abre arquivos de Janelas
    nRoomNum=str2double(get(handles.tRoomNum,'String'));
    sRoomNum=fPut0(nRoomNum,3);
    sFileWin=[sInputDir '\bWindow' sRoomNum '.tlx']; %nome do arquivo de janelas

    load(sFileWin,'-mat','cWindow'); % % load file
    if ~exist('cWindow','var')
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cWindowNotFoundIn ' ' sFileWin ' (E0080)']);
        return
    end
    if isempty(cWindow) %#ok<*USENS>
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cWindowIsEmptyFile ' '  sFileWin ' ' ErrorDlg.MightBeCorrupted ' (E0112)']);
        return
    end

    nTWin=size(cWindow,1);

    if nTWin>0
        for i=1:2:nTWin
            nPos(i)=cWindow{i,2}; 
            nPos(i+1)=cWindow{i+1,2};
        end
        for i=1:nTWin
            wDesc{i}=cPlane{nPos(i),3};
        end
    end
    nDec=num2str(str2double(nDec)-1);
   for k=1:nTWin
       aDataWin{k,1}=cWindow{k,1}; %Número
       aDataWin{k,2}=cWindow{k,4}; %Tipo
       aDataWin{k,3}=cWindow{k,2}; %Plano
       aDataWin{k,4}=wDesc{k}; %Descrição do plano

       aDataWin{k,5}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,5}(1))']); %X1
       aDataWin{k,6}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,5}(2))']); %Y1
       aDataWin{k,7}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,5}(3))']); %Z1
       aDataWin{k,8}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,6}(1))']); %X2
       aDataWin{k,9}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,6}(2))']); %Y2
       aDataWin{k,10}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,6}(3))']); %Z2
       aDataWin{k,11}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,7}(1))']); %X3
       aDataWin{k,12}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,7}(2))']); %Y3
       aDataWin{k,13}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,7}(3))']); %Z3
       aDataWin{k,14}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,8}(1))']); %X4
       aDataWin{k,15}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,8}(2))']); %Y4
       aDataWin{k,16}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,8}(3))']); %Z4
   end
    
    aColWiData=get(handles.tTableWin,'ColumnWidth');
    nColw=aColWiData{5}-6;
    aColWidth={20,30,39,135,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw};
    
    %Exibe dados dos planos
    set(handles.tTableWin,'Data',aDataWin,'ColumnWidth',aColWidth) % Carrega a tabela com os dados 

    %Mantém Scrol na Posição
    jScrollpane=findjobj(handles.tTableWin);
    scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
    nData=size(get(handles.tTableWin,'Data'),1);
    nPos=(scrollMax/nData)*(size(aDataWin,1)-1);
    jScrollpane.getVerticalScrollBar.setValue(floor(nPos));   % Coloca o Scroll na posição
    
    %Atualiza quantidade de campos salva
    set(handles.ttDecimalsWin,'UserData',str2double(nDec));
end



% --- Executes on button press in tDecUpWin.
function tDecUpWin_Callback(hObject, eventdata, handles)
% hObject    handle to tDecUpWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sInputDir spcodeDir

% Numero de casas Decimais
nDec=num2str(get(handles.ttDecimalsWin,'UserData'));
if nDec~=1 % Se for um, não faz nada
    % Abre arquivos de planos
    nRoomNum=str2double(get(handles.tRoomNum,'String'));
    sRoomNum=fPut0(nRoomNum,3);
    sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; %nome do arquivo de planos
    if exist(sFilePl,'file')==2
        load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
    else
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
        return
    end
    
    % Abre arquivos de Janelas
    nRoomNum=str2double(get(handles.tRoomNum,'String'));
    sRoomNum=fPut0(nRoomNum,3);
    sFileWin=[sInputDir '\bWindow' sRoomNum '.tlx']; %nome do arquivo de janelas

    load(sFileWin,'-mat','cWindow'); % % load file
    if ~exist('cWindow','var')
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cWindowNotFoundIn ' ' sFileWin ' (E0080)']);
        return
    end
    if isempty(cWindow) %#ok<*USENS>
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cWindowIsEmptyFile ' '  sFileWin ' ' ErrorDlg.MightBeCorrupted ' (E0112)']);
        return
    end

    nTWin=size(cWindow,1);

    if nTWin>0
        for i=1:2:nTWin
            nPos(i)=cWindow{i,2}; 
            nPos(i+1)=cWindow{i+1,2};
        end
        for i=1:nTWin
            wDesc{i}=cPlane{nPos(i),3};
        end
    end
    nDec=num2str(str2double(nDec)+1);
   for k=1:nTWin
       aDataWin{k,1}=cWindow{k,1}; %Número
       aDataWin{k,2}=cWindow{k,4}; %Tipo
       aDataWin{k,3}=cWindow{k,2}; %Plano
       aDataWin{k,4}=wDesc{k}; %Descrição do plano

       aDataWin{k,5}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,5}(1))']); %X1
       aDataWin{k,6}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,5}(2))']); %Y1
       aDataWin{k,7}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,5}(3))']); %Z1
       aDataWin{k,8}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,6}(1))']); %X2
       aDataWin{k,9}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,6}(2))']); %Y2
       aDataWin{k,10}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,6}(3))']); %Z2
       aDataWin{k,11}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,7}(1))']); %X3
       aDataWin{k,12}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,7}(2))']); %Y3
       aDataWin{k,13}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,7}(3))']); %Z3
       aDataWin{k,14}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,8}(1))']); %X4
       aDataWin{k,15}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,8}(2))']); %Y4
       aDataWin{k,16}=eval(['sprintf(''%2.' nDec 'f'', cWindow{k,8}(3))']); %Z4
   end
    
    aColWiData=get(handles.tTableWin,'ColumnWidth');
    nColw=aColWiData{5}+6;
    aColWidth={20,30,39,135,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw,nColw};
    
    %Exibe dados dos planos
    set(handles.tTableWin,'Data',aDataWin,'ColumnWidth',aColWidth) % Carrega a tabela com os dados 

    %Mantém Scrol na Posição
    jScrollpane=findjobj(handles.tTableWin);
    scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
    nData=size(get(handles.tTableWin,'Data'),1);
    nPos=(scrollMax/nData)*(size(aDataWin,1)-1);
    jScrollpane.getVerticalScrollBar.setValue(floor(nPos));   % Coloca o Scroll na posição
    
    %Atualiza quantidade de campos salva
    set(handles.ttDecimalsWin,'UserData',str2double(nDec));
end


% --- Executes on button press in tDecDownMat.
function tDecDownMat_Callback(hObject, eventdata, handles)
% hObject    handle to tDecDownMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Abre arquivos de características dos materiais
global sInputDir spcodeDir

% Numero de casas Decimais
nDec=num2str(get(handles.ttDecimalsMat,'UserData'));
if nDec~=1 % Se for um, não faz nada
    % Abre arquivos de planos
    nRoomNum=str2double(get(handles.tRoomNum,'String'));
    sRoomNum=fPut0(nRoomNum,3);
    sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; %nome do arquivo de planos
    if exist(sFilePl,'file')==2
        load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
    else
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
        return
    end
    
    % Abre arquivos de materiais
    nRoomNum=str2double(get(handles.tRoomNum,'String'));
    sRoomNum=fPut0(nRoomNum,3);
    sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];

    if ~exist(sFileMat,'file')
        load([spcodeDir '\bLangDef.tlx'],'-mat','UiGet');  %Load Language File
        [sFileMat,~]=uigetfile('bMat*.tlx',UiGet.MaterialFiles);
        if exist(sFileMat,'file')
            load(sFileMat,'-mat','cMat'); %Carrega arquivo
        else
            return
        end  
      sRoomNum=sFileMat(end-6:end-4);% get last 3 numbers
      set(handles.tRoomNum,'string',sRoomNum)
    else
      load(sFileMat,'-mat','cMat') %Carrega arquivo
    end
    if ~exist('cMat','var')
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cMatNotFoundIn ' ' sFileMat ' (E0071)']); 
        return
    end
    if isempty(cMat) 
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cMatIsEmptyFile ' '  sFileMat ' ' ErrorDlg.MightBeCorrupted ' (E0097)']);	
        return
    end

    [nTMat,~]=size(cMat); %Tamanho da variável
    cDesc=(cPlane(:,3));
    
    nDec=num2str(str2double(nDec)-1);

    for k=1:nTMat
        aDataMat{k,1}=cMat{k,1}; % %Número
        aDataMat{k,2}=cDesc{k}; %Descriçao
        aDataMat{k,3}=[]; %Cor
        aDataMat{k,4}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,2})']); %Refletância Difusa
        aDataMat{k,5}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,3})']); %Refletância Especular
        aDataMat{k,6}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,4})']); %Transmitância Difusa
        aDataMat{k,7}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,5})']); %Transmitância Especular
    end
        
    aColWiData=get(handles.tTableMat,'ColumnWidth');
    nColw=aColWiData{5}-6;
    aColWidth={20,130,50,nColw,nColw,nColw,nColw};
    
    %Exibe dados dos planos
    set(handles.tTableMat,'Data',aDataMat,'ColumnWidth',aColWidth) % Carrega a tabela com os dados 

    %Mantém Scrol na Posição
    jScrollpane=findjobj(handles.tTableMat);
    scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
    nData=size(get(handles.tTableMat,'Data'),1);
    nPos=(scrollMax/nData)*(size(aDataMat,1)-1);
    jScrollpane.getVerticalScrollBar.setValue(floor(nPos));   % Coloca o Scroll na posição
    
    %Atualiza quantidade de campos salva
    set(handles.ttDecimalsMat,'UserData',str2double(nDec));
end


% --- Executes on button press in tDecUpMat.
function tDecUpMat_Callback(hObject, eventdata, handles)
% hObject    handle to tDecUpMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global sInputDir spcodeDir

% Numero de casas Decimais
nDec=num2str(get(handles.ttDecimalsMat,'UserData'));
if nDec~=1 % Se for um, não faz nada
    % Abre arquivos de planos
    nRoomNum=str2double(get(handles.tRoomNum,'String'));
    sRoomNum=fPut0(nRoomNum,3);
    sFilePl=[sInputDir '\bPlane' sRoomNum '.tlx']; %nome do arquivo de planos
    if exist(sFilePl,'file')==2
        load(sFilePl,'-mat','cPlane'); %Carrega: cPlane
    else
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Abre Arquivo de Idioma
        errordlg([sFilePl ' ' ErrorDlg.NotFound ' (E0070)']);	
        return
    end
    
    % Abre arquivos de materiais
    nRoomNum=str2double(get(handles.tRoomNum,'String'));
    sRoomNum=fPut0(nRoomNum,3);
    sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];

    if ~exist(sFileMat,'file')
        load([spcodeDir '\bLangDef.tlx'],'-mat','UiGet');  %Load Language File
        [sFileMat,~]=uigetfile('bMat*.tlx',UiGet.MaterialFiles);
        if exist(sFileMat,'file')
            load(sFileMat,'-mat','cMat'); %Carrega arquivo
        else
            return
        end  
      sRoomNum=sFileMat(end-6:end-4);% get last 3 numbers
      set(handles.tRoomNum,'string',sRoomNum)
    else
      load(sFileMat,'-mat','cMat') %Carrega arquivo
    end
    if ~exist('cMat','var')
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cMatNotFoundIn ' ' sFileMat ' (E0071)']); 
        return
    end
    if isempty(cMat) 
        load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
        errordlg([ErrorDlg.cMatIsEmptyFile ' '  sFileMat ' ' ErrorDlg.MightBeCorrupted ' (E0097)']);	
        return
    end

    [nTMat,~]=size(cMat); %Tamanho da variável
    cDesc=(cPlane(:,3));
    
    nDec=num2str(str2double(nDec)+1);

    for k=1:nTMat
        aDataMat{k,1}=cMat{k,1}; % %Número
        aDataMat{k,2}=cDesc{k}; %Descriçao
        aDataMat{k,3}=[]; %Cor
        aDataMat{k,4}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,2})']); %Refletância Difusa
        aDataMat{k,5}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,3})']); %Refletância Especular
        aDataMat{k,6}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,4})']); %Transmitância Difusa
        aDataMat{k,7}=eval(['sprintf(''%2.' nDec 'f'', cMat{k,5})']); %Transmitância Especular
    end
        
    aColWiData=get(handles.tTableMat,'ColumnWidth');
    nColw=aColWiData{5}+6;
    aColWidth={20,130,50,nColw,nColw,nColw,nColw};
    
    %Exibe dados dos planos
    set(handles.tTableMat,'Data',aDataMat,'ColumnWidth',aColWidth) % Carrega a tabela com os dados 

    %Mantém Scrol na Posição
    jScrollpane=findjobj(handles.tTableMat);
    scrollMax=jScrollpane.getVerticalScrollBar.getMaximum;  % Posição máxima do scroll
    nData=size(get(handles.tTableMat,'Data'),1);
    nPos=(scrollMax/nData)*(size(aDataMat,1)-1);
    jScrollpane.getVerticalScrollBar.setValue(floor(nPos));   % Coloca o Scroll na posição
    
    %Atualiza quantidade de campos salva
    set(handles.ttDecimalsMat,'UserData',str2double(nDec));
end


% --- Executes on button press in tReflTable.
function tReflTable_Callback(hObject, eventdata, handles)
% hObject    handle to tReflTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cRefl2 spcodeDir sInputDir

try
    if isempty(cRefl2)
        return
    end

    % Verifica Língua
    load([spcodeDir '\bLangDef.tlx'],'-mat','sFileLang');  %Load Language File

    if strcmp('bLangPortuguese.tlx',sFileLang)
        nLang=2;
    elseif strcmp('bLangEnglish.tlx',sFileLang)
        nLang=1;
    elseif strcmp('bLangSpanish.tlx',sFileLang)
        nLang=3;
    else
    end

    % Gera matriz
    nSizeMax=max(cellfun('length',cRefl2(:,1)));

    %Determina tamanho do vetor
    nPosZero=find(cellfun('length',cRefl2(:,1))==0);
    nPosEnd=0; nLP=1;
    while nPosEnd==0
        if nPosZero(nLP)+1==nPosZero(nLP+1)
            nPosEnd=nLP;
        end
        nLP=nLP+1;
    end

    for nL=3:nPosZero(nLP)-2
        nSizeChar=size(cRefl2{nL,nLang},2);
        sChar=[cRefl2{nL,nLang} ' '];
    %     for nP=nSizeChar+2:nSizeMax+2
    %         sChar=[sChar '-'];
    %     end
        aChar{nL-2}=[sChar ': ' cRefl2{nL,4}];
    end
    [nPos]=listdlg('ListString',aChar,'SelectionMode','single','ListSize',[nSizeMax*6 300],'name',cRefl2{2,nLang},'PromptString',cRefl2{2,nLang});

    %Se escolheu linha de comentario ou em branco
    if isempty(cRefl2{nPos+2,4})
        return
    end
    nPosTr=handles.tReflTable.UserData;

    % Gera cMat
    if ~isempty(nPosTr)
        nRoomNum= str2double(get(handles.tRoomNum,'String'));
        if isnumeric(nRoomNum)
          sRoomNum=fPut0(nRoomNum,3);
          sFileMat=[sInputDir '\bMat' sRoomNum '.tlx'];
        else
            load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
            errordlg([ErrorDlg.PleaseInputRoomNumber ' (E0095)']);	
            return
        end

        aDataMat=get(handles.tTableMat,'Data');


        [nTMat,~]=size(aDataMat);

        for k=1:nTMat
           cLine{1}=aDataMat{k,1};
           cLine{2}=str2double(aDataMat{k,4});
           cLine{3}=str2double(aDataMat{k,5});
           cLine{4}=str2double(aDataMat{k,6});
           cLine{5}=str2double(aDataMat{k,7});

           for m=1:5
               cMat{k,m}=cLine{m};
           end

           % test for data consistence (RD+RS+TD+TS)<1
           if (cMat{k,2}+cMat{k,3}+cMat{k,4}+cMat{k,5})>1 % v3.07 allow ==1
               load([spcodeDir '\bLangDef.tlx'],'-mat','ErrorDlg');  %Load Language File
               errordlg([ErrorDlg.ErrorInMaterialCharacteristicsForPlane ' ' num2str(k) ' (E0100)'])
               return
           end  
        end

    end

    %Substitui Valores
    for nS=nPosTr(1,1):nPosTr(end,1)
        cMat{nS,2}=str2double(cRefl2{nPos+2,4});
        aDataMat{nS,4}=cRefl2{nPos+2,4};
    end

    save(sFileMat,'-mat','cMat')

    %Exibe dados dos materiais
    set(handles.tTableMat,'Data',aDataMat)
    catch
end


% --- Executes on button press in tEditDescription.
function tEditDescription_Callback(hObject, eventdata, handles)
% hObject    handle to tEditDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Verifica situação
if handles.tEditDescription.BackgroundColor(1)<1
    % Ativa Ediçao
    
    % Muda cor do botao
    set(handles.tEditDescription,'BackgroundColor',[1 1 1]);
    
    % Travas as outras abas
    set(handles.tPanDataButton,'Enable','off');
    set(handles.tPanVisButton,'Enable','off');
    set(handles.tPanWinButton,'Enable','off');
    set(handles.tPanMaterialButton,'Enable','off');
    set(handles.tPanElementButton,'Enable','off');
    set(handles.tPanShadingButton,'Enable','off');
    set(handles.tDeleteProject,'Enable','off');
    set(handles.tCreateNewPrjRec,'Enable','off');
    
    aColEdit=handles.tTableProject.ColumnEditable;
    aColEdit(2)=true;
    set(handles.tTableProject,'ColumnEditable',aColEdit);
else
    % Desativa Ediçao
    
    % Muda cor do botao
    set(handles.tEditDescription,'BackgroundColor',[0.941 0.941 0.941]);
    
    % Travas as outras abas
    set(handles.tPanDataButton,'Enable','on');
    set(handles.tPanVisButton,'Enable','on');
    set(handles.tPanWinButton,'Enable','on');
    set(handles.tPanMaterialButton,'Enable','on');
    set(handles.tPanElementButton,'Enable','on');
    set(handles.tPanShadingButton,'Enable','on');
    set(handles.tDeleteProject,'Enable','on');
    set(handles.tCreateNewPrjRec,'Enable','on');
    
    aColEdit=handles.tTableProject.ColumnEditable;
    aColEdit(2)=false;
    set(handles.tTableProject,'ColumnEditable',aColEdit);
end




% --- Executes on button press in tUpdate.
function tUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to tUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'Pointer','watch');
pause(0.1);


fOpenProject(hObject,eventdata,handles,true) 

set(gcf,'Pointer','arrow');



function tWindowType_Callback(hObject, eventdata, handles)
% hObject    handle to tWindowType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tWindowType as text
%        str2double(get(hObject,'String')) returns contents of tWindowType as a double


% --- Executes during object creation, after setting all properties.
function tWindowType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tWindowType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox40.
function checkbox40_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox40


% --- Executes on button press in checkbox41.
function checkbox41_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox41


% --- Executes during object creation, after setting all properties.
function tElChairOx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElChairOx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function tElChairOz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElChairOz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function tElChairOy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElChairOy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tElChairName_Callback(hObject, eventdata, handles)
% hObject    handle to tElChairName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElChairName as text
%        str2double(get(hObject,'String')) returns contents of tElChairName as a double


% --- Executes during object creation, after setting all properties.
function tElChairName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElChairName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tElCupboardOx_Callback(hObject, eventdata, handles)
% hObject    handle to tElCupboardOx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElCupboardOx as text
%        str2double(get(hObject,'String')) returns contents of tElCupboardOx as a double


% --- Executes during object creation, after setting all properties.
function tElCupboardOx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCupboardOx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tElCupboardOz_Callback(hObject, eventdata, handles)
% hObject    handle to tElCupboardOz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElCupboardOz as text
%        str2double(get(hObject,'String')) returns contents of tElCupboardOz as a double


% --- Executes during object creation, after setting all properties.
function tElCupboardOz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCupboardOz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tElCupboardOy_Callback(hObject, eventdata, handles)
% hObject    handle to tElCupboardOy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElCupboardOy as text
%        str2double(get(hObject,'String')) returns contents of tElCupboardOy as a double


% --- Executes during object creation, after setting all properties.
function tElCupboardOy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCupboardOy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tElCupboardN_Callback(hObject, eventdata, handles)
% hObject    handle to tElCupboardN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElCupboardN as text
%        str2double(get(hObject,'String')) returns contents of tElCupboardN as a double


% --- Executes during object creation, after setting all properties.
function tElCupboardN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElCupboardN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tElTableXdist_Callback(hObject, eventdata, handles)
% hObject    handle to tElTableXdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElTableXdist as text
%        str2double(get(hObject,'String')) returns contents of tElTableXdist as a double


% --- Executes during object creation, after setting all properties.
function tElTableXdist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElTableXdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tElTableYdist_Callback(hObject, eventdata, handles)
% hObject    handle to tElTableYdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tElTableYdist as text
%        str2double(get(hObject,'String')) returns contents of tElTableYdist as a double


% --- Executes during object creation, after setting all properties.
function tElTableYdist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tElTableYdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
