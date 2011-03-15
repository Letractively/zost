unit UBDOForm_JustificativaSalva;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls;

type
    TBDOForm_JustificativaSalva = class(TXXXForm_DialogTemplate)
        Label_UsuarioJustificador: TLabel;
        Label_UsuarioJustificadorValor: TLabel;
        Label_Justificativa: TLabel;
        Memo_Justificativa: TMemo;
    private
        { Private declarations }
    public
        { Public declarations }
    end;

implementation

{$R *.dfm}

end.
