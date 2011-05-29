unit ZTO.Win32.Rtl.Common.StringUtils;

{$WEAKPACKAGEUNIT ON}

interface

function CompressString(const aUncompressedString: String): String;
function DecompressString(const aCompressedString: String): String;
function URLEncode(const aURL: String): String;

implementation

uses ZLib
   , ZTO.Win32.Rtl.Common.Classes.Interposer
   , SysUtils;

function CompressString(const aUncompressedString: String): String;
begin

end;

function DecompressString(const aCompressedString: String): String;
begin

end;

function URLEncode(const aURL: String): String;
const
  UNRESERVED = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_.~';
var
  i: Integer;
  Character: Char;
  CharCode: Cardinal;
begin
  Result := '';

  for i := 1 to Length(aURL) do
  begin
    Character := aURL[i];

    // Check if character is an unreserved character:
    if Pos(Character,UNRESERVED) > 0 then
      Result := Result + Character
    else
    begin
        // The position in the Unicode table tells us how many bytes are needed.
        // Note that if we talk about first, second, etc. in the following, we are
        // counting from left to right:
        //
        //   Position in   |  Bytes needed   | Binary representation
        //  Unicode table  |   for UTF-8     |       of UTF-8
        // ----------------------------------------------------------
        //     0 -     127 |    1 byte       | 0XXX.XXXX
        //   128 -    2047 |    2 bytes      | 110X.XXXX 10XX.XXXX
        //  2048 -   65535 |    3 bytes      | 1110.XXXX 10XX.XXXX 10XX.XXXX
        // 65536 - 2097151 |    4 bytes      | 1111.0XXX 10XX.XXXX 10XX.XXXX 10XX.XXXX

        CharCode := Ord(Character);

        // Position 0 - 127 is equal to percent-encoding with an ASCII character encoding:
        if (CharCode < 128) then
          Result := Result + '%' + IntToHex(CharCode,2)
        // Position 128 - 2047: two bytes for UTF-8 character encoding.
        else if (CharCode > 127) and (CharCode < 2048) then
        begin
          // First UTF byte: Mask the first five bits of charcode with binary 110X.XXXX:
          Result := Result + '%' + IntToHex((CharCode shr 6) or $C0,2);
          // Second UTF byte: Get last six bits of charcode and mask them with binary 10XX.XXXX:
          Result := Result + '%' + IntToHex((CharCode and $3F) or $80,2);
        end
        // Position 2048 - 65535: three bytes for UTF-8 character encoding.
        else if (CharCode > 2047) and (CharCode < 65536) then
        begin
          // First UTF byte: Mask the first four bits of charcode with binary 1110.XXXX:
          Result := Result + '%' + IntToHex((CharCode shr 12) or $E0,2);
          // Second UTF byte: Get the next six bits of charcode and mask them binary 10XX.XXXX:
          Result := Result + '%' + IntToHex(((CharCode shr 6) and $3F) or $80,2);
          // Third UTF byte: Get the last six bits of charcode and mask them binary 10XX.XXXX:
          Result := Result + '%' + IntToHex((CharCode and $3F) and $80,2);
        end
        // Position 65536 - : four bytes for UTF-8 character encoding.
        else if (charcode > 65535) then
        begin
          // First UTF byte: Mask the first three bits of charcode with binary 1111.0XXX:
          Result := Result + '%' + IntToHex((CharCode shr 18) or $F0,2);
          // Second UTF byte: Get the next six bits of charcode and mask them binary 10XX.XXXX:
          Result := Result + '%' + IntToHex(((CharCode shr 12) and $3F) or $80,2);
          // Third UTF byte: Get the last six bits of charcode and mask them binary 10XX.XXXX:
          Result := Result + '%' + IntToHex(((CharCode shr 6) and $3F) or $80,2);
          // Fourth UTF byte: Get the last six bits of charcode and mask them binary 10XX.XXXX:
          Result := Result + '%' + IntToHex((CharCode and $3F) or $80,2);
        end;
    end;
  end;
end;

