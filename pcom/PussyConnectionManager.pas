unit PussyConnectionManager;

interface
uses SysUtils, ZDbcIntFS, Dialogs, System.Classes;

type
  TPussyConnectionManager = class(Tthread)
  public
     procedure init(ConnCount: Byte; DBString, DBUser, DBPass : string; FixIntervalSeconds : integer = 60);
     procedure OpenConnections();
     procedure Execute; override;
     function getStatement() : IZStatement;
     function getConnection() : IZConnection;
     function prepareStatement(sql : string) : IZPreparedStatement;
     procedure freeStatement(stmt: IZStatement);
     procedure freePreparedStatement(pstmt : IZPreparedStatement);
     procedure freeConnection(con : IZConnection);
     procedure test();
     procedure FixConnections();
  private
     savedDBString, savedDBUser, savedDBPass : string;
     ConnectionCount : byte;
     Connections : array of IZConnection;
     Statements : array of IZStatement;
     ConnectionsStatus: array of byte; // 0 = free, 1 = active, 2 = error
     fixInterval : integer;
  protected

  end;

implementation

procedure TPussyConnectionManager.Execute;
var
  con : IZConnection;
  stmt : IZStatement;
begin

  OpenConnections();

  while not terminated do
    begin
      self.FixConnections;
      sleep(FixInterval * 1000);
    end;

  for stmt in Statements do
    begin
      stmt.Close;
      sleep(30);
    end;

  for con in Connections do
    begin
      con.Close;
      sleep(30);
    end;


end;

procedure TPussyConnectionManager.FixConnections;
var
    con  : IZConnection;
    stmt : IZStatement;
    i : integer;
begin
  for i := 0 to connectionCount - 1 do
    begin

    System.TMonitor.Enter(Self);
    try
      con := connections[i];

      if con.PingServer = -1 then
        begin
          Con  := DriverManager.GetConnectionWithLogin(savedDBString, savedDBUser, savedDBPass);
          Con.SetAutoCommit(True);
          Con.SetTransactionIsolation(tiReadCommitted);
          Stmt := Con.CreateStatement;
          Connections[i] := Con;
          Statements[i] := Stmt;
          ConnectionsStatus[i] := 0;
        end;
    except

    end;
    System.TMonitor.Exit(Self);

    end;
end;

procedure TPussyConnectionManager.test;
var i : integer;
begin
for i := 0 to ConnectionCount - 1 do
  begin
  showMessage(IntToStr(Connections[i].PingServer));

  end;
end;

procedure TPussyConnectionManager.freeStatement(stmt: IZStatement);
var
  i: integer;
  found : boolean;
  con   : IZConnection;
begin
  found := false;
  System.TMonitor.Enter(Self);
  try
    for I := 0 to ConnectionCount - 1 do
      begin
        if Statements[i] = stmt then
          begin
            found := true;
            ConnectionsStatus[i] := 0;
            break;
          end;
      end;

      if not found then
      begin
        con := stmt.GetConnection;
        stmt.Close;
        sleep(50);
        con.Close;
      end;
  finally
   System.TMonitor.Exit(Self);
  end
end;

procedure TPussyConnectionManager.freePreparedStatement(pstmt: IZPreparedStatement);
var
  i: integer;
  found : boolean;
  con   : IZConnection;
begin
  found := false;
  System.TMonitor.Enter(Self);
  try
    for I := 0 to ConnectionCount - 1 do
      begin
        if Connections[i] = pstmt.GetConnection then
          begin
            found := true;
            pstmt.Close;
            ConnectionsStatus[i] := 0;
            break;
          end;
      end;

      if not found then
      begin
        con := pstmt.GetConnection;
        pstmt.Close;
        sleep(50);
        con.Close;
      end;
  finally
   System.TMonitor.Exit(Self);
  end
end;

procedure TPussyConnectionManager.freeConnection(con: IZConnection);
var
  i: integer;
  found : boolean;
