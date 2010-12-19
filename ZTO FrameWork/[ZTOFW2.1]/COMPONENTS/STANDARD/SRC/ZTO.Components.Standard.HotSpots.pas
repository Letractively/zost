unit ZTO.Components.Standard.HotSpots;

interface

uses Classes
   , Forms;

type
  { Fêmea }
  THotSpotSocket = class(TComponent)
  private
    FDevice: TComponent;
  public
    constructor Create(aOwner: TComponent); override;
  published
    property Device: TComponent read FDevice;
  end;

  { Macho }
  THotSpotPlug = class(TComponent)
  private
    FHotSpotSocket: THotSpotSocket;
  public
    constructor Create(aOwner: TComponent); override;
  published
    property HotSpotSocket: THotSpotSocket read FHotSpotSocket write FHotSpotSocket;
  end;

implementation

uses SysUtils;

(*
QUANDO USAR ESTES COMPONENTES PARA LIGAR FORMS E/OU DATAMODULES DISTINTOS
HAVERÁ COMPORTAMENTOS DIVERSOS DE ACORDO COM A FORMA DE "USES" QUE FOI USADA
ENTRE ELES (INTERFACE/IMPLEMENTATION). NESTES CASOS A LIGAÇÃO SÓ PODE SER FEITA
EM UMA DIREÇÃO E NÃO EM AMBAS
*)

{ TDataModuleHotSpot }

constructor THotSpotSocket.Create(aOwner: TComponent);
begin
  inherited;
  
  if not ((aOwner.InheritsFrom(TDataModule)) or (aOwner.InheritsFrom(TCustomForm))) then
    raise Exception.Create('Este componente só pode ser colocado em um TDataModule ou um TForm ou um de seus descendentes');

  FDevice := aOwner;
end;

{ THotSpotPlug }

constructor THotSpotPlug.Create(aOwner: TComponent);
begin
  inherited;

  if not ((aOwner.InheritsFrom(TDataModule)) or (aOwner.InheritsFrom(TCustomForm))) then
    raise Exception.Create('Este componente só pode ser colocado em um TDataModule ou um TForm ou um de seus descendentes');
end;

end.




