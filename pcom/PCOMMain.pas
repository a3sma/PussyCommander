unit PCOMMain;

interface

uses Vcl.Grids, Vcl.ComCtrls, Vcl.Buttons, Vcl.StdCtrls, Vcl.Controls,
  Vcl.WinXCtrls, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, ZAbstractConnection,
  ZConnection, System.Classes, Vcl.Forms, ZDbcIntFs, WinApi.Windows, System.SysUtils, WinApi.Messages, System.Win.Registry;

type
  TfrmPCOM = class(TForm)
    pnTop: TPanel;
    ZConnection: TZConnection;
    TrayIcon1: TTrayIcon;
    ppmTray: TPopupMenu;
    N1: TMenuItem;
    ppmConnections: TPopupMenu;
    pnTTAddDel: TPanel;
    N4: TMenuItem;
    N5: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    ppmContacts: TPopupMenu;
    N6: TMenuItem;
    ppmTopPanel: TPopupMenu;
    Panel4: TPanel;
    Panel5: TPanel;
    SaveDialog1: TSaveDialog;
    ppmClients: TPopupMenu;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    MenuItemAmmyAdmin: TMenuItem;
    MenuItemAnyDesk: TMenuItem;
    MenuItemDameWare: TMenuItem;
    MenuItemRDP: TMenuItem;
    MenuItemTeamViewer: TMenuItem;
    toggleConnectionsShowDeleted: TToggleSwitch;
    lblShowArchive: TLabel;
    txtSearchConnection: TEdit;
    sbtnButtonX: TSpeedButton;
    sbtnAddTT: TSpeedButton;
    sbtnDeleteTT: TSpeedButton;
    pcMain: TPageControl;
    tabConnections: TTabSheet;
    tabContacts: TTabSheet;
    tabClients: TTabSheet;
    Settings1: TMenuItem;
    N2: TMenuItem;
    sbtnAddContact: TSpeedButton;
    sbtnDelContact: TSpeedButton;
    txtSearchContacts: TEdit;
    sbtnContactsSearchClear: TSpeedButton;
    Label1: TLabel;
    toggleContactsShowDeleted: TToggleSwitch;
    sbtnAddClient: TSpeedButton;
    sbtnDelClient: TSpeedButton;
    txtSearchClients: TEdit;
    sbtnClientsSearchClear: TSpeedButton;
    Label2: TLabel;
    toggleClientsShowDeleted: TToggleSwitch;
    sgConnections: TStringGrid;
    sgContacts: TStringGrid;
    sgClients: TStringGrid;
    procedure ShowConnections();
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure ShowContacts();
    procedure N6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure MenuItemTeamViewerClick(Sender: TObject);
    procedure MenuItemAmmyAdminClick(Sender: TObject);
    procedure MenuItemAnyDeskClick(Sender: TObject);
    procedure MenuItemDameWareClick(Sender: TObject);
    procedure MenuItemRDPClick(Sender: TObject);
    procedure toggleConnectionsShowDeletedClick(Sender: TObject);
    procedure txtSearchConnectionChange(Sender: TObject);
    procedure sbtnButtonXClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure pcMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Settings1Click(Sender: TObject);
    procedure sbtnAddContactClick(Sender: TObject);
    procedure sbtnDelContactClick(Sender: TObject);
    procedure txtSearchContactsChange(Sender: TObject);
    procedure sbtnContactsSearchClearClick(Sender: TObject);
    procedure toggleContactsShowDeletedClick(Sender: TObject);
    procedure sbtnAddClientClick(Sender: TObject);
    procedure sbtnDelClientClick(Sender: TObject);
    procedure txtSearchClientsChange(Sender: TObject);
    procedure sbtnClientsSearchClearClick(Sender: TObject);
    procedure toggleClientsShowDeletedClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure sgConnectionsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sgConnectionsDblClick(Sender: TObject);
    procedure sgConnectionsMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sgConnectionsMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sgContactsDblClick(Sender: TObject);
    procedure sgContactsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sgContactsMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sgContactsMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sbtnDeleteTTClick(Sender: TObject);
    procedure sbtnAddTTClick(Sender: TObject);
    procedure sgClientsMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sgClientsMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sgClientsDblClick(Sender: TObject);
    procedure sgClientsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FirstTimeShow : boolean;
    { Private declarations }

    procedure AddDesktop( DesktopName, client_id : string );
    procedure AddClient(client_name : string);
    procedure DeleteDesktop( desk_id : string );
    procedure DeleteContact(contact_id: string);
    procedure DeleteClient(client_id: string);
    procedure AddContact(FIO, client_id : string);
    procedure ShowClients();
    procedure ClientMenuVisibilityAndCaptions();
  public
    showdesktopscounter       : integer;
    showcontactsCounter : integer;
    showclientscounter  : integer;
    { Public declarations }

  end;

