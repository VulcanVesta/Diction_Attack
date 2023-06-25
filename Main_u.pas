unit Main_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.GIFImg, Vcl.ExtCtrls,
  Vcl.StdCtrls, math, clsWords_u, Vcl.Imaging.jpeg;

type
  TfrmMain = class(TForm)
    imgBackground: TImage;
    imgShip: TImage;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    btnStart: TButton;
    tmrWords: TTimer;
    tmrPlaceWords: TTimer;
    lblWarning: TLabel;
    lblInfo: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure tmrWordsTimer(Sender: TObject);
    procedure tmrPlaceWordsTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Reset;
  private
    { Private declarations }
    objWords: TWords;
    iCount: integer;
    cLet: char;
    bWordLock: boolean;
    bAllWordsPlaced: boolean;  //Boolean to test if all words have been placed

     sWord: string;
 ilabel: integer;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
 btnStart.Visible := False;
 lblInfo.Visible := False;
 bWordLock := False;     //For KeyPress
 bAllWordsPlaced := False;    //For KeyPress
 lbl1.Caption := ' ';          //HAS to be space
 lbl2.Caption := ' ';
 lbl3.Caption := ' ';
 lbl1.Top := -20;
 lbl2.Top := -20;
 lbl3.Top := -20;

 objWords := TWords.create;
 iCount := 1;    //var used in timer
 tmrPlaceWords.Enabled := True;
 objWords.Free;

 tmrWords.Enabled := true;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
 (imgShip.Picture.Graphic as TGIFImage).Animate := True;

 lbl1.Caption := ' ';          //HAS to be space
 lbl2.Caption := ' ';
 lbl3.Caption := ' ';
end;
procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
 var
 cLet2: char;
 iWidth: integer;
begin
 cLet := key;

 if tmrWords.Enabled = False then     //Doesnt register if words arent moving
  begin
   exit;
  end;

 if cLet = ' ' then    //if cLet = SpaceBar
  begin
    exit;
  end;

 //Lock Word
 if (cLet = lbl1.caption[1]) AND (bWordLock = False) then
  begin
   lbl1.Font.Color := clRed;
   sWord := lbl1.Caption;
   iwidth := lbl1.Width;
   Delete(sWord, 1, 1);
   lbl1.Caption := sWord;
   lbl1.left := lbl1.Left + iWidth - lbl1.Width;
   ilabel := 1;
   bWordLock := True;
   exit;
  end
 else if (cLet = lbl2.caption[1]) AND (bWordLock = False) then
  begin
   lbl2.Font.Color := clRed;
   sWord := lbl2.Caption;
   iwidth := lbl2.Width;
   Delete(sWord, 1, 1);
   lbl2.Caption := sWord;
   lbl2.left := lbl2.Left + iWidth - lbl2.Width;
   ilabel := 2;
   bWordLock := True;
   exit;
  end
 else if (cLet = lbl3.caption[1]) AND (bWordLock = False) then
  begin
   lbl3.Font.Color := clRed;
   sWord := lbl3.Caption;
   iwidth := lbl3.Width;
   Delete(sWord, 1, 1);
   lbl3.Caption := sWord;
   lbl3.left := lbl3.Left + iWidth - lbl3.Width;
   ilabel := 3;
   bWordLock := True;
   exit;
  end;
  //Eliminate Word
 if (bWordLock = True) then
  begin
   if cLet = sWord[1] then
     begin
       if sWord.Length > 1 then
        begin  //Shorten word
         Delete(sWord, 1, 1);
         case ilabel of
          1: begin
           iWidth := lbl1.Width;     //old width
           lbl1.Caption := sWord;    //new width
           lbl1.Left := lbl1.Left + iWidth - lbl1.Width;
          end;
          2: begin
           iWidth := lbl2.Width;
           lbl2.Caption := sWord;
           lbl2.Left := lbl2.Left + iWidth - lbl2.Width;
          end;
          3: begin
           iWidth := lbl3.Width;
           lbl3.Caption := sWord;
           lbl3.Left := lbl3.Left + iWidth - lbl3.Width;
          end;
         end;
        end
        else begin  //Clear word
         bWordLock := False;
         case ilabel of
         1:begin
           lbl1.Caption := ' ';
           lbl1.Top := -20;
           end;

         2:begin
           lbl2.Caption := ' ';
           lbl2.Top := -20;
           end;

         3:begin
           lbl3.Caption := ' ';
           lbl3.Top := -20;
           end;
         end;
        end
     end
  end;

  //If all words finished
 if (lbl1.Caption = ' ') AND (lbl2.Caption = ' ') AND (lbl3.Caption = ' ') AND (bAllWordsPlaced = True) then
  begin
   lblInfo.Visible := True;
   lblInfo.Caption := 'Good soldier!';
   lblInfo.Left := btnStart.Left + (btnStart.Width DIV 2) - (lblInfo.Width DIV 2);       //Center lable
   Reset
  end;
