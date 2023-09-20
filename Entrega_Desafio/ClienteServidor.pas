unit ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Datasnap.DBClient, Data.DB,
  Datasnap.Provider, SimpleDS;

type
  TServidor = class
  private
    FPath: AnsiString;
  public
    constructor Create;
    //Tipo do par�metro n�o pode ser alterado
    function SalvarArquivos(AData: OleVariant): Boolean;
    function SalvarArquivosComErros(AData: OleVariant): Boolean;
    procedure RollBackDeArquivos(sPath: string);
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure btEnviarParaleloClick(Sender: TObject);
  private
    FPath: AnsiString;
    function InitDataset: TClientDataset;

  public
    FServidor: TServidor;
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
  IOUtils, uParalelo;

{$R *.dfm}

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
  cds := InitDataset;
  try
    try
      for i := 0 to QTD_ARQUIVOS_ENVIAR do
      begin
        cds.Append;
        TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(string(FPath));
        cds.Post;

        {$REGION Simula��o de erro, n�o alterar}
        if i = (QTD_ARQUIVOS_ENVIAR/2) then
          FServidor.SalvarArquivos(NULL);
        {$ENDREGION}
      end;
      FServidor.SalvarArquivosComErros(cds.Data);
    except
      On E: Exception do
      begin
        ShowMessage(E.Message);
        FServidor.RollBackDeArquivos(ExtractFilePath(ParamStr(0)) + 'Servidor\');
      end;
     end;
  finally
    FreeAndNil(cds);
  end
end;

procedure TfClienteServidor.btEnviarParaleloClick(Sender: TObject);
begin
  fParalelo.Show;
end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: TClientDataset;
begin
  cds := InitDataset;
  try
    try
       cds.Append;
       TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(string(FPath));
       cds.Post;

       FServidor.SalvarArquivos(cds.Data);
    except
       On E: Exception do
       begin
         ShowMessage(E.Message);
         FServidor.RollBackDeArquivos(ExtractFilePath(ParamStr(0)) + 'Servidor\');
       end;
    end;
  finally
    FreeAndNil(cds);
  end;
end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  {$WARN SYMBOL_PLATFORM OFF}
  FPath := AnsiString(IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + 'pdf.pdf');
  {$WARN SYMBOL_PLATFORM ON}
  FServidor := TServidor.Create;
end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;

procedure TServidor.RollBackDeArquivos(sPath: string);
var
  srLista: TSearchRec;
  iNumArquivos: integer;
begin
  iNumArquivos := FindFirst(sPath+'*.pdf', faAnyFile, srLista);

  while iNumArquivos = 0 do
  begin
    if (srLista.Attr and faDirectory) <> faDirectory then
      DeleteFile(sPath+srLista.name);

    iNumArquivos := FindNext(srLista);
  end;
end;

{ TServidor }

constructor TServidor.Create;
begin
  if not DirectoryExists(ExtractFilePath(ParamStr(0)) + 'Servidor') then
    ForceDirectories(PChar(ExtractFilePath(ParamStr(0)) + 'Servidor'));

  FPath := AnsiString(ExtractFilePath(ParamStr(0)) + 'Servidor\');
end;

function TServidor.SalvarArquivos(AData: OleVariant): Boolean;
var
  cds: TClientDataSet;
  FileName: string;
  i: integer;
begin
  Result := False;
  try
    fClienteServidor.ProgressBar.Min := 0;
    fClienteServidor.ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;

    cds := TClientDataset.Create(nil);
    cds.Data := AData;

    {$REGION Simula��o de erro, n�o alterar}
    if cds.RecordCount = 0 then
      Exit;
    {$ENDREGION}

    cds.First;

    For i := 0 to  QTD_ARQUIVOS_ENVIAR do
    begin
        FileName := string(FPath) + IntToStr(i) + '.pdf';

        if TFile.Exists(FileName) then
          TFile.Delete(FileName);

        TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
         fClienteServidor.ProgressBar.Position := i;
    end;

    FreeAndNil(cds);
    Result := True;
  except
     raise;
  end;
end;

function TServidor.SalvarArquivosComErros(AData: OleVariant): Boolean;
var
  cds: TClientDataSet;
  FileName: string;
begin
  Result := False;
  try
    cds := TClientDataset.Create(nil);
    cds.Data := AData;

    {$REGION Simula��o de erro, n�o alterar}
    if cds.RecordCount = 0 then
      Exit;
    {$ENDREGION}

    cds.First;

    while not cds.Eof do
    begin
      FileName := string(FPath) + cds.RecNo.ToString + '.pdf';
      if TFile.Exists(FileName) then
        TFile.Delete(FileName);

      TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
      cds.Next;
    end;

    Result := True;
  except
    raise;
  end;

end;

end.
