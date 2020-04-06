unit formDesktop;

interface

uses Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, Vcl.Controls, System.Classes,
  Vcl.ExtCtrls, Vcl.Forms, zDBCIntFS;


type
  TfrmDesktop = class(TForm)
    pnTop: TPanel;
    pnISDEL: TPanel;
    Label1: TLabel;
    sbtnRestore: TSpeedButton;
    sbtnDelete: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblExt1: TLabel;
    Label6: TLabel;
    sbtnSave: TSpeedButton;
    txtName: TEdit;
    TxtAddress: TEdit;
    TxtTel1: TEdit;
    TxtTel2: TEdit;
    TxtTel1Dob: TEdit;
    TxtTel2Dob: TEdit;
    pcMain: TPageControl;
    tabConnections: TTabSheet;
    tabOther: TTabSheet;
    mmComment: TMemo;
    gboxAmmyAdmin: TGroupBox;
    TxtAmmyAdminId: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    txtAmmyAdminPassword: TEdit;
    SpeedButton1: TSpeedButton;
    sbtnAmmyConnect: TSpeedButton;
    gboxTeamViewer: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    SpeedButton2: TSpeedButton;
    sbtnTeamViewerConnect: TSpeedButton;
    txtTeamViewerID: TEdit;
    txtTeamViewerPassword: TEdit;
    gboxAnyDesk: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    SpeedButton3: TSpeedButton;
    sbtnAnyDeskConnect: TSpeedButton;
    txtAnyDeskID: TEdit;
    txtAnyDeskPassword: TEdit;
    gboxRDP: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    txtRDPIp: TEdit;
    txtRDPPassword: TEdit;
    Label15: TLabel;
    TxtRdpUser: TEdit;
    gboxDameWare: TGroupBox;
    lblDWIP: TLabel;
    lblDWPassword: TLabel;
    BtnDameWarePasswordToggle: TSpeedButton;
    sbtnDameWareConnect: TSpeedButton;
    lblDWUserName: TLabel;
    txtDameWareIp: TEdit;
    txtDameWarePassword: TEdit;
    txtDameWareUser: TEdit;
    txtDameWareDomain: TEdit;
    lblDWDomain: TLabel;
    ChDameWareUseNTLogon: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure OpenDesktop( desktop_id : string );
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sbtnDeleteClick(Sender: TObject);
    procedure sbtnRestoreClick(Sender: TObject);
    procedure TxtTel1Exit(Sender: TObject);
    procedure TxtTel1Change(Sender: TObject);
    procedure TxtTel2Exit(Sender: TObject);
    procedure TxtTel2Change(Sender: TObject);
    procedure sbtnSaveClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure sbtnAmmyConnectClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure sbtnTeamViewerConnectClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure sbtnAnyDeskConnectClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ChDameWareUseNTLogonClick(Sender: TObject);
    procedure BtnDameWarePasswordToggleClick(Sender: TObject);
    procedure sbtnDameWareConnectClick(Sender: TObject);
  private
    { Private declarations }
    cur_desktop_id : string;
    procedure ToggleDameWareCredentials();
    procedure bgOpen();
    procedure Clear();
    procedure Save();
    procedure SetEchoModeForPasswords();
  public
    { Public declarations }
  end;

type
  TbgDesktopOpener = class(TThread)
  public
    desktop_id : string;
    stmtActive : IZStatement;
    stmtGroups : IZStatement;
    rsActive   : IZResultSet;
    fForm      : TfrmDesktop;
  private
    { Private declarations }
  protected
    procedure Execute(); override;
    procedure Display();
    procedure FreeStatement();
  end;

var
  frmDesktop: TfrmDesktop;

implementation

{$R *.dfm}

uses pcomlib, pussyConnectionManager;

procedure TfrmDesktop.SetEchoModeForPasswords();
begin
  txtAmmyAdminPassword.PasswordChar := #42;
  TxtAnyDeskPassword.PasswordChar := #42;
  TxtDameWarePassword.PasswordChar := #42;
  TxtRDPPassword.PasswordChar := #42;
  TxtTeamViewerPassword.PasswordChar := #42;
