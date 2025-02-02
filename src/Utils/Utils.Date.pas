unit Utils.Date;

interface

type

  TUtilsDate = class
  private
  protected
  public
    class function GetUTC(const ADate: TDateTime): TDateTime;
    class function GetLocalTime(const ADate: TDateTime): TDateTime;
    class function ISO8601ToLocalDateTime(const AISODateTime: string;
      const pFormat: String = 'dd/mm/yyyy hh:nn:ss'): string;
  end;

implementation

uses
  System.DateUtils,
  System.SysUtils;

{ TUtilsDate }

class function TUtilsDate.GetLocalTime(const ADate: TDateTime): TDateTime;
begin
  Result := TTimeZone.Local.ToLocalTime(ADate);
end;

class function TUtilsDate.GetUTC(const ADate: TDateTime): TDateTime;
begin
  Result := TTimeZone.Local.ToUniversalTime(ADate);
end;

class function TUtilsDate.ISO8601ToLocalDateTime(const AISODateTime: string; const pFormat: String): string;
var
  LUTCDateTime: TDateTime;
  LLocalDateTime: TDateTime;
begin
  if AISODateTime.Trim.IsEmpty then
    Exit('');

  LUTCDateTime := ISO8601ToDate(AISODateTime);

  LLocalDateTime := TTimeZone.Local.ToLocalTime(LUTCDateTime);

  Result := FormatDateTime(pFormat, LLocalDateTime);
end;

end.
