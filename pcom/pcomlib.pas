unit pcomlib;

{
  Pussy commander library
}

interface

uses Windows, TlHelp32, SysUtils, Classes, Forms, ShellApi, ShlObj, SHDocVw,
     zDBCIntFS, Registry, MyMsgDlg, StrUtils, zConnection, IOUtils, PussyConnectionManager, Vcl.Grids;

  function processExists(exeFileName: string): integer;
  function KillTask(ExeFileName:string):integer;
  function LeaveDitgits(input: string): string;
  function formatPhoneString(input : string): string;
  Function DelTree(DirName : string): Boolean;
  function pathIsFile(const FileName: string): Boolean;
  function strTruncate(input : string; maxlen : integer) : string;
  function GetDateDayName(dateTime : TDateTIme) : string;
  function getShortDname( dname : string ) : string;
  function mqInp(quest: string; slTemplate : TStringList) : string;
  function mqDlg(quest : string) : integer;
  function mqInform(quest : string) : integer;
  function getDBString() : string;
  function getDBUser() : string;
  function getDBPass() : string;
  function getSettingsDBString():String;
  function StringKeyMapENRU(strInput : string) : string;
  function LoadFileToStr(const FileName: TFileName): AnsiString;

  procedure wait ( sec : integer );
  procedure Autorun(Flag:boolean; NameParam, Path:String);
  procedure RDPConnect(ip, user, password : string);
  procedure TeamViewerConnect( id, password : string);
  procedure AnyDeskConnect( computer, password : string);
  procedure AmmyAdminConnect (id, password : string);
  procedure DameWareConnect( computer, domain, user, password, useNTLogon : string );
  procedure OneCConnect( dbpath : string );
  procedure OneCConnectExe( dbpath : string );
  procedure OneCConnectRDP( dbpath : string );
  procedure LoadDesktopDataForMenu(desktop_id : string);
  procedure OpenFolderAndSelectItem( Path: WideString );
  procedure DameWarePatchHost( computer, domain, user, password, useNTLogon : string );
  procedure handleMenuConnectionClick(hint : string);
  procedure InitConnectionManager();
  procedure sgApplyBestFit( sg : TStringGrid);

var                                 // global variables
    AmmyAdminExe   : string;
    AnyDeskEXE     : string;
    DameWareExe    : string;
    TeamViewerExe  : string;

    OneCExe  : string;
    OneCUser : string;
    OneCPass : string;

    dbstr  : string;
    dbuser : string;
    dbpass : string;
    dbip   : string;

    conmgr : TPussyConnectionManager;

    menu_aa_id, menu_aa_password : string;
    menu_ad_id, menu_ad_password : string;
    menu_dw_ip, menu_dw_user, menu_dw_domain, menu_dw_password, menu_dw_usentlogon : string;
    menu_tw_id, menu_tw_password : string;
    menu_rdp_ip, menu_rdp_user, menu_rdp_password : string;

type
  PPItemIDList = ^PItemIDList;

const
  OFASI_EDIT = 1;
  OFASI_OPENDESKTOP = 2;

implementation

procedure sgApplyBestFit(sg : TStringGrid);
var
  i, ColWidth, sgWidth, VisibleColumnCount, StartVisibleColumnNumber: integer;
begin
          // makes StringGrid columns width proportional
          // it works if all invisible columns are on the left side of grid and they have already width = -1.
VisibleColumnCount := 0;
StartVisibleColumnNumber := 0;

for I := 0 to sg.ColCount - 1 do
  begin
    if sg.ColWidths[i] >= 0 then inc(VisibleColumnCount, 1);
    if ( (StartVisibleColumnNumber = 0) and (sg.ColWidths[i] >= 0) ) then StartVisibleColumnNumber := i;
  end;

  sgWidth  := sg.Width;
  ColWidth := Trunc(sgWidth / VisibleColumnCount);

  for I := StartVisibleColumnNumber to sg.ColCount - 1 do
  begin
    sg.ColWidths[i] := ColWidth;
  end;