end;


procedure TfrmDesktop.SpeedButton1Click(Sender: TObject);
begin
  if TxtAmmyAdminPassword.PasswordChar = #0
  then
     TxtAmmyAdminPassword.PasswordChar := #42
  else
     TxtAmmyAdminPassword.PasswordChar := #0;
end;

procedure TfrmDesktop.SpeedButton2Click(Sender: TObject);
begin
  if txtTeamViewerPassword.PasswordChar = #0
  then
     txtTeamViewerPassword.PasswordChar := #42
  else
     txtTeamViewerPassword.PasswordChar := #0;
end;

procedure TfrmDesktop.SpeedButton3Click(Sender: TObject);
begin
  if txtAnyDeskPassword.PasswordChar = #0
  then
     txtAnyDeskPassword.PasswordChar := #42
  else
     txtAnyDeskPassword.PasswordChar := #0;
end;

procedure TfrmDesktop.SpeedButton4Click(Sender: TObject);
begin
  if txtRDPPassword.PasswordChar = #0
  then
     txtRDPPassword.PasswordChar := #42
  else
     txtRDPPassword.PasswordChar := #0;
end;

procedure TfrmDesktop.SpeedButton5Click(Sender: TObject);
begin
  RDPConnect(TxtRDPIP.Text, TxtRDPUser.Text, TxtRDPPassword.Text);
end;

procedure TfrmDesktop.BtnDameWarePasswordToggleClick(Sender: TObject);
begin
  if txtDameWarePassword.PasswordChar = #0
  then
     txtDameWarePassword.PasswordChar := #42
  else
     txtDameWarePassword.PasswordChar := #0;
end;

procedure TbgDesktopOpener.Execute();
begin
  stmtActive := conmgr.getStatement;
  rsactive   := stmtactive.ExecuteQuery('select * from desktops where ID = ' + desktop_id);
  Synchronize(Display);
  freeStatement();
end;

procedure TbgDesktopOpener.Display();
begin

while(rsactive.next()) do
  begin
  fForm.TxtName.Text          := rsActive.GetStringByName('NAME');
  fForm.TxtAddress.Text       := rsActive.GetStringByName('ADDRESS');
  fForm.TxtTel1.Text          := rsActive.GetStringByName('TEL1');
  fForm.TxtTel2.Text          := rsActive.GetStringByName('TEL2');
  fForm.mmComment.Text        := rsActive.GetStringByName('COMMENT');

  fForm.TxtAmmyAdminId.Text       := rsActive.GetStringByName('AMMYADMINID');
  fForm.TxtAmmyAdminPassword.Text := rsActive.GetStringByName('AMMYADMINPASSWORD');

  fForm.TxtAnyDeskID.Text        := rsActive.GetStringByName('ANYDESKID');
  fForm.TxtAnyDeskPassword.Text  := rsActive.GetStringByName('ANYDESKPASSWORD');

  fForm.txtDameWareIp.Text         := rsActive.GetStringByName('DAMEWAREIP');

  if (rsActive.GetStringByName('DAMEWAREUSENTLOGON') = '1') then fForm.ChDameWareUseNTLogon.Checked := true
                                                            else fForm.ChDameWareUseNTLogon.Checked := false;

  fForm.txtDameWareDomain.Text     := rsActive.GetStringByName('DAMEWAREDOMAIN');
  fForm.txtDameWareUser.Text       := rsActive.GetStringByName('DAMEWAREUSER');
  fForm.txtDameWarePassword.Text   := rsActive.GetStringByName('DAMEWAREPASSWORD');

  fForm.txtRDPIp.Text        := rsActive.GetStringByName('RDPIP');
  fForm.txtRDPUser.Text      := rsActive.GetStringByName('RDPUSER');
  fForm.txtRDPPassword.Text  := rsActive.GetStringByName('RDPPASSWORD');

  fForm.txtTeamViewerID.Text       := rsActive.GetStringByName('TEAMVIEWERID');
  fForm.txtTeamViewerPassword.Text := rsActive.GetStringByName('TEAMVIEWERPASSWORD');

  fForm.TxtTel1Dob.Text := rsActive.GetStringByName('TEL1DOB');
  fForm.TxtTel2Dob.Text := rsActive.GetStringByName('TEL2DOB');

  if rsActive.GetStringByName('ISDEL') = '1' then
     fForm.pnISDEL.Visible := true
  else
     fForm.pnISDEL.Visible := false;

  end;


  fForm.ToggleDameWareCredentials();
