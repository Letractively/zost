unit Unit2;

{ Caixa de diálogo comum. Copyright 2010 / 2011 ZTO Soluções Tecnológicas Ltda. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ZTO.Wizards.FormTemplates.Dialog, Grids, DBGrids, ZTO.Components.DataControls.DBGrid;

type
  TZTODialog2 = class(TZTODialog)
    ZTODBGrid1: TZTODBGrid;
  private
    { Declarações privadas }
  protected
    { Declarações protegidas }
  public
    { Declarações públicas }
  end;

implementation

uses Unit3;

{$R *.dfm}

end.