// a função abaixo faz o mesmo papel da função UFT8encode
//function URLEncode(const aURL: String): String;
//var
//  i: Integer;
//  CharCode: Word;
//begin
//  Result := '';
//
//  for i := 1 to Length(aURL) do
//  begin
//    CharCode := Ord(aUrl[i]);
//
//    if CharCode < 128 then
//      Result := Result + Chr(CharCode)
//    else if (CharCode > 127) and (CharCode < 2048) then
//    begin
//      Result := Result + Chr((CharCode shr 6) or 192);
//      Result := Result + Chr((CharCode and 63) or 128);
//    end
//    else
//    begin
//      Result := Result + Chr((CharCode shr 12) or 224);
//      Result := Result + Chr(((CharCode shr 6) and 63) or 128);
//      Result := Result + Chr((CharCode and 63) or 128);
//    end;
//  end;
//end;


// ABAIXO ESTÁ UM SCRIPT EM JAVASCRIPT COMPLETO QUE CODIFICA E DECOFICA UMA URL
// EM UTF8. HÁ UMA FORMA DE USAR ASCII PURO AO INVÉS DE UTF8
(*
<script type="text/javascript">
<!--
// ==========================================================================
// JavaScript Tool for URL Encoding/Decoding
// Copyright (C) 2006 Netzreport (netzreport.googlepages.com)
//
// Website: http://netzreport.googlepages.com/online_tool_for_url_en_decoding.html
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
//
// The GNU General Public License is also available from:
// http://www.gnu.org/copyleft/gpl.html
//
// A local copy of the GNU General Public License is available here:
// http://netzreport.googlepages.com/gpl.txt
// ==========================================================================
//
// --------------------------------------------------------------------------
// 2006-12-18: Changed character encoding. Now, one can choose between URL
//             encoding/decoding strings that are character encoded as ASCII
//             or UTF-8.
// 2006-11-19: First release
// --------------------------------------------------------------------------

// According to RFC 3986, only characters from a set of reserved and a set
// of unreserved characters are allowed in a URL:
var unreserved = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_.~";
var reserved = "!*'();:@&=+$,/?%#[]";
var allowed = unreserved + reserved;
var hexchars = "0123456789ABCDEFabcdef";

// --------------------------------- Encoding -------------------------------

// This function returns a percent sign followed by two hexadecimal digits.
// Input is a decimal value not greater than 255.
function gethex(decimal) {
  return "%" + hexchars.charAt(decimal >> 4) + hexchars.charAt(decimal & 0xF);
  }

function encode() {
  // Clear output field:
  document.converter.encoded.value = "";

  // Some variables:
  var decoded = document.converter.decoded.value;
  var encoded = "";

  // ---------------- If ASCII character encoding was chosen: ----------------

  if (document.converter.charset.value == "ascii") {

    // Remember non-ASCII characters, which will not be encoded:
    var notascii = "";

    for (var i = 0; i < decoded.length; i++ ) {
      var ch = decoded.charAt(i);
      // Check if character is an unreserved character:
      if (unreserved.indexOf(ch) != -1) {
        encoded = encoded + ch;
      } else {
        // If position in the Unicode table is smaller than 128, then we have
        // an ASCII character:
        var charcode = decoded.charCodeAt(i);
        if (charcode < 128) {
          encoded = encoded + gethex(charcode);
        } else {
          encoded = encoded + ch;
          notascii = notascii + ch + " ";
        }
      }
    }

    // Write result:
    document.converter.encoded.value = encoded;

    // Display warning message if necessary:
    if (notascii != "") alert("Warning: Non-ASCII characters in decoded text!\n\nThus, these characters have not been encoded:\n" + notascii);
  }

  // ---------------- If UTF-8 character encoding was chosen: ----------------

  if (document.converter.charset.value == "utf8") {
    for (var i = 0; i < decoded.length; i++ ) {
      var ch = decoded.charAt(i);
      // Check if character is an unreserved character:
      if (unreserved.indexOf(ch) != -1) {
        encoded = encoded + ch;
      } else {

        // The position in the Unicode table tells us how many bytes are needed.
        // Note that if we talk about first, second, etc. in the following, we are
        // counting from left to right:
        //
        //   Position in   |  Bytes needed   | Binary representation
        //  Unicode table  |   for UTF-8     |       of UTF-8
        // ----------------------------------------------------------
        //     0 -     127 |    1 byte       | 0XXX.XXXX
        //   128 -    2047 |    2 bytes      | 110X.XXXX 10XX.XXXX
        //  2048 -   65535 |    3 bytes      | 1110.XXXX 10XX.XXXX 10XX.XXXX
        // 65536 - 2097151 |    4 bytes      | 1111.0XXX 10XX.XXXX 10XX.XXXX 10XX.XXXX

        var charcode = decoded.charCodeAt(i);

        // Position 0 - 127 is equal to percent-encoding with an ASCII character encoding:
        if (charcode < 128) {
          encoded = encoded + gethex(charcode);
        }

        // Position 128 - 2047: two bytes for UTF-8 character encoding.
        if (charcode > 127 && charcode < 2048) {
          // First UTF byte: Mask the first five bits of charcode with binary 110X.XXXX:
          encoded = encoded + gethex((charcode >> 6) | 0xC0);
          // Second UTF byte: Get last six bits of charcode and mask them with binary 10XX.XXXX:
          encoded = encoded + gethex((charcode & 0x3F) | 0x80);
        }

        // Position 2048 - 65535: three bytes for UTF-8 character encoding.
        if (charcode > 2047 && charcode < 65536) {
          // First UTF byte: Mask the first four bits of charcode with binary 1110.XXXX:
          encoded = encoded + gethex((charcode >> 12) | 0xE0);
          // Second UTF byte: Get the next six bits of charcode and mask them binary 10XX.XXXX:
          encoded = encoded + gethex(((charcode >> 6) & 0x3F) | 0x80);
          // Third UTF byte: Get the last six bits of charcode and mask them binary 10XX.XXXX:
          encoded = encoded + gethex((charcode & 0x3F) | 0x80);
        }

        // Position 65536 - : four bytes for UTF-8 character encoding.
        if (charcode > 65535) {
          // First UTF byte: Mask the first three bits of charcode with binary 1111.0XXX:
          encoded = encoded + gethex((charcode >> 18) | 0xF0);
          // Second UTF byte: Get the next six bits of charcode and mask them binary 10XX.XXXX:
          encoded = encoded + gethex(((charcode >> 12) & 0x3F) | 0x80);
          // Third UTF byte: Get the last six bits of charcode and mask them binary 10XX.XXXX:
          encoded = encoded + gethex(((charcode >> 6) & 0x3F) | 0x80);
          // Fourth UTF byte: Get the last six bits of charcode and mask them binary 10XX.XXXX:
          encoded = encoded + gethex((charcode & 0x3F) | 0x80);
        }

      }

    }  // end of for ...

    // Write result:
    document.converter.encoded.value = encoded;
  }
}

// --------------------------------- Decoding -------------------------------

// This function returns the decimal value of two hexadecimal digits.
// Input is a percent sign followed by two hexadecimal digits. If the input
// string is shorter than three characters, the percent sign is missing or if
// not a hexadecimal numeral is used, then the decimal value 256 is returned:
function getdec(hexencoded) {
  if (hexencoded.length == 3) {
    if (hexencoded.charAt(0) == "%") {
      if (hexchars.indexOf(hexencoded.charAt(1)) != -1 && hexchars.indexOf(hexencoded.charAt(2)) != -1) {
        return parseInt(hexencoded.substr(1,2),16);
      }
    }
  }
  return 256;
}

function decode() {
  // Clear output field:
  document.converter.decoded.value = "";

  // Some variables:
  var encoded = document.converter.encoded.value;
  var decoded = "";
  // Remember characters that are not allowed in a URL:
  var notallowed = "";
  // Remember illegal percent encoding:
  var illegalencoding = "";

  // ---------------- If ASCII character encoding was chosen: ----------------
  if (document.converter.charset.value == "ascii") {
    var i = 0;
    while (i < encoded.length) {
      var ch = encoded.charAt(i);
      // Check for percent-encoded string:
      if (ch == "%") {
        // Check if percent-encoded string represents an ASCII character:
        if (getdec(encoded.substr(i,3)) < 128) {
          decoded = decoded + unescape(encoded.substr(i,3));
        } else {
          decoded = decoded + encoded.substr(i,3);
          illegalencoding = illegalencoding + encoded.substr(i,3) + " ";
        }
        i = i + 3;
      } else {
        // Check if character is an allowed character:
        if (allowed.indexOf(ch) == -1) notallowed = notallowed + ch + " ";
        decoded = decoded + ch;
        i++;
      }
    }

    // Write result:
    document.converter.decoded.value = decoded;

    // Display warning message if necessary:
    var warning = "";
    if (notallowed != "") warning = warning + "Characters not allowed in a URL:\n" + notallowed + "\n\n";
    if (illegalencoding != "") warning = warning + "Illegal percent-encoding (for ASCII):\n" + illegalencoding  + "\n\n";
    if (warning != "") alert("Warning: Illegal characters/strings in encoded text!\n\n" + warning);
  }

  // ---------------- If UTF-8 character encoding was chosen: ----------------
  if (document.converter.charset.value == "utf8") {
    // UTF-8 bytes from left to right:
    var byte1, byte2, byte3, byte4 = 0;

    var i = 0;
    while (i < encoded.length) {
      var ch = encoded.charAt(i);
      // Check for percent-encoded string:
      if (ch == "%") {

        // Check for legal percent-encoding of first byte:
        if (getdec(encoded.substr(i,3)) < 255) {

          // Get the decimal values of all (potential) UTF-bytes:
          byte1 = getdec(encoded.substr(i,3));
          byte2 = getdec(encoded.substr(i+3,3));
          byte3 = getdec(encoded.substr(i+6,3));
          byte4 = getdec(encoded.substr(i+9,3));

          // Check for one byte UTF-8 character encoding:
          if (byte1 < 128) {
            decoded = decoded + String.fromCharCode(byte1);
            i = i + 3;
          }

          // Check for illegal one byte UTF-8 character encoding:
          if (byte1 > 127 && byte1 < 192) {
            decoded = decoded + encoded.substr(i,3);
            illegalencoding = illegalencoding + encoded.substr(i,3) + " ";
            i = i + 3;
          }

          // Check for two byte UTF-8 character encoding:
          if (byte1 > 191 && byte1 < 224) {
            if (byte2 > 127 && byte2 < 192) {
              decoded = decoded + String.fromCharCode(((byte1 & 0x1F) << 6) | (byte2 & 0x3F));
            } else {
              decoded = decoded + encoded.substr(i,6);
              illegalencoding = illegalencoding + encoded.substr(i,6) + " ";
            }
            i = i + 6;
          }

          // Check for three byte UTF-8 character encoding:
          if (byte1 > 223 && byte1 < 240) {
            if (byte2 > 127 && byte2 < 192) {
              if (byte3 > 127 && byte3 < 192) {
                decoded = decoded + String.fromCharCode(((byte1 & 0xF) << 12) | ((byte2 & 0x3F) << 6) | (byte3 & 0x3F));
              } else {
                decoded = decoded + encoded.substr(i,9);
                illegalencoding = illegalencoding + encoded.substr(i,9) + " ";
              }
            } else {
              decoded = decoded + encoded.substr(i,9);
              illegalencoding = illegalencoding + encoded.substr(i,9) + " ";
            }
            i = i + 9;
          }

          // Check for four byte UTF-8 character encoding:
          if (byte1 > 239) {
            if (byte2 > 127 && byte2 < 192) {
              if (byte3 > 127 && byte3 < 192) {
                if (byte4 > 127 && byte4 < 192) {
                  decoded = decoded + String.fromCharCode(((byte1 & 0x7) << 18) | ((byte2 & 0x3F) << 12) | ((byte3 & 0x3F) << 6) | (byte4 & 0x3F));
                } else {
                  decoded = decoded + encoded.substr(i,12);
                  illegalencoding = illegalencoding + encoded.substr(i,12) + " ";
                }
              } else {
                decoded = decoded + encoded.substr(i,12);
                illegalencoding = illegalencoding + encoded.substr(i,12) + " ";
              }
            } else {
              decoded = decoded + encoded.substr(i,12);
              illegalencoding = illegalencoding + encoded.substr(i,12) + " ";
            }
            i = i + 12;
          }

        } else {  // the first byte is not legally percent-encoded
          decoded = decoded + encoded.substr(i,3);
          illegalencoding = illegalencoding + encoded.substr(i,3) + " ";
          i = i + 3;
        }

      } else {  // the string is not percent encoded
        // Check if character is an allowed character:
        if (allowed.indexOf(ch) == -1) notallowed = notallowed + ch + " ";
        decoded = decoded + ch;
        i++;
      }
    }  // end of while ...

    // Write result:
    document.converter.decoded.value = decoded;

    // Display warning message if necessary:
    var warning = "";
    if (notallowed != "") warning = warning + "Characters not allowed in a URL:\n" + notallowed + "\n\n";
    if (illegalencoding != "") warning = warning + "Illegal percent-encoding (for UTF-8):\n" + illegalencoding  + "\n\n";
    if (warning != "") alert("Warning: Illegal characters/strings in encoded text!\n\n" + warning);
  }
}
//-->
</script>
*)

end.
