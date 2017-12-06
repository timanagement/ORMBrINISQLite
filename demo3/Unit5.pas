unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.StdCtrls, Vcl.Buttons,
  uOrmBrINISQLite;

type
  TForm5 = class(TForm)
    DBGrid1: TDBGrid;
    edtID: TLabeledEdit;
    edtDescricao: TLabeledEdit;
    edtCaminho: TLabeledEdit;
    edtAtivo: TLabeledEdit;
    btnLocalizar: TBitBtn;
    btnNovo: TBitBtn;
    btnGravar: TBitBtn;
    btnSelecionar: TBitBtn;
    lblStatus: TLabel;
    btnCancelar: TBitBtn;
    OrmBrINISQLite1: TOrmBrINISQLite;
    btnExcluir: TBitBtn;
    odFileDB: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure OrmBrINISQLite1DataSourceStateChange(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1Enter(Sender: TObject);
    procedure OrmBrINISQLite1ClientDataSetAfterCancel(DataSet: TDataSet);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
  private
    procedure Status;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  Lid: Integer;

implementation

{$R *.dfm}

procedure TForm5.btnCancelarClick(Sender: TObject);
begin
  OrmBrINISQLite1.DataSet.Cancel;
end;

procedure TForm5.btnExcluirClick(Sender: TObject);
begin
  Lid := OrmBrINISQLite1.DataSet.FieldByName('ID').AsInteger;
  if (MessageDlg('Este procedimento irá excluir o ' + ''#13'' + 'registro ' +
    IntToStr(Lid) + '. Deseja prosseguir?', TMsgDlgType.mtInformation,
    [TMsgDlgBtn.mbok, TMsgDlgBtn.mbCancel], 0)) = mrOk then
  begin
    OrmBrINISQLite1.MasterCon.StartTransaction;
    OrmBrINISQLite1.oCon.Delete;
    OrmBrINISQLite1.oCon.ApplyUpdates(0);
    OrmBrINISQLite1.MasterCon.Commit;
  end;
end;

procedure TForm5.btnGravarClick(Sender: TObject);
begin
  OrmBrINISQLite1.Save(edtDescricao.Text, edtCaminho.Text, False);
end;

procedure TForm5.btnLocalizarClick(Sender: TObject);
begin
  if odFileDB.Execute = true then
  begin
    edtCaminho.Text := odFileDB.FileName;
    btnGravar.Enabled := True;
  end;
end;

procedure TForm5.btnNovoClick(Sender: TObject);
begin
  OrmBrINISQLite1.DataSet.Append;
  edtDescricao.SetFocus;
end;

procedure TForm5.btnSelecionarClick(Sender: TObject);
var
  Lindex: Integer;
begin
  Lid := OrmBrINISQLite1.DataSet.FieldByName('ID').AsInteger;
  OrmBrINISQLite1.MasterCon.ExecuteSQL('Update bases set Ativo = 0');
  OrmBrINISQLite1.MasterCon.ExecuteSQL('Update bases set Ativo = 1 ' +
    'Where ID = ' + IntToStr(Lid) + '');
  OrmBrINISQLite1.oCon.Open;
  DBGrid1.SelectedIndex := Lindex;
  Status;
end;

procedure TForm5.Status;
begin
  case OrmBrINISQLite1.DataSet.FieldByName('Ativo').AsBoolean of
    False:
      begin
        lblStatus.Caption := 'Inativo';
        edtAtivo.Text := 'Inativo';
      end;
    true:
      begin
        lblStatus.Caption := 'Ativo';
        edtAtivo.Text := 'Ativo';
      end;
  end;
end;

procedure TForm5.DBGrid1CellClick(Column: TColumn);
begin
  OrmBrINISQLite1DataSourceStateChange(Self);
end;

procedure TForm5.DBGrid1Enter(Sender: TObject);
begin
  OrmBrINISQLite1DataSourceStateChange(Self);
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  DBGrid1.DataSource := OrmBrINISQLite1.DataSource;
  OrmBrINISQLite1.DBParamsConfig;
end;

procedure TForm5.OrmBrINISQLite1ClientDataSetAfterCancel(DataSet: TDataSet);
begin
  OrmBrINISQLite1.DataSet.CancelUpdates;
end;

procedure TForm5.OrmBrINISQLite1DataSourceStateChange(Sender: TObject);
begin
  if OrmBrINISQLite1.DataSource.State in [dsBrowse] then
    Lid := OrmBrINISQLite1.DataSet.FieldByName('ID').AsInteger;
  edtID.Text := IntToStr(OrmBrINISQLite1.DataSet.FieldByName('ID').AsInteger);
  case OrmBrINISQLite1.DataSet.FieldByName('Ativo').AsBoolean of
    False:
      begin
        edtAtivo.Text := 'Inativo';
      end;
    true:
      begin
        edtAtivo.Text := 'Ativo';
      end;
  end;
  edtDescricao.Text := OrmBrINISQLite1.DataSet.FieldByName('Descricao')
    .AsString;
  edtCaminho.Text := OrmBrINISQLite1.DataSet.FieldByName('Caminho').AsString;

  btnNovo.Enabled := (OrmBrINISQLite1.DataSource).State in [dsBrowse];
  btnGravar.Enabled := (OrmBrINISQLite1.DataSource).State in [dsEdit, dsInsert];
  btnCancelar.Enabled := btnGravar.Enabled;
  btnSelecionar.Enabled := (btnNovo.Enabled) and
    not((OrmBrINISQLite1).DataSet.IsEmpty);
  btnExcluir.Enabled := btnSelecionar.Enabled;
  btnSelecionar.Enabled := btnNovo.Enabled;
  Status;
end;

end.
