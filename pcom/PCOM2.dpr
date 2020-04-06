program PCOM2;

uses
  Vcl.Forms,
  PCOMMain in 'PCOMMain.pas' {frmPCOM},
  pcomlib in 'pcomlib.pas',
  MymsgDlg in 'MymsgDlg.pas' {frmMyMsgDlg},
  formContact in 'formContact.pas' {frmContact},
  PussyConnectionManager in 'PussyConnectionManager.pas',
  formClient in 'formClient.pas' {frmClient},
  formDesktop in 'formDesktop.pas' {frmDesktop},
  formSettings in 'formSettings.pas' {frmSettings},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Smokey Quartz Kamri');
  Application.Title := 'PussyCommander2';
  Application.CreateForm(TfrmPCOM, frmPCOM);
  Application.CreateForm(TfrmMyMsgDlg, frmMyMsgDlg);
  Application.CreateForm(TfrmContact, frmContact);
  Application.CreateForm(TfrmClient, frmClient);
  Application.CreateForm(TfrmDesktop, frmDesktop);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;
end.
