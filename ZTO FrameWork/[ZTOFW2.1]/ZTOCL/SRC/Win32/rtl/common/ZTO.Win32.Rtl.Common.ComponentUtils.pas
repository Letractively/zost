unit ZTO.Win32.Rtl.Common.ComponentUtils;

{$WEAKPACKAGEUNIT ON}

interface

uses StdCtrls;

{ TODO -oCARLOS FEITOZA -cMELHORIA : Transforme isso em um componente com dois captions. Possivelmente usando dois labels unidos. A vantagem de se ter dois labels é que se poderia ter dois estilos diferentes para cada parte. Dê a opção de unir os labels com ".....:" }
procedure SetLabelDescriptionValue(const aLabelDescription
                                       , aLabelValue: TLabel;
                                   const aValue: String;
                                   const aSpacing: Byte = 2);

implementation

uses Classes;

procedure SetLabelDescriptionValue(const aLabelDescription
                                       , aLabelValue: TLabel;
                                   const aValue: String;
                                   const aSpacing: Byte = 2);
begin
	aLabelValue.Alignment   := taRightJustify;
  aLabelValue.Caption     := aValue;
  aLabelDescription.Width := aLabelValue.Left - aLabelDescription.Left - aSpacing;
end;



end.
