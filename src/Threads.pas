unit Threads;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, unmThread;

type
  TfThreads = class(TForm)
    edtNumThreads: TEdit;
    edtTempoThreads: TEdit;
    btnProcessar: TButton;
    ProgressBar1: TProgressBar;
    mMemo: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnProcessarClick(Sender: TObject);
    procedure edtNumThreadsExit(Sender: TObject);
    procedure edtTempoThreadsExit(Sender: TObject);

  private

  public
    { Public declarations }
  end;

var
  fThreads: TfThreads;
  fnmThread: TnmThread;

implementation

{$R *.dfm}


procedure TfThreads.btnProcessarClick(Sender: TObject);
var
  lstThreads: Tlist;
  i: integer;

begin
  mMemo.Clear;
  lstThreads := TList.Create;

  for i := 0 to StrToInt(edtNumThreads.Text) -1 do
  begin
    lstThreads.Add(TnmThread.Create);
    TnmThread(lstThreads[i]).iTempo := strToInt(edtTempoThreads.text);
    TnmThread(lstThreads[i]).iIteracoes := strToInt(edtTempoThreads.Text);
    TnmThread(lstThreads[i]).Priority := TpNormal;
    TnmThread(lstThreads[i]).Start;
  end;

  FreeAndNil(lstThreads);
end;

procedure TfThreads.edtNumThreadsExit(Sender: TObject);
begin

  if StrToInt(edtNumThreads.Text) = 0 then
  begin
    edtNumThreads.SetFocus;
    ShowMessage('Valor não pode ser igual a zero');
  end;

end;

procedure TfThreads.edtTempoThreadsExit(Sender: TObject);
begin

  if StrToInt(edtTempoThreads.Text) = 0 then
   begin
    edtTempoThreads.SetFocus;
    ShowMessage('Valor não pode ser igual a zero');
  end;

end;

end.
