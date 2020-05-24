unit formSettings;

interface

uses Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Controls, Vcl.Buttons, System.Classes,
  Vcl.Dialogs, Vcl.Forms, System.SysUtils, zDBCIntFs, ShellApi, Winapi.Windows;

type
  TfrmSettings = class(TForm)
    FileOpenDialog1: TFileOpenDialog;
    sBtnSaveAppSettings: TSpeedButton;
    gboxTeamViewer: TGroupBox;
    TxtTeamViewerExe: TEdit;
    Button1: TButton;
    SpeedButton1: TSpeedButton;
    gboxDameWare: TGroupBox;
    SpeedButton2: TSpeedButton;
    txtDameWareExe: TEdit;
    Button2: TButton;
    gboxAnyDesk: TGroupBox;
    SpeedButton3: TSpeedButton;
    txtAnyDeskExe: TEdit;
    Button3: TButton;
    gboxAmmyAdmin: TGroupBox;
    SpeedButton4: TSpeedButton;
    txtAmmyAdminExe: TEdit;
    Button4: TButton;
    pcTabs: TPageControl;
    TabSheetExePath: TTabSheet;
    TabSheetDbase: TTabSheet;
    sbtnSaveDBSettings: TSpeedButton;
    GroupBoxServerDBSettings: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    TxtDBIP: TEdit;
    TxtDBPort: TEdit;
    TxtDBPath: TEdit;
    TxtDBLogin: TEdit;
    TxtDBPassword: TEdit;
    btnTestSettings: TButton;
    BtnLocalDbase: TSpeedButton;
    BtnServerDbase: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure LoadExeSettings();
    procedure sBtnSaveAppSettingsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure sbtnSaveDBSettingsClick(Sender: TObject);
    procedure btnTestSettingsClick(Sender: TObject);
    procedure BtnLocalDbaseClick(Sender: TObject);
    procedure BtnServerDbaseClick(Sender: TObject);
  private
    { Private declarations }
    procedure SaveExeSettings();
    procedure CheckDBSettingsVisability();
    procedure SaveDBSettings();
    procedure LoadDBSettings();
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

uses pcomlib;

procedure TfrmSettings.SaveDBSettings;
var
  Connection : IZConnection;
  pstmt : IZPreparedStatement;
  strUseServerDB : string;
begin
  if BtnLocalDbase.Down then strUseServerDB := '0' else strUseServerDB := '1';

  Connection := DriverManager.GetConnectionWithLogin(getSettingsDBString(),'SYSDBA','masterkey');

  pstmt := Connection.PrepareStatement('UPDATE DBSETTINGS SET AVALUE = ? WHERE KEY = ''serverdb''');
  pstmt.SetString(1, strUseServerDB);
  pstmt.ExecuteUpdatePrepared;
  pstmt.Close;

  pstmt := Connection.PrepareStatement('UPDATE DBSETTINGS SET AVALUE = ? WHERE KEY = ''ip''');
  pstmt.SetString(1, TxtDBIP.Text);
  pstmt.ExecuteUpdatePrepared;
  pstmt.Close;

  pstmt := Connection.PrepareStatement('UPDATE DBSETTINGS SET AVALUE = ? WHERE KEY = ''port''');
  pstmt.SetString(1, TxtDBPort.Text);
  pstmt.ExecuteUpdatePrepared;
  pstmt.Close;

  pstmt := Connection.PrepareStatement('UPDATE DBSETTINGS SET AVALUE = ? WHERE KEY = ''path''');
  pstmt.SetString(1, TxtDBPath.Text);
  pstmt.ExecuteUpdatePrepared;
  pstmt.Close;

  pstmt := Connection.PrepareStatement('UPDATE DBSETTINGS SET AVALUE = ? WHERE KEY = ''login''');
  pstmt.SetString(1, TxtDBLogin.Text);
  pstmt.ExecuteUpdatePrepared;
  pstmt.Close;

  pstmt := Connection.PrepareStatement('UPDATE DBSETTINGS SET AVALUE = ? WHERE KEY = ''password''');
  pstmt.SetString(1, TxtDBPassword.Text);
  pstmt.ExecuteUpdatePrepared;
  pstmt.Close;

  Connection.Close;