end;

procedure TbgDesktopOpener.freeStatement();
begin
  rsActive.Close;
  sleep(30);
  conmgr.freeStatement(stmtActive);
end;

procedure TfrmDesktop.OpenDesktop(desktop_id : string);
begin

  cur_desktop_id := desktop_id;
  Clear();
  bgOpen();
  ShowModal();
end;

procedure TfrmDesktop.bgOpen();
var
  myTh : TbgDesktopOpener;
begin
  myTh := TbgDesktopOpener.Create(true);
  myTh.Priority := tpLower;
  myTh.fForm := self;
  myTh.desktop_id := cur_desktop_id;
  myTh.Start;
end;

procedure TfrmDesktop.sbtnAmmyConnectClick(Sender: TObject);
begin
  AmmyAdminConnect(TxtAmmyAdminId.Text, TxtAmmyAdminPassword.Text);
end;

procedure TfrmDesktop.sbtnAnyDeskConnectClick(Sender: TObject);
begin
  AnyDeskConnect(TxtAnyDeskId.Text, TxtAnyDeskPassword.Text);
end;

procedure TfrmDesktop.sbtnTeamViewerConnectClick(Sender: TObject);
begin
  TeamViewerConnect(TxtTeamViewerID.Text, TxtTeamViewerPassword.Text);
end;

procedure TfrmDesktop.ChDameWareUseNTLogonClick(Sender: TObject);
begin
  ToggleDameWareCredentials();
end;

procedure TfrmDesktop.Clear();
begin
  SetEchoModeForPasswords();

  TxtName.Clear();
  TxtAddress.Clear();
  TxtTel1.Clear();
  TxtTel2.Clear();
  mmComment.Clear();

  TxtAmmyAdminId.Clear();
  TxtAmmyAdminPassword.Clear();

  TxtAnyDeskID.Clear();
  TxtAnyDeskPassword.Clear();

  txtDameWareIp.Clear();
  ChDameWareUseNTLogon.Checked := false;
  txtDameWareDomain.Clear();
  txtDameWareUser.Clear();
  txtDameWarePassword.Clear();

  txtRDPIp.Clear();
  txtRDPUser.Clear();
  txtRDPPassword.Clear();

  txtTeamViewerID.Clear();
  txtTeamViewerPassword.Clear();

  TxtTel1Dob.Clear();
  TxtTel2Dob.Clear();
end;

procedure TfrmDesktop.Save;
var
  stmtActive : IZStatement;
  strUpdate  : string;
  strUseNTLogon : string;
