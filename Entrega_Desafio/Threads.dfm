object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'fThreads'
  ClientHeight = 268
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 69
    Height = 13
    Caption = 'N'#186' de Threads'
  end
  object Label2: TLabel
    Left = 164
    Top = 9
    Width = 32
    Height = 13
    Caption = 'Tempo'
  end
  object edtNumThreads: TEdit
    Left = 8
    Top = 28
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 0
    Text = '1'
    OnExit = edtNumThreadsExit
  end
  object edtTempoThreads: TEdit
    Left = 164
    Top = 28
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 1
    Text = '10'
    OnExit = edtTempoThreadsExit
  end
  object btnProcessar: TButton
    Left = 8
    Top = 60
    Width = 277
    Height = 46
    Caption = 'Processar Treads'
    TabOrder = 2
    OnClick = btnProcessarClick
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 251
    Width = 291
    Height = 17
    Align = alBottom
    TabOrder = 3
  end
  object mMemo: TMemo
    Left = 0
    Top = 115
    Width = 291
    Height = 136
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 4
  end
end
