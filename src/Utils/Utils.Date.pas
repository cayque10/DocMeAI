unit Utils.Date;

interface

type

  TUtilsDate = class
  private
  protected
  public
    /// <summary>
    /// Converts the given date and time from local time to UTC.
    /// </summary>
    /// <param name="ADate">The local date and time to be converted.</param>
    /// <returns>
    /// The corresponding UTC date and time.
    /// </returns>
    class function GetUTC(const ADate: TDateTime): TDateTime;

    /// <summary>
    /// Converts the given date and time from UTC to local time.
    /// </summary>
    /// <param name="ADate">The UTC date and time to be converted.</param>
    /// <returns>
    /// The corresponding local date and time.
    /// </returns>
    class function GetLocalTime(const ADate: TDateTime): TDateTime;

    /// <summary>
    /// Converts an ISO 8601 formatted date and time string to a local date and time string.
    /// </summary>
    /// <param name="AISODateTime">The ISO 8601 formatted date and time string to convert.</param>
    /// <param name="pFormat">The format to use for the output date and time string (default is 'dd/mm/yyyy hh:nn:ss').</param>
    /// <returns>
    /// The local date and time string formatted according to the specified format.
    /// </returns>
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
