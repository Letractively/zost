// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://www.webservicex.net/CurrencyConvertor.asmx?wsdl
//  >Import : http://www.webservicex.net/CurrencyConvertor.asmx?wsdl:0
// Encoding : utf-8
// Version  : 1.0
// (15/02/2009 23:54:46 - * $Rev: 3108 $)
// ************************************************************************ //

unit CurrencyConvertor;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

//const
//    AS_UNBOUNDED = false;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:double          - "http://www.w3.org/2001/XMLSchema"


  { "http://www.webserviceX.NET/"[GblSmpl] }
  CurrencyID = (
      AFA, 
      ALL, 
      DZD, 
      ARS, 
      AWG, 
      AUD, 
      BSD, 
      BHD, 
      BDT, 
      BBD, 
      BZD, 
      BMD, 
      BTN, 
      BOB, 
      BWP, 
      BRL, 
      GBP, 
      BND, 
      BIF, 
      XOF, 
      XAF, 
      KHR, 
      CAD, 
      CVE, 
      KYD, 
      CLP, 
      CNY, 
      COP, 
      KMF, 
      CRC, 
      HRK, 
      CUP, 
      CYP, 
      CZK, 
      DKK, 
      DJF, 
      DOP, 
      XCD, 
      EGP, 
      SVC, 
      EEK, 
      ETB, 
      EUR, 
      FKP, 
      GMD, 
      GHC, 
      GIP, 
      XAU, 
      GTQ, 
      GNF, 
      GYD, 
      HTG, 
      HNL, 
      HKD, 
      HUF, 
      ISK, 
      INR, 
      IDR, 
      IQD, 
      ILS, 
      JMD, 
      JPY, 
      JOD, 
      KZT, 
      KES, 
      KRW, 
      KWD, 
      LAK, 
      LVL, 
      LBP, 
      LSL, 
      LRD, 
      LYD, 
      LTL, 
      MOP, 
      MKD, 
      MGF, 
      MWK, 
      MYR, 
      MVR, 
      MTL, 
      MRO, 
      MUR, 
      MXN, 
      MDL, 
      MNT, 
      MAD, 
      MZM, 
      MMK, 
      NAD, 
      NPR, 
      ANG, 
      NZD, 
      NIO, 
      NGN, 
      KPW, 
      NOK, 
      OMR, 
      XPF, 
      PKR, 
      XPD, 
      PAB, 
      PGK, 
      PYG, 
      PEN, 
      PHP, 
      XPT, 
      PLN, 
      QAR, 
      ROL, 
      RUB, 
      WST, 
      STD, 
      SAR, 
      SCR, 
      SLL, 
      XAG, 
      SGD, 
      SKK, 
      SIT, 
      SBD, 
      SOS, 
      ZAR, 
      LKR, 
      SHP, 
      SDD, 
      SRG, 
      SZL, 
      SEK, 
      CHF, 
      SYP, 
      TWD, 
      TZS, 
      THB, 
      TOP, 
      TTD, 
      TND, 
      TRL, 
      USD, 
      AED, 
      UGX, 
      UAH, 
      UYU, 
      VUV, 
      VEB, 
      VND, 
      YER, 
      YUM, 
      ZMK, 
      ZWD, 
      TRY_
);


  // ************************************************************************ //
  // Namespace : http://www.webserviceX.NET/
  // soapAction: http://www.webserviceX.NET/ConversionRate
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : CurrencyConvertorSoap
  // service   : CurrencyConvertor
  // port      : CurrencyConvertorSoap
  // URL       : http://www.webservicex.net/CurrencyConvertor.asmx
  // ************************************************************************ //
  CurrencyConvertorSoap = interface(IInvokable)
  ['{A1817D10-F9A2-B6F6-30E2-8FFB22ABBD60}']
    function  ConversionRate(const FromCurrency: CurrencyID; const ToCurrency: CurrencyID): Double; stdcall;
  end;

function GetCurrencyConvertorSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): CurrencyConvertorSoap;

implementation

uses SysUtils;

function GetCurrencyConvertorSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): CurrencyConvertorSoap;
const
  defWSDL = 'http://www.webservicex.net/CurrencyConvertor.asmx?wsdl';
  defURL  = 'http://www.webservicex.net/CurrencyConvertor.asmx';
  defSvc  = 'CurrencyConvertor';
  defPrt  = 'CurrencyConvertorSoap';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as CurrencyConvertorSoap);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  InvRegistry.RegisterInterface(TypeInfo(CurrencyConvertorSoap), 'http://www.webserviceX.NET/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(CurrencyConvertorSoap), 'http://www.webserviceX.NET/ConversionRate');
  InvRegistry.RegisterInvokeOptions(TypeInfo(CurrencyConvertorSoap), ioDocument);
  RemClassRegistry.RegisterXSInfo(TypeInfo(CurrencyID), 'http://www.webserviceX.NET/', 'Currency');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(CurrencyID), 'TRY_', 'TRY');

end.