end;

procedure handleMenuConnectionClick(hint : string);
begin

if hint = 'ammyadmin' then
  begin
  AmmyAdminConnect (menu_aa_id, menu_aa_password);
  end;
if hint = 'anydesk' then
  begin
  AnyDeskConnect( menu_ad_id, menu_ad_password);
  end;
if hint = 'dameware' then
  begin
  DameWareConnect( menu_dw_ip, menu_dw_domain, menu_dw_user, menu_dw_password, menu_dw_usentlogon );
  end;
if hint = 'rdp' then
  begin
  RDPConnect(menu_rdp_ip, menu_rdp_user, menu_rdp_password);
  end;
if hint = 'teamviewer' then
  begin
  TeamViewerConnect( menu_tw_id, menu_tw_password);
  end;
end;

procedure LoadDesktopDataForMenu(desktop_id : string);
var
    stmtActive : IZStatement;
    rsActive   : IZResultSet;
begin

    menu_aa_id := '';
    menu_aa_password := '';
    menu_ad_id := '';
    menu_ad_password := '';
    menu_dw_ip := '';
    menu_dw_user := '';
    menu_dw_domain := '';
    menu_dw_password := '';
    menu_dw_usentlogon := '';
    menu_tw_id := '';
    menu_tw_password := '';
    menu_rdp_ip := '';
    menu_rdp_user := '';
    menu_rdp_password := '';

stmtActive := conmgr.getStatement;
rsactive   := stmtactive.ExecuteQuery('select * from desktops where ID = ' + desktop_id);
if rsActive.Next then
begin
    menu_aa_id := rsActive.GetStringByName('AMMYADMINID');
    menu_aa_password := rsActive.GetStringByName('AMMYADMINPASSWORD');
    menu_ad_id := rsActive.GetStringByName('ANYDESKID');
    menu_ad_password := rsActive.GetStringByName('ANYDESKPASSWORD');
    menu_dw_ip := rsActive.GetStringByName('DAMEWAREIP');
    menu_dw_user := rsActive.GetStringByName('DAMEWAREUSER');
    menu_dw_domain := rsActive.GetStringByName('DAMEWAREDOMAIN');
    menu_dw_password := rsActive.GetStringByName('DAMEWAREPASSWORD');
    menu_dw_usentlogon := rsActive.GetStringByName('DAMEWAREUSENTLOGON');
    menu_tw_id := rsActive.GetStringByName('TEAMVIEWERID');
    menu_tw_password := rsActive.GetStringByName('TEAMVIEWERPASSWORD');
    menu_rdp_ip := rsActive.GetStringByName('RDPIP');
    menu_rdp_user := rsActive.GetStringByName('RDPUSER');
    menu_rdp_password := rsActive.GetStringByName('RDPPASSWORD');
end;
rsActive.Close;
conmgr.freeStatement(stmtActive);
end;

procedure InitConnectionManager();
var
  Connection : IZConnection;
  stmtActive : IZStatement;
  rsActive   : izResultSet;
  strUseServerDB : string;
  strIp, strPort, strPath, strLogin, strPassword : string;
begin

  Connection := DriverManager.GetConnectionWithLogin(getSettingsDBString(),'SYSDBA','masterkey');
  stmtActive := Connection.CreateStatement;

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''serverdb''');
  if rsActive.Next then strUseServerDB := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''ip''');
  if rsActive.Next then strIp := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''port''');
  if rsActive.Next then strPort := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''path''');
  if rsActive.Next then strPath := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''login''');
  if rsActive.Next then strLogin := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''password''');
  if rsActive.Next then strPassword := rsActive.GetString(1);

  rsactive.Close;
  stmtActive.Close;
  Connection.Close;

  if strUseServerDB = '1' then
    begin
    dbuser := strLogin;
    dbpass := strPassword;
    dbstr  := 'zdbc:firebird-3.0://'+strIp+':'+strPort+'/'+strPath
    end
    else
    begin
    dbuser := '';
    dbpass := '';
    dbstr  := '';
    end;

  conmgr := TPussyConnectionManager.Create(true);
  conmgr.Priority := tpLower;
  conmgr.Init(3, getDBString, getDBUser, getDBPass, 180);
  conmgr.Start;
