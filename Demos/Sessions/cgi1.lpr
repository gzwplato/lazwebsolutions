program cgi1;

{$mode objfpc}{$H+}

uses
  LWSCGI,
  LWSSessions,
  LWSConsts;

type

  { TCGI }

  TCGI = class(TLWSCGI)
  private
    FSessions: TLWSSessions;
  protected
    procedure DoFillHeaders; override;
    procedure DoPopulateProperties; override;
    procedure DoResponse; override;
  public
    destructor Destroy; override;
  end;

  destructor TCGI.Destroy;
  begin
    FSessions.Free;
    inherited Destroy;
  end;

  procedure TCGI.DoFillHeaders;
  begin
    Headers.Text := FSessions.Header;
    inherited;
  end;

  procedure TCGI.DoPopulateProperties;
  begin
    inherited;
    FSessions := TLWSSessions.Create(HTTPCookie);
  end;

  procedure TCGI.DoResponse;
  var
    I: Integer;
  begin
    FSessions.Start;
    Contents.Add('<!DOCTYPE HTML>');
    Contents.Add('<html lang="en-US">');
    Contents.Add('<head>');
    Contents.Add('	<meta charset="UTF-8">');
    Contents.Add('	<title>Cookies</title>');
    Contents.Add('</head>');
    Contents.Add('<body>');
    if FSessions.Count = 0 then
    begin
      Contents.Add('Creating session ...' + BR);
      Contents.Add('Use F5 to show created session.' + BR);
      FSessions.Add('session1', 'ABC');
      FSessions.Add('session2', 123);
      FSessions.Add('session3', 1.5);
      FSessions.Add('session4', True);
    end
    else
    begin
      Contents.Add('Created session:' + BR);
      for I := 0 to Pred(FSessions.Count) do
        Contents.Add(FSessions.Items[I].AsString + BR);
    end;
    Contents.Add('</body>');
    Contents.Add('</html>');
  end;

begin
  with TCGI.Create do
    try
      Run;
    finally
      Free;
    end;
end.

