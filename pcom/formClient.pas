unit formClient;

interface

uses Vcl.Grids, Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.Controls, Vcl.Menus, System.Classes, Vcl.ExtCtrls, ZDBCIntFS,
  Vcl.Forms, WinApi.Windows, System.SysUtils, WinApi.Messages;

type
  TfrmClient = class(TForm)
    pnTop: TPanel;
    pnClientsTop: TPanel;
    Panel2: TPanel;
    pnDesktopsTop: TPanel;
    pnTTAddDel: TPanel;
    ppmContacts: TPopupMenu;
    N1: TMenuItem;
    ppmDesktops: TPopupMenu;
    N2: TMenuItem;
    MenuItemAmmyAdmin: TMenuItem;
    MenuItemAnyDesk: TMenuItem;
    MenuItemDameWare: TMenuItem;
    MenuItemRDP: TMenuItem;
    MenuItemTeamViewer: TMenuItem;
    N3: TMenuItem;
    pnISDEL: TPanel;
    Label1: TLabel;
    sbtnRestore: TSpeedButton;
    sbtnDelete: TSpeedButton;
    lblClientName: TLabel;
    txtClientName: TEdit;
    btnSaveClient: TSpeedButton;
    pcMain: TPageControl;
    tabContacts: TTabSheet;
    tabDesktops: TTabSheet;
    tabComment: TTabSheet;
    mmComment: TMemo;
    sbtnAddTT: TSpeedButton;
    sbtnDeleteTT: TSpeedButton;
    txtSearchDesktops: TEdit;
    sbtnButtonX: TSpeedButton;
    lblShowArchive: TLabel;
    toggleConnectionsShowDeleted: TToggleSwitch;
    sbtnAddContact: TSpeedButton;
    sbtnDelContact: TSpeedButton;
    txtSearchContacts: TEdit;
    sbtnContactsSearchClear: TSpeedButton;
    Label2: TLabel;
    toggleContactsShowDeleted: TToggleSwitch;
    sgConnections: TStringGrid;
    sgContacts: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure MenuItemAmmyAdminClick(Sender: TObject);
    procedure MenuItemAnyDeskClick(Sender: TObject);
    procedure MenuItemDameWareClick(Sender: TObject);
    procedure MenuItemRDPClick(Sender: TObject);
    procedure MenuItemTeamViewerClick(Sender: TObject);
    procedure sbtnRestoreClick(Sender: TObject);
    procedure sbtnDeleteClick(Sender: TObject);
    procedure btnSaveClientClick(Sender: TObject);
    procedure sbtnAddTTClick(Sender: TObject);
    procedure sbtnDeleteTTClick(Sender: TObject);
    procedure txtSearchDesktopsChange(Sender: TObject);
    procedure sbtnButtonXClick(Sender: TObject);
    procedure toggleConnectionsShowDeletedClick(Sender: TObject);
    procedure sbtnAddContactClick(Sender: TObject);
    procedure sbtnDelContactClick(Sender: TObject);
    procedure txtSearchContactsChange(Sender: TObject);
    procedure sbtnContactsSearchClearClick(Sender: TObject);
    procedure toggleContactsShowDeletedClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure sgConnectionsDblClick(Sender: TObject);
    procedure sgConnectionsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sgConnectionsMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sgConnectionsMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure sgContactsDblClick(Sender: TObject);
    procedure sgContactsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sgContactsMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sgContactsMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
  cur_client_id : string;
  showcontactscounter, showdesktopscounter : integer;
    { Private declarations }

  procedure Clear();
  procedure bgOpen();
  procedure SaveClient();
  procedure DeleteContact(contact_id: string);
  procedure DeleteDesktop(desktop_id: string);
  procedure AddContact(FIO: string);
  procedure AddDesktop(name : string);
  procedure ClientMenuVisibilityAndCaptions();
  public
    { Public declarations }
  procedure OpenClient(client_id : string);
  procedure ShowContacts();
  procedure ShowDesktops();
  end;

  type
  TbgClientOpener = class(TThread)
  public
    client_id : string;
    stmtActive : IZStatement;
    rsActive   : IZResultSet;
    rsGroups   : IZResultSet;
    fForm      : TfrmClient;
  private
    { Private declarations }
  protected
    procedure Execute(); override;
    procedure Display();
    procedure FreeStatement();
  end;

type
  TbgShowContacts = class(TThread)
  public
    search     : string;
    client_id  : string;
    showDeleted : boolean;
    stmtActive : IZStatement;
    rsActive   : IZResultSet;
    fForm      : TfrmClient;
    showcontactscounter : integer;
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Display;
    procedure FreeStatement;
  end;

