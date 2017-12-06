{
      TormBrINISQLitem componente que possibilita o uso do SQLite para criar
      e armazenar parametros de inicializa��o para aplica��es desenvolvidas em
       Delphi

                   Copyright (c) 2017, Alexandre da Silva Santos
                          All rights reserved.

                    GNU Lesser General Public License
                      Vers�o 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos � permitido copiar e distribuir c�pias deste documento de
       licen�a, mas mud�-lo n�o � permitido.

       Esta vers�o da GNU Lesser General Public License incorpora
       os termos e condi��es da vers�o 3 da GNU General Public License
       Licen�a, complementado pelas permiss�es adicionais listadas no
       arquivo LICENSE na pasta principal.
       Este componente contou com a colabora��o de: Fabr�cio Louren�o

      @author(Alexandre S. Santos <alexsystem@gmail.com>)
      @author(Skype : alexsystem@msn.com)

 Este componente usa como engine o ORMBr Framework da autoria Isaque Pinheiro
  Dados para contato do autor do ORMBr:
  e-mail: isaquepsp@gmail.com
  Skype : ispinheiro
  Website : http://www.ormbr.com.br
  Telagram : https://t.me/ormbr
  ORM Brasil � um ORM simples e descomplicado para quem utiliza Delphi.
}

unit uOrmBrINISQLite;

interface

uses
  Variants,
  Vcl.OleCtrls, Windows, Vcl.Forms,
  Vcl.Controls, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Winapi.Messages,
  SysUtils,
  TypInfo,
  Rtti,
  Generics.Collections,
  System.Classes, Data.DBXJSON,
  Data.DB, Datasnap.DBClient,
  System.Generics.Collections,
  /// ormBr
  ormbr.factory.interfaces,
  ormbr.types.database,
  ormbr.database.interfaces,
  ormbr.database.factory,
  ormbr.factory.sqlite3,
  ormbr.ddl.commands,
  ormbr.ddl.generator.SQLite,
  ormbr.dml.generator.SQLite,
  ormbr.metadata.SQLite,
  ormbr.modeldb.compare,
  sqlite3,
  SQLiteTable3,
  ormbr.container.dataset.interfaces,
  ormbr.container.dataset,
  ormbr.container.clientdataset,
  ormbr.container.objectset,
  ormbr.container.objectset.interfaces,
  // Mapeamento de classes ORMBr
  ormbr.types.blob,
  ormbr.types.lazy,
  ormbr.types.mapping,
  ormbr.types.nullable,
  ormbr.mapping.Classes,
  ormbr.mapping.register,
  ormbr.mapping.attributes,
  ormbr.metadata.DB.factory,
  ormbr.metadata.classe.factory;

const
  _Ativo: Boolean = False;

type

  [Entity]
  [Table('bases', '')]
  [PrimaryKey('ID', AutoInc, NoSort, False, 'Chave prim�ria')]
  [Sequence('SEQ_bases')]
  TConfigDB = class
  private
    { Private declarations }
    FID: Integer;
    FDescricao: String;
    FCaminho: String;
    FAtivo: Boolean;

  public
    { Public declarations }
    constructor Create;
    [Restrictions([NoUpdate, NotNull, Hidden])]
    [Column('ID', ftInteger)]
    [Dictionary('ID', 'Este campo � auto incremento', '', '', '', taCenter)]
    property ID: Integer read FID write FID;

    [Column('Descricao', ftString, 50)]
    [Dictionary('Descri��o', 'Descri��o n�o pode estar vazio', '', '', '',
      taLeftJustify)]
    property Descricao: String read FDescricao write FDescricao;

    [Column('Caminho', ftString, 255)]
    [Dictionary('Caminho', 'Caminho n�o pode estar vazio', '', '', '',
      taLeftJustify)]
    property Caminho: String read FCaminho write FCaminho;

    [Restrictions([NotNull, Unique, Hidden])]
    [Column('Ativo', ftBoolean)]
    [Dictionary('Ativo', 'Campo Ativo � Unique', '', '', '', taLeftJustify)]
    property Ativo: Boolean read FAtivo write FAtivo default False;
  end;

  TCFGClientDataSet = class(TClientDataSet)
  private
    FOnBeforePost: TNotifyEvent;
  protected

  public

  published
    { Published declarations }
  end;

  TCFGDataSource = class(TDataSource)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;



  TOrmBrINISQLite = class(TComponent)
  private
    FAppPathName: String;
    oConn: IDBConnection;
    oManager: IDatabaseCompare;
    FDatabase: TSQLiteDatabase;
    oConfigDB: IContainerDataSet<TConfigDB>;
    FDriverName: TDriverName;
    FConnMaster: IDBConnection;
    FMetadataMaster: TMetadataClasseAbstract;
    FMetadataTarget: TMetadataDBAbstract;
    FEntity: TConfigDB;
    procedure SaveData(aConfigDB: IContainerDataSet<TConfigDB>;
      aObj: TConfigDB);
  protected
    FDataSet: TCFGClientDataSet;
    FDataSource: TCFGDataSource;
  published
    property dataset: TCFGClientDataSet read FDataSet write FDataSet;
    property DataSource: TCFGDataSource read FDataSource write FDataSource;
    property Entity: TConfigDB read FEntity;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DBParamsConfig;
    procedure Save(aDescricao, aCaminho: String; aSituacao: Boolean);
    class function GetAllEntityClass: TArray<TClass>;
    property MasterCon: IDBConnection read oConn;
    property oCon: IContainerDataSet<TConfigDB> read oConfigDB;
  end;

