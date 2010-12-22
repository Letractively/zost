unit UConfigurations;

interface

uses
  Classes, SysUtils, IniFiles, Forms, Windows;

const
  cPARAMETROSSection = 'PARAMETROS';
  cENVIOSection = 'ENVIO';

  {Section: PARAMETROS}
  cPARAMETROSORIGEM = 'ORIGEM';
  cPARAMETROSTIPODOCUMENTO = 'TIPODOCUMENTO';
  cPARAMETROSTODOSOSDOCUMENTOS = 'TODOSOSDOCUMENTOS';
  cPARAMETROSOPCAODATA = 'OPCAODATA';
  cPARAMETROSDATAINICIAL = 'DATAINICIAL';
  cPARAMETROSDATAFINAL = 'DATAFINAL';
  cPARAMETROSNUMEROMESES = 'NUMEROMESES';
  cPARAMETROSNOMEDOARQUIVO = 'NOMEDOARQUIVO';
  cPARAMETROSDATABASE = 'DATABASE';
  cPARAMETROSHOSTNAME = 'HOSTNAME';
  cPARAMETROSUSERNAME = 'USERNAME';
  cPARAMETROSPASSWORD = 'PASSWORD';
  cPARAMETROSPROTOCOL = 'PROTOCOL';
  cPARAMETROSPORTNUMB = 'PORTNUMB';
  cPARAMETROSTOTALTHREADS = 'TOTALTHREADS';
  cPARAMETROSCONCURRENTTHREADS = 'CONCURRENTTHREADS';
  cPARAMETROSAPPNAME = 'APPNAME';
  cPARAMETROSSTANDALONE = 'STANDALONE';
  cPARAMETROSORDENARDADOS = 'ORDENARDADOS';

  {Section: ENVIO}
  cENVIOSERVIDOR = 'SERVIDOR';
  cENVIOREMOTEBASEDIR = 'REMOTEBASEDIR';
  cENVIOUSERNAME = 'USERNAME';
  cENVIOPASSWORD = 'PASSWORD'; 

type
  TConfigurations = class(TObject)
  private
    {Section: PARAMETROS}
    FPARAMETROSORIGEM: Integer;
    FPARAMETROSTIPODOCUMENTO: Integer;
    FPARAMETROSTODOSOSDOCUMENTOS: Boolean;
    FPARAMETROSOPCAODATA: Integer;
    FPARAMETROSDATAINICIAL: TDateTime;
    FPARAMETROSDATAFINAL: TDateTime;
    FPARAMETROSNUMEROMESES: Integer;
    FPARAMETROSNOMEDOARQUIVO: string;
    FPARAMETROSDATABASE: string;
    FPARAMETROSHOSTNAME: string;
    FPARAMETROSUSERNAME: string;
    FPARAMETROSPASSWORD: string;
    FPARAMETROSPROTOCOL: string;
    FPARAMETROSPORTNUMB: Word;
    FPARAMETROSTOTALTHREADS: Word;
    FPARAMETROSCONCURRENTTHREADS: Byte;
    FPARAMETROSAPPNAME: string;
    FPARAMETROSSTANDALONE: Boolean;
    FPARAMETROSORDENARDADOS: Boolean;

    {Section: ENVIO}
    FENVIOSERVIDOR: String;
    FENVIOREMOTEBASEDIR: String;
    FENVIOUSERNAME: String;
    FENVIOPASSWORD: String;
  public
    procedure LoadSettings(Ini: TIniFile);
    procedure SaveSettings(Ini: TIniFile);
    
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    {Section: PARAMETROS}
    property PARAMETROSORIGEM: Integer read FPARAMETROSORIGEM write FPARAMETROSORIGEM;
    property PARAMETROSTIPODOCUMENTO: Integer read FPARAMETROSTIPODOCUMENTO write FPARAMETROSTIPODOCUMENTO;
    property PARAMETROSTODOSOSDOCUMENTOS: Boolean read FPARAMETROSTODOSOSDOCUMENTOS write FPARAMETROSTODOSOSDOCUMENTOS;
    property PARAMETROSOPCAODATA: Integer read FPARAMETROSOPCAODATA write FPARAMETROSOPCAODATA;
    property PARAMETROSDATAINICIAL: TDateTime read FPARAMETROSDATAINICIAL write FPARAMETROSDATAINICIAL;
    property PARAMETROSDATAFINAL: TDateTime read FPARAMETROSDATAFINAL write FPARAMETROSDATAFINAL;
    property PARAMETROSNUMEROMESES: Integer read FPARAMETROSNUMEROMESES write FPARAMETROSNUMEROMESES;
    property PARAMETROSNOMEDOARQUIVO: string read FPARAMETROSNOMEDOARQUIVO write FPARAMETROSNOMEDOARQUIVO;
    property PARAMETROSDATABASE: string read FPARAMETROSDATABASE write FPARAMETROSDATABASE;
    property PARAMETROSHOSTNAME: string read FPARAMETROSHOSTNAME write FPARAMETROSHOSTNAME;
    property PARAMETROSUSERNAME: string read FPARAMETROSUSERNAME write FPARAMETROSUSERNAME;
    property PARAMETROSPASSWORD: string read FPARAMETROSPASSWORD write FPARAMETROSPASSWORD;
    property PARAMETROSPROTOCOL: string read FPARAMETROSPROTOCOL write FPARAMETROSPROTOCOL;
    property PARAMETROSPORTNUMB: Word read FPARAMETROSPORTNUMB write FPARAMETROSPORTNUMB;
    property PARAMETROSTOTALTHREADS: Word read FPARAMETROSTOTALTHREADS write FPARAMETROSTOTALTHREADS;
    property PARAMETROSCONCURRENTTHREADS: Byte read FPARAMETROSCONCURRENTTHREADS write FPARAMETROSCONCURRENTTHREADS;
    property PARAMETROSAPPNAME: string read FPARAMETROSAPPNAME write FPARAMETROSAPPNAME;
    property PARAMETROSSTANDALONE: Boolean read FPARAMETROSSTANDALONE write FPARAMETROSSTANDALONE;
    property PARAMETROSORDENARDADOS: Boolean read FPARAMETROSORDENARDADOS write FPARAMETROSORDENARDADOS;

    {Section: ENVIO}
    property ENVIOSERIVIDOR: string read FENVIOSERVIDOR write FENVIOSERVIDOR;
    property ENVIOREMOTEBASEDIR: string read FENVIOREMOTEBASEDIR write FENVIOREMOTEBASEDIR;
    property ENVIOUSERNAME: string read FENVIOUSERNAME write FENVIOUSERNAME;
    property ENVIOPASSWORD: string read FENVIOPASSWORD write FENVIOPASSWORD;
  end;