type
  TbgShowDesktops = class(TThread)
  public
    search     : string;
    client_id  : string;
    showDeleted : boolean;
    stmtActive : IZStatement;
    rsActive   : IZResultSet;
    fForm      : TfrmClient;
    showdesktopscounter : integer;
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Display;
    procedure FreeStatement;
  end;

var
  frmClient: TfrmClient;

implementation

{$R *.dfm}
uses pcomlib, PussyConnectionManager, formContact, formDesktop;

procedure TfrmClient.ShowContacts;
var
  myTh : TbgShowContacts;
  showArchive : boolean;
begin
  inc(showContactscounter, 1);

  if toggleContactsShowDeleted.State = tssOn then
    showArchive := true
  else
    showArchive := false;

  myTh := TbgShowContacts.Create(true);
  myTh.Priority := tpLower;
  myTh.fForm := self;
  myTh.showDeleted := showArchive;
  myTh.client_id := cur_client_id;
  myTh.showContactscounter := showContactscounter;
  myTh.search := Trim(AnsiLowerCase(txtSearchContacts.Text));
  myTh.Start;
end;

procedure TfrmClient.ShowDesktops;
var
  myTh : TbgShowDesktops;
  ShowArchive : boolean;
begin
  inc(showDesktopscounter, 1);

  if toggleConnectionsShowDeleted.State = tssOn then
    showArchive := true
  else
    showArchive := false;

  myTh := TbgShowDesktops.Create(true);
  myTh.Priority := tpLower;
  myTh.fForm := self;
  myTh.showDeleted := showArchive;
  myTh.client_id := cur_client_id;
  myTh.showDesktopscounter := showDesktopscounter;
  myTh.search := Trim(AnsiLowerCase(txtSearchDesktops.Text));
  myTh.Start;
end;

procedure TbgShowContacts.Execute;
var
  strQuar, strWhere : string;
  strShowDel : string;
begin

stmtactive := conmgr.getStatement;
try

if showDeleted then
  strShowDel := ''
else
  strShowDel := ' isdel = 0 and ';

strQuar := 'select id, gruppa, fio, tel1, tel2, email, tel1dob, tel2dob from contacts where ';