type
  TbgShowConnections = class(TThread)
  public
    search      : string;
    stmtActive  : IZStatement;
    rsActive    : IZResultSet;
    fForm       : TfrmPCOM;
    showDeleted : boolean;
    showdesktopscounter : integer;
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Display;
    procedure FreeStatement;
  end;

type
  TbgShowContacts = class(TThread)
  public
    search     : string;
    stmtActive : IZStatement;
    rsActive   : IZResultSet;
    showDeleted : boolean;
    fForm      : TfrmPCOM;
    showcontactscounter : integer;
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Display;
    procedure FreeStatement;
  end;

type
  TbgShowClients = class(TThread)
  public
    search     : string;
    stmtActive : IZStatement;
    rsActive   : IZResultSet;
    showDeleted : boolean;
    fForm      : TfrmPCOM;
    showclientscounter : integer;
  private
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Display;
    procedure FreeStatement;
  end;

var
  frmPCOM: TfrmPCOM;

implementation

{$R *.dfm}

uses formContact, PussyConnectionManager, formClient, formDesktop, formSettings, pcomlib;

procedure TfrmPCOM.Settings1Click(Sender: TObject);
begin
  frmSettings.Show;
end;

procedure TfrmPCOM.sgClientsDblClick(Sender: TObject);
var
  client_id : string;
begin
if sgClients.Row >= 1 then
   begin
     client_id  := sgClients.Cells[0, sgClients.Row];
     frmClient.OpenClient(client_id);
     ShowClients();
   end;
end;