var
  Configurations: TConfigurations = nil;

implementation

procedure TConfigurations.LoadSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    {Section: PARAMETROS}
    FPARAMETROSORIGEM := Ini.ReadInteger(cPARAMETROSSection, cPARAMETROSORIGEM, 1);
    FPARAMETROSTIPODOCUMENTO := Ini.ReadInteger(cPARAMETROSSection, cPARAMETROSTIPODOCUMENTO, 1);

    if UpperCase(Ini.ReadString(cPARAMETROSSection, cPARAMETROSTODOSOSDOCUMENTOS, 'True')) = 'TRUE' then
      FPARAMETROSTODOSOSDOCUMENTOS := True
    else
      FPARAMETROSTODOSOSDOCUMENTOS := False;

    FPARAMETROSOPCAODATA         := Ini.ReadInteger(cPARAMETROSSection, cPARAMETROSOPCAODATA, 1);
    FPARAMETROSDATAINICIAL       := Ini.ReadDateTime(cPARAMETROSSection, cPARAMETROSDATAINICIAL, StrToDateTime('01/01/2001'));
    FPARAMETROSDATAFINAL         := Ini.ReadDateTime(cPARAMETROSSection, cPARAMETROSDATAFINAL, StrToDateTime('01/12/2010'));
    FPARAMETROSNUMEROMESES       := Ini.ReadInteger(cPARAMETROSSection, cPARAMETROSNUMEROMESES, 10);
    FPARAMETROSNOMEDOARQUIVO     := Ini.ReadString(cPARAMETROSSection, cPARAMETROSNOMEDOARQUIVO, '.\CJF');
    FPARAMETROSDATABASE          := Ini.ReadString(cPARAMETROSSection, cPARAMETROSDATABASE, 'TRF5PRD');
    FPARAMETROSHOSTNAME          := Ini.ReadString(cPARAMETROSSection, cPARAMETROSHOSTNAME, 'TAMANDARE');
    FPARAMETROSUSERNAME          := Ini.ReadString(cPARAMETROSSection, cPARAMETROSUSERNAME, 'ATENAS');
    FPARAMETROSPASSWORD          := Ini.ReadString(cPARAMETROSSection, cPARAMETROSPASSWORD, 'ATENAS');
    FPARAMETROSPROTOCOL          := Ini.ReadString(cPARAMETROSSection, cPARAMETROSPROTOCOL, 'oracle');
    FPARAMETROSPORTNUMB          := Ini.ReadInteger(cPARAMETROSSection, cPARAMETROSPORTNUMB, 0);
    FPARAMETROSTOTALTHREADS      := Ini.ReadInteger(cPARAMETROSSection, cPARAMETROSTOTALTHREADS, 100);
    FPARAMETROSCONCURRENTTHREADS := Ini.ReadInteger(cPARAMETROSSection, cPARAMETROSCONCURRENTTHREADS, 10);
    FPARAMETROSAPPNAME           := Ini.ReadString(cPARAMETROSSection, cPARAMETROSAPPNAME, '');
    FPARAMETROSSTANDALONE        := Ini.ReadBool(cPARAMETROSSection, cPARAMETROSSTANDALONE,False);
    FPARAMETROSORDENARDADOS      := Ini.ReadBool(cPARAMETROSSection, cPARAMETROSORDENARDADOS,True);

    FENVIOSERVIDOR               := Ini.ReadString(cENVIOSection, cENVIOSERVIDOR, '10.1.0.15');
    FENVIOREMOTEBASEDIR          := Ini.ReadString(cENVIOSection, cENVIOREMOTEBASEDIR, '/');
    FENVIOUSERNAME               := Ini.ReadString(cENVIOSection, cENVIOUSERNAME, 'jurtrf5');
    FENVIOPASSWORD               := Ini.ReadString(cENVIOSection, cENVIOPASSWORD, '');
  end;
