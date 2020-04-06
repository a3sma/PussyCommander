unit ConnectionChecker;

interface

  uses System.Classes, PussyConnectionManager;
type
  TbgConnectionChecker = class(TThread)
  public
    conmgr     : TPussyConnectionManager;
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

procedure TbgConnectionChecker.Execute;
begin

while not terminated do
begin
    sleep(5 * 1000);
    conmgr.FixConnections;
    sleep(5 * 1000);
end;

end;

end.
