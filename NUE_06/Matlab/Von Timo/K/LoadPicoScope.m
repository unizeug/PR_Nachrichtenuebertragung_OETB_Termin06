function [ScopeHandle,Version]=LoadPicoScope()
if exist('PS3000a.dll','file') & exist('ps3000aApi.h','file') & exist('PS3000.dll','file') & exist('PS3000.h','file')
    Version='unknown';
else
    if exist('PS3000a.dll','file') & exist('ps3000aApi.h','file')
        Version='3204A';
    else
        if exist('PS3000.dll','file') & exist('PS3000.h','file')
            Version='3204';
        else
            error('Files missing. Need PS3000.dll, PS3000.h for PicoScope 3204; Need PS3000a.dll, ps3000aApi.h for PicoScope 3204A');
        end
    end
end
status=0;
if numel(Version)==numel('unknown')
    %try 3204
    if ~libisloaded('PS3000')
        LoadLibrary('PS3000.dll','PS3000.h');
        if ~libisloaded('PS3000')
            error('library PS3000.dll or PS3000.h not found') %check if the library is loaded
        else
            status=1;
        end
    else
        status=1;
    end
    if status==1
        ScopeHandle=calllib('PS3000', 'ps3000_open_unit');
        Version='3204';
    end
    % Wenn das Laden eines PicoScopes 3204 nicht klappte ...
    if status==0 | ScopeHandle<1
        unloadlibrary('PS3000');
        %try 3204A
        status=0;
        if ~libisloaded('PS3000a')
            LoadLibrary('PS3000a.dll','ps3000aApi.h');
            if ~libisloaded('PS3000a')
                error('library PS3000a.dll or ps3000aApi.h not found') %check if the library is loaded
            else
                status=1;
            end
        else
            status=1;
        end
        if status==1
            Zer = libpointer('stringPtr');
            ScopeHandlePtr = libpointer('int16Ptr',0);
            g=calllib('PS3000a', 'ps3000aOpenUnit',ScopeHandlePtr,Zer);
            ScopeHandle=ScopeHandlePtr.value;
            Version='3204A';
        end
        if status==0 | ScopeHandle<1
            %kein passendes PicoScope gefunden
            unloadlibrary('PS3000a');
            error('no PicoScope found')            
        end
    end
else %Wenn nur Dateien für eines der beiden Versionen vorliegen
    if numel(Version)==numel('3204')
        if ~libisloaded('PS3000')
            LoadLibrary('PS3000.dll','PS3000.h');
            if ~libisloaded('PS3000')
                error('library PS3000.dll or PS3000.h not found') %check if the library is loaded
            else
                status=1;
            end
        else
            status=1;
        end
        if status==1
            ScopeHandle=calllib('PS3000', 'ps3000_open_unit');
        end
    else
        if ~libisloaded('PS3000a')
            LoadLibrary('PS3000a.dll','ps3000aApi.h');
            if ~libisloaded('PS3000a')
                error('library PS3000a.dll or ps3000aApi.h not found') %check if the library is loaded
            else
                status=1;
            end
        else
            status=1;
        end
        if status==1
            Zer = libpointer('stringPtr');
            ScopeHandlePtr = libpointer('int16Ptr',0);
            g=calllib('PS3000a', 'ps3000aOpenUnit',ScopeHandlePtr,Zer);
            ScopeHandle=ScopeHandlePtr.value;
        end
    end
    if status==0 | ScopeHandle<1
        %kein passendes PicoScope gefunden
        error('no PicoScope found')
    end
end
