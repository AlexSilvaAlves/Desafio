unit unmThread;

interface

uses
  System.Classes, SysUtils, Windows, ComCtrls;

type
  TnmThread = class(TThread)
  private
    iFTempo: integer;
    iFIteracoes: integer;
    procedure Laco;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    property iTempo: Integer read iFTempo write iFTempo;
    property iIteracoes: Integer read iFIteracoes write iFIteracoes;

  end;

implementation

{ TnmThread }

uses Threads;

constructor TnmThread.Create;
begin
  inherited Create(true);
  FreeOnTerminate := True;
end;

destructor TnmThread.Destroy;
begin

  inherited;
end;


procedure TnmThread.Execute;
begin
  Laco;
end;

procedure TnmThread.Laco;
var
  iLaco,
  iTempoAguardar: integer;
  sIDThread: string;
begin
  inherited;
  sIDThread := ThreadID.ToString;
  fThreads.mMemo.Lines.Add(sIDThread+' - Inciando processamento');

  fThreads.ProgressBar1.Min := 0;
  fThreads.ProgressBar1.Max := 100 * iIteracoes;

  for iLaco := 0 to 100 * iIteracoes do
  begin
    iTempoAguardar := Random(iFTempo);
    Sleep(iTempoAguardar);
    fThreads.ProgressBar1.Position := iLaco;
  end;

  fThreads.mMemo.Lines.Add(sIDThread+' - Processamento finalisado');
end;

end.
