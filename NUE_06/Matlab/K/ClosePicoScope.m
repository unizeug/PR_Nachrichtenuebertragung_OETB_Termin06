function ClosePicoScope(ScopeHandle)

if libisloaded('PS3000')
    calllib('PS3000', 'ps3000_close_unit',ScopeHandle);
    unloadlibrary('PS3000');
    display('Lib unloaded.');
else
    if libisloaded('PS3000a')
        f=calllib('PS3000a', 'ps3000aCloseUnit',ScopeHandle);
        unloadlibrary('PS3000a');
        display('Lib unloaded.');
    else
        display('No Lib to unload.')
    end
end

