unit Unit3;

{ DataModule comum. Copyright 2010 / 2011 ZTO Solu��es Tecnol�gicas Ltda. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ZTO.Wizards.FormTemplates.DataModule, ZConnection, DB, ZAbstractRODataset,
  ZDataset;

type
  TZTODataModule3 = class(TZTODataModule)
    ZConnection1: TZConnection;
    DataSource1: TDataSource;
    ZReadOnlyQuery1: TZReadOnlyQuery;
  private
    { Declara��es privadas }
  protected
    { Declara��es protegidas }
  public
    { Declara��es p�blicas }
  end;

var
  ZTODataModule3: TZTODataModule3;

implementation

{$R *.dfm}

end.