end;

procedure DameWarePatchHost( computer, domain, user, password, useNTLogon : string );
var
    Connection : IZConnection;
    stmtActive : IZStatement;
    rsActive   : IZResultSet;
    strUpdate  : string;
    strQuar    : string;
    rowid      : string;
begin
Connection := DriverManager.GetConnectionWithLogin('zdbc:sqlite-3://127.0.0.1:3050/'+GetEnvironmentVariable('APPDATA')+'\DameWare Development\MRCCv2.db','','');
stmtActive := Connection.CreateStatement;

strQuar := 'select rowid from mrc where machine = '''+computer+''' ';
rsActive := stmtActive.ExecuteQuery(strQuar);

if rsActive.Next then
begin
   rowid := rsActive.GetString(1);
end
else
begin
  rowid := 'null';
end;

strUpdate :=
'REPLACE INTO ' +
'MRC(ROWID, PARENTID, OBJTYPE, TREETYPE, MACHINE, ALIAS, PORTNUM, REMEMBER, USECURNT, AUTHTYPE, KEYMAPPING, NOKEYBDRTR, COMPLEVEL,USECLIPBD,SCANBLOCKS,SCANBLKDLY,SERVICESTA,SFT_COMLVL,RDP_REDRPR,MD_COMPRES) ' +
'VALUES ('+rowid+',0, 2, 0, '''+computer+''', '''+computer+''', 6129, 1, '+useNTLogon+', 1, 1, 1, 3,1,32,12,3,0,0,4); ';

stmtactive.ExecuteUpdate(strUpdate);
stmtActive.Close;
sleep(50);
Connection.Close;
sleep(50);
end;

function getShortDname( dname : string ) : string;
begin
result := dname;

if pos('.', dname) >= 2 then
  begin
  result := copy(dname,1, pos('.', dname) -1 );
  end;
end;

procedure AmmyAdminConnect(id, password : string);
var
 strParams : string;
begin
  id := StringReplace(id, ' ', '',[rfReplaceAll, rfIgnoreCase]);
  strParams := ' -connect ' + id + ' -password ' + password;
  ShellExecute(0,'open',PWIDECHAR(ammyAdminExe),PWIDECHAR(strParams),PWIDECHAR(ExtractFilePath(OneCExe)),SW_SHOWNORMAL);
end;

procedure RDPConnect(ip, user, password : string);
var ip_without_port : string;
begin
  // cmdkey /generic:"<server>" /user:"<user>" /pass:"<pass>"
  // cmdkey /add:server01 /user:<username> /pass:<password>
  // mstsc /v:<server>
  //
  ip_without_port := ip;
  if pos(':', ip) >= 1 then
    begin
      ip_without_port := copy(ip, 1, pos(':', ip) - 1 );
    end;
  // really dont know is this solution good or bad, but it works
  ShellExecute(0,'open',PWIDECHAR('cmdkey'),PWIDECHAR(' /generic:"TERMSRV/'+ip_without_port+'" /user:"'+user+'" /pass:"'+password+'"'),nil,SW_SHOWMINIMIZED);
  ShellExecute(0,'open',PWIDECHAR('cmdkey'),PWIDECHAR(' /add:'+ip_without_port+'" /user:"'+user+'" /pass:"'+password+'"'),nil,SW_SHOWMINIMIZED);
  sleep(100);
  ShellExecute(0,'open',PWIDECHAR('mstsc'),PWIDECHAR(' /v:"' + ip+'"'),nil,SW_SHOWNORMAL);
end;

procedure TeamViewerConnect( id, password : string);
begin
   id := StringReplace(id, ' ', '',[rfReplaceAll, rfIgnoreCase]);
   ShellExecute(0,'open',PWIDECHAR(teamViewerExe),PWIDECHAR(' -i' + id + ' -P ' + password),PWIDECHAR(ExtractFilePath(teamViewerExe)),SW_SHOWNORMAL);
end;

procedure AnyDeskConnect( computer, password : string );
var
  myFile : TextFile;
  batFilePath, VBSFilePath : string;
begin

  computer := StringReplace(computer, ' ', '',[rfReplaceAll, rfIgnoreCase]);
  batFilePath := GetCurrentDir() + '\AnyDeskScripts\' + computer + '.bat';
  VBSFilePath := GetCurrentDir() + '\AnyDeskScripts\' + computer + '.vbs';

  AssignFile(myFile, batFilePath);
  ReWrite(myFile);
  WriteLn(myFile, 'echo '+password+' | "'+AnyDeskExe+'" '+computer+' --with-password');
  CloseFile(myFile);

  AssignFile(myFile, VBSFilePath);
  ReWrite(myFile);
  WriteLn(myFile, 'Set WshShell = CreateObject("WScript.Shell")');
  WriteLn(myFile, 'WshShell.Run chr(34) & "'+batFilePath+'" & Chr(34), 0');
  WriteLn(myFile, 'Set WshShell = Nothing');
  CloseFile(myFile);

  ShellExecute(0,'open',PWIDECHAR(VBSFilePath),nil,nil,SW_SHOWNORMAL)
end;

procedure DameWareConnect( computer, domain, user, password, useNTLogon : string );
begin
  DameWarePatchHost( computer, domain, user, password, useNTLogon );
  ShellExecute(0,'open',PWIDECHAR(DameWareExe),PWIDECHAR('-c: -m:'+computer+' -u:'+user+' -p:"'+password+'" -d:'+domain+' -a:1 -md:'),PWIDECHAR(ExtractFilePath(DameWareExe)),SW_SHOWNORMAL);
end;

procedure OneCConnect( dbpath : string );
begin
  if OneCExe = '1c.rdp' then
  begin
    OneCConnectRDP( dbpath );
  end else
  begin
    OneCConnectEXE(dbpath);
  end;
end;

procedure OneCConnectEXE( dbpath : string );
var
  strParams : string;
begin
  if dbpath <> '' then
  begin
  strParams := ' enterprise /WS "http://'+dbpath+'" /N '+OneCUser+' /P ' + OneCPass;
  ShellExecute(0,'open',PWIDECHAR(OneCExe),PWIDECHAR(strParams),PWIDECHAR(ExtractFilePath(OneCExe)),SW_SHOWNORMAL);
  end else
  begin
  ShellExecute(0,'open',PWIDECHAR(OneCExe),nil,PWIDECHAR(ExtractFilePath(OneCExe)),SW_SHOWNORMAL);
  end;
end;

function LoadFileToStr(const FileName: TFileName): AnsiString;
var
  FileStream : TFileStream;
begin
  FileStream:= TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
     if FileStream.Size>0 then
     begin
      SetLength(Result, FileStream.Size);
      FileStream.Read(Pointer(Result)^, FileStream.Size);
     end;
    finally
     FileStream.Free;
    end;
end;

procedure OneCConnectRDP( dbpath : string );
var
  strParams  : string;
  strTMP     : string;
  strRDPPath : string;
begin
  if dbpath <> '' then
  begin
  strParams  := ' enterprise /WS "http://'+dbpath+'" /N '+OneCUser+' /P ' + OneCPass;
  strRDPPath := GetCurrentDir() + '\RemoteApps\' + getShortDname(dbpath) + '.rdp';

  strTMP := TFile.ReadAllText(GetCurrentDir() + '\1c.rdp');
  strTMP := StringReplace(strTMP, 'remoteapplicationcmdline:s:', 'remoteapplicationcmdline:s:'+strParams, [rfReplaceAll, rfIgnoreCase]);

  TFile.WriteAllText(strRDPPath, strTMP);

  ShellExecute(0,'open',PWIDECHAR(strRDPPath),'','',SW_SHOWNORMAL);
  end else
  begin
  ShellExecute(0,'open',PWIDECHAR(OneCExe),nil,PWIDECHAR(ExtractFilePath(OneCExe)),SW_SHOWNORMAL);
  end;
end;

function StringKeyMapENRU(strInput : string) : string;
var
  i   : integer;
  str : string;
begin
str := AnsiLowerCase(strInput);
for i := 1 to length(str) do
    begin
		if str[i] = 'q' then str[i] := 'é';
		if str[i] = 'w' then str[i] := 'ö';
		if str[i] = 'e' then str[i] := 'ó';
		if str[i] = 'r' then str[i] := 'ê';
		if str[i] = 't' then str[i] := 'å';
		if str[i] = 'y' then str[i] := 'í';
		if str[i] = 'u' then str[i] := 'ã';
		if str[i] = 'i' then str[i] := 'ø';
		if str[i] = 'o' then str[i] := 'ù';
		if str[i] = 'p' then str[i] := 'ç';
    if str[i] = '[' then str[i] := '[';
    if str[i] = ']' then str[i] := ']';
		if str[i] = 'a' then str[i] := 'ô';
		if str[i] = 's' then str[i] := 'û';
		if str[i] = 'd' then str[i] := 'â';
		if str[i] = 'f' then str[i] := 'à';
		if str[i] = 'g' then str[i] := 'ï';
		if str[i] = 'h' then str[i] := 'ð';
		if str[i] = 'j' then str[i] := 'î';
		if str[i] = 'k' then str[i] := 'ë';
		if str[i] = 'l' then str[i] := 'ä';
    if str[i] = ';' then str[i] := 'æ';
    if str[i] = chr(39) then str[i] := 'ý';
		if str[i] = 'z' then str[i] := 'ÿ';
		if str[i] = 'x' then str[i] := '÷';
		if str[i] = 'c' then str[i] := 'ñ';
		if str[i] = 'v' then str[i] := 'ì';
		if str[i] = 'b' then str[i] := 'è';
		if str[i] = 'n' then str[i] := 'ò';
		if str[i] = 'm' then str[i] := 'ü';
    if str[i] = ',' then str[i] := 'á';
    if str[i] = '.' then str[i] := 'þ';
    if str[i] = '/' then str[i] := '.';
    end;
result := str;
end;


function getDBUser() : string;
begin
  result := 'SYSDBA';

  if dbuser <> '' then result := dbuser;
end;

function getDBPass() : string;
begin
  result := 'zorba';

  if dbpass <> '' then result := dbpass;
end;

function getSettingsDBString() : string;
var
  strTmp : string;
begin
 strTMP := GetCurrentDir();

 if AnsiEndsStr('Win32\Release', strTMP) or AnsiEndsStr('Win32\Debug', strTMP) then
  begin
     Result := 'zdbc:firebird-3.0:' + copy( strTMP, 1, pos('Win32\', strTMP )-2) + '\db\settings.fdb';
  end
 else
  begin
    Result := 'zdbc:firebird-3.0:' + strTMP + '\db\settings.fdb'
  end;
end;

function getDBString() : string;
var
  strCurDir : string;
begin
 strCurDir := GetCurrentDir();

 if AnsiEndsStr('Win32\Release', strCurDir) or AnsiEndsStr('Win32\Debug', strCurDir) then
  begin
     Result := 'zdbc:firebird-3.0:' + copy( strCurDir, 1, pos('Win32\', strCurDir )-2) + '\db\pcom.fdb';   // local db for dev comp
  end
 else
  begin
    Result := 'zdbc:firebird-3.0:' + strCurDir + '\db\pcom.fdb'    // local embedded db
  end;

  if dbstr <> '' then result := dbstr;
end;

function mqInp(quest: string; slTemplate : TStringList) : string;
var
  frmDlg : TfrmMyMsgDlg;
  res : string;
  i : integer;
begin
res := '';
frmDlg := TfrmMyMsgDlg.Create(nil);
frmDlg.MakeInputBox;
frmDlg.LblQuestion.Caption := quest;

if slTemplate <> nil then
  begin
    for i := 0 to slTemplate.Count - 1 do
      begin
       frmDlg.cmbAnswer.Items.Add(slTemplate[i]);
      end;
  end;

frmDlg.ShowModal;

res := frmDlg.textAnswer;
frmDlg.Close;
frmDlg.Free;
res := strTruncate(res, 200);

result := res;
end;

function mqDlg(quest : string) : integer;
var
  frmDlg : TfrmMyMsgDlg;
  res : integer;
begin
frmDlg := TfrmMyMsgDlg.Create(nil);
frmDlg.LblQuestion.Caption := quest;
frmDlg.cmbAnswer.Visible := false;
frmDlg.ShowModal;

res := frmDlg.Answer;

frmDlg.Close;
frmDlg.Free;

result := res;
end;

function mqInform(quest : string) : integer;
var
  frmDlg : TfrmMyMsgDlg;
  res : integer;
begin
frmDlg := TfrmMyMsgDlg.Create(nil);
frmDlg.LblQuestion.Caption := quest;
frmDlg.Makeinform;
frmDlg.ShowModal;

res := frmDlg.Answer;

frmDlg.Close;
frmDlg.Free;

result := res;
end;


procedure Wait ( sec : integer );
var
  i : integer;
begin
  for I := 0 to sec * 100 - 1 do
    begin
      sleep(10);
      Application.ProcessMessages;
    end;
end;

function GetDateDayName(dateTime : TDateTIme) : string;
begin
  result := SysUtils.FormatSettings.LongDayNames[DayOfWeek(dateTime)];
end;

function strTruncate(input : string; maxlen : integer) : string;
var
  res : string;
begin
  res := StringReplace(input, chr(39), '',[rfReplaceAll, rfIgnoreCase]);
  if length(res) > maxlen then res := copy(res,0, maxlen);

  result := res;
end;

function SHOpenFolderAndSelectItems( pidlFolder: PItemIDList; cidl: UINT;
    apidl: PPItemIDList; dwFlags: DWORD ): HRESULT; stdcall; external shell32;

procedure OpenFolderAndSelectItem( Path: WideString );
var
  desk: IShellFolder;
  iidl: PItemIDList;
  attrs, che: Cardinal;
begin
   SHGetDesktopFolder( desk );
   desk.ParseDisplayName( 0, nil, PWideChar( Path ), che, iidl, attrs );
   SHOpenFolderAndSelectItems( iidl, 0, nil, 0 );
   // if in last argument of SHOpenFolderAndSelectItems put OFASI_EDIT
   // then Explorer enter edit-name mode on selected object
end;


function pathIsFile(const FileName: string): Boolean;
var
  Code: Integer;
  res : boolean;
begin
  res := false;
  Code := GetFileAttributes(PChar(FileName));
  if ( (code <> -1) and ((FILE_ATTRIBUTE_DIRECTORY and code) = 0) ) then  res := true;

  Result := res;
end;

Function DelTree(DirName : string): Boolean;
 var
   SHFileOpStruct : TSHFileOpStruct;
   DirBuf : array [0..255] of char;
 begin
   try
    Fillchar(SHFileOpStruct,Sizeof(SHFileOpStruct),0) ;
    FillChar(DirBuf, Sizeof(DirBuf), 0 ) ;
    StrPCopy(DirBuf, DirName) ;
    with SHFileOpStruct do begin
     Wnd := 0;
     pFrom := @DirBuf;
     wFunc := FO_DELETE;
     fFlags := FOF_ALLOWUNDO;
     fFlags := fFlags or FOF_NOCONFIRMATION;
     fFlags := fFlags or FOF_SILENT;
    end; 
     Result := (SHFileOperation(SHFileOpStruct) = 0) ;
    except
     Result := False;
   end;
 end;

procedure Autorun(Flag:boolean; NameParam, Path:String);
var Reg:TRegistry;
begin
  if Flag then
  begin
     Reg := TRegistry.Create;
     Reg.RootKey := HKEY_CURRENT_USER;
     Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', false);
     Reg.WriteString(NameParam, Path);
     Reg.Free;
  end
  else
  begin
     Reg := TRegistry.Create;
     Reg.RootKey := HKEY_CURRENT_USER;
     Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',false);
     Reg.DeleteValue(NameParam);
     Reg.Free;
  end;
end;

function processExists(exeFileName: string): integer;
 var
    ContinueLoop: BOOL;
    FSnapshotHandle: THandle;
    FProcessEntry32: TProcessEntry32;
    PsNum : Integer;
 begin
    PsNum:=0;
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

    while Integer(ContinueLoop) <> 0 do
    begin
      if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
        UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
        UpperCase(ExeFileName))) then
      begin
        inc(PsNum,1);

      end; 
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32); 
    end; 
    CloseHandle(FSnapshotHandle);
    Result:=PsNum;
 end;

function KillTask(ExeFileName:string):integer;
const
  PROCESS_TERMINATE=$0001;
var
  Co:BOOL;
  FS:THandle;
  FP:TProcessEntry32;
begin
  result    := 0;
  FS        := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
  FP.dwSize := Sizeof(FP);
  Co        := Process32First(FS,FP);
while integer(Co) <> 0 do
begin
  if ((UpperCase(ExtractFileName(FP.szExeFile))=UpperCase(ExeFileName)) or (UpperCase(FP.szExeFile)=UpperCase(ExeFileName))) then
    Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),FP.th32ProcessID),0));
    Co := Process32Next(FS,FP);
  end;
CloseHandle(FS);
end;

function LeaveDitgits(input: string): string;
var strDest:string;
    i: integer;
begin
strDest:='';
if input <>'' then
begin
for I := 1 to Length(input) do
  begin
    if input[i]='0' then strDest:=strDest+'0';
    if input[i]='1' then strDest:=strDest+'1';
    if input[i]='2' then strDest:=strDest+'2';
    if input[i]='3' then strDest:=strDest+'3';
    if input[i]='4' then strDest:=strDest+'4';
    if input[i]='5' then strDest:=strDest+'5';
    if input[i]='6' then strDest:=strDest+'6';
    if input[i]='7' then strDest:=strDest+'7';
    if input[i]='8' then strDest:=strDest+'8';
    if input[i]='9' then strDest:=strDest+'9';
  end;
end;
Result:=strDest;
end;

function formatPhoneString(input : string): string;
var
  output, tmp : string;
  i, len : integer;
begin
  tmp := leaveDitgits(input);
  len := length(tmp);

  output := '';
for i := 1 to len do
  begin
    if ( (i = 1) ) then output := tmp[i];
    if ( (i = 1) and (i <> len)) then output := output + '-';

    if (i >= 2) and (i <= 4) then output := output + tmp[i];
    if ( (i = 4) and (i <> len) ) then output := output + '-';
    if (i >= 5) and (i <= 7) then output := output + tmp[i];
    if ( (i = 7) and (i <> len) ) then output := output + '-';

    if i >= 8 then
      begin
        output := output + tmp[i];
        if ( odd(i) and (i <> len) ) then output := output + '-';
      end;
  end;

result := output;
end;

end.