end;


procedure TfrmSettings.BtnLocalDbaseClick(Sender: TObject);
begin
  CheckDBSettingsVisability();
end;

procedure TfrmSettings.BtnServerDbaseClick(Sender: TObject);
begin
  CheckDBSettingsVisability();
end;

procedure TfrmSettings.btnTestSettingsClick(Sender: TObject);
var
  testok : boolean;
  Connection : IZConnection;
  stmtActive : IZStatement;
  rsActive   : IZResultSet;
  ErrorString : string;
begin

try
  begin
  Connection := DriverManager.GetConnectionWithLogin('zdbc:firebird-3.0://'+TxtDBIP.Text+':'+TxtDBPort.Text+'/'+TxtDBPath.Text,TxtDBLogin.Text,TxtDBPassword.Text);
  stmtActive := Connection.CreateStatement;
  rsActive := stmtActive.ExecuteQuery('select first 1 skip 0 * from zTHISISPUSSYCOMMANDER20');
  while rsActive.Next do begin end;
  rsActive.Close;
  stmtActive.Close;
  Connection.Close;
  testok := true;
  end;
except
  on E : Exception do
  begin
   ErrorString := E.ClassName + ' ' + E.Message;
   testok := false;
  end;
end;

if testOk then showMessage('Connection ok!') else ShowMessage(ErrorString);


end;

procedure TfrmSettings.Button1Click(Sender: TObject);
begin
if fileOpenDialog1.Execute then
  begin
    TxtTeamViewerExe.Text := fileOpenDialog1.FileName;
  end;
end;

procedure TfrmSettings.Button2Click(Sender: TObject);
begin
if fileOpenDialog1.Execute then
  begin
    TxtDameWareExe.Text := fileOpenDialog1.FileName;
  end;
end;

procedure TfrmSettings.Button3Click(Sender: TObject);
begin
if fileOpenDialog1.Execute then
  begin
    TxtAnyDeskExe.Text := fileOpenDialog1.FileName;
  end;
end;

procedure TfrmSettings.Button4Click(Sender: TObject);
begin
if fileOpenDialog1.Execute then
  begin
    TxtAmmyAdminExe.Text := fileOpenDialog1.FileName;
  end;
end;

procedure TfrmSettings.CheckDBSettingsVisability();
begin
  if BtnLocalDbase.Down then
      GroupBoxServerDBSettings.Visible := false
  else
      GroupBoxServerDBSettings.Visible := true;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
PcTabs.ActivePage := TabSheetExePath;
LoadExeSettings();
LoadDBSettings();
CheckDBSettingsVisability();
end;

procedure TfrmSettings.SaveExeSettings;
var
  Connection : IZConnection;
  pstmt : IZPreparedStatement;
begin
  // Global vars set.
  AmmyAdminExe  := TxtAmmyAdminExe.Text;
  AnyDeskEXE    := TxtAnyDeskExe.Text;
  DameWareExe   := TxtDameWareExe.Text;
  TeamViewerExe := TxtTeamViewerExe.Text;

  Connection := DriverManager.GetConnectionWithLogin(getSettingsDBString(), 'SYSDBA', 'masterkey');

  pstmt := Connection.PrepareStatement('UPDATE EXESETTINGS SET EXEPATH = ? WHERE APPLICATION = ''ammyadmin''');
  pstmt.SetString(1, AmmyAdminExe);
  pstmt.ExecuteUpdatePrepared;
  pstmt.Close;

  pstmt := Connection.PrepareStatement('UPDATE EXESETTINGS SET EXEPATH = ? WHERE APPLICATION = ''anydesk''');
  pstmt.SetString(1, AnyDeskEXE);
  pstmt.ExecuteUpdatePrepared;
  pstmt.Close;

  pstmt := Connection.PrepareStatement('UPDATE EXESETTINGS SET EXEPATH = ? WHERE APPLICATION = ''dameware''');
  pstmt.SetString(1, DameWareExe);
  pstmt.ExecuteUpdatePrepared;
  pstmt.Close;

  pstmt := Connection.PrepareStatement('UPDATE EXESETTINGS SET EXEPATH = ? WHERE APPLICATION = ''teamviewer''');
  pstmt.SetString(1, TeamViewerExe);
  pstmt.ExecuteUpdatePrepared;
  pstmt.Close;

  Connection.Close;
