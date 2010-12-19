unit Mdl.Lib.ZTODataModule_Base;

{ DataModule comum. Copyright 2010 / 2011 ZTO Soluções Tecnológicas Ltda. }

interface

uses Windows
   , Messages
   , Classes
   , Forms
   , ZTO.Wizards.FormTemplates.DataModule
   , ZTO.Wizards.FormTemplates.CustomForm
   , Sys.Lib.Types
   , ZDataSet
   , ZSqlUpdate;

type
  TZQuery = class (ZDataSet.TZQuery)
  protected
    procedure DoAfterCancel; override;
    procedure DoAfterClose; override;
    procedure DoAfterDelete; override;
    procedure DoAfterEdit; override;
    procedure DoAfterInsert; override;
    procedure DoAfterOpen; override;
    procedure DoAfterPost; override;
    procedure DoAfterRefresh; override;
    procedure DoAfterScroll; override;
    procedure DoBeforeCancel; override;
    procedure DoBeforeClose; override;
    procedure DoBeforeDelete; override;
    procedure DoBeforeEdit; override;
    procedure DoBeforeInsert; override;
    procedure DoBeforeOpen; override;
    procedure DoBeforePost; override;
    procedure DoBeforeRefresh; override;
    procedure DoBeforeScroll; override;
  end;

  TZTODataModule_Base = class(TZTODataModule)
    procedure ZTODataModuleCreate(Sender: TObject);
  private
    { Declarações privadas }
    procedure DoDelayedClose(var Msg: TMessage);
  protected
    { Declarações protegidas }
    MyGUI: TZTOCustomForm;
    procedure DoQueryEvent(const aZQuery: TZQuery; const aQueryEvent: TQueryEvent); virtual;
  public
    { Declarações públicas }
    procedure DelayedClose;
    procedure CreateGUI; virtual;
    procedure ValidateClose(var aCanClose: Boolean);
  end;

implementation

uses DB
   , SysUtils;

{$R *.dfm}

procedure TZTODataModule_Base.CreateGUI;
begin
  { Por padrão não faz nada }
end;

procedure TZTODataModule_Base.DelayedClose;
begin
  SetTimer(0,0,1000,Classes.MakeObjectInstance(DoDelayedClose));
end;

procedure TZTODataModule_Base.DoDelayedClose(var Msg: TMessage);
begin
  KillTimer(0,TWMTimer(Msg).TimerID);

  if not Assigned(MyGUI) then
    Free;
end;

{ TODO -oCARLOS FEITOZA -cDOCUMENTAÇÃO : ESTE MÉTODO SERVE COMO UM CONCENTRADOR
DE EVENTOS BEFORE E AFTER ENCONTRADOS NOS COMPONENTES QUERY }
procedure TZTODataModule_Base.DoQueryEvent(const aZQuery    : TZQuery;
                                           const aQueryEvent: TQueryEvent);
begin
  { Para setar o refresh SQL...
  Quando necessário, em datamodules herdados, configure o refreshsql aqui,
  baseado no dataset. Devemos informar SQLs que retornem todos os campos que são
  de alguma forma calculados e que precisem de um refresh imediato após a
  postagem dos dados que podem ter mudado em caso de edição e que efetivamente
  mudaram em caso de inserção. Em modo insert deve-se obter o registro por meio
  de LAST_INSERT_ID ou outra forma de obter tal registro. Em modo edit devemos
  usar o parâmetro correspondente à chave primária prefixado por "OLD_" a fim de
  atualizar as informações apenas do registro que acabamos de editar }
end;

procedure TZTODataModule_Base.ValidateClose(var aCanClose: Boolean);
var
  i: Word;
begin
  for i := 0 to Pred(DataSets.Count) do
    if DataSets.DataSetItem[i].DataSet.State <> dsBrowse then
    begin
      Application.MessageBox('Ainda existem alterações que devem ser confirmadas ou descartadas. Não é possível fechar','Não é possível fechar',MB_ICONWARNING);
      aCanClose := False;
      Break;
    end;
end;

procedure TZTODataModule_Base.ZTODataModuleCreate(Sender: TObject);
begin
  CreateGUI;
end;

{ TZQuery }

procedure TZQuery.DoAfterCancel;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeAfterCancel);
end;

procedure TZQuery.DoAfterClose;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeAfterClose);
end;

procedure TZQuery.DoAfterDelete;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeAfterDelete);
end;

procedure TZQuery.DoAfterEdit;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeAfterEdit);
end;

procedure TZQuery.DoAfterInsert;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeAfterInsert);
end;

procedure TZQuery.DoAfterOpen;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeAfterOpen);
end;

procedure TZQuery.DoAfterPost;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeAfterPost);
end;

procedure TZQuery.DoAfterRefresh;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeAfterRefresh);
end;

procedure TZQuery.DoAfterScroll;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeAfterScroll);
end;

procedure TZQuery.DoBeforeCancel;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeBeforeCancel);
end;

procedure TZQuery.DoBeforeClose;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeBeforeClose);
end;

procedure TZQuery.DoBeforeDelete;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeBeforeDelete);
  if Application.MessageBox('Tem certeza de que deseja excluir este registro?','Tem certeza?',MB_ICONQUESTION or MB_YESNO) = ID_NO then
    Abort;
end;

procedure TZQuery.DoBeforeEdit;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeBeforeEdit);
end;

procedure TZQuery.DoBeforeInsert;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeBeforeInsert);
end;

procedure TZQuery.DoBeforeOpen;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeBeforeOpen);
end;

procedure TZQuery.DoBeforePost;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeBeforePost);
end;

procedure TZQuery.DoBeforeRefresh;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeBeforeRefresh);
end;

procedure TZQuery.DoBeforeScroll;
begin
  inherited;
  TZTODataModule_Base(Owner).DoQueryEvent(Self,qeBeforeScroll);
end;

end.
