unit UXXXForm_RecordInformation;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, UXXXForm_DialogTemplate, ActnList, ExtCtrls, StdCtrls;

type
    TXXXForm_RecordInformation = class(TXXXForm_DialogTemplate)
        Label_CreationDateAndTime: TLabel;
        Label_CreationDateAndTimeValor: TLabel;
        Label_TableName: TLabel;
        Label_TableNameValor: TLabel;
        Label_RecordId: TLabel;
        Label_RecordIdValor: TLabel;
        Label_CreatorFullName: TLabel;
        Label_CreatorFullNameValor: TLabel;
        Label_LastModificationDateAndTime: TLabel;
        Label_LastModificationDateAndTimeValor: TLabel;
        Label_LastModifierFullName: TLabel;
        Label_LastModifierFullNameValor: TLabel;
        Label_CreatorId: TLabel;
        Label_CreatorIdValor: TLabel;
        Label_LastModifierId: TLabel;
        Label_LastModifierIdValor: TLabel;
        Label_RecordStatus: TLabel;
        Label_RecordStatusValor: TLabel;
        procedure FormCreate(Sender: TObject);
    private
        { Private declarations }
        LarguraTotal: Word;
        procedure SetCreationDateAndTime(const Value: TDateTime);
        procedure SetCreatorFullName(const Value: AnsiString);
        procedure SetCreatorId(const Value: Cardinal);
        procedure SetLastModificationDateAndTime(const Value: TDateTime);
        procedure SetLastModifierFullName(const Value: AnsiString);
        procedure SetLastModifierId(const Value: Cardinal);
        procedure SetRecordStatus(const Value: AnsiString);
        procedure SetRecordId(const Value: Cardinal);
        procedure SetTableName(const Value: AnsiString);
    public
        { Public declarations }
        property TableName: AnsiString write SetTableName;
        property RecordId: Cardinal write SetRecordId;

        property CreatorId: Cardinal write SetCreatorId;
        property CreatorFullName: AnsiString write SetCreatorFullName;
        property CreationDateAndTime: TDateTime write SetCreationDateAndTime;

        property LastModifierId: Cardinal write SetLastModifierId;
        property LastModifierFullName: AnsiString write SetLastModifierFullName;
        property LastModificationDateAndTime: TDateTime write SetLastModificationDateAndTime;

        property RecordStatus: AnsiString write SetRecordStatus;
    end;

implementation

{$R *.dfm}

procedure TXXXForm_RecordInformation.FormCreate(Sender: TObject);
begin
    inherited;
    LarguraTotal := ClientWidth - 12;
end;

procedure TXXXForm_RecordInformation.SetCreationDateAndTime(const Value: TDateTime);
begin
    Label_CreationDateAndTimeValor.Caption := FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Value);
 	Label_CreationDateAndTime.Width := LarguraTotal - Label_CreationDateAndTimeValor.Width;
end;

procedure TXXXForm_RecordInformation.SetCreatorFullName(const Value: AnsiString);
begin
    Label_CreatorFullNameValor.Caption := String(Value);
	Label_CreatorFullName.Width := LarguraTotal - Label_CreatorFullNameValor.Width;
end;

procedure TXXXForm_RecordInformation.SetCreatorId(const Value: Cardinal);
begin
    Label_CreatorIdValor.Caption := IntToStr(Value);
	Label_CreatorId.Width := LarguraTotal - Label_CreatorIdValor.Width;
end;

procedure TXXXForm_RecordInformation.SetLastModificationDateAndTime(const Value: TDateTime);
begin
    Label_LastModificationDateAndTimeValor.Caption := FormatDateTime('dd/mm/yyyy "às" hh:nn:ss',Value);
	Label_LastModificationDateAndTime.Width := LarguraTotal - Label_LastModificationDateAndTimeValor.Width;
end;

procedure TXXXForm_RecordInformation.SetLastModifierFullName(const Value: AnsiString);
begin
    Label_LastModifierFullNameValor.Caption := String(Value);
	Label_LastModifierFullName.Width := LarguraTotal - Label_LastModifierFullNameValor.Width;
end;

procedure TXXXForm_RecordInformation.SetLastModifierId(const Value: Cardinal);
begin
    Label_LastModifierIdValor.Caption := IntToStr(Value);
	Label_LastModifierId.Width := LarguraTotal - Label_LastModifierIdValor.Width;
end;

procedure TXXXForm_RecordInformation.SetRecordId(const Value: Cardinal);
begin
    Label_RecordIdValor.Caption := IntToStr(Value);
	Label_RecordId.Width := LarguraTotal - Label_RecordIdValor.Width;
end;

procedure TXXXForm_RecordInformation.SetRecordStatus(const Value: AnsiString);
begin
    Label_RecordStatusValor.Caption := UpperCase(String(Value));
	Label_RecordStatus.Width := LarguraTotal - Label_RecordStatusValor.Width;
end;

procedure TXXXForm_RecordInformation.SetTableName(const Value: AnsiString);
begin
    Label_TableNameValor.Caption := UpperCase(String(Value));
	Label_TableName.Width := LarguraTotal - Label_TableNameValor.Width;  
end;


end.