end;

procedure TfrmSettings.sBtnSaveAppSettingsClick(Sender: TObject);
begin
SaveExeSettings();
end;

procedure TfrmSettings.sbtnSaveDBSettingsClick(Sender: TObject);
begin
SaveDBSettings();

try
begin
  conmgr.Terminate; // close connections;
end;
except
end;

InitConnectionManager(); // it will re-read conf and re-init
end;

procedure TfrmSettings.SpeedButton1Click(Sender: TObject);
begin
if TxtTeamViewerExe.Text <> '' then ShellExecute(0,'open',PWIDECHAR(TxtTeamViewerExe.Text),nil,nil,SW_SHOWNORMAL);
end;

procedure TfrmSettings.SpeedButton2Click(Sender: TObject);
begin
if TxtDameWareExe.Text <> '' then ShellExecute(0,'open',PWIDECHAR(TxtDameWareExe.Text),nil,nil,SW_SHOWNORMAL);
end;

procedure TfrmSettings.SpeedButton3Click(Sender: TObject);
begin
if TxtAnyDeskExe.Text <> '' then ShellExecute(0,'open',PWIDECHAR(TxtAnyDeskExe.Text),nil,nil,SW_SHOWNORMAL);
end;

procedure TfrmSettings.SpeedButton4Click(Sender: TObject);
begin
if TxtAmmyAdminExe.Text <> '' then ShellExecute(0,'open',PWIDECHAR(TxtAmmyAdminExe.Text),nil,nil,SW_SHOWNORMAL);
end;

procedure TfrmSettings.LoadExeSettings;
var
  Connection : IZConnection;
  stmtActive : IZStatement;
  rsActive   : izResultSet;
begin

  Connection := DriverManager.GetConnectionWithLogin(getSettingsDBString(),'SYSDBA','masterkey');
  stmtActive := Connection.CreateStatement;

  rsActive := stmtActive.ExecuteQuery('select exepath from exesettings where application = ''ammyadmin''');
  if rsActive.Next then TxtAmmyAdminExe.Text := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select exepath from exesettings where application = ''anydesk''');
  if rsActive.Next then TxtAnyDeskExe.Text := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select exepath from exesettings where application = ''dameware''');
  if rsActive.Next then TxtDameWareExe.Text := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select exepath from exesettings where application = ''teamviewer''');
  if rsActive.Next then TxtTeamViewerExe.Text := rsActive.GetString(1);

  AmmyAdminExe  := TxtAmmyAdminExe.Text;
  AnyDeskEXE    := TxtAnyDeskExe.Text;
  DameWareExe   := TxtDameWareExe.Text;
  TeamViewerExe := TxtTeamViewerExe.Text;

  rsactive.Close;
  stmtActive.Close;
  Connection.Close;
end;

procedure TfrmSettings.LoadDBSettings;
var
  Connection : IZConnection;
  stmtActive : IZStatement;
  rsActive   : izResultSet;
  strUseServerDB : string;
begin

  Connection := DriverManager.GetConnectionWithLogin(getSettingsDBString(),'SYSDBA','masterkey');
  stmtActive := Connection.CreateStatement;

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''serverdb''');
  if rsActive.Next then strUseServerDB := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''ip''');
  if rsActive.Next then TxtDBIP.Text := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''port''');
  if rsActive.Next then TxtDBPort.Text := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''path''');
  if rsActive.Next then TxtDBPath.Text := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''login''');
  if rsActive.Next then TxtDBLogin.Text := rsActive.GetString(1);

  rsActive := stmtActive.ExecuteQuery('select avalue from dbsettings where key = ''password''');
  if rsActive.Next then TxtDBPassword.Text := rsActive.GetString(1);

  rsactive.Close;
  stmtActive.Close;
  Connection.Close;

  if strUseServerDB = '1' then BtnServerDbase.Down := true else BtnLocalDbase.Down := true;

end;

end.