procedure register;

implementation

var
  LConfigDB: TConfigDB;

procedure register;
begin
  RegisterComponents('OrmBr', [TOrmBrINISQLite]);
end;

{ TOrmBrINISQLite }

constructor TOrmBrINISQLite.Create(AOwner: TComponent);
begin
  inherited;
  FDataSet := TCFGClientDataSet.Create(self);
  FDataSet.Name := 'ClientDataSet';
  FDataSet.SetSubComponent(true);
  FDataSource := TCFGDataSource.Create(self);
  FDataSource.Name := 'DataSource';
  FDataSource.SetSubComponent(true);
  FDataSource.dataset := FDataSet;
end;



procedure TOrmBrINISQLite.DBParamsConfig;
var
  cDDL: TDDLCommand;
begin
  FAppPathName := ExtractFilePath(ParamStr(0));
  if not Assigned(oConfigDB) then
  begin
    FDatabase := TSQLiteDatabase.Create(Self);
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'dbConfig.dll') then
    begin
      FDatabase.FileName := FAppPathName + 'dbConfig.dll';
      oConn := TFactorySQLite.Create(FDatabase, dnSQLite);
      oManager := TModelDbCompare.Create(oConn);
      oManager.CommandsAutoExecute := True;
      { Se false apenas faz a leitura }
      oManager.BuildDatabase;
    end;
    FDatabase.FileName := FAppPathName + 'dbConfig.dll';
    // Inst�ncia da class de conex�o via FireDAC
    oConn := TFactorySQLite.Create(FDatabase, dnSQLite);
    oConfigDB := TContainerClientDataSet<TConfigDB>.Create(oConn, FDataSet);
    oConfigDB.Open;
  end;
end;

destructor TOrmBrINISQLite.Destroy;
begin
  FDataSource.Destroy;
  FDataSet.Destroy;
  inherited;
//  RemoveFreeNotifications;
end;

class function TOrmBrINISQLite.GetAllEntityClass: TArray<TClass>;
begin
  //
end;

procedure TOrmBrINISQLite.Save(aDescricao, aCaminho: String;
  aSituacao: Boolean);
begin
  LConfigDB := oConfigDB.Current;
  LConfigDB.Descricao := aDescricao;
  LConfigDB.Caminho := aCaminho;
  LConfigDB.Ativo := aSituacao;
  SaveData(oConfigDB, LConfigDB);
end;

procedure TOrmBrINISQLite.SaveData(aConfigDB: IContainerDataSet<TConfigDB>;
  aObj: TConfigDB);
begin
  try
    aConfigDB.Save(aObj);
    ShowMessage('Dados salvos com sucesso');
  except
    ShowMessage('Erro ao salvar os dados');
  end;
  aConfigDB.ApplyUpdates(0);
end;


{ TConfigDB }

constructor TConfigDB.Create;
begin
  inherited;
  Self.FDescricao := '';
  Self.FCaminho := '';
  Self.FAtivo := _Ativo;
end;


initialization

TRegisterClass.RegisterEntity(TConfigDB)

end.