begin
  if chDameWareUseNtLogon.Checked then strUseNTLogon := '1' else strUseNTlogon := '0';

  stmtActive := conmgr.getStatement;

  strUpdate  := 'update desktops set COMMENT = '''+mmComment.Text+''', NAME = '''+TxtName.Text+''', ADDRESS = '''+TxtAddress.Text+''',TEL1 = '''+TxtTel1.Text+''', TEL2 = '''+TxtTel2.Text+''', AMMYADMINID = '''+TxtAmmyAdminId.Text+''', AMMYADMINPASSWORD = '''+TxtAmmyAdminPassword.Text+''' where id = ' + cur_desktop_id;
  stmtActive.AddBatch(strUpdate);

  strUpdate  := 'update desktops set ANYDESKID = '''+TxtAnyDeskId.Text+''', ANYDESKPASSWORD = '''+TxtAnyDeskPassword.Text+''', DAMEWAREIP = '''+txtDameWareIp.Text+''',DAMEWAREUSENTLOGON = '+strUseNTLogon+', DAMEWAREDOMAIN = '''+txtDAMEWAREDOMAIN.Text+''', DAMEWAREUSER = '''+txtDAMEWAREUSER.Text+''', DAMEWAREPASSWORD = '''+txtDAMEWAREPASSWORD.Text+''' where id = ' + cur_desktop_id;
  stmtActive.AddBatch(strUpdate);

  strUpdate  := 'update desktops set RDPIP = '''+txtRDPIP.Text+''', RDPUSER = '''+txtRDPUSER.Text+''', RDPPASSWORD = '''+txtRDPPASSWORD.Text+''', TEAMVIEWERID = '''+txtTEAMVIEWERID.Text+''', TEAMVIEWERPASSWORD = '''+txtTEAMVIEWERPASSWORD.Text+''', tel1dob = '''+TxtTel1Dob.Text+''', tel2dob = '''+TxtTel2Dob.Text+''' where id = ' + cur_desktop_id;
  stmtActive.AddBatch(strUpdate);

  stmtActive.ExecuteBatch();
  conmgr.freeStatement(stmtActive);
end;

procedure TfrmDesktop.sbtnDameWareConnectClick(Sender: TObject);
var
  useNTLogon : string;
begin
  if ChDameWareUseNTLogon.Checked
  then
      useNTLogon := '1'
  else
      useNTLogon := '0';

  DameWareConnect( TxtDameWareIp.Text, TxtDameWareDomain.Text, TxtDameWareUser.Text, TxtDameWarePassword.Text, useNTLogon );
end;

procedure TfrmDesktop.sbtnDeleteClick(Sender: TObject);
var
  stmtActive : IZStatement;
begin
if mqDlg('Delete?') = mrOK then
begin
  stmtActive := conmgr.getStatement;
  stmtActive.ExecuteUpdate('delete from desktops where id = ' + cur_desktop_id );
  conmgr.freeStatement(stmtActive);
  self.Close;
end;

end;

procedure TfrmDesktop.sbtnRestoreClick(Sender: TObject);
var
  stmtActive : IZStatement;
begin
  stmtActive := conmgr.getStatement;
  stmtActive.ExecuteUpdate('update desktops set isdel = 0 where id = ' + cur_desktop_id );
  conmgr.freeStatement(stmtActive);
  pnISDEL.Hide;
end;

procedure TfrmDesktop.sbtnSaveClick(Sender: TObject);
begin
  Save();
end;

procedure TfrmDesktop.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 27 then
  begin
  CloseModal();
  Close();
  end;
end;

procedure TfrmDesktop.FormShow(Sender: TObject);
begin
pcMain.ActivePageIndex := tabConnections.PageIndex;
ToggleDameWareCredentials();
end;

procedure TfrmDesktop.ToggleDameWareCredentials();
begin
  if chDameWareUseNTLogon.Checked then
  begin
  lblDWUserName.Visible := false;
  lblDWDomain.Visible   := false;
  lblDWPassword.Visible := false;
  TxtDameWareDomain.Visible := false;
  TxtDameWareUser.Visible   := false;
  TxtDameWarePassword.Visible := false;
  BtnDameWarePasswordToggle.Visible := false;
  end else
  begin
  lblDWUserName.Visible := true;
  lblDWDomain.Visible   := true;
  lblDWPassword.Visible := true;
  TxtDameWareDomain.Visible := true;
  TxtDameWareUser.Visible   := true;
  TxtDameWarePassword.Visible := true;
  BtnDameWarePasswordToggle.Visible := true;
  end;

end;

procedure TfrmDesktop.TxtTel1Change(Sender: TObject);
begin
  TxtTel1.Text := formatPhoneString(TxtTel1.Text);
  TxtTel1.SelStart := Length(TxtTel1.Text);
end;

procedure TfrmDesktop.TxtTel1Exit(Sender: TObject);
begin
TxtTel1.Text := formatPhoneString(TxtTel1.Text);
end;

procedure TfrmDesktop.TxtTel2Change(Sender: TObject);
begin
  TxtTel2.Text     := formatPhoneString(TxtTel2.Text);
  TxtTel2.SelStart := Length(TxtTel2.Text);
end;

procedure TfrmDesktop.TxtTel2Exit(Sender: TObject);
begin
TxtTel2.Text := formatPhoneString(TxtTel2.Text);
end;

end.
