# Color conversion utilities copied from here:
# https://github.com/Misterio77/nix-colors/
{lib, ...}: let
  inherit
    (lib)
    foldl
    imap0
    mod
    reverseList
    stringToCharacters
    toLower
    ;
  inherit
    (builtins)
    add
    elemAt
    map
    stringLength
    substring
    ;
in rec {
  math = rec {
    # Go figure out why but nixpkgs standard lib doesn't include a pow function
    # Thats annoying'
    pow = base: exponent:
      if exponent > 1
      then let
        x = pow base (exponent / 2);
        odd_exp = mod exponent 2 == 1;
      in
        x
        * x
        * (
          if odd_exp
          then base
          else 1
        )
      else if exponent == 1
      then base
      else if exponent == 0 && base == 0
      then throw "undefined"
      else if exponent == 0
      then 1
      else throw "undefined";
  };

  color = let
    hexToDecMap = {
      "0" = 0;
      "1" = 1;
      "2" = 2;
      "3" = 3;
      "4" = 4;
      "5" = 5;
      "6" = 6;
      "7" = 7;
      "8" = 8;
      "9" = 9;
      "a" = 10;
      "b" = 11;
      "c" = 12;
      "d" = 13;
      "e" = 14;
      "f" = 15;
    };
  in rec {
    base16To10 = exponent: scalar: scalar * math.pow 16 exponent;

    hexToDec = hex: let
      decimals = map hexCharToDec (stringToCharacters hex);
      decimalsAscending = reverseList decimals;
      decimalsPowered = imap0 base16To10 decimalsAscending;
    in
      foldl add 0 decimalsPowered;

    hexCharToDec = hex: let
      lowerHex = toLower hex;
    in
      if stringLength hex != 1
      then throw "Function only accepts a single character."
      else if hexToDecMap ? ${lowerHex}
      then hexToDecMap."${lowerHex}"
      else throw "Character ${hex} is not a hexadecimal value.";

    # WARN: This will NOT work with hex strings that are not 6 characters long
    hexToRGB = hex: let
      rgbStartIndex = [0 2 4];
      hexList = map (idx: builtins.substring idx 2 hex) rgbStartIndex;
      hexLength = stringLength hex;
      ret = map hexToDec hexList;
    in {
      r = elemAt ret 0;
      g = elemAt ret 1;
      b = elemAt ret 2;
    };
  };
}