procedure TfrmPCOM.sgClientsMouseDown(Sender: TObject; Button: TMouseButton;
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
       ppmClients.Popup(cp.X, cp.Y);
     end;
    end;
  end;
end;

procedure TfrmPCOM.sgClientsMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  sgClients.Perform(WM_VSCROLL, 1, 0);
  sgClients.Perform(WM_VSCROLL, 1, 0);
  Handled := True;
end;

procedure TfrmPCOM.sgClientsMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  sgClients.Perform(WM_VSCROLL, 0, 0);
  sgClients.Perform(WM_VSCROLL, 0, 0);
  Handled := True;
end;

procedure TfrmPCOM.sgConnectionsDblClick(Sender: TObject);
var desk_id : string;
begin
   if sgConnections.Row >= 1 then
   begin
     desk_id  := sgConnections.Cells[0, sgConnections.Row];
     if desk_id <> '' then
     begin
       frmDesktop.OpenDesktop(desk_id);
       ShowConnections();
     end;
   end;
end;

procedure TfrmPCOM.sgConnectionsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
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
       ppmConnections.Popup(cp.X, cp.Y);
     end;
    end;
  end;
end;

procedure TfrmPCOM.sgConnectionsMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  sgConnections.Perform(WM_VSCROLL, 1, 0);
  sgConnections.Perform(WM_VSCROLL, 1, 0);
  Handled := True;
end;

procedure TfrmPCOM.sgConnectionsMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  sgConnections.Perform(WM_VSCROLL, 0, 0);
  sgConnections.Perform(WM_VSCROLL, 0, 0);
  Handled := True;
end;

procedure TfrmPCOM.sgContactsDblClick(Sender: TObject);
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

procedure TfrmPCOM.sgContactsMouseDown(Sender: TObject; Button: TMouseButton;
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

procedure TfrmPCOM.sgContactsMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  sgContacts.Perform(WM_VSCROLL, 1, 0);
  sgContacts.Perform(WM_VSCROLL, 1, 0);
  Handled := True;
end;

procedure TfrmPCOM.sgContactsMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  sgContacts.Perform(WM_VSCROLL, 0, 0);
  sgContacts.Perform(WM_VSCROLL, 0, 0);
  Handled := True;
end;

procedure TfrmPCOM.ShowClients;
var
  myTh : TbgShowClients;
  showArchive : boolean;
begin
  inc(showclientscounter, 1);

  if toggleClientsShowDeleted.State = tssOn then
    showArchive := true
    else
    showArchive := false;

  myTh := TbgShowClients.Create(true);
  myTh.Priority := tpLower;
  myTh.fForm := self;
  myTh.showDeleted := showArchive;
  myTh.showclientscounter := showclientscounter;
  myTh.search := Trim(AnsiLowerCase(txtSearchClients.Text));
  myTh.Start;
end;

procedure TfrmPcom.AddClient(client_name : string);
var
    pstmt      : IZPreparedStatement;
    rsActive   : IZResultSet;
    new_id     : string;
begin
  pstmt := conmgr.prepareStatement('INSERT INTO CLIENTS (NAME) VALUES (?) returning ID;');
  try
  pstmt.SetString(1, client_name);
  rsactive := pstmt.ExecuteQueryPrepared;
  if rsActive.Next then
  begin
     new_id := rsActive.GetString(1);
  end;
  rsActive.Close;
  sleep(25);
  finally
  conmgr.freePreparedStatement(pstmt);
  end;

  if new_id <> '' then frmClient.OpenClient(new_id);
  ShowClients();
end;

procedure TfrmPCOM.AddDesktop(DesktopName, client_id : string);
var
    pstmt      : IZPreparedStatement;
    rsActive   : IZResultSet;
    new_id     : string;
begin
  pstmt := conmgr.prepareStatement('INSERT INTO DESKTOPS (NAME, CLIENT_ID) VALUES (?, ?) returning ID;');

  try
  pstmt.SetString(1, DesktopName);
  pstmt.SetString(2, client_id);
  rsactive   := pstmt.ExecuteQueryPrepared;
  if rsActive.Next then
  begin
     new_id := rsActive.GetString(1);
  end;
  rsActive.Close;
  sleep(25);
  finally
  conmgr.freePreparedStatement(pstmt);
  end;

  if new_id <> '' then frmDesktop.OpenDesktop(new_id);
  ShowConnections();
end;

procedure TfrmPCOM.Button1Click(Sender: TObject);
begin
  conmgr.test;
end;

procedure TfrmPCOM.AddContact(FIO, client_id : string);
var
    pstmt      : IZPreparedStatement;
    rsActive   : IZResultSet;
    new_id     : string;
begin
  pstmt := conmgr.prepareStatement('INSERT INTO CONTACTS (FIO, CLIENT_ID) VALUES (?, ?) returning ID;');

  try
  pstmt.SetString(1, FIO);
  pstmt.SetString(2, client_id);
  rsactive   := pstmt.ExecuteQueryPrepared;
  if rsActive.Next then
  begin
     new_id := rsActive.GetString(1);
  end;
  rsActive.Close;
  sleep(25);
  finally

  conmgr.freePreparedStatement(pstmt);
  end;

  if new_id <> '' then frmContact.Open(new_id);
  ShowContacts();
end;

procedure TfrmPCOM.DeleteDesktop(desk_id: string);
var
   stmtActive : IZStatement;
begin

  stmtActive := conmgr.getStatement;
  try
    stmtactive.ExecuteUpdate('update desktops set isdel = 1 where id = ' + desk_id);
  finally
    conmgr.freeStatement(stmtActive);
  end;
  ShowConnections();

end;

procedure TfrmPCOM.txtSearchClientsChange(Sender: TObject);
begin
  ShowClients();
end;

procedure TfrmPCOM.DeleteClient(client_id : string);
var
    stmtActive : IZStatement;
begin
  stmtActive := conmgr.getStatement;
  try
  stmtactive.ExecuteUpdate('update clients set isdel = 1 where id = ' + client_id);
  finally
  conmgr.freeStatement(stmtActive);
  end;

  ShowClients();
end;

procedure TfrmPCOM.DeleteContact(contact_id: string);
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

procedure TfrmPCOM.ClientMenuVisibilityAndCaptions();
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

procedure TfrmPCOM.FormCreate(Sender: TObject);
begin
  FirstTimeShow := true;
end;

procedure TfrmPCOM.FormResize(Sender: TObject);
begin
   sgApplyBestFit(sgConnections);
   sgApplyBestFit(sgContacts);
   sgApplyBestFit(sgClients);
end;

procedure TfrmPCOM.FormShow(Sender: TObject);
begin
  if FirstTimeShow then
  begin

    FirstTimeShow := false;
    pcMain.ActivePage := tabConnections;
    frmSettings.LoadExeSettings;
    InitConnectionManager();

    ForceDirectories(ExtractFilePath(Application.Exename)+'\AnyDeskScripts\');
    ForceDirectories(ExtractFilePath(Application.Exename)+'\RemoteApps\');
   end;

  ShowConnections();
  txtSearchConnection.SetFocus;
end;

procedure TfrmPCOM.MenuItemAmmyAdminClick(Sender: TObject);
begin
  handleMenuConnectionClick(TMenuItem(Sender).hint);
end;

procedure TfrmPCOM.MenuItemAnyDeskClick(Sender: TObject);
begin
  handleMenuConnectionClick(TMenuItem(Sender).hint);
end;

procedure TfrmPCOM.MenuItemDameWareClick(Sender: TObject);
begin
  handleMenuConnectionClick(TMenuItem(Sender).hint);
end;

procedure TfrmPCOM.MenuItemRDPClick(Sender: TObject);
begin
  handleMenuConnectionClick(TMenuItem(Sender).hint);
end;

procedure TfrmPCOM.MenuItemTeamViewerClick(Sender: TObject);
begin
  handleMenuConnectionClick(TMenuItem(Sender).hint);
end;

procedure TfrmPCOM.ShowConnections();
var
  myTh        : TbgShowConnections;
  showArchive : boolean;
begin
  inc(showdesktopscounter, 1);

  if toggleConnectionsShowDeleted.State = tssOn then
    showArchive := true
    else
    showArchive := false;

  myTh := TbgShowConnections.Create(true);
  myTh.Priority := tpLower;
  myTh.fForm := self;
  myTh.showDeleted := showArchive;
  myTh.showdesktopscounter := showdesktopscounter;
  myTh.search := Trim(AnsiLowerCase(txtSearchConnection.Text));
  myTh.Start;
end;

procedure TfrmPCOM.ShowContacts();
var
  myTh : TbgShowContacts;
  ShowArchive : boolean;
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
  myTh.showContactscounter := showContactscounter;
  myTh.search := Trim(AnsiLowerCase(txtSearchContacts.Text));
  myTh.Start;
end;

procedure TfrmPCOM.sbtnAddClientClick(Sender: TObject);
var
  strNewName : string;
begin

   strNewName := mqInp('New client name', nil);
    if strNewName <> '' then
      begin
      AddClient(strNewName);
      end;
end;

procedure TfrmPCOM.sbtnAddContactClick(Sender: TObject);
var
  strNewName : string;
  client_id  : string;
  client_name : string;
begin
   if ( (sgContacts.Row >= 1) and (sgContacts.Cells[1, sgContacts.Row] <> '')) then
   begin
     client_id   := sgContacts.Cells[1, sgContacts.Row];
     client_name := sgContacts.Cells[2, sgContacts.Row];
     strNewName  := mqInp('New full name for ' + client_name, nil);

     if strNewName <> '' then
        begin
        AddContact(strNewName, client_id);
        end;
   end;
end;

procedure TfrmPCOM.sbtnAddTTClick(Sender: TObject);
var
  strNewName  : string;
  client_id   : string;
  client_name : string;
begin
  if ( (sgConnections.Row >= 1) and (sgConnections.Cells[1, sgConnections.Row] <> '')) then
  begin
     client_id   := sgConnections.Cells[1, sgConnections.Row];
     client_name := sgConnections.Cells[2, sgConnections.Row];
     strNewName := mqInp('New desktop connection name for ' + client_name, nil);

     if strNewName <> '' then
     begin
        AddDesktop(strNewName, client_id);
     end;
  end;
end;

procedure TfrmPCOM.toggleClientsShowDeletedClick(Sender: TObject);
begin
  Self.ActiveControl := nil;
  ShowClients();
end;

procedure TfrmPCOM.toggleConnectionsShowDeletedClick(Sender: TObject);
begin
  Self.ActiveControl := nil;
  showConnections;
end;

procedure TfrmPCOM.toggleContactsShowDeletedClick(Sender: TObject);
begin
  Self.ActiveControl := nil;
  ShowContacts;
end;

procedure TfrmPCOM.TrayIcon1Click(Sender: TObject);
begin
  Application.Restore;
  Application.BringToFront;
end;

procedure TfrmPCOM.TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var cp: TPoint;
begin
if button = mbRight then
  begin
    GetCursorPos(cp);
    ppmTray.Popup(cp.X, cp.Y);
  end;
end;

procedure TfrmPCOM.txtSearchContactsChange(Sender: TObject);
begin
  ShowContacts();
end;

procedure TfrmPCOM.txtSearchConnectionChange(Sender: TObject);
begin
  ShowConnections();
end;

procedure TbgShowConnections.Execute;
var
  strQuar, strWhere : string;
  strShowDel : string;
begin
  search := StringReplace(search, #39, '', [rfReplaceAll]);

  if showDeleted then
    strShowDel := ''
    else
    strShowDel := 'clients.isdel = 0 and desktops.isdel = 0 and ';

  stmtactive := conmgr.getStatement;
  try
                  //     1              2             3             4             5                   6               7              8             9
  strQuar := 'select clients.id, clients.name, desktops.id, desktops.name, desktops.tel1, desktops.tel1dob, desktops.tel2, desktops.tel2dob, desktops.address '+' from desktops inner join clients on clients.id = desktops.CLIENT_ID where ' + strShowDel;

  if length(search) = length(leaveditgits(search)) then
    strWhere := '( desktops.tel1 CONTAINING '''+ formatPhoneString(search) + ''' or desktops.tel2 CONTAINING '''+ formatPhoneString(search) + ''' ) order by clients.name, desktops.address, desktops.tel1, desktops.tel2'
  else
    strWhere := '( (LOWER(desktops.address) CONTAINING '''+ search + ''') or (LOWER(desktops.address) CONTAINING '''+ StringKeyMapENRU(search) + ''') or (LOWER(desktops.name) CONTAINING '''+search+''') or (LOWER(desktops.name) CONTAINING '''+StringKeyMapENRU(search)+''') or (LOWER(clients.name) CONTAINING '''+search+''') or (LOWER(clients.name) CONTAINING '''+StringKeyMapENRU(search)+''') ) order by clients.name, desktops.address, desktops.tel1, desktops.tel2';

  strQuar := strQuar + strWhere;

  rsactive   := stmtactive.ExecuteQuery(strQuar);

  Synchronize(Display);
  finally
  FreeStatement();
  end;
end;

procedure TbgShowClients.Execute;
var
 strShowDel : string;
begin
  search := StringReplace(search, #39, '', [rfReplaceAll]);

  if showDeleted then
    strShowDel := '1, 0' // show isdel = 1 or isdel = 0 -> all clients
  else
    strShowDel := '0, 0'; // show isdel = 0 or isdel = 0 -> only isdel = 0 -> only active clients

  stmtactive := conmgr.getStatement;
  try
    rsactive   := stmtactive.ExecuteQuery('select * from get_clients_info('''+search+''','''+StringKeyMapENRU(search)+''', '+strShowDel+') order by name');
    Synchronize(Display);
  finally
    FreeStatement();
  end;
end;

procedure TbgShowClients.FreeStatement;
begin
  rsactive.Close;
  sleep(50);
  conmgr.freeStatement(stmtActive);
end;

procedure TbgShowConnections.FreeStatement;
begin
  rsactive.Close;
  sleep(50);
  conmgr.freeStatement(stmtActive);
end;

procedure TbgShowContacts.Execute;
var strQuar, strWhere : string;
    strShowDel : string;
begin
  search := StringReplace(search, #39, '', [rfReplaceAll]);

  if showdeleted then
    strShowDel := ''
    else
    strShowDel := 'clients.isdel = 0 and contacts.isdel = 0 and';

  stmtactive := conmgr.getStatement;
  try
  strQuar := 'select contacts.id, contacts.gruppa, contacts.fio, contacts.tel1, contacts.tel2, contacts.email, clients.NAME, clients.id, contacts.tel1dob, contacts.tel2dob from contacts inner join clients on contacts.client_id = clients.id where ';
  if Length(search) = Length(LeaveDitgits(search)) then // if only ditgits then searching in phones
     strWhere := ' ( '+strShowDel+' ( ( contacts.tel1 CONTAINING '''+ formatPhoneString(search) + ''') or ( contacts.tel2 CONTAINING '''+ formatPhoneString(search) + ''' ) ) ) order by clients.name, gruppa, fio;'
  else
     strWhere := ' ( '+strShowDel+' ( ( (LOWER(gruppa) CONTAINING '''+ search + ''') or (LOWER(gruppa) CONTAINING '''+ StringKeyMapENRU(search) + ''') or (LOWER(fio) CONTAINING '''+search+''') or (LOWER(fio) CONTAINING '''+StringKeyMapENRU(search)+''') or ( lower(email) containing '''+search+''') or ( lower(email) containing '''+search+''') or ( lower(clients.name) containing '''+search+''') or ( lower(clients.name) containing '''+StringKeyMapENRU(search)+''') ) ) ) order by clients.name, gruppa, fio;';

  strQuar := strQuar + strWhere;
  rsactive   := stmtactive.ExecuteQuery(strQuar);
  Synchronize(Display);
  finally
  FreeStatement();
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
      sg.ColCount := 8;
      sg.ColWidths[0] := -1;
      sg.ColWidths[1] := -1;

      sg.Cells[0, 0] := 'ContactID';
      sg.Cells[1, 0] := 'ClientID';
      sg.Cells[2, 0] := 'Client';
      sg.Cells[3, 0] := 'Group';
      sg.Cells[4, 0] := 'Name';
      sg.Cells[5, 0] := 'Phone 1';
      sg.Cells[6, 0] := 'Phone 2';
      sg.Cells[7, 0] := 'E-Mail';
    end;
  //////////////////////////////////////////////////////////
    i := 0;
    while(rsactive.next()) do
      begin
        inc(i, 1);
        if i + 1 > sg.RowCount then sg.RowCount := i + 1;

        ///////////////////////////////////////////////////
        sg.Cells[0, i] := rsActive.GetString(1);
        sg.Cells[1, i] := rsActive.GetString(8);
        sg.Cells[2, i] := rsActive.GetString(7);
        sg.Cells[3, i] := rsActive.GetString(2);
        sg.Cells[4, i] := rsActive.GetString(3);

        if rsActive.GetString(9) = '' then
          sg.Cells[5, i] := rsActive.GetString(4)
        else
          sg.Cells[5, i] := rsActive.GetString(4) + ' ext ' + rsActive.GetString(9);

        if rsActive.GetString(10) = '' then
          sg.Cells[6, i] := rsActive.GetString(5)
        else
          sg.Cells[6, i] := rsActive.GetString(5) + ' ext ' + rsActive.GetString(10);

        sg.Cells[7, i] := rsActive.GetString(6);
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


procedure TbgShowClients.Display;
var
  i, j : integer;
  sg   : TStringGrid;
begin
if showclientscounter = fForm.showclientscounter then begin

  sg := fForm.sgClients;
////////////////////////////////////////////////////////////
  if sg.ColCount < 4 then  // Init first time
  begin
    sg.RowCount := 2;
    sg.ColCount := 4;
    sg.ColWidths[0] := -1;

    sg.Cells[0, 0] := 'ClientID';
    sg.Cells[1, 0] := 'Client name';
    sg.Cells[2, 0] := 'Desktops count';
    sg.Cells[3, 0] := 'Contacts count';
  end;
////////////////////////////////////////////////////////////

  i := 0;
  while(rsactive.next()) do
    begin
      inc(i, 1);
      if i + 1 > sg.RowCount then sg.RowCount := i + 1;

      ///////////////////////////////////////////////////

      sg.Cells[0, i] := rsActive.GetString(1);
      sg.Cells[1, i] := rsActive.GetString(2);
      sg.Cells[2, i] := rsActive.GetString(3);
      sg.Cells[3, i] := rsActive.GetString(4);
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

procedure TbgShowConnections.Display;
var
  i,j : integer;
  phones  : string;
  sg : TStringGrid;
begin
if showdesktopscounter = fForm.showdesktopscounter then begin

  sg := fForm.sgConnections;
////////////////////////////////////////////////////////////
  if sg.ColCount < 6 then  // Init first time
  begin
    sg.RowCount := 2;
    sg.ColCount := 6;
    sg.ColWidths[0] := -1;
    sg.ColWidths[1] := -1;

    sg.Cells[0, 0] := 'DesktopID';
    sg.Cells[1, 0] := 'ClientID';
    sg.Cells[2, 0] := 'Client';
    sg.Cells[3, 0] := 'Desktop address / group';
    sg.Cells[4, 0] := 'Desktop name';
    sg.Cells[5, 0] := 'Phones';
  end;
////////////////////////////////////////////////////////////

  i := 0;
  while(rsactive.next()) do
    begin
      inc(i, 1);
      if i + 1 > sg.RowCount then sg.RowCount := i + 1;

      ///////////////////////////////////////////////////
      phones := '';
      if rsActive.GetString(6) = '' then
        phones := rsActive.GetString(5)
      else
        phones := rsActive.GetString(5) + ' доб. ' + rsActive.GetString(6);

      if rsActive.GetString(8) = '' then
      begin
        if rsActive.GetString(7) <> '' then phones := phones + ', ' + rsActive.GetString(7);
      end
      else
      begin
        if rsActive.GetString(7) <> '' then phones := phones + ', ' + rsActive.GetString(7) + ' доб. ' + rsActive.GetString(8);
      end;

      sg.Cells[0, i] := rsActive.GetString(3);
      sg.Cells[1, i] := rsActive.GetString(1);
      sg.Cells[2, i] := rsActive.GetString(2);
      sg.Cells[3, i] := rsActive.GetString(9);
      sg.Cells[4, i] := rsActive.GetString(4);
      sg.Cells[5, i] := phones;
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

procedure TfrmPCOM.N10Click(Sender: TObject);
var client_id : string;
begin
   if sgConnections.Row >= 1 then
   begin
     client_id  := sgConnections.Cells[1, sgConnections.Row];
     frmClient.OpenClient(client_id);
     ShowConnections();
   end;
end;

procedure TfrmPCOM.N1Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TfrmPCOM.N5Click(Sender: TObject);
begin
ShowConnections();
end;

procedure TfrmPCOM.N6Click(Sender: TObject);
begin
ShowContacts();
end;

procedure TfrmPCOM.N7Click(Sender: TObject);
begin
ShowClients();
end;

procedure TfrmPCOM.N8Click(Sender: TObject);
begin
  frmSettings.Show;
end;

procedure TfrmPCOM.N9Click(Sender: TObject);
var client_id : string;
begin
   if sgContacts.Row >= 1 then
   begin
     client_id  := sgContacts.Cells[1, sgContacts.Row];
     frmClient.OpenClient(client_id);
     ShowContacts();
   end;
end;

procedure TfrmPCOM.pcMainChange(Sender: TObject);
begin
  if pcMain.ActivePage = tabContacts then showContacts();
  if pcMain.ActivePage = tabConnections then ShowConnections();
  if pcMain.ActivePage = tabClients then ShowClients();
end;

procedure TfrmPCOM.pcMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var cp : TPoint;
begin
  if button = mbRight then
    begin
      GetCursorPos(cp);
      ppmTopPanel.Popup(cp.X, cp.Y);
    end;
end;

procedure TfrmPCOM.sbtnButtonXClick(Sender: TObject);
begin
  txtSearchConnection.Clear();
end;

procedure TfrmPCOM.sbtnClientsSearchClearClick(Sender: TObject);
begin
  txtSearchClients.Clear;
end;

procedure TfrmPCOM.sbtnContactsSearchClearClick(Sender: TObject);
begin
 txtSearchContacts.Clear;
end;

procedure TfrmPCOM.sbtnDelClientClick(Sender: TObject);
var client_name, client_id : string;
    answer : integer;
begin
if ( (sgClients.Row > 1) and (sgClients.Cells[0, sgClients.Row] <> '') ) then
   begin
     client_name  := sgClients.Cells[1, sgClients.Row];
     client_id    := sgClients.Cells[0, sgClients.Row];

     answer := mqDlg('Send ' + client_name + ' to archive?');
     if answer = mrOk then
      begin
         DeleteClient(client_id);
      end;
   end;

end;
procedure TfrmPCOM.sbtnDelContactClick(Sender: TObject);
var contact_id, contact_name : string;
    answer : integer;
begin
   if ( (sgContacts.Row >= 1) and (sgContacts.Cells[0, sgContacts.Row] <> '')) then
   begin

     contact_id   := sgContacts.Cells[0, sgContacts.Row];
     contact_name := sgContacts.Cells[4, sgContacts.Row];

     answer := mqDlg('Send ' + contact_name + ' to archive?');
     if answer = mrOk then
      begin
         DeleteContact(contact_id);
      end;
   end;

end;

procedure TfrmPCOM.sbtnDeleteTTClick(Sender: TObject);
var desktop_name, desktop_id : string;
    answer : integer;
begin
   if ( (sgConnections.Row >= 1) and (sgConnections.Cells[0, sgConnections.Row] <> '')) then
   begin
     desktop_id  := sgConnections.Cells[0, sgConnections.Row];
     desktop_name := sgConnections.Cells[4, sgConnections.Row];

     answer := mqDlg('Send ' + desktop_name + ' to archive?');
     if answer = mrOk then
      begin
         DeleteDesktop(desktop_id);
      end;
   end;

end;

end.
