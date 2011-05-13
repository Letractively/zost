unit UXXXDataModule_AddEntity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList,

  UXXXDataModule, ImgList;

type
	TXXXDataModule_AddEntityClass = class of TXXXDataModule_AddEntity;

  	TXXXDataModule_AddEntity = class(TXXXDataModule)
  	private
    	{ Private declarations }
  	public
    	{ Public declarations }
        procedure RegisterEntities(const aEntitiesList: TStrings);
  	end;

implementation

uses
	UXXXForm_AddEntity;

{$R *.dfm}

{ TDataModule_AddEntity }

procedure TXXXDataModule_AddEntity.RegisterEntities(const aEntitiesList: TStrings);
var
  	i: Word;
  	SQL: String;
begin
  	inherited;
  	if aEntitiesList.Count > 0 then
  	begin
    	SQL :=
      	'INSERT IGNORE'#13#10 +
      	'  INTO ENTIDADESDOSISTEMA (VA_NOME,TI_TIPO)'#13#10 +
      	'VALUES'#13#10;

      	for i := 0 to Pred(aEntitiesList.Count) do
      	begin
        	SQL := SQL +
        	'       (' + QuotedStr(aEntitiesList[i]) + ', 1';

        	if i = Pred(aEntitiesList.Count) then
          		SQL := SQL + ')'
        	else
          		SQL := SQL + '),'#13#10;
        end;

		try
        	ExecuteQuery(DataModuleMain.ZConnections[0].Connection,AnsiString(SQL));
      	finally
        	TXXXForm_AddEntity(Owner).Close;
        end;
	end
    else
    	MessageBox(Application.Handle,'Nenhuma entidade foi selecionada. Não é possível registrar!','Nada a ser registrado...',MB_ICONWARNING);
end;

end.
