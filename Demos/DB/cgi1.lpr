program cgi1;

{$mode objfpc}{$H+}

uses
  LWSCGI,
  JDO,
  PQConnection;

resourcestring
  SCouldNotInsert = 'ERROR: Could not insert.';
  SSuccessfullyInserted = '-- Successfully inserted! --';

type

  { TCGI }

  TCGI = class(TLWSCGI)
  private
    FDB: TJDODataBase;
    FQuery: TJDOQuery;
  protected
    procedure Init; override;
    procedure Finit; override;
    procedure Request; override;
  end;

  procedure TCGI.Init;
  begin
    FDB := TJDODataBase.Create('db.cfg');
    FQuery := TJDOQuery.Create(FDB, 'jdo_demo');
  end;

  procedure TCGI.Finit;
  begin
    FQuery.Free;
    FDB.Free;
  end;

  procedure TCGI.Request;
  begin
    FDB.StartTrans;
    try
      FQuery.AddField('ftstr', ftStr);
      FQuery.AddField('ftbool', ftBool);
      FQuery.AddField('ftdate', ftDate);
      FQuery.AddField('ftfloat', ftFloat);
      FQuery.AddField('ftint', ftInt);
      if FQuery.Insert(Fields) then
        Contents.Text := SSuccessfullyInserted
      else
        Contents.Text := SCouldNotInsert;
      FDB.Commit;
    except
      FDB.Rollback;
      raise;
    end;
  end;

begin
  with TCGI.Create do
    try
      Run;
    finally
      Free;
    end;
end.
