object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Form5'
  ClientHeight = 363
  ClientWidth = 575
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblStatus: TLabel
    Left = 8
    Top = 264
    Width = 59
    Height = 19
    Caption = 'Status : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 560
    Height = 145
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
    OnEnter = DBGrid1Enter
  end
  object edtID: TLabeledEdit
    Left = 8
    Top = 176
    Width = 41
    Height = 21
    EditLabel.Width = 11
    EditLabel.Height = 13
    EditLabel.Caption = 'ID'
    TabOrder = 1
  end
  object edtDescricao: TLabeledEdit
    Left = 55
    Top = 176
    Width = 434
    Height = 21
    EditLabel.Width = 49
    EditLabel.Height = 13
    EditLabel.Caption = 'Descri'#231#227'o '
    TabOrder = 2
  end
  object edtCaminho: TLabeledEdit
    Left = 8
    Top = 224
    Width = 489
    Height = 21
    EditLabel.Width = 44
    EditLabel.Height = 13
    EditLabel.Caption = 'Caminho '
    TabOrder = 3
  end
  object edtAtivo: TLabeledEdit
    Left = 503
    Top = 176
    Width = 65
    Height = 21
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = 'Ativo '
    TabOrder = 4
  end
  object btnLocalizar: TBitBtn
    Left = 503
    Top = 224
    Width = 64
    Height = 21
    Caption = 'Localizar...'
    TabOrder = 5
    OnClick = btnLocalizarClick
  end
  object btnNovo: TBitBtn
    Left = 8
    Top = 304
    Width = 81
    Height = 28
    Caption = 'Novo Registro'
    TabOrder = 6
    OnClick = btnNovoClick
  end
  object btnGravar: TBitBtn
    Left = 320
    Top = 304
    Width = 81
    Height = 28
    Caption = 'Gravar'
    TabOrder = 7
    OnClick = btnGravarClick
  end
  object btnSelecionar: TBitBtn
    Left = 464
    Top = 304
    Width = 97
    Height = 28
    Caption = 'Selecionar'
    TabOrder = 8
    OnClick = btnSelecionarClick
  end
  object btnCancelar: TBitBtn
    Left = 112
    Top = 304
    Width = 82
    Height = 28
    Caption = 'Cancelar'
    TabOrder = 9
    OnClick = btnCancelarClick
  end
  object btnExcluir: TBitBtn
    Left = 216
    Top = 304
    Width = 81
    Height = 28
    Caption = 'Excluir'
    TabOrder = 10
    OnClick = btnExcluirClick
  end
  object OrmBrINISQLite1: TOrmBrINISQLite
    dataset.Aggregates = <>
    dataset.Params = <>
    dataset.AfterCancel = OrmBrINISQLite1ClientDataSetAfterCancel
    DataSource.DataSet.Aggregates = <>
    DataSource.DataSet.Params = <>
    DataSource.DataSet.AfterCancel = OrmBrINISQLite1ClientDataSetAfterCancel
    DataSource.OnStateChange = OrmBrINISQLite1DataSourceStateChange
    Left = 256
    Top = 248
  end
  object odFileDB: TOpenDialog
    Filter = 'Base de Dados (*.FDB)|*.FDB'
    InitialDir = 'C:\'
    Left = 118
    Top = 249
  end
end
