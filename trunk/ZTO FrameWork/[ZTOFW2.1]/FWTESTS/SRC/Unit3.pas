unit Unit3;

{ DataModule comum. Copyright 2010 / 2011 ZTO Soluções Tecnológicas Ltda. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ZTO.Wizards.FormTemplates.DataModule, ZConnection, DB, ZAbstractRODataset,
  ZDataset, ZAbstractDataset;

type
  TZTODataModule3 = class(TZTODataModule)
    ZConnection1: TZConnection;
    DataSource1: TDataSource;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    ZQuery1: TZQuery;
    DataSource2: TDataSource;
  private
    { Declarações privadas }
  protected
    { Declarações protegidas }
  public
    { Declarações públicas }
  end;

var
  ZTODataModule3: TZTODataModule3;

implementation

{$R *.dfm}

end.