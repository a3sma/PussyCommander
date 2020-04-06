unit formTT;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinCaramel,
  cxTextEdit, cxLabel, cxGroupBox, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxMemo,
  dxGDIPlusClasses, cxImage, risalib, ZConnection, ZDBCIntFS, Vcl.ExtCtrls,
  OverbyteIcsWndControl, OverbyteIcsPing;

type
  TfrmTT = class(TForm)
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxTextTTName: TcxTextEdit;
    cxTextTTAddress: TcxTextEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxTextTel1: TcxTextEdit;
    cxTextTel2: TcxTextEdit;
    cxGroupBoxKassa1: TcxGroupBox;
    cxTextEditKassa1DName: TcxTextEdit;
    cxTextEditKassa1DBase: TcxTextEdit;
    cxButtonADConnect1: TcxButton;
    cxButtonDWConnect1: TcxButton;
    cxButton1CConnect1: TcxButton;
    cxGroupBoxKassa2: TcxGroupBox;
    cxTextEditKassa2Dname: TcxTextEdit;
    cxTextEditKassa2DBase: TcxTextEdit;
    cxButtonADConnect2: TcxButton;
    cxButtonDWConnect2: TcxButton;
    cxButton1CConnect2: TcxButton;
    cxGroupBoxKassa3: TcxGroupBox;
    cxTextEditKassa3Dname: TcxTextEdit;
    cxTextEditKassa3DBase: TcxTextEdit;
    cxButtonADConnect3: TcxButton;
    cxButtonDWConnect3: TcxButton;
    cxButton1CConnect3: TcxButton;
    cxButtonSave: TcxButton;
    cxMemoComment: TcxMemo;
    cxButton1: TcxButton;
    pnKassa1Status: TPanel;
    Ping1: TPing;
    pnKassa2Status: TPanel;
    pnKassa3Status: TPanel;
    procedure cxButtonSaveClick(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure pnKassa1StatusClick(Sender: TObject);
    procedure pnKassa2StatusClick(Sender: TObject);
    procedure pnKassa3StatusClick(Sender: TObject);
    procedure cxButton1CConnect1Click(Sender: TObject);
    procedure cxButton1CConnect2Click(Sender: TObject);
    procedure cxButton1CConnect3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    tt_id : string;
    { Private declarations }
    procedure bgOpen();
  public
    { Public declarations }
    procedure Open(ttid : string);
    procedure Clear();
    procedure Save();
    procedure CheckPings();
  end;


type
  TbgOpener = class(TThread)
  public
    tt_id      : string;
    stmtActive : IZStatement;
    rsActive   : IZResultSet;
    fForm      : TfrmTT;
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Display;
    procedure freeStatement;
  end;

type
  TbgPinger = class(TThread)
  public
    address     : string;
    ping_result : boolean;
    ping1       : TPing;
    kassa_num   : integer;
    fForm       : TfrmTT;
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Display;
  end;

var
  frmTT: TfrmTT;

implementation

{$R *.dfm}

uses PussyConnectionManager;

procedure TbgPinger.Execute;
begin
Ping1 := TPing.Create(fForm);
ping1.address := address;
ping1.Timeout := 1000;

try
  begin

  Ping1.ping;
  if ping1.ErrorCode=0 then
  begin
  ping_result := True;
  if ping1.Reply.DataSize=0 then
  begin
  ping_result:=false;
  End;
  end
  Else
  Begin
  ping_result := False;
  End;
  End;
except
  begin

  end;
end;


Synchronize(Display);
Ping1.Free;
end;

procedure TbgPinger.Display;
begin

if kassa_num = 1 then
  begin
  if ping_result then begin fForm.pnKassa1Status.Color := clLime; end;
  end;
if kassa_num = 2 then
  begin
  if ping_result then begin fForm.pnKassa2Status.Color := clLime; end;
  end;
if kassa_num = 3 then
  begin
  if ping_result then begin fForm.pnKassa3Status.Color := clLime; end;
  end;


end;


procedure TfrmTT.Clear();
begin

cxTextTTName.Clear();
cxTextTTAddress.Clear();
cxTextTel1.Clear();
cxTextTel2.Clear();
cxTextEditKassa1DName.Clear();
cxTextEditKassa1DBase.Clear();
cxTextEditKassa2DName.Clear();
cxTextEditKassa2DBase.Clear();
cxTextEditKassa3DName.Clear();
cxTextEditKassa3DBase.Clear();
cxMemoComment.Clear();

pnKassa1Status.Color := clGray;
pnKassa2Status.Color := clGray;
pnKassa3Status.Color := clGray;
end;


procedure TfrmTT.cxButton1CConnect1Click(Sender: TObject);
begin
OneCConnect(cxTextEditKassa1DName.Text + '/' + cxTextEditKassa1DBase.Text);
end;

procedure TfrmTT.cxButton1CConnect2Click(Sender: TObject);
begin
OneCConnect(cxTextEditKassa2DName.Text + '/' + cxTextEditKassa2DBase.Text);
end;

procedure TfrmTT.cxButton1CConnect3Click(Sender: TObject);
begin
OneCConnect(cxTextEditKassa3DName.Text + '/' + cxTextEditKassa3DBase.Text);
end;

procedure TfrmTT.cxButton1Click(Sender: TObject);
begin
Close();
end;

procedure TfrmTT.cxButtonSaveClick(Sender: TObject);
begin
Save();
end;

procedure TfrmTT.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 27 then Close();
end;

procedure TfrmTT.Open(ttid : string);
begin
tt_id := ttid;

Clear();
bgOpen();
ShowModal();
end;

procedure TfrmTT.CheckPings;
var
  myTh1, myTh2, myTh3 : TbgPinger;
begin
  pnKassa1Status.Color := clGray;
  pnKassa2Status.Color := clGray;
  pnKassa3Status.Color := clGray;

  myTh1 := TbgPinger.Create(true);
  myTh1.Priority := tpLower;
  myTh1.fForm := self;
  myTh1.address := cxTextEditKassa1DName.Text;
  myTh1.kassa_num := 1;
  myTh1.Start;

  myTh2 := TbgPinger.Create(true);
  myTh2.Priority := tpLower;
  myTh2.fForm := self;
  myTh2.address := cxTextEditKassa2DName.Text;
  myTh2.kassa_num := 2;
  myTh2.Start;

  myTh3 := TbgPinger.Create(true);
  myTh3.Priority := tpLower;
  myTh3.fForm := self;
  myTh3.address := cxTextEditKassa3DName.Text;
  myTh3.kassa_num := 3;
  myTh3.Start;
end;

procedure TfrmTT.pnKassa2StatusClick(Sender: TObject);
var ping_result : boolean;
begin
ping_result := false;
pnKassa2Status.Color := clGray;
try
  begin
  ping1.address:=Trim(cxTextEditKassa2DName.Text);
  Ping1.ping;
  if ping1.ErrorCode=0 then
  begin
  ping_result:=True;
  if ping1.Reply.DataSize=0 then
  begin
  ping_result:=false;
  End;
  end
  Else
  Begin
  ping_result:=False;
  End;
  End;
except
  begin
  ping_result := false;
  end;
end;

if ping_result then pnKassa2Status.Color := clLime;

end;

procedure TfrmTT.pnKassa3StatusClick(Sender: TObject);
var ping_result : boolean;
begin
ping_result := false;
pnKassa3Status.Color := clGray;
try
  begin
  ping1.address:=Trim(cxTextEditKassa3DName.Text);
  Ping1.ping;
  if ping1.ErrorCode=0 then
  begin
  ping_result:=True;
  if ping1.Reply.DataSize=0 then
  begin
  ping_result:=false;
  End;
  end
  Else
  Begin
  ping_result:=False;
  End;
  End;
except
  begin
  ping_result := false;
  end;
end;

if ping_result then pnKassa3Status.Color := clLime;

end;

procedure TfrmTT.pnKassa1StatusClick(Sender: TObject);
var ping_result : boolean;
begin
ping_result := false;
pnKassa1Status.Color := clGray;
try
  begin
  ping1.address:=Trim(cxTextEditKassa1DName.Text);
  Ping1.ping;
  if ping1.ErrorCode=0 then
  begin
  ping_result:=True;
  if ping1.Reply.DataSize=0 then
  begin
  ping_result:=false;
  End;
  end
  Else
  Begin
  ping_result:=False;
  End;
  End;
except
  begin
  ping_result := false;
  end;
end;

if ping_result then pnKassa1Status.Color := clLime;

end;

procedure TfrmTT.bgOpen();
var
  myTh : TbgOpener;
begin
  myTh := TbgOpener.Create(true);
  myTh.Priority := tpLower;
  myTh.fForm := self;
  myTh.tt_id := tt_id;
  myTh.Start;
end;

procedure TbgOpener.Execute;
begin
stmtActive := conMgr.getStatement;
rsactive   := stmtactive.ExecuteQuery('select * from TTS where ID = ' + tt_id);
Synchronize(Display);
FreeStatement();
end;

procedure TbgOpener.FreeStatement;
begin
rsactive.Close;
sleep(50);
ConMgr.freeStatement(stmtactive);
end;


procedure TbgOpener.Display;
begin

while(rsactive.next()) do
  begin
  fForm.cxTextTTName.Text := rsActive.GetStringByName('TTNAME');
  fForm.cxTextTTAddress.Text := rsActive.GetStringByName('TTADDRESS');
  fForm.cxTextTel1.Text := rsActive.GetStringByName('TEL1');
  fForm.cxTextTel2.Text := rsActive.GetStringByName('TEL2');
  fForm.cxTextEditKassa1DName.Text := rsActive.GetStringByName('KASSA1_DNAME');
  fForm.cxTextEditKassa1DBase.Text := rsActive.GetStringByName('K1DBASE');
  fForm.cxTextEditKassa2DName.Text := rsActive.GetStringByName('KASSA2_DNAME');
  fForm.cxTextEditKassa2DBase.Text := rsActive.GetStringByName('K2DBASE');
  fForm.cxTextEditKassa3DName.Text := rsActive.GetStringByName('KASSA3_DNAME');
  fForm.cxTextEditKassa3DBase.Text := rsActive.GetStringByName('K3DBASE');
  fForm.cxMemoComment.Text := rsActive.GetStringByName('COMMENT');
  end;

  fForm.CheckPings();
end;

procedure TfrmTT.Save;
var
    stmtActive : IZStatement;
    strQuar    : string;
begin
strQuar := 'update TTS set TTNAME = '''+cxTextTTName.Text+''', TTADDRESS = '''+cxTextTTAddress.Text+''', TEL1 = '''+cxTextTel1.Text+''', TEL2 = '''+cxTextTel2.Text+''', KASSA1_DNAME = '''+cxTextEditKassa1DName.Text+''', K1DBASE = '''+cxTextEditKassa1DBase.Text+''', KASSA2_DNAME = '''+cxTextEditKassa2DName.Text+''', K2DBASE = '''+cxTextEditKassa2DBase.Text+''', KASSA3_DNAME = '''+cxTextEditKassa3DName.Text+''', K3DBASE = '''+cxTextEditKassa3DBase.Text+''', COMMENT = '''+cxMemoComment.Text+''' where ID =' + tt_id;

stmtActive := conmgr.getStatement;
stmtactive.ExecuteQuery(strQuar);
conmgr.freeStatement(stmtActive);
end;

end.
