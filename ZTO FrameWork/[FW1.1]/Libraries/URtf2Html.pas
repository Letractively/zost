unit URtf2Html;
{  ************************************************************************  }
{                                                                            }
{  RTF2HTML V 2.1                                                            }
{  by hr                                                                     }
{  last change:  15-07-98                                                    }
{                                                                            }
{  Diese Version sollte weniger komplexe RTF-Files fehlerfrei bzw.           }
{  komplexere RTF-Files layoutm��ig weitestgehend korrekt �bersetzen k�nnen  }
{                                                                            }
{  Aufruf-Parameter:                                                         }
{                                                                            }
{  -  'optimize'                                                             }
{     eliminiert �berfl�ssige HTML-Tags wie zb. '<B></B>' oder </SUB><SUB>   }
{  -  'onlyDefiniteOpt'                                                      }
{     sorgt daf�r, das Strings wie '</FONT><FONT FACE="Arial">' NICHT        }
{     wegoptimiert werden, da das schlie�ende </FONT>-Tag u.u. eine andere   }
{     Anweisung als <FONT FACE="Arial"> hier im Beispiel deaktivieren        }
{     k�nnte                                                                 }
{  -  'noFonts'                                                              }
{     deaktiviert alle <FONT FACE="...">-Anweisungen                         }
{                                                                            }
{  Folgendes wird, so weit im HTML 3 m�glich, �quivalent �bersetzt:          }
{                                                                            }
{  -  Stylesheets im allgemeinen (flie�t in die spezifischen Zeilen-         }
{     Formatierungen mit ein)                                                }
{  -  bold, italic, underline, strikethrough, subscript, superscript         }
{  -  center, left/right justified                                           }
{  -  Aufz�hlungen aller Arten                                               }
{  -  left indents (mittels <UL>-Schachtelungen)                             }
{  -  Zeilenumbruch/Absatz                                                   }
{  -  etwaige Farb-/Schriftart-/Schriftgr��e-Formatierungen                  }
{  -  Sonderzeichen ( ' " <   usw.)                                          }
{  -  Tabellen                                                               }
{                                                                            }
{  Folgendes kann Fehler bzw. unerw�nschte Ergebnisse verursachen            }
{  (known 'bugs'):                                                           }
{                                                                            }
{  -  Der Aufrufparameter 'optimize' bewirkt, da� auch Zeichenketten wie     }
{     '</FONT><FONT FACE="Arial">' gnadenlos wegoptimiert werden kann, was   }
{     leicht in Formatierungs-Fehlern (NICHT HTML-Syntax-Fehlern) enden      }
{     kann; Abhilfe: Parameter 'onlyDefiniteOpt'                             }
{  -  �bernahme von Text-Formatierungen in eine Tabelle, wenn eine solche    }
{     beginnt, was in RTF rein theoretisch m�glich ist, findet NICHT statt   }
{     GRUND:   1. werden beim Beginn einer Tabelle normalerweise ohnehin     }
{                 alle Text-Formatierungen zur�ckgesetzt                     }
{              2. m��te man eine 'mitgeschleifte' Formatierung in einer      }
{                 HTML-Tabelle Feld f�r Feld neu setzen und am Feld-Ende     }
{                 wieder l�schen  --->  das ausgespuckte HTML-File wird      }
{                 **SEHR** gro�                                              }
{  -  Aufz�hlungen in Tabellenfeldern (soll's ja auch geben) werden nur      }
{     mit Pseudo-Tabs und &middot's �bersetzt (ohne <UL>, <LI>)              }
{  -  wenig sinnvolle RTF-Dokumente mit Punkten im Inhaltsverzeichnis,       }
{     zu denen keine entsprechende �berschrift existiert verursachen         }
{     HTML-Dokumente mit Phantasie-Referenzen                                }
{                                                                            }
{  Folgendes wird in der vorliegenden Version ignoriert:                     }
{                                                                            }
{  -  Kopf-/Fu�zeile                                                         }
{  -  File Tables                                                            }
{  -  Bilder  (Text-Hinweis wird im Html-Dokument angezeigt)                 }
{  -  bestimmte rtf-spezifische Formatierungen                               }
{  -  Dokument-Infos                                                         }
{                                                                            }
{  ************************************************************************  }
{  History:                                                                  }
{                                                                            }
{  V 1.0:  - erste offizielle Version                                        }
{                                                                            }
{  V 1.1:  - Bug in IgnoreGroup() entfernt (Index binind wurde nicht erh�ht) }
{          - Function empty() zum Leeren der Stacks                          }
{          - �nderung bei der Behandlung von Gruppen-Enden                   }
{          - �nderung bei der Darstellung von Bullet-Listen                  }
{                                                                            }
{  V 1.2:  - �bersetzung von Tabellen (neue Prozedur ProcessTable() )        }
{          - erweiterte Sonderzeichen-Behandlung                             }
{          - Aufz�hlungen/Listen werden jetzt als Symbol+Text nach HTML      }
{            konvertiert (ohne <UL> bzw. <OL>-Tags)                          }
{          - kleine Layout-Bereinigungen                                     }
{                                                                            }
{  V 1.3:  - �nderung bei der Behandlung von Gruppen-Anf�ngen (neue Pro-     }
{            zeduren CopyStack(), CopyAttrib() )                             }
{          - neue Prozedur htmlchar() zur korrekten Ausgabe von Dokument-    }
{            Text                                                            }
{          - Bug in chfmt() entfernt (in einzelnen F�llen wurden Format-     }
{            Flags falsch gesetzt)                                           }
{                                                                            }
{  V 2.0:  - Einbindung von Stylesheets (neue Procedures initstyles(),       }
{            plainchar() )                                                   }
{          - Inhaltsverzeichnis/�berschrift-Verweis-Strukturen werden        }
{            in HTML-Sprungmarken umgewandelt                                }
{          - W�rter, die mit 'http://' beginnen, werdem automatisch in       }
{            Hyperlinks umgewandelt (neue Prozedur incl_hlink() )            }
{          - Aufz�hlungen (auch geschachtelt) werden als entsprechend        }
{            strukturierte <UL>'s nach HTML konvertiert                      }
{          - verbesserte HTML-Code-Optimierfunktion                          }
{          - neue Procedures addfontname(), addcolstr(), add_ks() zur        }
{            Unterst�tzung von optim()                                       }
{          - Aufrufparameter f�r rtf2html() zum Variieren der Konvertier-    }
{            Vorgangsweisen                                                  }
{          - Globale Liste von 'left indents', womit Einz�ge bei Auf-        }
{            z�hlungen im RTF-Doc. in (halbwegs) entsprechend tiefe          }
{            <UL>-Schachtelungen umgewandelt werden                          }
{          - diverse kleine Layout-�nderungen                                }
{                                                                            }
{  V 2.1:  - �berarbeiteter Formatierungs-Algorithmus                        }
{          - alle left indents werden nun mittels <UL>-Schachtelungen,       }
{            so weit m�glich, �bersetzt                                      }
{                                                                            }
{  ************************************************************************  }
interface

uses
    SysUtils, Windows, ComCtrls;

type
    TExtraParam = (epNoFonts,epOptimize,epOnlyDefiniteOpt,epHTMLBlockOnly);
    TExtraParams = set of TExtraParam;

type
    TTextFormat = record
        Invisible: Boolean;                { versteckter Text }
        CapsLock: Boolean;                 { Blockschrift }
        Bold: Boolean;                 { fett }
        Italic: Boolean;               { kursiv }
        Underline: Boolean;            { unterstrichen }
        SuperScript: Boolean;          { hochgestellt }
        SubScript: Boolean;            { tiefgestellt }
        Strike: Boolean;               { durchgestrichen }
        FontNumber: SmallInt;                 { Schriftart }
        FontColor: String;                  { Text-Fabe }
        FontSize: SmallInt;                { Text-Gr��e }
        RightJustified: Boolean;           { rechtsb�ndig }
        FullyJustified: Boolean;
        Centered: Boolean;             { zentriert }
        Table: Integer;                { Tabelle }
    end;

    PTag = ^TTag;     { der Formatierungs-Stack }
    TTag = record
        OpenTag: ShortString; { carlos - era string }
        CloseTag: ShortString; { carlos - era string}
        NextTag: PTag;
    end;

    TRtf2Html = class
    private
        FRichText: String;
        FImagesDir: String;
        function ReplaceAll(aSrcStr: String; const aOldPatterns, aNewPatterns: array of String): String;
        function OptimizeHtml(aSrcStr: String): String;
        function ClearHTML(const aHTML: String): String;
        procedure WriteHtml(const txt: string; var outstring: string; var outfile: textfile);
        function optStyle(basestyle, actstyle: string): string;
        procedure CloseLists(var aOutputString: string; var aOutputFile: textfile);
        procedure InitializeStylesSheets(var aInputFile, aOutputFile: textfile; var aSource: string);
        procedure ProcessTable(var infile, outfile: textfile; var line: string);
        procedure ProcessGroup(var infile, outfile: textfile; var line: string; var attrib: TTextFormat);
        procedure ConvertFile(const aSrcFilename, aDestFilename: TFileName; aExtraParams: TExtraParams);
        procedure MakeColorTable(var infile, outfile: textfile; var src: string);
        procedure MakeFontTable(var infile, outfile: textfile; var src: string);
        procedure IgnoreGroup(var line: string; var infile: textfile);
        function LineAt(const index: integer; const line: string; var infile: textfile): string;
        function html(const ctrlword: string; var aTextFormat: TTextFormat): string;
        function plainchar(ch: string): string;
        function htmlchar(ch: string; aTextFormat: TTextFormat): string;
        function createFTags(aTextFormat: TTextFormat): string;
        procedure PopTagFromStack(var aTagStack: PTag);
        function EmptyTagStack(var aTagStack: PTag): string;
        procedure PushTagIntoStack(var aTagStack: PTag; aOpenTag, aCloseTag: ShortString);
        procedure CopyTextFormat(var aDestination: TTextFormat; aSource: TTextFormat);
        function GetFontName(var aFontNumber: SmallInt): string;
        function CompareTextFormats(TextFormat1, TextFormat2: TTextFormat): boolean;
        procedure ResetFormat(var attrib: TTextFormat; const kind: string);
        function HtmlColorFromRtfColor(rtfcol: string): string;
        procedure cut_tag(rtf_tag: string; var line: string);
        procedure AddFontName(fname: string);
        procedure AddFontColor(colstr: string);
        function Decimal2Hexadecimal(num: integer): string;
        function Hexadecimal2Decimal(hex: string): integer;
        procedure incl_hlink(var line: string);
        procedure InitInvalidString;
        procedure PushInvalidString(aInvalidString: string);
        function HTMLFontSize(aFontSize: SmallInt): ShortString;
        function HTMLFontColor(aFontColor: ShortString): ShortString;
        function HTMLFontFamily(aFontNumber: SmallInt): ShortString;
        procedure ReplaceSpecialTags(var aText: String);
        function GetHyperText: String;
    public
        property ImagesDir: String write FImagesDir;
        function GetRtfCode(aRichEdit: TRichEdit): String;
        property RichText: String read FRichText write FRichText;
        property HyperText: String read GetHyperText;
    end;

implementation

uses
    Classes, StrUtils;

const                               { Pseudo-enum f�r Tabellen-Behandlung }
    plain : integer = 0;
    in_cell : integer = 1;
    cell_end : integer = 2;
    row_end : integer = 3;


    fontsOpt : integer = 3;         { Die ersten <fontsOpt> Schriftarten in der font table werden bei Redundanz }
                                    { im HTML-Code wegoptimiert (sofern Flag 'optimize' gesetzt ist)            }

    ul_indent : integer = 285;      { left indent wird in (left indent DIV ul_indent) <UL>s umgewandelt       }
                                    { je kleiner dieser Wert ist, desto feiner sind die Level-Unterteilungen, }
                                    { aber es werden auch umso mehr <UL>s pro Einzug generiert                } 

type
    TFontFace = record
        FontFace: ShortString;
        Number: SmallInt;
    end;

    PInvalidString = ^TInvalidString;
    TInvalidString = record
        InvalidStr: string;
        NextInvalidString: PInvalidString;
    end;

    TListLevelInfo = record
        DocumentLevel: Integer;
        ListLevel: Integer;
        Indent: array[0..20] of Integer;
    end;

    TStyleSheet = record
        name: string;
        ctrl: string;
    end;

    TConvertionFlags = record
        NoFonts: Boolean;
        Optimize: Boolean;
        OnlyDefiniteOpt: Boolean;
    end;

var
    ConvertionFlags : TConvertionFlags;
    stylesheet : array [0..300] of TStyleSheet;
    InvalidString : PInvalidString;
    col : TStringList;
    FontFaces : array[0..200] of TFontFace;
    linkstyles, anchstyles, actlinknum, actanchnum : array [1..9] of integer;

    OutputString, pntxta, pntxtb, enumtxt, txtwait : string;
    bkmkpar, lastline, li_open, listitem, listbull, pnnum, nextpar, enumdigit : boolean;
    ahref, anchor, ahrefwait, newhrefnum, no_newind : boolean;

    changefmt : boolean;
    TagStack : PTag;

    anchlvl, indexlvl, lastindent, lvlnum, globbrk : integer;

    ListLevelInfo : TListLevelInfo;

procedure TRtf2Html.PushInvalidString(aInvalidString: string);
var
    NewInvalidString : PInvalidString;
begin
    New(NewInvalidString);
    NewInvalidString^.InvalidStr := aInvalidString;
    NewInvalidString^.NextInvalidString := InvalidString;
    InvalidString := NewInvalidString;
end;

{ Inicializar a pilha de strings que s�o vari�veis e s�o inv�lidas. killstr ser�
varrida na otimiza��o e cada uma das ocorr�ncias ser� removida }
procedure TRtf2Html.InitInvalidString;
begin
    InvalidString := nil;
end;

{  ************************************************************************  }

procedure TRtf2Html.incl_hlink (var line: string);
var
   helpstr, htxt, str : string;
   h, h_end, strlen : integer;

begin
    str := line;

    h := Pos('http://', str);
    helpstr := '';

    while h > 0 do
    begin
        h_end := h + 7;
        strlen := length(str);

        while (str[h_end] <> '<')
        and (str[h_end] <> ' ')
        and (str[h_end] <> ',')
        and (h_end <= strlen) do
            Inc(h_end);

        htxt    := Copy(str, h, h_end-h);
        helpstr := helpstr + Copy(str, 1, h-1) + '<A HREF="' + htxt + '">' + htxt + '</A>';
        str     := Copy(str, h_end, length(str));

        h := Pos('http://', str);
    end;

    line := helpstr + str;
end;

{  ************************************************************************  }

{  ************************************************************************  }

function TRtf2Html.Hexadecimal2Decimal (hex: string): integer;  { hexadezimal -> dezimal - Konvertierung f�r Zahlen <= 255 }
var
    i : integer;

begin
    Result := 0;
    for i := 1 to 2 do
        if (hex[i] = 'A') or (hex[i] = 'a') then Result := Result*16 + 10
        else if (hex[i] = 'B') or (hex[i] = 'b') then Result := Result*16 + 11
        else if (hex[i] = 'C') or (hex[i] = 'c') then Result := Result*16 + 12
        else if (hex[i] = 'D') or (hex[i] = 'd') then Result := Result*16 + 13
        else if (hex[i] = 'E') or (hex[i] = 'e') then Result := Result*16 + 14
        else if (hex[i] = 'F') or (hex[i] = 'f') then Result := Result*16 + 15
        else Result := Result*16 + strtoint(hex[i]);
end;

{  ************************************************************************  }

function TRtf2Html.Decimal2Hexadecimal (num: integer): string;  { dezimal -> hexadezimal - Konvertierung f�r Zahlen <= 255 }
var
    hex : string;
    digit : integer;
begin
    hex := '';
    digit := num div 16;

    while length(hex) < 2 do
    begin
        if digit <= 9 then
            hex := hex + inttostr(digit)
        else if digit = 10 then
            hex := hex + 'A'
        else if digit = 11 then
            hex := hex + 'B'
        else if digit = 12 then
            hex := hex + 'C'
        else if digit = 13 then
            hex := hex + 'D'
        else if digit = 14 then
            hex := hex + 'E'
        else if digit = 15 then
            hex := hex + 'F';

        digit := num mod 16;
    end;

    Result := hex;
end;

{  ************************************************************************  }

procedure TRtf2Html.AddFontColor (colstr: string);
var
    str : string;

begin
    str := '<SPAN STYLE="color: ' + colstr + '"></SPAN>';
    PushInvalidString(str);
end;

{  ************************************************************************  }

procedure TRtf2Html.AddFontName (fname: string);
var
    str : string;

begin
    str := '<SPAN STYLE="font-family: ' + fname + '"></SPAN>';

    PushInvalidString(str);

    if not ConvertionFlags.OnlyDefiniteOpt then                    { das kann u.u. ins Auge gehen, optimiert aber sehr gut }
    begin                                                          { vor allem bei <UL>'s                                  }
        str := '</SPAN><SPAN STYLE="font-family: ' + fname + '">'; { das </FONT> zu Beginn k�nnte aber von einer anderen   }
        PushInvalidString(str);                                    { Formatierung als <FONT FACE = "fname"> stammen        }
    end;
end;
{  ************************************************************************  }

function TRtf2Html.HTMLFontSize (aFontSize: SmallInt): ShortString;  { liefert den html-Code f�r die angegebene neue Schrift-Gr��e }
begin
    Result := Format('<SPAN STYLE="font-size: %upt">',[aFontSize]);
    PushInvalidString(Result + '</SPAN>');
end;

function TRtf2Html.HTMLFontFamily (aFontNumber: SmallInt): ShortString;
begin
    Result := Format('<SPAN STYLE="font-family: %s">',[GetFontName(aFontNumber)]);
    PushInvalidString(Result + '</SPAN>');
end;

function TRtf2Html.HTMLFontColor (aFontColor: ShortString): ShortString;
begin
    Result := Format('<SPAN STYLE="color: %s">',[aFontColor]);
    PushInvalidString(Result + '</SPAN>');
end;

{  ************************************************************************  }

procedure TRtf2Html.cut_tag (rtf_tag : string; var line : string);     { verk�rzt Stylesheet-Strings }
var
    i, strlen : integer;
    act_tag : string;

begin
    i := Pos(rtf_tag, line);
    while i > 0 do
    begin
        strlen := length(line);
        act_tag := rtf_tag;
        Inc(i, length(rtf_tag));

        while (line[i] <> '\') and (line[i] <> ' ') and (i <= strlen) do
        begin
            act_tag := act_tag + line[i];
            Inc(i);
        end;

        line := StringReplace(Line,act_tag, '',[rfReplaceAll]);
        i := Pos(rtf_tag, line);
    end;
end;

function TRtf2Html.HtmlColorFromRtfColor (rtfcol: string): string;  { wandelt rft-Farbangabe in html-Farbangabe um }
var
    red_ind, green_ind, blue_ind : integer;
    redstr, greenstr, bluestr, colstr : string;
    red, green, blue : integer;

begin
    redstr := '';
    greenstr := '';
    bluestr := '';

    red_ind := pos('red',rtfcol)+3;
    green_ind := pos('green',rtfcol)+5;
    blue_ind := pos('blue',rtfcol)+4;

    while (rtfcol[red_ind] in ['0'..'9']) and (red_ind <= length(rtfcol)) do
    begin
        redstr := redstr + rtfcol[red_ind];
        Inc(red_ind);
    end;
    try
       red := strtoint(redstr);
    except
       on EConvertError do red := 0;
    end;
    redstr := Decimal2Hexadecimal(red);

    while (rtfcol[green_ind] in ['0'..'9']) and (green_ind <= length(rtfcol)) do
    begin
        greenstr := greenstr + rtfcol[green_ind];
        Inc(green_ind);
    end;
    try
       green := strtoint(greenstr);
    except
       on EConvertError do green := 0;
    end;
    greenstr := Decimal2Hexadecimal(green);

    while (rtfcol[blue_ind] in ['0'..'9']) and (blue_ind <= length(rtfcol)) do
    begin
        bluestr := bluestr + rtfcol[blue_ind];
        Inc(blue_ind);
    end;
    try
       blue := strtoint(bluestr);
    except
       on EConvertError do blue := 0;
    end;
    bluestr := Decimal2Hexadecimal(blue);

    colstr := '#'+redstr+greenstr+bluestr;
    Result := colstr;
end;

{  ************************************************************************  }

procedure TRtf2Html.ResetFormat (var attrib: TTextFormat; const kind: string);  { setzt intern gespeicherte Formatierungen zur�ck }
begin
    with attrib do
    begin
        if (kind = 'text') or (kind = 'all') then
        begin
            Invisible := false;
            CapsLock := false;
            Bold := false;
            Italic := false;
            Underline := false;
            SuperScript := false;
            SubScript := false;
            Strike := false;
            FontNumber:= -1;
            FontColor:= 'none';
            FontSize:= -1;
        end;
        if (kind = 'par') or (kind = 'all') then
        begin
            RightJustified := False;
            FullyJustified := False;
            Centered := False;
        end;
        if (kind = 'all') then
            Table := 0;
    end;
end;

{  ************************************************************************  }
{ compara dois formatos e retorna true se eles s�o diferentes }
function TRtf2Html.CompareTextFormats(TextFormat1: TTextFormat;
                                      TextFormat2: TTextFormat): Boolean;  { vergleicht zwei Format-Records }
begin
    Result := (TextFormat1.Invisible <> TextFormat2.Invisible)
           or (TextFormat1.Bold <> TextFormat2.Bold)
           or (TextFormat1.Italic <> TextFormat2.Italic)
           or (TextFormat1.Underline <> TextFormat2.Underline)
           or (TextFormat1.SuperScript <> TextFormat2.SuperScript)
           or (TextFormat1.SubScript <> TextFormat2.SubScript)
           or (TextFormat1.Strike <> TextFormat2.Strike)
           or (TextFormat1.FontNumber <> TextFormat2.FontNumber)
           or (TextFormat1.FontColor <> TextFormat2.FontColor)
           or (TextFormat1.FontSize <> TextFormat2.FontSize)
           or (TextFormat1.RightJustified <> TextFormat2.RightJustified)
           or (TextFormat1.Centered <> TextFormat2.Centered)
           or (TextFormat1.FullyJustified <> TextFormat2.FullyJustified);
end;

{  ************************************************************************  }

function TRtf2Html.GetFontName (var aFontNumber: SmallInt): string;
var
    i : integer;
begin
    i := 0;
    while (FontFaces[i].Number <> aFontNumber) and (i < high(FontFaces)) do Inc(i);

    if i > high(FontFaces) then           { sollte eigentlich nicht vorkommen..... }
    begin
        aFontNumber := FontFaces[high(FontFaces)].Number;
        Result := FontFaces[high(FontFaces)].FontFace;
    end
    else
        Result := FontFaces[i].FontFace;
end;

{  ************************************************************************  }

procedure TRtf2Html.CopyTextFormat(var aDestination: TTextFormat;
                                       aSource: TTextFormat);
begin
    aDestination.Invisible := aSource.Invisible;
    aDestination.CapsLock := aSource.CapsLock;
    aDestination.Bold := aSource.Bold;
    aDestination.Italic := aSource.Italic;
    aDestination.Underline := aSource.Underline;
    aDestination.SuperScript := aSource.SuperScript;
    aDestination.SubScript := aSource.SubScript;
    aDestination.Strike := aSource.Strike;
    aDestination.FontNumber := aSource.FontNumber;
    aDestination.FontColor := aSource.FontColor;
    aDestination.FontSize := aSource.FontSize;
    aDestination.RightJustified := aSource.RightJustified;
    aDestination.Centered := aSource.Centered;
    aDestination.FullyJustified := aSource.FullyJustified;
  {  aDestination.table := aSource.table;}
end;

{  ************************************************************************  }

procedure TRtf2Html.PushTagIntoStack(var aTagStack: PTag;
                                         aOpenTag: ShortString;
                                         aCloseTag: ShortString);
var                             { neue Formatierung auf den Stack ..... }
    ptr : PTag;
begin
    New(ptr);
    ptr^.OpenTag := aOpenTag;
    ptr^.CloseTag := aCloseTag;
    ptr^.NextTag := aTagStack;
    aTagStack := ptr;
end;

{  ************************************************************************  }
{ Remove um tag da pilha}
procedure TRtf2Html.PopTagFromStack(var aTagStack: PTag);
var                             { oberste Formatierung vom Stack entfernen }
    ptr : PTag;
begin
    ptr := aTagStack;
    aTagStack := aTagStack^.NextTag;
    Dispose(ptr);
end;

{  ************************************************************************  }
{ Esvazia a pilha criando como resultado uma string com os tags de fechamento }
function TRtf2Html.EmptyTagStack(var aTagStack: PTag): string;
begin
    Result := '';
    while (aTagStack <> nil) do
    begin
        { carlos - removi as coisas inuteis }
//        if copy(stk^.CloseTag,1,6) = '</FONT' then
//            Result := Result + '</FONT>'
//        else
            Result := Result + aTagStack^.CloseTag;
        PopTagFromStack(aTagStack);
    end;
end;

{  ************************************************************************  }

function TRtf2Html.createFTags (aTextFormat: TTextFormat): string;
begin
    Result := '';
    
    with aTextFormat do
    begin
        if Bold then
        begin
            PushTagIntoStack(TagStack, '<B>', '</B>');
            Result := Result + '<B>';
        end;

        if Italic then
        begin
            PushTagIntoStack(TagStack, '<I>', '</I>');
            Result := Result + '<I>';
        end;

        if Underline then
        begin
            PushTagIntoStack(TagStack, '<U>', '</U>');
            Result := Result + '<U>';
        end;

        if SubScript then
        begin
            PushTagIntoStack(TagStack, '<SUB>', '</SUB>');
            Result := Result + '<SUB>';
        end;

        if SuperScript then
        begin
            PushTagIntoStack(TagStack, '<SUP>', '</SUP>');
            Result := Result + '<SUP>';
        end;

        if Strike then
        begin
            PushTagIntoStack(TagStack, '<S>', '</S>');
            Result := Result + '<S>';
        end;

        if FontColor <> 'none' then
        begin
            PushTagIntoStack(TagStack, HTMLFontColor(FontColor), '</SPAN>');
            Result := Result + HTMLFontColor(FontColor);
        end;

        if FontNumber > -1 then
        begin
            PushTagIntoStack(TagStack, HTMLFontFamily(FontNumber), '</SPAN>');
            Result := Result + HTMLFontFamily(FontNumber);
        end;
        
        if FontSize > -1 then
        begin
            PushTagIntoStack(TagStack, HTMLFontSize(FontSize), '</SPAN>');
            Result := Result + HTMLFontSize(FontSize);
        end;
    end;
end;

{  ************************************************************************  }

function TRtf2Html.htmlchar(ch: string; aTextFormat: TTextFormat): string;
var
    ltr : char;
    curlink, curanch : string;

begin
    Result := '';

    if changefmt then
        Result := Result + EmptyTagStack(TagStack);

    if nextpar then
    begin
        if aTextFormat.Centered then
            Result := Result + '<DIV ALIGN="CENTER">'
        else if aTextFormat.RightJustified then
            Result := Result + '<DIV ALIGN="RIGHT">'
        else if aTextFormat.FullyJustified then
            Result := Result + '<DIV ALIGN="JUSTIFY">'
    end;

    if changefmt or nextpar then
    begin
        Result := Result + CreateFTags(aTextFormat);
    end;

    ListLevelInfo.DocumentLevel := globbrk;
    nextpar := false;        { wir sind nicht mehr am Beginn eines neuen Absatzes }
    changefmt := false;

    if ahrefwait then
    begin
        if newhrefnum then        { jetzt wird's Zeit, eine Referenz zu setzen }
        begin
            ahref := true;
            newhrefnum := false;
            Inc(actlinknum[indexlvl]);
            curlink := inttostr(indexlvl) + '-' + inttostr(actlinknum[indexlvl]);
            Result := Result + '<A HREF="#' + curlink + '">';
        end;
    end;

    if anchor then
    begin                         { jetzt kommt eine Sprungmarke }
        Inc(actanchnum[anchlvl]);
        curanch := inttostr(anchlvl) + '-' + inttostr(actanchnum[anchlvl]);
        Result := Result + '<A NAME="' + curanch + '">';
    end;

    if not aTextFormat.Invisible then
    begin
        if length(ch) = 1 then
        begin
            ltr := ch[1];
            if ltr = '<' then
                Result := Result + '&lt;'
            else if ltr = '>' then
                Result := Result + '&gt;'
            else if ltr = '&' then
                Result := Result + '&amp;'
            else
                if ltr in ['a'..'z'] then
                begin
                    if aTextFormat.CapsLock then
                        Result := Result + UpperCase(ltr)
                    else
                        Result := Result + ltr;
                end
                else
                    Result := Result + ltr;
        end
        else if (length(ch) = 2) then
        begin
            if ch = 'c4' then Result := Result + '&Auml;'           { '�' }
            else if ch = 'd6' then Result := Result + '&Ouml;'      { '�' }
            else if ch = 'dc' then Result := Result + '&Uuml;'      { '�' }
            else if ch = 'e4' then                         { '�' }
            begin
                if aTextFormat.CapsLock then
                    Result := Result + '&Auml;'
                else
                    Result := Result + '&auml;';
            end
            else if ch = 'f6' then                         { '�' }
            begin
                if aTextFormat.CapsLock then
                    Result := Result + '&Ouml;'
                else
                    Result := Result + '&ouml;';
            end
            else if ch = 'fc' then                         { '�' }
            begin
                if aTextFormat.CapsLock then
                    Result := Result + '&Uuml;'
                else
                    Result := Result + '&uuml;';
            end
            else if ch = 'df' then Result := Result + '&szlig;'     { '�' }
            else if ch = 'b7' then Result := Result + '&middot;'    { Aufz�hlungs-Punkt }
            else Result := Result + chr(Hexadecimal2Decimal(ch));
        end { if length(ch) = 1 ... }
        else
        begin
            if ch = '&pict;' then
                Result := Result + '<P>[*** picture ***]</P>'     { Graphik-Substitut}
            else if (Pos('&&', ch) = 1) then
                Result := Result + Copy(ch, 3, length(ch)-2)     { Aufz�hlungstext }
            else if ch = '&tab;' then
                Result := Result + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
            else if ch = '&quote;' then
                Result := Result + #39
            else if ch = '&dblquote;' then
                Result := Result + #34
            else if ch = '&emspace;' then
                Result := Result + '&nbsp;&nbsp;'
            else if ch = '&enspace;' then
                Result := Result + '&nbsp;'
            else if ch = '&emdash;' then
                Result := Result + '--'
            else if ch = '&endash;' then
                Result := Result + '-'
            else if ch = '&nbsp;' then
                Result := Result + ch;                           { nonbreaking space }
        end;
    end
    else  { hidden text }
        Result := Result + '';

    if anchor then
    begin
        Result := Result + '</A>';
        anchor := false;
    end;
end;

{  ************************************************************************  }

function TRtf2Html.plainchar(ch: string): string;
begin
    if ch = 'c4' then Result := '�'
    else if ch = 'd6' then Result := '�'
    else if ch = 'dc' then Result := '�'
    else if ch = 'e4' then Result := '�'
    else if ch = 'f6' then Result := '�'
    else if ch = 'fc' then Result := '�'
    else if ch = 'df' then Result := '�'
    else Result := chr(Hexadecimal2Decimal(ch));
end;

{  ************************************************************************  }
{$WARNINGS OFF}
function TRtf2Html.html (const ctrlword: string; var aTextFormat: TTextFormat): string;
var                                      { fri�t rtf-Kontrollwort & spuckt entsprechenden html-Code aus }
    num : integer;
    txt : string;

begin
    Result := '';

    if (ctrlword = 'plain') or (ctrlword = 'pard') or (ctrlword = 'sectd') then         { alle Formatierungen deaktivieren }
    begin
        if (ctrlword = 'plain') then
        begin
            ResetFormat(aTextFormat, 'text');
            changefmt := true;
            if TagStack <> NIL then
                Result := Result + EmptyTagStack(TagStack);
        end;

        if (ctrlword = 'pard') or (ctrlword = 'sectd') then      { neue Absatz-Formatierung }
        begin
            ResetFormat(aTextFormat, 'par');

            enumtxt := '';
            txtwait := '';
            ahrefwait := false;
            lastindent := 0;
            no_newind := true;
            li_open := false;
            listbull := false;
            enumdigit := false;
            pnnum := false;
            lvlnum := -1;

          {  if listitem then
                Result := Result + '</LI>'; }

            while ListLevelInfo.ListLevel > 0 do
            begin
                Dec(ListLevelInfo.ListLevel);
                txt := txt + '</UL>';
            end;
            listitem := false;
        end;

        if txt <> '' then Result := Result + txt;
    end

    else if ctrlword = 'v' then          { versteckter Text }
        aTextFormat.Invisible := true

    else if ctrlword = 'v0' then
        aTextFormat.Invisible := false

    else if ctrlword = 'caps' then       { Blockschrift }
        aTextFormat.CapsLock := true

    else if ctrlword = 'caps0' then
        aTextFormat.CapsLock := false

    else if ctrlword = 'tab' then                         { Tabulator }
    begin                                                 { Notl�sung }
        if not aTextFormat.Invisible then Result := Result + htmlchar('&tab;', aTextFormat);
    end

    else if ctrlword = 'qc' then       { Formatierung: zentriert }
    begin
        if not aTextFormat.Centered then
        begin
            aTextFormat.Centered := true;
        end;
    end

    else if ctrlword = 'qr' then       { Formatierung: rechtsb�ndig }
    begin
        if not aTextFormat.RightJustified then
        begin
            aTextFormat.RightJustified := true;
        end;
    end

    else if ctrlword = 'qj' then       { Paragrafo justificado }
    begin
        if not aTextFormat.FullyJustified then
        begin
            aTextFormat.FullyJustified := true;
        end;
    end

    else if (ctrlword = 'par') or (ctrlword = 'sect') then      { neuer Absatz }
    begin
        Result := Result + EmptyTagStack(TagStack);

        if aTextFormat.RightJustified or aTextFormat.Centered or aTextFormat.FullyJustified then
            Result := Result + '</DIV>';

        changefmt := true;
        newhrefnum := true;
        nextpar := true;

        if listitem then
        begin
            Result := Result + '</LI>';
            li_open := true;
        end
        else
        begin
            if Result = '</DIV>' then
                Result := '<BR>'
            else if not (aTextFormat.RightJustified or aTextFormat.Centered or aTextFormat.FullyJustified) then
                Result := Result + '<BR>';

            if lvlnum > -1 then
            begin
                Inc(lvlnum);
                enumtxt := pntxtb + inttostr(lvlnum) + pntxta;
            end;
            bkmkpar := false;
        end;
    end

    else if (ctrlword = 'line') then      { Zeilenumbruch }
    begin
        Result := Result + '<BR>';
    end

    else if (ctrlword = 'page')then       { Seitenumbruch }
    begin
        Result := Result + '<BR><HR><BR>';
    end

    else if (ctrlword = 'emdash') then      { langer Gedankenstrich }
    begin
        if not aTextFormat.Invisible then Result := Result + htmlchar('&emdash;', aTextFormat);
    end

    { das hier mu� ALLES von htmlchar �bernommen werden }

    else if (ctrlword = 'endash') then      { kurzer Gedankenstrich }
    begin
        if not aTextFormat.Invisible then Result := Result + htmlchar('&endash;', aTextFormat);
    end

    else if (ctrlword = 'emspace') then      { langer Zwischenraum }
    begin
        if not aTextFormat.Invisible then Result := Result + htmlchar('&emspace;', aTextFormat);
    end

    else if (ctrlword = 'enspace') then      { kurzer Zwischenraum }
    begin
        if not aTextFormat.Invisible then Result := Result + htmlchar('&enspace;', aTextFormat);
    end

    else if (ctrlword = 'lquote') or (ctrlword = 'rquote') then      { einfaches Anf�hrungszeichen, Apostroph }
    begin
        if not aTextFormat.Invisible then Result := Result + htmlchar('&quote;', aTextFormat);
    end

    else if (ctrlword = 'ldblquote') or (ctrlword = 'rdblquote') then     { doppeltes Anf�hrungszeichen }
    begin
        if not aTextFormat.Invisible then Result := Result + htmlchar('&dblquote;', aTextFormat);
    end

    else if ctrlword = 'b' then        { Formatierung: fett }
    begin
        if not aTextFormat.Bold then
        begin
            changefmt := true;
            aTextFormat.Bold := true;
        end;
    end

    else if ctrlword = 'b0' then
    begin
        if aTextFormat.Bold then
        begin
            changefmt := true;
            aTextFormat.Bold := false;
        end;
    end

    else if ctrlword = 'i' then        { Formatierung: kursiv }
    begin
        if not aTextFormat.Italic then
        begin
            changefmt := true;
            aTextFormat.Italic := true;
        end;
    end

    else if ctrlword = 'i0' then
    begin
        if aTextFormat.Italic then
        begin
            changefmt := true;
            aTextFormat.Italic := false;
        end;
    end

    else if (ctrlword = 'ul')          { Formatierung: unterstreichen }
         or (ctrlword = 'uld')
         or (ctrlword = 'uldash')
         or (ctrlword = 'uldashd')
         or (ctrlword = 'uldashdd')
         or (ctrlword = 'uldb')
         or (ctrlword = 'ulth')
         or (ctrlword = 'ulwave') then
    begin
        if not aTextFormat.Underline then
        begin
            changefmt := true;
            aTextFormat.Underline := true;
        end;
    end

    else if (ctrlword = 'ulnone') or (ctrlword = 'ul0') then    { Formatierung: unterstreichen beenden }
    begin
        if aTextFormat.Underline then
        begin
            changefmt := true;
            aTextFormat.Underline := false;
        end;
    end

    else if (ctrlword = 'super') or (pos('up',ctrlword) = 1) then  { Formatierung: hochstellen }
    begin
        if not aTextFormat.SuperScript then
        begin
            changefmt := true;
            aTextFormat.SuperScript := true;
        end;
    end

    else if (ctrlword = 'sub') or (pos('dn',ctrlword) = 1) then  { Formatierung: tiefstellen }
    begin
        if not aTextFormat.SubScript then
        begin
            changefmt := true;
            aTextFormat.SubScript := true;
        end;
    end

    else if (ctrlword = 'nosupersub') then    { Formatierung: hoch-/tiefstellen beenden }
    begin
        if aTextFormat.SuperScript or aTextFormat.SubScript then
        begin
            changefmt := true;
            aTextFormat.SuperScript := false;
            aTextFormat.SubScript := false;
        end;
    end

    else if (ctrlword = 'strike') or (ctrlword = 'strikedl') then        { Formatierung: durchstreichen }
    begin
        if not aTextFormat.Strike then
        begin
            changefmt := true;
            aTextFormat.Strike := true;
        end;
    end

    else if (ctrlword = 'strike0') or (ctrlword = 'strikedl0') then
    begin
        if aTextFormat.Strike then
        begin
            changefmt := true;
            aTextFormat.Strike := false;
        end;
    end

    else if pos('li',ctrlword) = 1 then
    begin
        if (ctrlword[3] in ['0'..'9']) and (aTextFormat.Table = 0) then
        begin
            try
                num := strtoint(copy(ctrlword,3,length(ctrlword)-2));
            except
                on EConvertError do
                    num := 0;
            end;

            if no_newind then
            begin
                lastindent := lastindent + num;
                no_newind := false;

                while (ListLevelInfo.Indent[ListLevelInfo.ListLevel] < lastindent) and (ListLevelInfo.ListLevel <= 20)
                do
                begin
                    Inc(ListLevelInfo.ListLevel);
                    Result := Result + '<UL>';
                end;
            end;
        end;
    end

    else if pos('fi',ctrlword) = 1 then
    begin
        if ctrlword[3] in ['0'..'9','-'] then
        begin
            try
                num := strtoint(copy(ctrlword,3,length(ctrlword)-2));
            except
                on EConvertError do
                    num := 0;
            end;

            if no_newind then
            begin
                lastindent := lastindent + num;
            end;
        end;
    end

    else if pos('f',ctrlword) = 1 then
    begin
        if (ctrlword[2] in ['0'..'9']) and (not ConvertionFlags.NoFonts) then       { neue Schriftart }
        begin
            try
                num := strtoint(copy(ctrlword,2,length(ctrlword)-1));
            except
                on EConvertError do
                    num := 0;
            end;                             { Font-Nummer erfassen }

            if aTextFormat.FontNumber <> num then
            begin
                changefmt := true;
                aTextFormat.FontNumber := num;
            end;
        end
        else if ctrlword[2] = 's' then       { neue Schrift-Gr��e }
        begin
            try
                num := strtoint(copy(ctrlword,3,length(ctrlword)-2));
            except
                on EConvertError do             { Schrift-Gr��en-Zahl erfassen }
                    num := 0;
            end;
            num := num div 2;   { Schrift-Gr��en in RTF sind in halben Punkten angegeben }

            if aTextFormat.FontSize <> num then
            begin
                changefmt := true;
                aTextFormat.FontSize := num;
            end;
        end;
    end

    else if pos('cf',ctrlword) = 1 then       { neue Vordergrund-Farbe }
    begin
        try
            num := strtoint(copy(ctrlword,3,length(ctrlword)-2));
        except
            on EConvertError do              { Farb-Nummer erfassen }
                num := 0;
        end;

        if num > col.count-1 then
            txt := col[Pred(col.count)]           { sollte auch nicht vorkommen }
        else
            txt := col[num];

        if aTextFormat.FontColor <> txt then
        begin
            changefmt := true;
            aTextFormat.FontColor := txt;
        end;
    end;
end;
{$WARNINGS ON}
{  ************************************************************************  }

function TRtf2Html.LineAt (const index: integer; const line: string; var infile: textfile): string;
var                                                      { liefert einen Teilstring von 'line' ab Position 'index' }
    nextstr, str : string;                               { zur�ck. Ist 'line' k�rzer als 'index', wird eine        }
begin                                                    { neue Zeile eingelesen und an 'line' angeh�ngt, und dies }
    str := line;                                         { bei Bedarf so lange wiederholt, bis 'index' kleiner als }
    while (not EOF(infile)) and (index > length(str)) do { die Zeilenl�nge ist und somit das gew�nschte Resultat   }
    begin                                                { geliefert werden kann }
        ReadLn(infile, nextstr);
        str := str + nextstr;
    end;

    if index > length(str) then    { gesuchte Stelle existiert im Input-File gar nicht mehr }
        Result := ''
    else
        Result := Copy(str,index,length(str)-index+1);
end;

{  ************************************************************************  }

procedure TRtf2Html.IgnoreGroup(var line: string; var infile: textfile);   { springt zum Ende der aktuellen Group }
var
    lastline : boolean;
    i, brk, strlen : integer;
    binlen, binind : longint;

begin
    lastline := false;
    i := 0;
    strlen := 0;
    brk := 0;   { z�hlt die geschwungenen Klammern }

    while (not lastline) and (brk > -1) do
    begin
        if EOF(infile) then lastline := true;
        strlen := length(line);
        i := 1;
        while (i <= strlen) and (brk > -1) do
        begin
            if line[i] = '\' then
            begin
                if pos('bin',line) = i+1 then     { bei Bin�r-Daten im RTF-File funktioniert das Klammern-Z�hlen }
                begin                             { nicht und daher wird die im 'bin'-tag angegebene Menge von   }
                    binlen := 0;                  { Bytes ungepr�ft �bersprungen                                 }
                    i := i+4;
                    while (line[i] in ['0'..'9']) and (i <= strlen) do
                    begin                                           { L�nge der Bin�r-Daten erfassen }
                        binlen := binlen * 10 + strtoint(line[i]);
                        Inc(i);
                    end;
                    binind := 1;
                    while (binind <= binlen) and (not (EOF(infile) and (i > strlen)) ) do
                    begin                                           { Bin�r-Daten �berspringen }
                        if EOF(infile) then lastline := true;
                        if (i > strlen) and (not lastline) then
                        begin
                            ReadLn(infile, line);
                            Inc(binind);
                            if EOF(infile) then lastline := true;
                            i := 1;
                        end
                        else
                        begin
                            Inc(i);
                            Inc(binind);
                        end;
                    end;
                end;
            end;

            if line[i] = '{' then Inc(brk)
            else if line[i] = '}' then Dec(brk);

            Inc(i);
        end;

        if (brk > -1) and not lastline then ReadLn(infile, line);  { noch immer in in der Group --> n�chste Zeile }
    end;

    if (i > strlen) and not lastline then
    begin
        ReadLn(infile, line);  { letztes Zeichen der Zeile war Group-Ende  -->  weiter mit neuer Zeile }
        line := '}' + line;
    end
    else line := LineAt(i-1, line, infile);    { sonst: Zeile := Zeile ab Group-Ende }
end;

{  ************************************************************************  }

procedure TRtf2Html.MakeFontTable (var infile, outfile: textfile; var src: string);
var
    fnum, ftind, i, i2, strlen: integer;
    endfonts, lastline: boolean;
    nextstr: string;

begin
    ftind := 0;
    endfonts := false;
    lastline := false;
    i := pos('\fonttbl',src)+8;
    strlen := length(src);

    While not lastline and not endfonts do
    begin
        if EOF(infile) then lastline := true;
        while (i <= strlen) and (src[i] <> '\') do Inc(i); { Font-Deklaration suchen }
        Inc(i);
        if i > strlen then Exit;
        { Fehler im Format }

        fnum := 0;
        if src[i] = 'f' then
        begin
            Inc(i);
            while (src[i] in ['0'..'9']) and (i <= strlen) do   { Font-Nummer }
            begin
                fnum := (fnum*10)+strtoint(src[i]);
                Inc(i);
            end;

            { nun wird der Anfang des Font-Namens gesucht }
            while (i <= strlen) and (src[i] <> '}') and (src[i] <> '{') and (src[i] <> ' ') do Inc(i);
            if src[i] = '{' then
                while (i <= strlen) and (src[i] <> '}') do Inc(i);
            Inc(i);
            if i > strlen then Exit;

            { und nun das Ende..... }
            i2 := i;
            while (i2 <= strlen) and (src[i2] <> ';') and (src[i2] <> '{') and (src[i2] <> '\') do Inc(i2);
            if (src[i2] = '{') and (pos('\*\falt',src) = i2+1) then
            begin
                i := i2+9;
                while (i2 <= strlen) and (src[i2] <> '}') do Inc(i2);
            end;
            if i2 > strlen then Exit;   { Fehler im Format }

            if not ConvertionFlags.NoFonts then
            begin
                with FontFaces[ftind] do
                begin
                    FontFace := Copy(src,i,i2-i);   { Font-Name }
                    Number := fnum;
                    if (ConvertionFlags.Optimize) and (ftind < fontsOpt) then
                        AddFontName(FontFace);    { KillStrings zum sp�teren Optimieren setzen }
                end;                          { f�r die ersten <fontsOpt> deklarierten Schriften }
                Inc(ftind);
            end;

            src := Copy(src,i2,strlen-i2+1);

            while (length(src) < 5) and (not lastline) do
            begin    { Deklaration in n�chster Zeile fortgesetzt }
                if EOF(infile) then
                    lastline := true
                else
                    ReadLn(infile,nextstr);
                src := src + nextstr;
            end;

            strlen := length(src);
            i := 0;

            while (i <= strlen) and (src[i] <> '}') do
                Inc(i);

            if i > strlen then Exit;
            { Fehler im Format }

            if (src[i] = '}') and (src[i+1] = '}') then
            begin
                endfonts := true;
                src := Copy(src,i+1,strlen-i);
            end
            { \fonttbl beendet }
            else
            begin
                while (i <= strlen) and (src[i] <> '{') do Inc(i);
                { Suche nach n�chster Font-Deklaration }
                if i > strlen then Exit;
                { Fehler im Format }
                src := Copy(src,i,strlen-i+1);
                strlen := length(src);
                i := 0;
            end;
        end
        else
            Exit;
    end;
end;

{  ************************************************************************  }

procedure TRtf2Html.MakeColorTable (var infile, outfile: textfile; var src: string);
var
    i, i2, strlen : integer;
    endcolours, lastline : boolean;
    colstr, nextstr : string;

begin
    endcolours := false;
    lastline := false;
    i := pos('\colortbl',src)+10; { carlos - era 9}
    strlen := length(src);

    if (src[i] = ';') then col.add('#000000');  { "auto" color (Farbe 0) nicht gesetzt --> schwarz }

    While not lastline and not endcolours do
    begin
        if EOF(infile) then lastline := true;

        while (i <= strlen) and (src[i] <> '\') do Inc(i); { Farb-Deklaration suchen }
        i2 := i;
        while (i2 <= strlen) and (src[i2] <> ';') do Inc(i2); { das Ende ebendieser suchen }

        if i2 > strlen then Exit;  { Fehler im Format }
        if (src[i2+1] = '}') then endcolours := true;

        colstr := HtmlColorFromRtfColor(Copy(src,i,i2-i));
        col.add(colstr); { im html-Farben-Format in die Liste eintragen }

        if ConvertionFlags.Optimize then
            AddFontColor(colstr); { KillStrings zum sp�teren Optimieren setzen }

        src := Copy(src,i2+1,strlen);

        while (length(src) < 5) and (not EOF(infile)) do
        begin    { Deklaration in n�chster Zeile fortgesetzt }
            ReadLn(infile,nextstr);
            src := src + nextstr;
        end;

        strlen := length(src);
        i := 0;
    end;
end;

{ TRtf2Html }

{ Substitui cada uma das ocorr�ncias indicadas em aOldPatterns pelas strings
indicadas em aReplaceWith respectivamente na string aSrcStr. }
function TRtf2Html.ReplaceAll(aSrcStr: String; const aOldPatterns, aNewPatterns: array of String): String;
var
    i: Cardinal;
begin
    Result := aSrcStr;
    if High(aOldPatterns) = High(aNewPatterns) then
        for i := 0 to High(aOldPatterns) do
            Result := StringReplace(Result,aOldPatterns[i],aNewPatterns[i],[rfReplaceAll]);
end;

procedure TRtf2Html.ReplaceSpecialTags(var aText: String);
    procedure ReplaceImage(aImgTag: ShortString);
    var
        ImgHtmlTag: String;
    begin
        { Remove os tags N�O HTML}
        ImgHtmlTag := StringReplace(aImgTag,'[img]','',[]);
        ImgHtmlTag := StringReplace(ImgHtmlTag,'[/img]','',[]);
        { Cria o tag HTML }
        ImgHtmlTag := '<IMG SRC="' + FImagesDir + '\' + ImgHtmlTag + '">';
        aText := StringReplace(aText,aImgTag,ImgHtmlTag,[rfReplaceAll]);
    end;
var
    OffSet, PosImg: Integer;
    LengthOfTag: Byte;
begin

    { Buscando tags de imagem e substituindo... }
    OffSet := 1;
    repeat
        PosImg := PosEx('[img]',aText,OffSet);
        if PosImg > 0 then
        begin
            OffSet := PosImg;
            OffSet := PosEx('[/img]',aText,OffSet) + 6; // 6 = restante dos caracteres do tag de fechamento + 1
            LengthOfTag := OffSet - PosImg;
            ReplaceImage(Copy(aText,PosImg,LengthOfTag));
        end;
    until PosImg = 0;
end;

{ eliminiert �berfl�ssige Formatierungs-Anweisungen }
function TRtf2Html.OptimizeHtml(aSrcStr: String): String;
var
    line, comp : string;
    helpp : PInvalidString;

begin
    line := aSrcStr;

    repeat
        comp := line;

        if ConvertionFlags.Optimize then
        begin
            line := ReplaceAll(Line,['<B></B>','<I></I>','<U></U>','</B><B>','</I><I>','</U><U>'],['','','','','','']);
            line := ReplaceAll(Line,['<SUP></SUP>','<SUB></SUB>','<S></S>','</SUP><SUP>','</SUB><SUB>','</S><S>'],['','','','','','']);
            line := ReplaceAll(Line,['<DIV ALIGN="CENTER"></DIV>','</DIV><DIV ALIGN="CENTER">','<DIV ALIGN="RIGHT"></DIV>','</DIV><DIV ALIGN="RIGHT">','<DIV ALIGN="JUSTIFY"></DIV>','</DIV><DIV ALIGN="JUSTIFY">'],['','','','']);
        end;

        line := ReplaceAll(Line,['<UL></UL>','</UL><UL>'],['','']);

        if ConvertionFlags.Optimize then
        begin
            helpp := InvalidString;
            while (helpp <> NIL) do
            begin
                line := StringReplace(Line,helpp^.InvalidStr,'',[rfReplaceAll]);
                helpp := helpp^.NextInvalidString;
            end;
        end;

    until line = comp;

    Result := line;
end;

{ Limpa e corrige o HTML final gerado }
function TRtf2Html.ClearHTML(const aHTML: String): String;
var
    i: Cardinal;
begin
    Result := '';
    { A corre��o tem de ser feita linha a linha }
    with TStringList.Create do
        try
            Text := aHTML;
            for i := 0 to Pred(Count) do
                if Strings[i] <> '' then
                begin
                    { removendo <BR> desncess�rios }
                    Strings[i] := ReplaceAll(Strings[i],['</UL><BR>','</OL><BR>'],['</UL>','</OL>'])
                end;
        finally
            Result := Text;
            Free;
        end;
end;

procedure TRtf2Html.WriteHtml (const txt: string; var outstring: string; var outfile: textfile);
var
    i, strlen: integer;
    str, htxt: string;
    par, br: boolean;

begin
    if length(txt) > 0 then
    begin
        outstring := outstring + txt;

        par := false;
        br := false;

        str := OptimizeHtml(outstring);

        strlen := length(str);

        i := Pos('<P>', str) + 2;
        if i = 2 then
        begin
            i := Pos('<BR>', str) + 3;
            if i > 3 then br := true;
        end
        else
            par := true;

        if (br) or (par) or (strlen > 100) then
        begin
            while par or br do
            begin
                htxt := Copy(str, 1, i);
                incl_hlink(htxt);

                WriteLn(outfile, htxt);
                str := Copy(str, i+1, length(str)-i);

                par := false;
                br := false;

                i := Pos('<P>', str) + 2;
                if i = 2 then
                begin
                    i := Pos('<BR>', str) + 3;
                    if i > 3 then br := true;
                end
                else
                    par := true;
            end;

            outstring := str;
            strlen := length(str);

            if  (strlen > 100)
            and (outstring[strlen] = '>')
            and (outstring[Pred(strlen)] <> 'L')
            and (outstring[Pred(strlen)] <> 'A') then
            begin
                incl_hlink(outstring);
                WriteLn(outfile, outstring);
                outstring := '';
            end;
        end;
    end; { if length(txt) > 0 ... }
end;

function TRtf2Html.optStyle(basestyle, actstyle: string) : string;
var
    sbased, sact : string;

begin
    Result := '';
    sbased := basestyle;
    sact := actstyle;

    sact := ReplaceAll(Sact,['\widctlpar','\adjustright','\nowidctlpar'],['','','']);
    sact := ReplaceAll(Sact,['\keepn','\cgrid','\widctl'],['','','']);

    cut_tag('\sbasedon', sact);
    cut_tag('\snext', sact);
    cut_tag('\sa', sact);
    cut_tag('\sb', sact);
    cut_tag('\lang', sact);
    cut_tag('\slmult', sact);
    cut_tag('\sl', sact);
    cut_tag('\outlinelevel', sact);
    cut_tag('\kerning', sact);
    cut_tag('\expndtw', sact);
    cut_tag('\expnd', sact);
    cut_tag('\tx', sact);

    if pos(sbased, sact) > 0 then
    begin
        sbased := '';
    end;
    if ((pos('\fi', sact) > 0) or (pos('\li', sact) > 0))
    and ((pos('\fi', sbased) > 0) or (pos('\li', sbased) > 0)) then
    begin
        cut_tag('\fi', sbased);
        cut_tag('\li', sbased);
    end;

    Result := sbased + sact;
end;

procedure TRtf2Html.CloseLists (var aOutputString: String;
                                var aOutputFile: TextFile);
var
    txt : string;
begin
    txt := '';

    if listitem and not li_open then
        txt := txt + '</LI>';

    while ListLevelInfo.ListLevel > 0 do
    begin
        txt := txt + '</UL>';
        Dec(ListLevelInfo.ListLevel);
    end;

    WriteHtml(txt, aOutputString, aOutputFile);
end;


function TRtf2Html.GetRtfCode(aRichEdit: TRichEdit): String;
var
    strStream: TStringStream;
begin
    strStream := TStringStream.Create('') ;
    try
        aRichEdit.PlainText := False;
        aRichEdit.Lines.SaveToStream(strStream) ;
        Result := strStream.DataString;
    finally
        strStream.Free
    end;
end;

function TRtf2Html.GetHyperText: String;
begin
    Result := '';

    { Salva o RTF como arquivo }
    with TFileStream.Create(ExtractFilePath(ParamStr(0)) + 'input.rtf', fmCreate) do
        try
            Write(Pointer(FRichText)^, Length(FRichText));
        finally
            Free;
        end;

    { Converte o arquivo salvo }
    ConvertFile(ExtractFilePath(ParamStr(0)) + 'input.rtf'
               ,ExtractFilePath(ParamStr(0)) + 'output.html'
               ,[epOptimize,epHTMLBlockOnly]);

    { Abre o arquivo salvo e coloca seu conte�do em result }
	with TFileStream.Create(ExtractFilePath(ParamStr(0)) + 'output.html', fmOpenRead or fmShareDenyWrite) do
        try
    		try
      			SetLength(Result, Size);
                Read(Pointer(Result)^, Size);
            except
            	Result := ''; { Desaloca a mem�ria };
      			raise;
            end;
        finally
            Free;
        end;

    { Substitui Tags especiais em Result }
    ReplaceSpecialTags(Result);

    DeleteFile(PChar(ExtractFilePath(ParamStr(0)) + 'output.html'));
    DeleteFile(PChar(ExtractFilePath(ParamStr(0)) + 'input.rtf'));
end;

procedure TRtf2Html.InitializeStylesSheets (var aInputFile
                                              , aOutputFile: TextFile;
                                            var aSource: string);
var
    i, j, hrnum, strlen, snum, sbased : integer;
    endstyles, lastline, str, ctr, firststyle : boolean;
    basedon, cwd, txt, nextstr, sname, snumstr, spchar : string;

begin
    basedon := '';      { Platzhalter f�r Basis-Styles }
    spchar := '';       { Sonderzeichen }
    snum := 0;          { Style-Nummer im Stylesheet }
    sbased := 0;        { basierend auf Style Nr. <sbased> }
    snumstr := '';      { Style-Nummer im String-Format }
    cwd := '';          { Kontroll-Wort }
    sname := '';        { Style-Bezeichnung }
    ctr := false;       { derzeit in einem Kontrollwort ? }
    str := false;       { derzeit in einer Style-Bezeichnung ? }
    endstyles := false; { Ende des Stylesheets ? }
    lastline := false;  { Ende des Input-Files ???????   (wer wei�...) }

    firststyle := true;
    i := pos('\stylesheet',aSource)+11;
    strlen := length(aSource);

    While (not lastline) and (not endstyles) do
    begin
        if EOF(aInputFile) then lastline := true;

        while (i <= strlen) and (aSource[i] <> '{') do Inc(i); { Style-Deklaration suchen }

        if (i < strlen) then
        begin
            txt := Copy(aSource, i+1, 3);
            if not(
                      ((Copy(txt, 1, 2) = '\s') and (txt[3] in ['0'..'9']))   { vieles ist m�glich in RTF ..... }
                   or (txt = '\ds')
                   or (txt = '\*\')
                   ) then    { Style 0 }
            begin
                firststyle := false;
                Inc(i);
                snum := 0;
                while (i <= strlen) and (aSource[i] <> '}') do
                begin
                    if aSource[i] = ';' then
                    begin
                         stylesheet[snum].name := sname;
                         str := false;
                    end;

                    if (
                        ctr                           { entweder Kontrollwort }
                    or  ((aSource[i] = '\') and not (aSource[i+1] = #39))
                        )                             { oder Beginn eines solchen und NICHT ein Sonderzeichen }
                    and not (aSource[i] = ' ')            { aber KEIN Leerzeichen }
                    then
                        stylesheet[snum].ctrl := stylesheet[snum].ctrl + aSource[i];

                    if str and (aSource[i] <> '\') then sname := sname + aSource[i];
                    if ctr then cwd := cwd + aSource[i];

                    if aSource[i] = ' ' then    { hier k�nnte der Style-Name beginnen }
                    begin
                        ctr := false;
                        cwd := '';
                        str := true;
                    end;
                    if aSource[i] = '\' then   { hier beginnt ein Kontrollwort }
                    begin
                        if aSource[i+1] = #39 then
                        begin
                            spchar := aSource[i+2]+aSource[i+3];
                            sname := sname + plainchar(spchar);
                            i := i+3;
                        end
                        else
                        begin
                            ctr := true;
                            cwd := '';
                            str := false;
                            sname := '';
                        end;
                    end;
                    Inc(i);

                    if (i > strlen-5) then
                    begin
                        if not lastline then
                        begin
                            aSource := LineAt(i, aSource, aInputFile);
                            ReadLn(aInputFile, nextstr);
                            aSource := aSource + nextstr;
                            i := 1;
                        end;
                    end;

                    if aSource[i] = '{' then
                    begin
                        aSource := LineAt(i+1,aSource,aInputFile);
                        IgnoreGroup(aSource, aInputFile);
                        i := 2;
                        strlen := length(aSource);
                    end;
                end;
                stylesheet[snum].ctrl := optStyle('', stylesheet[snum].ctrl);
            end
            else if (txt = '\ds') or (txt = '\*\') then    { character / section style }
            begin
                aSource := LineAt(i+1,aSource,aInputFile);
                IgnoreGroup(aSource, aInputFile);
                i := 1;
            end
            else if ((Copy(txt, 1, 2) = '\s') and (txt[3] in ['0'..'9'])) then  { paragraph style             }
            begin                                                               { (das, wonach wir suchen...) }
                i := i+3;
                snumstr := '';
                while aSource[i] in ['0'..'9'] do
                begin
                    snumstr := snumstr + aSource[i];
                    Inc(i);
                end;
                try
                    snum := strtoint(snumstr);
                except
                    on EConvertError do
                        snum := 300;
                end;

                str := false;
                ctr := false;
                sname := '';
                cwd := '';

                while (i <= strlen) and (aSource[i] <> '}') do
                begin
                    if aSource[i] = ';' then
                    begin
                         stylesheet[snum].name := sname;
                         str := false;

                         if pos('toc', sname) > 0 then
                         begin
                             hrnum := 0;
                             for j := 4 to length(sname) do
                             begin
                                 if sname[j] in ['1'..'9'] then
                                     hrnum := strtoint(sname[j]);
                             end;
                             if hrnum > 0 then
                                 linkstyles[hrnum] := snum;
                         end
                         else if pos('heading', sname) > 0 then
                         begin
                             hrnum := 0;
                             for j := 8 to length(sname) do
                             begin
                                 if sname[j] in ['1'..'9'] then
                                     hrnum := strtoint(sname[j]);
                             end;
                             if hrnum > 0 then
                                 anchstyles[hrnum] := snum;
                         end;
                    end;

                    if (
                        ctr                           { entweder Kontrollwort }
                    or  ((aSource[i] = '\') and not (aSource[i+1] = #39))
                        )                             { oder Beginn eines solchen und NICHT ein Sonderzeichen }
                    and not (aSource[i] = ' ')            { aber KEIN Leerzeichen }
                    then
                        stylesheet[snum].ctrl := stylesheet[snum].ctrl + aSource[i];

                    if str and (aSource[i] <> '\') then sname := sname + aSource[i];
                    if ctr then cwd := cwd + aSource[i];

                    if aSource[i] = ' ' then    { hier k�nnte der Style-Name beginnen }
                    begin
                        ctr := false;
                        if Copy(cwd, 1, 8) = 'sbasedon' then  { Grundlage ist ein anderer Style }
                        begin
                            try
                                sbased := strtoint(Copy(cwd, 9, length(cwd)-9));
                            except
                                on EConvertError do
                                    sbased := -1;
                            end;
                            if (sbased >= 0) and (sbased < snum) then
                            begin
                                basedon := stylesheet[sbased].ctrl;
                                stylesheet[snum].ctrl := optStyle(stylesheet[sbased].ctrl, stylesheet[snum].ctrl);
                            end;
                        end;
                        cwd := '';
                        str := true;
                    end;
                    if aSource[i] = '\' then   { hier beginnt ein Kontrollwort }
                    begin
                        if aSource[i+1] = #39 then
                        begin
                            spchar := aSource[i+2]+aSource[i+3];
                            sname := sname + plainchar(spchar);
                            i := i+3;
                        end
                        else
                        begin
                            ctr := true;
                            if Copy(cwd, 1, 8) = 'sbasedon' then { Grundlage ist ein anderer Style }
                            begin
                                try
                                    sbased := strtoint(Copy(cwd, 9, length(cwd)-9));
                                except
                                    on EConvertError do
                                        sbased := -1;
                                end;
                                if sbased >= 0 then
                                begin
                                    basedon := stylesheet[sbased].ctrl;
                                end;
                            end;
                            cwd := '';
                            str := false;
                            sname := '';
                        end;
                    end;
                    Inc(i);
                    if (i > strlen-5) then      { bei Zeiten n�chste Zeile anh�ngen... }
                    begin
                        if not lastline then
                        begin
                            aSource := LineAt(i, aSource, aInputFile);
                            ReadLn(aInputFile, nextstr);
                            aSource := aSource + nextstr;
                            i := 1;
                            strlen := length(aSource);
                        end;
                    end;

                    if aSource[i] = '{' then        { Groups im Stylesheet werden hier ignoriert }
                    begin
                        aSource := LineAt(i+1,aSource,aInputFile);
                        IgnoreGroup(aSource, aInputFile);
                        i := 2;
                        strlen := length(aSource);
                    end;
                end; { while (i <= strlen) and (src[i] <> .... }

                stylesheet[snum].ctrl := optStyle(basedon, stylesheet[snum].ctrl);
                basedon := '';
            end;
        end; { while i <= strlen ..... }

        aSource := LineAt(i, aSource, aInputFile);
        strlen := length(aSource);
        i := 1;

        while (length(aSource) < 5) and (not EOF(aInputFile)) do
        begin    { Deklaration in n�chster Zeile fortgesetzt }
            ReadLn(aInputFile,nextstr);
            aSource := aSource + nextstr;
            strlen := length(aSource);
        end;

        if (aSource[i+1] = '}') then       { das Stylesheet ist zu Ende }
        begin
            endstyles := true;
            aSource := Copy(aSource,i+1,strlen-i);
        end
        else
        begin
            if not firststyle then
                aSource := Copy(aSource,i+1,strlen-i);
        end;
    end;
end;

procedure TRtf2Html.ProcessTable (var infile, outfile: textfile; var line: string);
var                                   { bearbeitet eine Tabelle }
    brkopen, i, lvl, strlen : integer;
    ctrlword, txt, buf : string;
    TextFormat : TTextFormat;
    tempattrib : array[1..20] of TTextFormat;
    fmtdiff, lastline, tabpard : boolean;

begin
    lvl := 1;
    brkopen := 1;             { String-Index bei �ffnender Klammer, wird vor IgnoreGroup() gebraucht }
    i := 1;
    lastline := false;
    li_open := false;
    tabpard := false;
    buf := '';
    ResetFormat(TextFormat, 'all');

    WriteHtml('<BR><TABLE BORDER=2><TR><TD>', OutputString, outfile);
    TextFormat.Table := in_cell;

    While not lastline do
    begin
        strlen := length(line);

        if not tabpard then i := 1;

        if EOF(infile) then lastline := true;

        while i <= strlen do
        begin
            case line[i] of
                '{':
                    begin
                        Inc(globbrk);
                        Inc(lvl);

                        if tabpard then brkopen := i;

                        CopyTextFormat(tempattrib[lvl], TextFormat);
                    end;
                '}':
                    begin
                        Dec(globbrk);
                        Dec(lvl);

                        fmtdiff := CompareTextFormats(TextFormat, tempattrib[lvl+1]);
                        if fmtdiff then
                        begin
                            changefmt := true;
                            CopyTextFormat(TextFormat, tempattrib[lvl+1]);
                        end;
                    end;
                '\': { Kontroll-Ausdruck bzw. RTF-spezifische Zeichen als Text }
                    begin
                        Inc(i);
                        if line[i] in ['\','{','}'] then  {RTF-spezifisches Zeichen als Text}
                            if (TextFormat.Table = row_end) or (TextFormat.Table = cell_end) then
                            begin
                                if not TextFormat.Invisible then buf := buf + htmlchar(line[i], TextFormat);
                            end
                            else
                            begin
                                if not TextFormat.Invisible then WriteHtml(htmlchar(line[i], TextFormat), OutputString, outfile);
                            end

                        else if line[i] = '~' then
                            if (TextFormat.Table = row_end) or (TextFormat.Table = cell_end) then
                            begin
                                if not TextFormat.Invisible then buf := buf + htmlchar('&nbsp;', TextFormat);
                            end
                            else
                            begin
                                if not TextFormat.Invisible then WriteHtml(htmlchar('&nbsp;', TextFormat), OutputString, outfile);
                            end

                        else if line[i] = '*' then
                        begin
                            if tabpard then
                            begin
                                txt := Copy (line, 1, brkopen-1);    { vor IgnoreGroup mu� die Zeile seit dem letzten }
                                line := LineAt(i,line,infile);       { \pard gespeichert werden, da der aktuelle      }
                                IgnoreGroup(line, infile);           { Absatz noch nicht als Teil einer Tabelle       }
                                strlen := length(line);              { identifiziert ist                              }
                                line := txt + Copy(line, 2, strlen-1);
                                Dec(globbrk);
                                i := brkopen-1;
                            end
                            else
                            begin
                                line := LineAt(i,line,infile);
                                IgnoreGroup(line, infile);
                                strlen := length(line);
                                i := 0;
                            end;
                        end

                        else if (line[i] = '_') then
                            if (TextFormat.Table = row_end) or (TextFormat.Table = cell_end) then
                            begin
                                if not TextFormat.Invisible then buf := buf + htmlchar('-', TextFormat);
                            end
                            else
                            begin
                                if not TextFormat.Invisible then WriteHtml(htmlchar('-', TextFormat), OutputString, outfile);
                            end

                        else if (line[i] = '-') then
                        begin
                            { nix, da es sich um ein optionales Abteilungszeichen handelt }
                        end

                        else if line[i] = #39 then   { Sonderzeichen, z.B. Umlaut, beginnend mit ' }
                        begin
                            txt := line[i+1]+line[i+2];
                            i := i+2;

                            if (TextFormat.Table = row_end) or (TextFormat.Table = cell_end) then
                            begin
                                buf := buf + htmlchar(txt, TextFormat);
                            end
                            else  { Best�tigung, da� wir uns in einer neuen Cell befinden -> kein Buffer n�tig }
                            begin
                                WriteHtml(htmlchar(txt, TextFormat), OutputString, outfile)
                            end;
                        end

                        else if line[i] in ['a'..'z'] then  { Kontroll-Ausdruck }
                        begin
                            ctrlword := '';
                            while (line[i] in ['a'..'z','0'..'9','-']) and (i <= strlen) do
                            begin
                                ctrlword := ctrlword + line[i];
                                Inc(i);
                            end;

                            if i > strlen then                 { Kontrollwort zu Ende + neue Zeile im RTF-File }
                            begin
                                if not lastline then ReadLn(infile, line);
                                if EOF(infile) then lastline := true;
                                i := 0;
                                strlen := length(line);
                            end
                            else
                                if line[i] <> ' ' then Dec(i); { nur der Delimiter <SPACE> ist als solcher }
                                                               { Teil eines Kontrollwortes                 }

                            { Variable 'i' steht nun am Ende des Kontroll-Wortes }

                            if (ctrlword = 'bkmkstart') or
                               (ctrlword = 'bkmkend') or
                               (ctrlword = 'filetbl') or
                               (ctrlword = 'footer') or
                               (ctrlword = 'footerf') or
                               (ctrlword = 'footnote') or
                               (ctrlword = 'header') or
                               (ctrlword = 'headerf') or
                               (ctrlword = 'levelnumbers') or
                               (ctrlword = 'leveltext') or
                               (ctrlword = 'list') or
                               (ctrlword = 'listlevel') or
                               (ctrlword = 'listname') or
                               (ctrlword = 'listoverridetable') or
                               (ctrlword = 'listtable') or
                               (ctrlword = 'pict') or
                               (ctrlword = 'pntxtb') or
                               (ctrlword = 'pntxta') or
                               (ctrlword = 'revtbl') or
                               (ctrlword = 'sp') or
                               (ctrlword = 'template') then
                            begin
                                if tabpard then
                                begin
                                    txt := Copy (line, 1, brkopen-1);
                                    line := LineAt(i,line,infile);
                                    IgnoreGroup(line, infile);
                                    strlen := length(line);
                                    line := txt + Copy(line, 2, strlen-1);
                                    Dec(globbrk);
                                    i := brkopen-1;
                                end
                                else
                                begin
                                    line := LineAt(i,line,infile);
                                    IgnoreGroup(line, infile);
                                    strlen := length(line);
                                    i := 0;
                                end;

                                if ctrlword = 'pict' then
                                    if (TextFormat.Table = row_end) or (TextFormat.Table = cell_end) then
                                        buf := buf + htmlchar('&pict;', TextFormat)
                                    else
                                        WriteHtml(htmlchar('&pict;', TextFormat), OutputString, outfile);
                            end
                            else if (ctrlword = 'par') or (ctrlword = 'sect') then      { neuer Absatz }
                            begin
                                txt := '';
                                txt := EmptyTagStack(TagStack);

                                if TextFormat.RightJustified or TextFormat.Centered or TextFormat.FullyJustified then
                                begin
                                    txt := txt + '</DIV>';
                                end;

                                txt := txt + '<BR>';

                                if TextFormat.Table = cell_end then
                                begin
                                    buf := buf + txt;
                                end
                                else if TextFormat.Table = in_cell then
                                begin
                                    WriteHtml(txt, OutputString, outfile);
                                end;
                            end
                            else if (ctrlword = 'intbl') then
                            begin
                                tabpard := false;
                            end
                            else if (ctrlword = 'pard') or ((ctrlword = 'widctlpar') and (pos('\intbl', line) <> i+1)) then
                            begin
                                if TextFormat.Table = row_end then
                                begin
                                    if tabpard then
                                    begin
                                        TextFormat.Table := plain;
                                        WriteHtml('</TABLE><BR>', OutputString, outfile);
                                        Exit;
                                    end
                                    else
                                    begin
                                        if line[i] = ' ' then
                                            line := Copy (line, i-5, strlen-i+6)
                                        else
                                            line := Copy (line, i-4, strlen-i+5);
                                        i := 5;
                                        strlen := length(line);
                                        tabpard := true;
                                    end;
                                end;
                                if ctrlword = 'pard' then
                                    if (TextFormat.Table = cell_end) or (TextFormat.Table = row_end) then
                                        buf := buf + html(ctrlword, TextFormat)  { Buffer, weil wir noch auf \cell warten }
                                    else
                                        WriteHtml(html(ctrlword, TextFormat), OutputString, outfile);
                            end
                            else if ctrlword = 'trowd' then      { Beginn einer Tabellen-Zeile }
                            begin
                                tabpard := false;
                                if TextFormat.Table = row_end then     { neue Zeile in bestehender Tabelle }
                                begin
                                    buf := '';
                                    WriteHtml('<TR><TD>', OutputString, outfile);
                                    ResetFormat(TextFormat, 'all');
                                    TextFormat.Table := in_cell;
                                end;
                            end
                            else if ctrlword = 'row' then
                            begin
                                ResetFormat(TextFormat, 'all');
                                buf := '';
                                tabpard := false;
                                WriteHtml('</TR>', OutputString, outfile);
                                TextFormat.Table := row_end;
                            end
                            else if ctrlword = 'cell' then
                            begin
                                tabpard := false;
                                if TextFormat.Table = cell_end then
                                    txt := '<TD>' + buf + EmptyTagStack(TagStack) + '</TD>'
                                else if TextFormat.Table = row_end then
                                    txt := '<TR><TD>' + buf + EmptyTagStack(TagStack) + '</TD>'
                                else if TextFormat.Table = in_cell then
                                    txt := EmptyTagStack(TagStack) + '</TD>';

                                WriteHtml(txt, OutputString, outfile);
                                ResetFormat(TextFormat, 'all');
                                TextFormat.Table := cell_end;
                                buf := '';
                            end
                            else  { nicht ignoriertes Kontrollwort }
                            begin
                                if (TextFormat.Table = cell_end) or (TextFormat.Table = row_end) then
                                    buf := buf + html(ctrlword, TextFormat)  { Buffer, weil wir noch auf \cell warten }
                                else
                                    WriteHtml(html(ctrlword, TextFormat), OutputString, outfile);
                            end;
                        end;
                    end;
                else   { Dokument-Text }
                begin
                    if (TextFormat.Table = cell_end) or (TextFormat.Table = row_end) then
                        { in Buffer schreiben, wir noch auf ein \cell warten, }
                        { welches best�tigt, da� die row noch nicht zu Ende ist }
                        buf := buf + htmlchar(line[i], TextFormat)
                    else
                        WriteHtml(htmlchar(line[i], TextFormat), OutputString, outfile);
                end;
            end;  { case }
            Inc(i);
        end;   { while i <= strlen... }

        if not lastline then
        begin
            if not tabpard then
                ReadLn(infile, line)
            else
            begin
                ReadLn(infile, txt);
                line := line + txt;
            end;
        end;
    end;  { While not lastline }
end;

procedure TRtf2Html.ProcessGroup (var infile, outfile: textfile; var line: string; var attrib: TTextFormat);
var                                   { bearbeitet eine rtf-'Group' }
    brk, i, j, num, strlen : integer;
    ctrlword, txt, lvlnumstr : string;
    tempattrib : TTextFormat;
    fmtdiff, quitblock, inv : boolean;

begin
    Inc(globbrk);
    num := 0;

    quitblock := false;

    While not lastline do
    begin
        strlen := length(line);
        i := 1;
        if EOF(infile) then lastline := true;

        while i <= strlen do
        begin
            case line[i] of
                '{': { neuer Block }
                    begin
                        line := LineAt(i+1, line, infile);

                        if ahref then
                        begin
                            WriteHtml('</A>', OutputString, outfile);
                            ahref := false;
                        end;

                        CopyTextFormat(tempattrib, attrib);

                        ProcessGroup (infile, outfile, line, attrib);

                        fmtdiff := CompareTextFormats(attrib, tempattrib);
                        if fmtdiff then
                        begin
                            txt := EmptyTagStack(TagStack);
                            changefmt := true;
                            WriteHtml(txt, OutputString, outfile);
                            CopyTextFormat(attrib, tempattrib);
                        end;

                        txt := '';

                        strlen := length(line);
                        i := 0; { aufgerufene Prozedur liefert neue 'line' zur�ck }
                    end;
                '}': { Ende des aktuellen Blocks }
                    begin
                        line := LineAt(i+1, line, infile);

                        if ahref then
                        begin
                            WriteHtml('</A>', OutputString, outfile);
                            ahref := false;
                        end;

                        Dec(globbrk);
                        Exit;
                    end;
                '\': { Kontroll-Ausdruck bzw. RTF-spezifische Zeichen als Text }
                    begin
                        inv := attrib.Invisible;

                        Inc(i);
                        if line[i] in ['\','{','}'] then  {RTF-spezifisches Zeichen als Text}
                        begin
                            if not inv then WriteHtml(htmlchar(line[i], attrib), OutputString, outfile);
                        end

                        else if line[i] = '~' then
                        begin
                            if not inv then WriteHtml(htmlchar('&nbsp;', attrib), OutputString, outfile);
                        end

                        else if line[i] = '*' then
                        begin
                            if (Copy(line, i+2, 3) = 'pn ') or (Copy(line, i+2, 3) = 'pn\') then
                            begin
                                pntxta := '';
                                pntxtb := '';
                                lvlnumstr := '';
                                i := i+4;
                                brk := 1;

                                while (brk > 0) and (not quitblock) do
                                begin
                                    if line[i] = '\' then
                                    begin
                                        Inc(i);
                                        if line[i] in ['a'..'z'] then  { Kontroll-Ausdruck }
                                        begin
                                            ctrlword := '';
                                            while (line[i] in ['a'..'z','0'..'9','-']) and (i <= strlen) do
                                            begin
                                                ctrlword := ctrlword + line[i];
                                                Inc(i);
                                            end;

                                            Dec(i);    { sonst verlieren wir ein Zeichen }

                                            if (ctrlword = 'pnlvlblt')
                                            or ((pos('pnlvl', ctrlword) = 1) and (ctrlword[6] in ['5'..'9']))
                                            then
                                            begin
                                                pnnum := false;
                                                listbull := true;
                                                listitem := true;
                                                ListLevelInfo.DocumentLevel := globbrk-1;   { aktuelles Group-Level speichern }
                                                Inc(ListLevelInfo.ListLevel);

                                                WriteHtml('<UL><LI type=disc>', OutputString, outfile);
                                            end
                                            else if (ctrlword = 'pnlvlcont')
                                                 or (ctrlword = 'pnlvlbody')
                                                 or ((pos('pnlvl', ctrlword) = 1) and (ctrlword[6] in ['1'..'4'])) then
                                            begin
                                                if (ctrlword = 'pnlvlbody') then
                                                    pnnum := true
                                                else
                                                    pnnum := false;

                                                listbull := false;
                                                listitem := false;
                                                ListLevelInfo.DocumentLevel := globbrk-1;   { aktuelles Group-Level speichern }
                                              {  enums.lvl := 0;     }
                                            end
                                            else if (ctrlword = 'pndec')
                                                 or (ctrlword = 'pncard')
                                                 or (ctrlword = 'pnucltr')
                                                 or (ctrlword = 'pnucrm')
                                                 or (ctrlword = 'pnlcltr')
                                                 or (ctrlword = 'pnlcrm')
                                                 or (ctrlword = 'pnord')
                                                 or (ctrlword = 'pnordt') then
                                            begin
                                                enumdigit := true;
                                            end
                                            else if (Pos('pnstart', ctrlword) > 0) then
                                            begin
                                                if enumdigit and pnnum then
                                                begin
                                                    lvlnumstr := '';
                                                    for j := 8 to length(ctrlword) do
                                                    begin
                                                        lvlnumstr := lvlnumstr + ctrlword[j];
                                                    end;
                                                    try
                                                        lvlnum := strtoint(lvlnumstr);
                                                    except
                                                        on EConvertError do
                                                            lvlnum := 1;
                                                    end;
                                                end;
                                            end
                                            else if (ctrlword = 'pntxta') and (pnnum) then
                                            begin               { Text, der nach der Aufz�hlungs-Nummer steht }
                                                Inc(i, 2);
                                                while line[i] <> '}' do
                                                begin
                                                    pntxta := pntxta + line[i];
                                                    Inc(i);
                                                end;
                                                Dec(i);   { sonst verlieren wir eine schlie�ende Klammer }
                                            end
                                            else if (ctrlword = 'pntxtb') and (pnnum) then
                                            begin
                                                Inc(i, 2);      { Text, der vor der Aufz�hlungs-Nummer steht }
                                                while line[i] <> '}' do
                                                begin
                                                    pntxtb := pntxtb + line[i];
                                                    Inc(i);
                                                end;
                                                Dec(i);   { sonst verlieren wir eine schlie�ende Klammer }
                                            end;
                                        end;
                                    end
                                    else if line[i] = '{' then
                                    begin
                                        Inc(brk);
                                    end
                                    else if line[i] = '}' then
                                    begin
                                        Dec(brk);
                                    end;

                                    Inc(i);

                                    if (i > strlen) then
                                    begin
                                        if not lastline then
                                        begin
                                            ReadLn(infile, line);
                                            if (brk = 0) then
                                            begin
                                                line := '}' + line;
                                                i := 0;
                                            end
                                            else
                                               i := 1;
                                            if EOF(infile) then lastline := true;
                                        end
                                        else
                                        begin
                                            quitblock := true;
                                        end;
                                    end;

                                    if ((quitblock) or (brk = 0)) and (i > 0) then
                                        i := i-2;                 { sonst fehlt die letzte Klammer }
                                end;                              { zum Beenden der Rekursion      }
                                if (not listbull) and (pnnum) then
                                begin
                                    txt := pntxtb + lvlnumstr + pntxta;
                                    if length(txt) > 0 then
                                    begin
                                        txt := '&&' + txt;
                                        WriteHtml(htmlchar(txt, attrib), OutputString, outfile);
                                    end;
                                end;
                            end
                            else
                            begin
                                if (Copy(line, i+2, 4) = 'bkmk') and not bkmkpar then
                                begin                                      { RTF-Bookmarks wirken sich im Layout }
                                    WriteHtml('<P>', OutputString, outfile);  { als vergr��erter Zeilenabstand �ber }
                                    bkmkpar := true;                       { und unter dem Bookmark aus.....     }
                                end;
                                line := LineAt(i,line,infile);
                                IgnoreGroup(line, infile);
                                i := 0;
                                strlen := length(line);
                            end;
                        end

                        else if (line[i] = '_') then
                        begin
                            if not inv then WriteHtml(htmlchar('-', attrib), OutputString, outfile);
                        end

                        else if (line[i] = '-') then
                        begin
                            { nix, da es sich um ein optionales Abteilungszeichen handelt }
                        end

                        else if line[i] = #39 then   { Sonderzeichen, z.B. Umlaut, beginnend mit ' }
                        begin
                            txt := line[i+1]+line[i+2];
                            i := i+2;
                            WriteHtml(htmlchar(txt, attrib), OutputString, outfile);
                        end

                        else if line[i] in ['a'..'z'] then  { Kontroll-Ausdruck }
                        begin
                            ctrlword := '';
                            while (line[i] in ['a'..'z','0'..'9','-']) and (i <= strlen) do
                            begin
                                ctrlword := ctrlword + line[i];
                                Inc(i);
                            end;

                            if i > strlen then                 { Kontrollwort zu Ende + neue Zeile im RTF-File }
                            begin
                                if not lastline then ReadLn(infile, line);
                                if EOF(infile) then lastline := true;
                                i := 0;
                                strlen := length(line);
                            end
                            else
                                if line[i] <> ' ' then Dec(i); { nur der Delimiter <SPACE> ist als solcher }
                                                               { Teil eines Kontrollwortes                 }

                            { Variable 'i' steht nun am Ende des Kontroll-Wortes }

                            if ctrlword = 'fonttbl' then
                            begin
                                MakeFontTable (infile, outfile, line); { erfa�t die Schriftarten und liefert neue      }
                                i := 0;                           { Zeile ab erstem Zeichen nach der Font-Tabelle }
                                strlen := length(line);
                                if EOF(infile) then lastline := true;  { just in case... }
                            end
                            else if ctrlword = 'colortbl' then
                            begin
                                MakeColorTable (infile, outfile, line);  { erfa�t die verwendeten Farben und liefert neue }
                                i := 0;                              { Zeile ab erstem Zeichen nach der Farb-Tabelle  }
                                strlen := length(line);
                                if EOF(infile) then lastline := true;  { just in case... }
                            end
                            else if ctrlword = 'stylesheet' then
                            begin
                                InitializeStylesSheets (infile, outfile, line);  { erfa�t die verwendeten Styles und liefert neue }
                                i := 0;                              { Zeile ab erstem Zeichen nach dem Stylesheet    }
                                strlen := length(line);
                                if EOF(infile) then lastline := true;  { just in case... }
                            end
                            else if (pos('s',ctrlword) = 1) and (ctrlword[2] in ['0'..'9']) then
                            begin                                   { Stylesheet-Eintrag }
                                try
                                    num := strtoint(copy(ctrlword,2,length(ctrlword)-1));
                                except
                                    on EConvertError do
                                        num := 0;
                                end;                             { Style-Nummer erfassen }

                                for j := 1 to 9 do
                                begin
                                    if linkstyles[j] = num then
                                    begin
                                        if anchstyles[j] > -1 then
                                        begin
                                            ahrefwait := true;
                                            newhrefnum := true;
                                            indexlvl := j;
                                        end;
                                        break;
                                    end;
                                    if anchstyles[j] = num then
                                    begin
                                        anchor := true;
                                        anchlvl := j;
                                    end;
                                end;

                                txt := LineAt(i+1, line, infile);
                                line := stylesheet[num].ctrl + txt;
                                strlen := length(line);
                                i := 0;
                            end
                            else if ctrlword = 'trowd' then
                            begin
                                WriteHtml(EmptyTagStack(TagStack), OutputString, outfile);
                                CloseLists(OutputString, outfile);

                                line := LineAt(i, line, infile);
                                ProcessTable(infile, outfile, line);
                                i := 0;
                                strlen := length(line);
                            end
                            else if (ctrlword = 'bkmkstart') or
                                    (ctrlword = 'bkmkend') or
                                    (ctrlword = 'filetbl') or
                                    (ctrlword = 'footer') or
                                    (ctrlword = 'footerf') or
                                    (ctrlword = 'footnote') or
                                    (ctrlword = 'header') or
                                    (ctrlword = 'headerf') or
                                    (ctrlword = 'info') or
                                    (ctrlword = 'levelnumbers') or
                                    (ctrlword = 'leveltext') or
                                    (ctrlword = 'list') or
                                    (ctrlword = 'listlevel') or
                                    (ctrlword = 'listname') or
                                    (ctrlword = 'listoverridetable') or
                                    (ctrlword = 'listtable') or
                                    (ctrlword = 'pict') or
                                    (ctrlword = 'pntext') or
                                    (ctrlword = 'revtbl') or
                                    (ctrlword = 'sp') or
                                    (ctrlword = 'template') then
                            begin
                                line := LineAt(i,line,infile);
                                IgnoreGroup(line, infile);
                                i := 0;
                                strlen := length(line);
                                if ctrlword = 'pict' then
                                    WriteHtml(htmlchar('&pict;', attrib), OutputString, outfile);
                            end
                            else  { nicht ignoriertes Kontrollwort }
                            begin
                                if ahref then
                                    WriteHtml('</A>', OutputString, outfile);

                                WriteHtml(html(ctrlword, attrib), OutputString, outfile);
                                if ahref then ahref := false;
                            end;   { begin nicht ignoriertes Kontrollwort }
                        end;
                    end;
                else  { Dokument-Text }
                begin
                    if li_open then
                    begin
                        WriteHtml('<LI TYPE="disc">', OutputString, outfile);
                        li_open := false;
                    end;

                    if pnnum and nextpar and (length(enumtxt) > 0) then
                    begin
                        enumtxt := '&&' + enumtxt;
                        WriteHtml(htmlchar(enumtxt, attrib), OutputString, outfile);
                        enumtxt := '';
                    end;
                    WriteHtml(htmlchar(line[i], attrib), OutputString, outfile);
                end;
            end;  { case }
            Inc(i);
        end;   { while i <= strlen... }

        if not lastline then ReadLn(infile, line);
    end;  { While not lastline }

    Dec(globbrk);
end;

procedure TRtf2Html.ConvertFile (const aSrcFilename, aDestFilename: TFileName; aExtraParams: TExtraParams);
var
    infile, outfile: textfile;
    src, txt: string;
    TextFormat: TTextFormat;
    i: integer;

begin
    changefmt := false;

    for i := 0 to 20 do            { Indents zur <UL>-Steuerung setzen }
    begin
        ListLevelInfo.Indent[i] := (i*ul_indent);
    end;

    for i := 0 to 300 do           { internes Stylesheet initialisieren }
    begin
        stylesheet[i].ctrl := '';
        stylesheet[i].name := '';
    end;


    for i := 1 to 9 do            { arrays zur Sprungmarken-Steuerung initialisieren }
    begin
        linkstyles[i] := -1;
        anchstyles[i] := -1;
        actlinknum[i] := 0;
        actanchnum[i] := 0;
    end;

    ConvertionFlags.NoFonts := false;           { default sind alle Aufrufparameter 'false' }
    ConvertionFlags.Optimize := false;
    ConvertionFlags.OnlyDefiniteOpt := false;

    { auf mitgegebene Parameter pr�fen ... }
    ConvertionFlags.NoFonts := epNoFonts in aExtraParams;
    ConvertionFlags.Optimize := epOptimize in aExtraParams;
    ConvertionFlags.OnlyDefiniteOpt := epOnlyDefiniteOpt in aExtraParams;

    TagStack := NIL;            { Haupt-Formatierungs-Stack }
    ResetFormat(TextFormat, 'all');     { Attribut-Record 'defaulten' }
    OutputString := '';             { das, was letztendlich ins outfile geschrieben wird }
    bkmkpar := false;            { Hilfsflag zu Formatierungszwecken }
    lastline := false;           { Flag, um das File-Ende abzufangen }
    li_open := false;            { true, solange bei einer Aufz�hlung kein Ende feststeht }
    listitem := false;           { false, wenn <UL>, aber kein <LI> }
    lastindent := 0;
    no_newind := true;
    txtwait := '';
    pnnum := false;              { true, wenn ein Aufz�hlungspunkt mit formatierter Numerierung folgt }
    nextpar := true;             { true, sobald ein \par gelesen wird; false ab erstem Dokument-Text-Zeichen danach }
    enumdigit := false;          { true, wenn eine numerische Aufz�hlung folgt }
    enumtxt := '';               { der String, der die formatierte Numerierung enth�lt }

    col := TStringList.Create;   { interne Farbtabelle }
    lvlnum := -1;                { aktuelle Zahl bei Aufz�hlungen }
    ListLevelInfo.ListLevel := 0;              { aktuelles Aufz�hlungs bzw. Einr�ckungs-Level }
    globbrk := 0;                { Anzahl der offenen Klammern im RTF-Dokument }

    ahref := false;              { true bei einer Referenz }
    anchor := false;             { true bei einer Sprungmarke }
    indexlvl := 0;               { aktuelles Level im Inhaltsverzeichnis }
    anchlvl := 0;                { aktuelles Heading-(�berschrift-)Level }
    ahrefwait := false;          { true, wenn der n�chste Text Teil einer Referenz ist }
    newhrefnum := false;         { true bei jedem neuen Punkt im Inhaltsverzeichnis }

    if ConvertionFlags.Optimize then
        InitInvalidString;            { wenn's optimiert werden soll, m�ssen die Kill Strings gesetzt werden }

    AssignFile(infile, aSrcFilename);
    AssignFile(outfile, aDestFilename);
    Reset(infile);
    ReWrite(outfile);

    if not (epHTMLBlockOnly in aExtraParams) then
    begin
        WriteLn(outfile,'<HTML>');
        WriteLn(outfile,'<HEAD>');
        WriteLn(outfile,('<TITLE>'+aSrcFilename+'</TITLE>'));
        WriteLn(outfile,'</HEAD>');
        WriteLn(outfile,'<BODY TEXT="#000000" BGCOLOR="#FFFFFF" LINK="#3333FF" VLINK="#999999" ALINK="#FF0000">');
    end;

    Flush(outfile);

    try
        ReadLn(infile, src);
        ProcessGroup (infile, outfile, src, TextFormat);

    finally
        txt := EmptyTagStack(TagStack);
        if TextFormat.RightJustified or TextFormat.Centered or TextFormat.FullyJustified then
            txt := txt + '</DIV>';

        WriteHtml(txt, OutputString, outfile);
        CloseLists(OutputString, outfile);

        WriteLn(outfile, OutputString);
        if not (epHTMLBlockOnly in aExtraParams) then
        begin
            WriteLn(outfile,'</BODY>');
            WriteLn(outfile,'</HTML>');
        end;
        col.Free;

        Flush(outfile);          { wir ziehen an der Leine, damit auch alles wegkommt.... }
        CloseFile(infile);
        CloseFile(outfile);

        { CARLOS - LIMPANDO COISAS INUTEIS }
        with TFileStream.Create(aDestFilename, fmOpenRead or fmShareDenyWrite) do
            try
                try
                    SetLength(OutputString, Size);
                    Read(Pointer(OutputString)^, Size);
                except
                    OutputString := ''; { Desaloca a mem�ria };
                    raise;
                end;
            finally
                Free;
            end;

            OutputString := ClearHTML(OutputString);

            with TFileStream.Create(aDestFilename, fmCreate) do
                try
                    Write(Pointer(OutputString)^, Length(OutputString));
                finally
                    Free;
                end;
    end;
end;

end.
