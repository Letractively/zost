unit Mdl.Lib.ZTOSDIForm_Base;

{ Formul�rio SDI comum. Copyright 2010 / 2011 ZTO Solu��es Tecnol�gicas Ltda. }

interface

uses
  Classes, Controls, Forms,
  ZTO.Wizards.FormTemplates.SDIForm;

type
  TZTOSDIForm_Base = class(TZTOSDIForm)
  private
    { Declara��es privadas }
  protected
    { Declara��es protegidas }
  public
    { Declara��es p�blicas }
  end;

implementation

{$R *.dfm}

end.
