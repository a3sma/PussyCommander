unit formContact;

interface

uses Vcl.StdCtrls, Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, Vcl.Forms, ZdbcIntFs, System.sysUtils;


type
  TfrmContact = class(TForm)
    Panel1: TPanel;
    pnISDEL: TPanel;
    Label1: TLabel;
    sbtnRestore: TSpeedButton;
    sbtnDelete: TSpeedButton;
    btnClose: TButton;
    btnSaveAndClose: TSpeedButton;
    mmComment: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    cmbGroup: TComboBox;
    txtName: TEdit;
    txtPhone1: TEdit;
    txtPhone2: TEdit;
    txtExt1: TEdit;
    txtExt2: TEdit;
    txtEmail: TEdit;
    pnBottom: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sbtnRestoreClick(Sender: TObject);
    procedure sbtnDeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveAndCloseClick(Sender: TObject);
    procedure txtPhone1Change(Sender: TObject);
    procedure txtPhone1Exit(Sender: TObject);
    procedure txtPhone2Change(Sender: TObject);
    procedure txtPhone2Exit(Sender: TObject);
  private
    contact_id : string;
    { Private declarations }
     procedure Clear();
     procedure bgOpen();
     procedure SaveContact();
  public
    { Public declarations }
    procedure Open(c_id : string);
  end;

type
  TbgContactOpener = class(TThread)
  public
    contact_id : string;
    stmtActive : IZStatement;
    stmtGroups : IZStatement;
    rsActive   : IZResultSet;
    rsGroups   : IZResultSet;
    fForm      : TfrmContact;
  private
    { Private declarations }
  protected
    procedure Execute(); override;
    procedure Display();
    procedure FreeStatement();
  end;


var
  frmContact: TfrmContact;

implementation

{$R *.dfm}
uses PussyConnectionManager, pcomLib;

procedure TfrmContact.btnCloseClick(Sender: TObject);
begin
self.Close;
end;

procedure TfrmContact.btnSaveAndCloseClick(Sender: TObject);
begin
SaveContact();
Close();
end;

procedure TfrmContact.Clear;
begin
txtName.Clear();
cmbGroup.Items.Clear;
cmbGroup.Clear();
txtPhone1.Clear();
txtPhone2.Clear();
txtEmail.Clear();
mmComment.Clear();
txtExt1.Clear;
txtExt2.Clear;
end;

procedure TfrmContact.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 27 then Close();
end;

procedure TfrmContact.Open(c_id : string);
begin
  contact_id := c_id;
  Clear();
  bgOpen();
  ShowModal();
end;

procedure TfrmContact.bgOpen;
var
  myTh : TbgContactOpener;
begin
  myTh := TbgContactOpener.Create(true);
  myTh.Priority := tpLower;
  myTh.fForm := self;
  myTh.contact_id := contact_id;
  myTh.Start;
end;

procedure TbgContactOpener.Execute();
var client_id : string;
    rstmp : IZResultSet;
begin
stmtActive := conmgr.getStatement;
stmtGroups := conmgr.getStatement;

client_id := '';
rstmp := stmtActive.ExecuteQuery('select client_id from contacts where id = ' + contact_id);
if rstmp.Next then client_id := rstmp.GetString(1);
rstmp.Close;

rsactive   := stmtactive.ExecuteQuery('select * from contacts where ID = ' + contact_id);
rsGroups   := stmtGroups.ExecuteQuery('select gruppa from contacts where isdel=0 and client_id = '+client_id+' group by gruppa');
Synchronize(Display);
freeStatement();
end;

procedure TbgContactOpener.Display();
begin

while rsGroups.Next do
  begin
   if (rsGroups.GetString(1) <> '' ) then fForm.cmbGroup.Items.Add(rsGroups.GetString(1));
  end;

while(rsactive.next()) do
  begin
  fForm.txtName.Text          := rsActive.GetStringByName('FIO');
  fForm.cmbGroup.Text         := rsActive.GetStringByName('GRUPPA');
  fForm.txtPhone1.Text        := rsActive.GetStringByName('TEL1');
  fForm.txtPhone2.Text        := rsActive.GetStringByName('TEL2');
  fForm.txtEmail.Text         := rsActive.GetStringByName('EMAIL');
  fForm.mmComment.Text        := rsActive.GetStringByName('COMMENT');
  fForm.txtExt1.Text          := rsActive.GetStringByName('TEL1DOB');
  fForm.txtExt2.Text          := rsActive.GetStringByName('TEL2DOB');

  if rsActive.GetStringByName('ISDEL') = '1' then
    begin
      fForm.pnISDEL.Visible := true;
      fForm.Height := 268;
    end
  else
    begin
      fForm.pnISDEL.Visible := false;
      fForm.Height := 268 - 38;
    end;
  end;

end;

procedure TfrmContact.SaveContact;
var
  pstmt : IZPreparedStatement;
  strUpdate  : string;
begin
  strUpdate  := 'update contacts set fio = ?, gruppa = ?, tel1 = ?,tel2 = ?, email = ?, comment = ?, tel1dob = ?, tel2dob = ? where id = ?';
  pstmt := conmgr.prepareStatement(strUpdate);
  pstmt.SetString(1, txtName.Text);
  pstmt.SetString(2, cmbGroup.Text);
  pstmt.SetString(3, txtPhone1.Text);
  pstmt.SetString(4, txtPhone2.Text);
  pstmt.SetString(5, txtEmail.Text);
  pstmt.SetString(6, mmComment.Text);
  pstmt.SetString(7, txtExt1.Text);
  pstmt.SetString(8, txtExt2.Text);
  pstmt.SetString(9, contact_id);

  pstmt.ExecuteUpdatePrepared;
  conmgr.freePreparedStatement(pstmt);
end;

procedure TfrmContact.sbtnRestoreClick(Sender: TObject);
var
  stmtActive : IZStatement;
begin
  stmtActive := conmgr.getStatement;
  stmtActive.ExecuteUpdate('update contacts set isdel = 0 where id = ' + contact_id );
  conmgr.freeStatement(stmtActive);
  pnISDEL.Hide;
end;

procedure TfrmContact.sbtnDeleteClick(Sender: TObject);
var
  stmtActive : IZStatement;
begin
if mqDlg('Delete?') = mrOK then
begin
  stmtActive := conmgr.getStatement;
  stmtActive.ExecuteUpdate('delete from contacts where id = ' + contact_id );
  conmgr.freeStatement(stmtActive);
  self.Close;
end;

end;

procedure TfrmContact.txtPhone1Change(Sender: TObject);
begin
  txtPhone1.Text := formatPhoneString(txtPhone1.Text);
  txtPhone1.SelStart := Length(txtPhone1.Text);
end;

procedure TfrmContact.txtPhone1Exit(Sender: TObject);
begin
  txtPhone1.Text := formatPhoneString(txtPhone1.Text);
end;

procedure TfrmContact.txtPhone2Change(Sender: TObject);
begin
  txtPhone2.Text := formatPhoneString(txtPhone2.Text);
  txtPhone2.SelStart := Length(txtPhone2.Text);
end;

procedure TfrmContact.txtPhone2Exit(Sender: TObject);
begin
  txtPhone2.Text := formatPhoneString(txtPhone2.Text);
end;

procedure TbgContactOpener.freeStatement();
begin
  rsActive.Close;
  sleep(30);
  rsGroups.Close;
  sleep(30);
  conmgr.freeStatement(stmtGroups);
  conmgr.freeStatement(stmtActive);
end;

end.
