program DictionAttack_p;

uses
  Vcl.Forms,
  Main_u in 'Main_u.pas' {frmMain},
  clsWords_u in 'clsWords_u.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
