unit Unit2;

{ Caixa de di�logo comum. Copyright 2010 / 2011 ZTO Solu��es Tecnol�gicas Ltda. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ZTO.Wizards.FormTemplates.Dialog, Grids, DBGrids,
  ZTO.Components.DataControls.ZTODBGrid;

type
  TZTODialog2 = class(TZTODialog)
    ZTODBGrid1: TZTODBGrid;
  private
    { Declara��es privadas }
  protected
    { Declara��es protegidas }
  public
    { Declara��es p�blicas }
  end;

implementation

uses Unit3;

{$R *.dfm}

end.