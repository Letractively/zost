unit UConfiguracoes;

interface

uses
  Classes, SysUtils, IniFiles, Forms, Windows;

const
  cCONFIGURACOESSection = 'CONFIGURACOES';

  {Section: CONFIGURACOES}
  cCONFIGURACOESDATABASE = 'DATABASE';
  cCONFIGURACOESHOSTNAME = 'HOSTNAME';
  cCONFIGURACOESPASSWORD = 'PASSWORD';
  cCONFIGURACOESPROTOCOL = 'PROTOCOL';
  cCONFIGURACOESUSERNAME = 'USERNAME';
  cCONFIGURACOESOBJOWNER = 'OBJOWNER';

type
  TConfiguracoes = class(TObject)
  private
    {Section: CONFIGURACOES}
    FCONFIGURACOESDATABASE: string;
    FCONFIGURACOESHOSTNAME: string;
    FCONFIGURACOESPASSWORD: string;
    FCONFIGURACOESPROTOCOL: string;
    FCONFIGURACOESUSERNAME: string;
    FCONFIGURACOESOBJOWNER: string;
  public
    procedure LoadSettings(Ini: TIniFile);
    procedure SaveSettings(Ini: TIniFile);
    
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    {Section: CONFIGURACOES}
    property CONFIGURACOESDATABASE: string read FCONFIGURACOESDATABASE write FCONFIGURACOESDATABASE;
    property CONFIGURACOESHOSTNAME: string read FCONFIGURACOESHOSTNAME write FCONFIGURACOESHOSTNAME;
    property CONFIGURACOESPASSWORD: string read FCONFIGURACOESPASSWORD write FCONFIGURACOESPASSWORD;
    property CONFIGURACOESPROTOCOL: string read FCONFIGURACOESPROTOCOL write FCONFIGURACOESPROTOCOL;
    property CONFIGURACOESUSERNAME: string read FCONFIGURACOESUSERNAME write FCONFIGURACOESUSERNAME;
    property CONFIGURACOESOBJOWNER: string read FCONFIGURACOESOBJOWNER write FCONFIGURACOESOBJOWNER;
  end;

var
  Configuracoes: TConfiguracoes = nil;

implementation

procedure TConfiguracoes.LoadSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    {Section: CONFIGURACOES}
    FCONFIGURACOESDATABASE := Ini.ReadString(cCONFIGURACOESSection, cCONFIGURACOESDATABASE, 'TRF5DSV');
    FCONFIGURACOESHOSTNAME := Ini.ReadString(cCONFIGURACOESSection, cCONFIGURACOESHOSTNAME, 'TAMANDARE');
    FCONFIGURACOESPASSWORD := Ini.ReadString(cCONFIGURACOESSection, cCONFIGURACOESPASSWORD, 'ESPARTA2');
    FCONFIGURACOESPROTOCOL := Ini.ReadString(cCONFIGURACOESSection, cCONFIGURACOESPROTOCOL, 'oracle-9i');
    FCONFIGURACOESUSERNAME := Ini.ReadString(cCONFIGURACOESSection, cCONFIGURACOESUSERNAME, 'ESPARTA2');
    FCONFIGURACOESOBJOWNER := Ini.ReadString(cCONFIGURACOESSection, cCONFIGURACOESOBJOWNER, 'ESPARTA2');
  end;
end;

procedure TConfiguracoes.SaveSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    {Section: CONFIGURACOES}
    Ini.WriteString(cCONFIGURACOESSection, cCONFIGURACOESDATABASE, FCONFIGURACOESDATABASE);
    Ini.WriteString(cCONFIGURACOESSection, cCONFIGURACOESHOSTNAME, FCONFIGURACOESHOSTNAME);
    Ini.WriteString(cCONFIGURACOESSection, cCONFIGURACOESPASSWORD, FCONFIGURACOESPASSWORD);
    Ini.WriteString(cCONFIGURACOESSection, cCONFIGURACOESPROTOCOL, FCONFIGURACOESPROTOCOL);
    Ini.WriteString(cCONFIGURACOESSection, cCONFIGURACOESUSERNAME, FCONFIGURACOESUSERNAME);
    Ini.WriteString(cCONFIGURACOESSection, cCONFIGURACOESOBJOWNER, FCONFIGURACOESOBJOWNER);
  end;
end;

procedure TConfiguracoes.LoadFromFile(const FileName: string);
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

procedure TConfiguracoes.SaveToFile(const FileName: string);
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
  Configuracoes := TConfiguracoes.Create;

finalization
  Configuracoes.Free;

end.

