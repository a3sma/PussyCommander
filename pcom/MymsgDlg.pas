unit MymsgDlg;

interface

uses Vcl.Controls, Vcl.StdCtrls, dxGDIPlusClasses, System.Classes, Vcl.ExtCtrls, Vcl.Forms, System.SysUtils, WinApi.Windows;


type
  TfrmMyMsgDlg = class(TForm)
    imgQuestion: TImage;
    lblQuestion: TLabel;
    btnYes: TButton;
    btnCancel: TButton;
    cmbAnswer: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MakeInputBox;
    procedure Makeinform;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnYesClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cmbAnswerKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    answer : integer;
    needTextAnswer : boolean;
    textAnswer : string;
  end;

var
  frmMyMsgDlg: TfrmMyMsgDlg;

implementation

{$R *.dfm}

procedure TfrmMyMsgDlg.Makeinform;
begin
  BtnCancel.Visible := false;
  cmbAnswer.Visible := false;
  BtnYes.Left := 378;
end;

procedure TfrmMyMsgDlg.MakeInputBox;
begin
  cmbAnswer.Visible := true;
  cmbAnswer.Clear;
  needTextAnswer := true;
  self.Caption := 'Input';
end;

procedure TfrmMyMsgDlg.btnCancelClick(Sender: TObject);
begin
answer := mrCancel;
self.Close;
end;

procedure TfrmMyMsgDlg.btnYesClick(Sender: TObject);
begin
answer := mrOk;
if needTextAnswer then textAnswer := StringReplace(cmbAnswer.Text, chr(39), '',[rfReplaceAll, rfIgnoreCase]);

self.Close;
end;

procedure TfrmMyMsgDlg.cmbAnswerKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then self.BtnYesClick(self);
end;

procedure TfrmMyMsgDlg.FormCreate(Sender: TObject);
begin
answer := mrCancel;
needTextAnswer := false;
textAnswer := '';
end;

procedure TfrmMyMsgDlg.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key = #27 then self.BtnCancelClick(self);
end;

procedure TfrmMyMsgDlg.FormShow(Sender: TObject);
begin
  SetWindowLong(self.Handle, GWL_HWNDPARENT, GetDesktopWindow);
  SetWindowPos(self.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE   or SWP_NOSIZE);

  if needTextAnswer then cmbAnswer.SetFocus;
end;

end.