begin
  found := false;
  System.TMonitor.Enter(Self);
  try
    for I := 0 to ConnectionCount - 1 do
      begin
        if Connections[i] = con then
          begin
            found := true;
            ConnectionsStatus[i] := 0;
            break;
          end;
      end;

      if not found then
      begin
        con.Close;
      end;
  finally
   System.TMonitor.Exit(Self);
  end
end;

function TPussyConnectionManager.getConnection;
var i : integer;
    Connection : IZConnection;
    Statement  : IZStatement;
begin
  System.TMonitor.Enter(Self);
  try
    result := nil;
    for I := 0 to ConnectionCount-1 do
    begin
      if ConnectionsStatus[i] = 0 then
        begin
        ConnectionsStatus[i] := 1;
        result := Connections[i];
        break;
        end;

    end;
    if result = nil then
    begin
        Connection := DriverManager.GetConnectionWithLogin(savedDBString, savedDBUser, savedDBPass);
        Connection.SetAutoCommit(True);
        Connection.SetTransactionIsolation(tiReadCommitted);
        result     := Connection;
    end;
  finally
   System.TMonitor.Exit(Self);
  end;
end;

function TPussyConnectionManager.prepareStatement(sql : string) : IZPreparedStatement;
var i : integer;
    Connection : IZConnection;
begin
  System.TMonitor.Enter(Self);
  try
    result := nil;
    for I := 0 to ConnectionCount-1 do
    begin
      if ConnectionsStatus[i] = 0 then
        begin
        ConnectionsStatus[i] := 1;
        result := Connections[i].PrepareStatement(sql);
        break;
        end;

    end;
    if result = nil then
    begin
        Connection := DriverManager.GetConnectionWithLogin(savedDBString, savedDBUser, savedDBPass);
        Connection.SetAutoCommit(True);
        Connection.SetTransactionIsolation(tiReadCommitted);
        result := Connection.PrepareStatement(sql);
    end;
  finally
   System.TMonitor.Exit(Self);
  end;
end;

function TPussyConnectionManager.getStatement;
var i : integer;
    Connection : IZConnection;
    Statement  : IZStatement;
begin
  System.TMonitor.Enter(Self);
  try
    result := nil;
    for I := 0 to ConnectionCount-1 do
    begin
      if ConnectionsStatus[i] = 0 then
        begin
        ConnectionsStatus[i] := 1;
        result := Statements[i];
        break;
        end;

    end;
    if result = nil then
    begin
        Connection := DriverManager.GetConnectionWithLogin(savedDBString, savedDBUser, savedDBPass);
        Connection.SetAutoCommit(True);
        Connection.SetTransactionIsolation(tiReadCommitted);
        Statement  := Connection.CreateStatement;
        result     := statement;
    end;
  finally
   System.TMonitor.Exit(Self);
  end;
end;

procedure TPussyConnectionManager.Init(ConnCount: Byte; DBString, DBUser, DBPass : string; FixIntervalSeconds : integer = 60);
begin

  ConnectionCount := ConnCount;
  SetLength(Connections, ConnectionCount);
  SetLength(Statements, ConnectionCount);
  SetLength(ConnectionsStatus, ConnectionCount);
  savedDBString := DBString;
  savedDBUser   := DBUser;
  savedDBPass   := DBPass;
  fixInterval   := FixIntervalSeconds;

end;

procedure TPussyConnectionManager.OpenConnections;
var
  i : integer;
begin

System.TMonitor.Enter(Self);
  for i := 0 to ConnectionCount - 1 do
    begin
      try
      begin
      Connections[i] := DriverManager.GetConnectionWithLogin(savedDBString, savedDBUser, savedDBPass);
      Connections[i].SetAutoCommit(True);
      Connections[i].SetTransactionIsolation(tiReadCommitted);
      Statements[i] := Connections[i].CreateStatement;
      ConnectionsStatus[i] := 0;

      end;
      except
      ConnectionsStatus[i] := 2;
      end;

    end;
System.TMonitor.Exit(Self);

end;


end.
