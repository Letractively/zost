unit ZTO.Win32.Db.Controls.Utils;

{$WEAKPACKAGEUNIT ON}

interface

uses Classes, DB, DBCtrls, DBGrids;

function IsDataWare(    aComponent: TComponent;
                    out aDataSet  : TDataSet;
                    out aDataField: TField): Boolean;

implementation

function IsDataWare(    aComponent: TComponent;
                    out aDataSet  : TDataSet;
                    out aDataField: TField): Boolean;
begin
	aDataSet := nil;
	aDataField := nil;
	Result := False;

	if aComponent is TDBEdit then
	begin
    Result :=     Assigned(TDBEdit(aComponent).DataSource)
              and Assigned(TDBEdit(aComponent).DataSource.DataSet)
              and Assigned(TDBEdit(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBEdit(aComponent).DataSource.DataSet;
			aDataField := TDBEdit(aComponent).Field;
		end;
	end
	else if aComponent is TDBMemo then
	begin
		Result :=     Assigned(TDBMemo(aComponent).DataSource)
              and Assigned(TDBMemo(aComponent).DataSource.DataSet)
              and Assigned(TDBMemo(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBMemo(aComponent).DataSource.DataSet;
			aDataField := TDBMemo(aComponent).Field;
		end;
	end
	else if aComponent is TDBImage then
	begin
		Result :=     Assigned(TDBImage(aComponent).DataSource)
              and Assigned(TDBImage(aComponent).DataSource.DataSet)
              and Assigned(TDBImage(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBImage(aComponent).DataSource.DataSet;
			aDataField := TDBImage(aComponent).Field;
		end;
	end
	else if aComponent is TDBListBox then
	begin
		Result :=     Assigned(TDBListBox(aComponent).DataSource)
              and Assigned(TDBListBox(aComponent).DataSource.DataSet)
              and Assigned(TDBListBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBListBox(aComponent).DataSource.DataSet;
			aDataField := TDBListBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBComboBox then
	begin
		Result :=     Assigned(TDBComboBox(aComponent).DataSource)
              and Assigned(TDBComboBox(aComponent).DataSource.DataSet)
              and Assigned(TDBComboBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBComboBox(aComponent).DataSource.DataSet;
			aDataField := TDBComboBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBCheckBox then
	begin
		Result :=     Assigned(TDBCheckBox(aComponent).DataSource)
              and Assigned(TDBCheckBox(aComponent).DataSource.DataSet)
              and Assigned(TDBCheckBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBCheckBox(aComponent).DataSource.DataSet;
			aDataField := TDBCheckBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBRadioGroup then
	begin
		Result :=     Assigned(TDBRadioGroup(aComponent).DataSource)
              and Assigned(TDBRadioGroup(aComponent).DataSource.DataSet)
              and Assigned(TDBRadioGroup(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBRadioGroup(aComponent).DataSource.DataSet;
			aDataField := TDBRadioGroup(aComponent).Field;
		end;
	end
	else if aComponent is TDBLookupListBox then
	begin
		Result :=     Assigned(TDBLookupListBox(aComponent).DataSource)
              and Assigned(TDBLookupListBox(aComponent).DataSource.DataSet)
              and Assigned(TDBLookupListBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBLookupListBox(aComponent).DataSource.DataSet;
			aDataField := TDBLookupListBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBLookupComboBox then
	begin
		Result :=     Assigned(TDBLookupComboBox(aComponent).DataSource)
              and Assigned(TDBLookupComboBox(aComponent).DataSource.DataSet)
              and Assigned(TDBLookupComboBox(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBLookupComboBox(aComponent).DataSource.DataSet;
			aDataField := TDBLookupComboBox(aComponent).Field;
		end;
	end
	else if aComponent is TDBRichEdit then
	begin
		Result :=     Assigned(TDBRichEdit(aComponent).DataSource)
              and Assigned(TDBRichEdit(aComponent).DataSource.DataSet)
              and Assigned(TDBRichEdit(aComponent).Field);

		if Result then
		begin
			aDataSet := TDBRichEdit(aComponent).DataSource.DataSet;
			aDataField := TDBRichEdit(aComponent).Field;
    	end;
	end
	else if aComponent is TDBGrid then
	begin
		Result :=     Assigned(TDBGrid(aComponent).DataSource)
              and Assigned(TDBGrid(aComponent).DataSource.DataSet);
		if Result then
			aDataSet := TDBGrid(aComponent).DataSource.DataSet;
	end;
end;

end.
