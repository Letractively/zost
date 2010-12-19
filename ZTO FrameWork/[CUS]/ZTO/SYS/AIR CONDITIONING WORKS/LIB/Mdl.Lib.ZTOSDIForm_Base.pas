unit Mdl.Lib.ZTOSDIForm_Base;

{ Formulário SDI comum. Copyright 2010 / 2011 ZTO Soluções Tecnológicas Ltda. }

interface

uses
  Classes, Controls, Forms,
  ZTO.Wizards.FormTemplates.SDIForm;

type
  TZTOSDIForm_Base = class(TZTOSDIForm)
  private
    { Declarações privadas }
  protected
    { Declarações protegidas }
  public
    { Declarações públicas }
  end;

implementation

{$R *.dfm}

end.