if length(search) = length(leaveditgits(search)) then
  strWhere := '( '+strShowDel+' client_id = '+client_id+' and ( tel1 CONTAINING '''+ formatPhoneString(search) + ''' or tel2 CONTAINING '''+ formatPhoneString(search) + ''') ) order by gruppa, fio;'
else
  strWhere := '( '+strShowDel+' client_id = '+client_id+' and ( (LOWER(gruppa) CONTAINING '''+ search + ''') or (LOWER(gruppa) CONTAINING '''+ StringKeyMapENRU(search) + ''') or (LOWER(fio) CONTAINING '''+search+''') or (LOWER(fio) CONTAINING '''+StringKeyMapENRU(search)+''') or ( lower(email) containing '''+search+''') or ( lower(email) containing '''+search+''') ) ) order by gruppa, fio;';

strQuar := strQuar + strWhere;

rsactive   := stmtactive.ExecuteQuery(strQuar);
Synchronize(Display);
finally
FreeStatement();
end;

end;

procedure TbgShowDesktops.Execute;
var
  strQuar, strWhere : string;
  strShowDel : string;
begin

if showDeleted then
  strShowDel := ''
  else
  strShowDel := ' and isdel = 0 ';

stmtactive := conmgr.getStatement;
try

strQuar := 'select * from desktops where client_id = ' + client_id + ' '+strShowDel+' and ';

if length(search) = length(leaveditgits(search)) then
  strWhere := '( tel1 CONTAINING '''+ formatPhoneString(search) + ''' or tel2 CONTAINING '''+ formatPhoneString(search) + ''' ) order by address, name, tel1, tel2;'
else
  strWhere := '( (LOWER(address) CONTAINING '''+ search + ''') or (LOWER(address) CONTAINING '''+ StringKeyMapENRU(search) + ''') or (LOWER(name) CONTAINING '''+search+''') or (LOWER(name) CONTAINING '''+StringKeyMapENRU(search)+''') ) order by address, name, tel1, tel2;';

strQuar := strQuar + strWhere;

rsactive   := stmtactive.ExecuteQuery(strQuar);

Synchronize(Display);
finally
FreeStatement();
end;

end;

procedure TbgShowDesktops.Display;
var
  i,j    : integer;
  phones : string;
  sg     : TStringGrid;
begin
if showdesktopscounter = fForm.showdesktopscounter then begin

 sg := fForm.sgConnections;

 ///////////////////////////////////////////////////////
 if sg.ColCount < 6 then  // Init first time
  begin
    sg.RowCount := 2;
    sg.ColCount := 4;
    sg.ColWidths[0] := -1;

    sg.Cells[0, 0] := 'DesktopID';
    sg.Cells[1, 0] := 'Desktop address / group';
    sg.Cells[2, 0] := 'Desktop name';
    sg.Cells[3, 0] := 'Phones';
  end;
//////////////////////////////////////////////////////////

  i := 0;
  while(rsactive.next()) do
    begin
      inc(i, 1);
      if i + 1 > sg.RowCount then sg.RowCount := i + 1;

      ///////////////////////////////////////////////////
      phones := '';

      if rsActive.GetStringByName('tel1dob') = '' then
        phones := rsActive.GetStringByName('tel1')
      else
        phones := rsActive.GetStringByName('tel1') + ' ext ' + rsActive.GetStringByName('tel1dob');

      if rsActive.GetStringByName('tel2dob') = '' then
      begin
        if rsActive.GetStringByName('tel2') <> '' then phones := phones + ', ' + rsActive.GetStringByName('tel2');
      end
      else
      begin
        if rsActive.GetStringByName('tel2') <> '' then phones := phones + ', ' + rsActive.GetStringByName('tel2') + ' ext ' + rsActive.GetStringByName('tel2dob');
      end;

      sg.Cells[0, i] := rsActive.GetStringByName('id');
      sg.Cells[1, i] := rsActive.GetStringByName('address');
      sg.Cells[2, i] := rsActive.GetStringByName('name');
      sg.Cells[3, i] := phones;
      ////////////////////////////////////////////////////

      end;

      if sg.RowCount >= i + 2 then
        begin
          sg.RowCount := i + 2;
          for j := 0 to sg.ColCount do sg.Cells[j, sg.RowCount - 1] := '';
          if sg.RowCount >= 3 then sg.RowCount := sg.RowCount - 1;

        end;

      sgApplyBestFit(sg);
end;

end;

procedure TbgShowContacts.Display;
var
  i,j : integer;
  sg  : TStringGrid;
begin

if showcontactscounter = fForm.showcontactscounter then begin

 sg := fForm.sgContacts;

 ///////////////////////////////////////////////////////
 if sg.ColCount < 6 then  // Init first time
  begin
    sg.RowCount := 2;
    sg.ColCount := 6;
    sg.ColWidths[0] := -1;

    sg.Cells[0, 0] := 'ContactID';
    sg.Cells[1, 0] := 'Group';
    sg.Cells[2, 0] := 'Name';
    sg.Cells[3, 0] := 'Phone 1';
    sg.Cells[4, 0] := 'Phone 2';
    sg.Cells[5, 0] := 'E-Mail';
  end;
//////////////////////////////////////////////////////////

  i := 0;
  while(rsactive.next()) do
    begin
      inc(i, 1);
      if i + 1 > sg.RowCount then sg.RowCount := i + 1;

      ///////////////////////////////////////////////////
      sg.Cells[0, i] := rsActive.GetString(1);
      sg.Cells[1, i] := rsActive.GetString(2);
      sg.Cells[2, i] := rsActive.GetString(3);

      if rsActive.GetString(7) = '' then
        sg.Cells[3, i] := rsActive.GetString(4)
      else
        sg.Cells[3, i] := rsActive.GetString(4) + ' ext ' + rsActive.GetString(7);

      if rsActive.GetString(8) = '' then
        sg.Cells[4, i] := rsActive.GetString(5)
      else
        sg.Cells[4, i] := rsActive.GetString(5) + ' ext ' + rsActive.GetString(8);

      sg.Cells[5, i] := rsActive.GetString(6);
      ////////////////////////////////////////////////////

      end;

      if sg.RowCount >= i + 2 then
        begin
          sg.RowCount := i + 2;
          for j := 0 to sg.ColCount do sg.Cells[j, sg.RowCount - 1] := '';
          if sg.RowCount >= 3 then sg.RowCount := sg.RowCount - 1;

        end;

      sgApplyBestFit(sg);
end;

end;

procedure TbgShowContacts.FreeStatement;
begin
rsactive.Close;
sleep(50);
conmgr.freeStatement(stmtActive);
end;

procedure TbgShowDesktops.FreeStatement;
begin
rsactive.Close;
sleep(50);
conmgr.freeStatement(stmtActive);
end;

procedure TfrmClient.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then Close();
end;

procedure TfrmClient.FormResize(Sender: TObject);
begin
  sgApplyBestFit(sgConnections);
  sgApplyBestFit(sgContacts);
end;

procedure TfrmClient.FormShow(Sender: TObject);
begin
  pcMain.ActivePageIndex := tabDesktops.PageIndex;
end;

procedure TfrmClient.MenuItemAmmyAdminClick(Sender: TObject);
begin
  handleMenuConnectionClick(TMenuItem(Sender).hint);
end;

procedure TfrmClient.MenuItemAnyDeskClick(Sender: TObject);
begin
  handleMenuConnectionClick(TMenuItem(Sender).hint);
end;

procedure TfrmClient.MenuItemDameWareClick(Sender: TObject);
begin
  handleMenuConnectionClick(TMenuItem(Sender).hint);
end;

procedure TfrmClient.MenuItemRDPClick(Sender: TObject);
begin
  handleMenuConnectionClick(TMenuItem(Sender).hint);
end;

procedure TfrmClient.MenuItemTeamViewerClick(Sender: TObject);
begin
  handleMenuConnectionClick(TMenuItem(Sender).hint);
end;

procedure TfrmClient.N1Click(Sender: TObject);
begin
  ShowContacts();
end;

procedure TfrmClient.N2Click(Sender: TObject);
begin
  ShowDesktops();
end;

procedure TbgClientOpener.Execute();
begin
  stmtActive := conmgr.getStatement;
  rsactive   := stmtactive.ExecuteQuery('select * from clients where ID = ' + client_id);
  Synchronize(Display);
  freeStatement();
end;

procedure TbgClientOpener.Display();
begin

while(rsactive.next()) do
  begin
  fForm.txtClientName.Text  := rsActive.GetStringByName('NAME');
  fForm.mmComment.Text      := rsActive.GetStringByName('COMMENT');

  if rsActive.GetStringByName('ISDEL') = '1' then
     fForm.pnISDEL.Visible := true
  else
     fForm.pnISDEL.Visible := false;
  end;

end;

procedure TbgClientOpener.freeStatement();
begin
  rsActive.Close;
  sleep(30);
  conmgr.freeStatement(stmtActive);
end;

procedure TfrmClient.OpenClient(client_id: string);
begin
  cur_client_id := client_id;
  Clear();
  bgOpen();
  ShowDesktops();
  ShowModal();
end;

procedure TfrmClient.pcMainChange(Sender: TObject);
begin
  if pcMain.ActivePage = tabContacts then showContacts();
  if pcMain.ActivePage = tabDesktops then ShowDesktops();
end;

procedure TfrmClient.Clear;
var
  j : integer;
begin
  txtClientName.Clear;
  mmComment.Clear;

  sgContacts.RowCount := 2;
  for j := 0 to sgContacts.ColCount do sgContacts.Cells[j, sgContacts.RowCount - 1] := '';

  sgConnections.RowCount := 2;
  for j := 0 to sgConnections.ColCount do sgConnections.Cells[j, sgConnections.RowCount - 1] := '';
end;

procedure TfrmClient.AddContact(FIO: string);
var
    stmtActive : IZStatement;
    rsActive   : IZResultSet;
    new_id     : string;
begin
  stmtActive := conmgr.getStatement;

  try
  rsactive   := stmtactive.ExecuteQuery('INSERT INTO CONTACTS (FIO,CLIENT_ID) VALUES ('''+FIO+''','+cur_client_id+') returning ID;');
  if rsActive.Next then
  begin
     new_id := rsActive.GetString(1);
  end;
  rsActive.Close;
  sleep(25);
  finally

  conmgr.freeStatement(stmtActive);
  end;

  if new_id <> '' then frmContact.Open(new_id);
  ShowContacts();
end;

procedure TfrmClient.AddDesktop(name: string);
var
    stmtActive : IZStatement;
    rsActive   : IZResultSet;
    new_id     : string;
begin
  stmtActive := conmgr.getStatement;

  try
  rsactive   := stmtactive.ExecuteQuery('INSERT INTO DESKTOPS (NAME,CLIENT_ID) VALUES ('''+name+''','+cur_client_id+') returning ID;');
  if rsActive.Next then
  begin
     new_id := rsActive.GetString(1);
  end;
  rsActive.Close;
  sleep(25);
  finally
  conmgr.freeStatement(stmtActive);
  end;

  if new_id <> '' then frmDesktop.OpenDesktop(new_id);
  ShowDesktops();
end;

procedure TfrmClient.DeleteContact(contact_id: string);
var
    stmtActive : IZStatement;
begin
  stmtActive := conmgr.getStatement;
  try
  stmtactive.ExecuteUpdate('update contacts set isdel = 1 where id = ' + contact_id);
  finally
  conmgr.freeStatement(stmtActive);
  end;

  ShowContacts();
end;

procedure TfrmClient.DeleteDesktop(desktop_id: string);
var
    stmtActive : IZStatement;
begin
  stmtActive := conmgr.getStatement;
  try
  stmtactive.ExecuteUpdate('update desktops set isdel = 1 where id = ' + desktop_id);
  finally
  conmgr.freeStatement(stmtActive);
  end;

  ShowDesktops();
end;

procedure TfrmClient.toggleConnectionsShowDeletedClick(Sender: TObject);
begin
  Self.ActiveControl := nil;
  ShowDesktops();
end;

procedure TfrmClient.toggleContactsShowDeletedClick(Sender: TObject);
begin
  Self.ActiveControl := nil;
  ShowContacts();
end;

procedure TfrmClient.txtSearchContactsChange(Sender: TObject);
begin
  ShowContacts();
end;

procedure TfrmClient.txtSearchDesktopsChange(Sender: TObject);
begin
  ShowDesktops();
end;

procedure TfrmClient.ClientMenuVisibilityAndCaptions;
begin
    if menu_aa_id  = '' then
      MenuItemAmmyAdmin.Visible := false
    else
    begin
      MenuItemAmmyAdmin.Visible := true;
      MenuItemAmmyAdmin.Caption := menu_aa_id;
    end;

    if menu_ad_id  = '' then
      MenuItemAnyDesk.Visible := false
    else
    begin
    MenuItemAnyDesk.Caption := menu_ad_id;
    MenuItemAnyDesk.Visible := true;
    end;

    if menu_dw_ip  = '' then
      MenuItemDameWare.Visible := false
    else
    begin
      MenuItemDameWare.Caption := menu_dw_ip;
      MenuItemDameWare.Visible := true;
    end;

    if menu_tw_id  = '' then
      MenuItemTeamViewer.Visible := false
    else
    begin
      MenuItemTeamViewer.Caption := menu_tw_id;
      MenuItemTeamViewer.Visible := true;
    end;

    if menu_rdp_ip = '' then
      MenuItemRDP.Visible := false
    else
    begin
      MenuItemRDP.Caption := menu_rdp_user + '@' + menu_rdp_ip;
      MenuItemRDP.Visible := true;
    end;

end;


procedure TfrmClient.bgOpen;
var
  myTh : TbgClientOpener;
begin
  myTh := TbgClientOpener.Create(true);
  myTh.Priority := tpLower;
  myTh.fForm := self;
  myTh.client_id := cur_client_id;
  myTh.Start;
end;

procedure TfrmClient.btnSaveClientClick(Sender: TObject);
begin
  SaveClient();
end;

procedure TfrmCLient.SaveClient();
var
  stmtActive : IZStatement;
  strUpdate  : string;
begin
  stmtActive := conmgr.getStatement;
  strUpdate  := 'update clients set NAME = '''+txtClientName.Text+''', Comment = '''+mmComment.Text+''' where id = ' + cur_client_id;
  stmtActive.ExecuteUpdate(strUpdate);
  conmgr.freeStatement(stmtActive);
end;

procedure TfrmClient.sbtnAddContactClick(Sender: TObject);
var
  strNewName : string;
begin

strNewName := mqInp('New name: ', nil);

if strNewName <> '' then
  begin
    AddContact(strNewName);
  end;
end;

procedure TfrmClient.sbtnAddTTClick(Sender: TObject);
var
  strNewName : string;
begin

strNewName := mqInp('New connection name: ', nil);

if strNewName <> '' then
  begin
    AddDesktop(strNewName);
  end;
end;

procedure TfrmClient.sbtnButtonXClick(Sender: TObject);
begin
  txtSearchDesktops.Text := '';
end;

procedure TfrmClient.sbtnContactsSearchClearClick(Sender: TObject);
begin
  txtSearchContacts.Clear;
end;

procedure TfrmClient.sbtnDelContactClick(Sender: TObject);
var contact_id, contact_name : string;
    answer : integer;
begin
   if ( (sgContacts.Row >= 1) and (sgContacts.Cells[0, sgContacts.Row] <> '')) then
   begin
     contact_id   := sgContacts.Cells[0, sgContacts.Row];
     contact_name := sgContacts.Cells[2, sgContacts.Row];

     answer := mqDlg('Send ' + contact_name + ' to archive?');
     if answer = mrOk then
      begin
         DeleteContact(contact_id);
      end;
   end;

end;

procedure TfrmClient.sbtnDeleteClick(Sender: TObject);
var
  stmtActive : IZStatement;
begin
  if mqDlg('Delete?') = mrOK then
  begin
    stmtActive := conmgr.getStatement;
    stmtActive.ExecuteUpdate('delete from clients where id = ' + cur_client_id );
    conmgr.freeStatement(stmtActive);
    self.Close;
  end;
end;

procedure TfrmClient.sbtnDeleteTTClick(Sender: TObject);
var desktop_name, desktop_id : string;
    answer : integer;
begin
   if ( (sgConnections.Row >= 1) and (sgConnections.Cells[0, sgConnections.Row] <> '')) then
   begin
     desktop_id   := sgConnections.Cells[0, sgConnections.Row];
     desktop_name := sgConnections.Cells[2, sgConnections.Row];

     answer := mqDlg('Send ' + desktop_name + ' to archive?');
     if answer = mrOk then
      begin
         DeleteDesktop(desktop_id);
      end;
   end;

end;

procedure TfrmClient.sbtnRestoreClick(Sender: TObject);
var
  stmtActive : IZStatement;
begin
  stmtActive := conmgr.getStatement;
  stmtActive.ExecuteUpdate('update clients set isdel = 0 where id = ' + cur_client_id );
  conmgr.freeStatement(stmtActive);
  pnISDEL.Hide;
end;

procedure TfrmClient.sgConnectionsDblClick(Sender: TObject);
var desk_id : string;
begin
   if sgConnections.Row >= 1 then
   begin
     desk_id  := sgConnections.Cells[0, sgConnections.Row];
     if desk_id <> '' then
     begin
       frmDesktop.OpenDesktop(desk_id);
       ShowDesktops();
     end;
   end;
end;

procedure TfrmClient.sgConnectionsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  cp : TPoint;
  desktop_id : string;
  Col, Row   : integer;
begin
if button = mbRight then
  begin
    sgConnections.MouseToCell(X, Y, Col, Row);
    sgConnections.Row := Row;
    begin
     if Row >= 1 then
     begin
       GetCursorPos(cp);
       desktop_id  := sgConnections.Cells[0, Row];
       LoadDesktopDataForMenu(desktop_id);
       ClientMenuVisibilityAndCaptions();
       ppmDesktops.Popup(cp.X, cp.Y);
     end;
    end;
  end;
end;

procedure TfrmClient.sgConnectionsMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  sgConnections.Perform(WM_VSCROLL, 1, 0);
  sgConnections.Perform(WM_VSCROLL, 1, 0);
  Handled := True;
end;

procedure TfrmClient.sgConnectionsMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  sgConnections.Perform(WM_VSCROLL, 0, 0);
  sgConnections.Perform(WM_VSCROLL, 0, 0);
  Handled := True;
end;

procedure TfrmClient.sgContactsDblClick(Sender: TObject);
var c_id : string;
begin
   if sgContacts.Row >= 1 then
   begin
     c_id  := sgContacts.Cells[0, sgContacts.Row];
     if c_id <> '' then
     begin
       frmContact.Open(c_id);
       ShowContacts();
     end;
   end;
end;

procedure TfrmClient.sgContactsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  cp : TPoint;
  desktop_id : string;
  Col, Row   : integer;
begin
if button = mbRight then
  begin
    sgContacts.MouseToCell(X, Y, Col, Row);
    sgContacts.Row := Row;
    begin
     if Row >= 1 then
     begin
       GetCursorPos(cp);
       ppmContacts.Popup(cp.X, cp.Y);
     end;
    end;
  end;
end;

procedure TfrmClient.sgContactsMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  sgContacts.Perform(WM_VSCROLL, 1, 0);
  sgContacts.Perform(WM_VSCROLL, 1, 0);
  Handled := True;
end;

procedure TfrmClient.sgContactsMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  sgContacts.Perform(WM_VSCROLL, 0, 0);
  sgContacts.Perform(WM_VSCROLL, 0, 0);
  Handled := True;
end;

end.