end;

procedure TConfigurations.SaveSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    {Section: PARAMETROS}
    Ini.WriteInteger(cPARAMETROSSection, cPARAMETROSORIGEM, FPARAMETROSORIGEM);
    Ini.WriteInteger(cPARAMETROSSection, cPARAMETROSTIPODOCUMENTO, FPARAMETROSTIPODOCUMENTO);

    Ini.WriteString(cPARAMETROSSection, cPARAMETROSTODOSOSDOCUMENTOS, BoolToStr(FPARAMETROSTODOSOSDOCUMENTOS,True));

    Ini.WriteInteger(cPARAMETROSSection, cPARAMETROSOPCAODATA, FPARAMETROSOPCAODATA);
    Ini.WriteDateTime(cPARAMETROSSection, cPARAMETROSDATAINICIAL, FPARAMETROSDATAINICIAL);
    Ini.WriteDateTime(cPARAMETROSSection, cPARAMETROSDATAFINAL, FPARAMETROSDATAFINAL);
    Ini.WriteInteger(cPARAMETROSSection, cPARAMETROSNUMEROMESES, FPARAMETROSNUMEROMESES);
    Ini.WriteString(cPARAMETROSSection, cPARAMETROSNOMEDOARQUIVO, FPARAMETROSNOMEDOARQUIVO);
    Ini.WriteString(cPARAMETROSSection, cPARAMETROSDATABASE, FPARAMETROSDATABASE);
    Ini.WriteString(cPARAMETROSSection, cPARAMETROSHOSTNAME, FPARAMETROSHOSTNAME);
    Ini.WriteString(cPARAMETROSSection, cPARAMETROSUSERNAME, FPARAMETROSUSERNAME);
    Ini.WriteString(cPARAMETROSSection, cPARAMETROSPASSWORD, FPARAMETROSPASSWORD);
    Ini.WriteString(cPARAMETROSSection, cPARAMETROSPROTOCOL, FPARAMETROSPROTOCOL);
    Ini.WriteInteger(cPARAMETROSSection, cPARAMETROSPORTNUMB, FPARAMETROSPORTNUMB);
    Ini.WriteInteger(cPARAMETROSSection, cPARAMETROSTOTALTHREADS, FPARAMETROSTOTALTHREADS);
    Ini.WriteInteger(cPARAMETROSSection, cPARAMETROSCONCURRENTTHREADS, FPARAMETROSCONCURRENTTHREADS);
    Ini.WriteString(cPARAMETROSSection, cPARAMETROSAPPNAME, FPARAMETROSAPPNAME);
    Ini.WriteBool(cPARAMETROSSection,cPARAMETROSSTANDALONE,FPARAMETROSSTANDALONE);
    Ini.WriteBool(cPARAMETROSSection,cPARAMETROSORDENARDADOS,FPARAMETROSORDENARDADOS);

    Ini.WriteString(cENVIOSection, cENVIOSERVIDOR, FENVIOSERVIDOR);
    Ini.WriteString(cENVIOSection, cENVIOREMOTEBASEDIR, FENVIOREMOTEBASEDIR);
    Ini.WriteString(cENVIOSection, cENVIOUSERNAME, FENVIOUSERNAME);
    Ini.WriteString(cENVIOSection, cENVIOPASSWORD, FENVIOPASSWORD);
  end;
end;

procedure TConfigurations.LoadFromFile(const FileName: string);
var
  Ini: TIniFile;
begin
  if FileExists(FileName) then
  begin
    Ini := TIniFile.Create(FileName);
    try
      LoadSettings(Ini);
    finally
      Ini.Free;
    end;
  end;
end;

procedure TConfigurations.SaveToFile(const FileName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FileName);
  try
    SaveSettings(Ini);
  finally
    Ini.Free;
  end;
end;

initialization
  Configurations := TConfigurations.Create;
  Configurations.LoadFromFile(GetCurrentDir + '\Config.ini');

finalization
  Configurations.SaveToFile(GetCurrentDir + '\Config.ini');
  Configurations.Free;

end.