end;

procedure TfrmMain.Reset;
begin
 tmrWords.Enabled := False;
 btnStart.Visible := True;
 lbl1.Font.Color := clYellow;
 lbl2.Font.Color := clYellow;
 lbl3.Font.Color := clYellow;
end;

procedure TfrmMain.tmrPlaceWordsTimer(Sender: TObject);
begin    //Place words
 if iCount = 1 then
  begin
   lbl1.Caption := objWords.CreateWords(1);
   lbl1.Top := -20;
   lbl1.left := RandomRange(0,401);
   Inc(iCount);
  end
 else if iCount = 2 then
  begin
   lbl2.Caption :=  objWords.CreateWords(1);
   lbl2.Top := -20;
   lbl2.left := RandomRange(0,401);
   Inc(iCount);
  end
 else if iCount = 3 then
  begin
   lbl3.Caption :=  objWords.CreateWords(1);
   lbl3.Top := -20;
   lbl3.left := RandomRange(0,401);
   Inc(iCount);
  end
 else if iCount = 4 then
  begin
   bAllWordsPlaced := True;
   tmrPlaceWords.Enabled := False;
  end;
end;

procedure TfrmMain.tmrWordsTimer(Sender: TObject);
begin   //Move words
 Refresh;
 if (lbl1.Top + lbl1.Height) < lblWarning.Top then
  begin
   lbl1.Top := lbl1.Top + 5;
   if lblWarning.Width/2 > (lbl1.left + (lbl1.Width/2)) then
    begin
     lbl1.Left := lbl1.Left + 1;
    end
   else if lblWarning.Width/2 < (lbl1.left + (lbl1.Width/2)) then
    begin
     lbl1.Left := lbl1.Left - 1;
    end;
  end;

 if (lbl2.Top + lbl2.Height) < lblWarning.Top then
  begin
   lbl2.Top := lbl2.Top + 5;
   if lblWarning.Width/2 > (lbl2.left + (lbl2.Width/2)) then
    begin
     lbl2.Left := lbl2.Left + 1;
    end
   else if lblWarning.Width/2 < (lbl2.left + (lbl2.Width/2)) then
    begin
     lbl2.Left := lbl2.Left - 1;
    end;
  end;

 if (lbl3.Top + lbl3.Height) < lblWarning.Top then
  begin
   lbl3.Top := lbl3.Top + 5;
   if lblWarning.Width/2 > (lbl3.left + (lbl3.Width/2)) then
    begin
     lbl3.Left := lbl3.Left + 1;
    end
   else if lblWarning.Width/2 < (lbl3.left + (lbl3.Width/2)) then
    begin
     lbl3.Left := lbl3.Left - 1;
    end;
  end;

 //If words hit finish line
 if ((lbl1.Top + lbl1.Height) >= lblWarning.Top) OR ((lbl2.Top + lbl2.Height) >= lblWarning.Top) OR ((lbl3.Top + lbl3.Height) >= lblWarning.Top) then
  begin
   lblInfo.Visible := True;
   lblInfo.Caption := 'Aint fast enough damn it!';
   lblInfo.Left := btnStart.Left + (btnStart.Width DIV 2) - (lblInfo.Width DIV 2);       //Center lable
   Reset
  end;

end;

end.