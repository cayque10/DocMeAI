unit WS.Wrapper.Converter;

interface

uses
  System.Classes;

type
  TWSWrapperConverter = class
  private
  public
    /// <summary>
    /// Converts the specified entity object to a TStringStream.
    /// </summary>
    /// <param name="AEntity">The entity object to be converted.</param>
    /// <returns>
    /// A TStringStream containing the serialized representation of the entity.
    /// </returns>
    class function EntitityToStream(const AEntity: TObject): TStringStream; overload;

    /// <summary>
    /// Converts the specified entity object of a generic type to a TStringStream,
    /// including only the specified field.
    /// </summary>
    /// <param name="AEntity">The entity object of type T to be converted.</param>
    /// <param name="AFieldName">The name of the field to include in the conversion.</param>
    /// <returns>
    /// A TStringStream containing the serialized representation of the entity's specified field.
    /// </returns>
    class function EntitityToStream<T: Class>(const AEntity: T; const AFieldName: String): TStringStream; overload;
  end;

implementation

uses
  System.JSON,
  System.Rtti,
  System.SysUtils,
  Rest.JSON.Types,
  System.TypInfo,
  System.Generics.Collections,
  WS.Wrapper.Attributes;

{ TRequestAdapterEntityToStream }

class function TWSWrapperConverter.EntitityToStream<T>(const AEntity: T; const AFieldName: String): TStringStream;
const
  PROPERTY_DEFAULT_PAG_JSON = 'asjson';
var
  LContext: TRttiContext;
  LType: TRttiType;
  LField: TRttiField;
  LProperty: TRttiProperty;
  I: Integer;
  LPropertyName: String;
  LJSONObject: TJSONObject;
  LFieldValue: Variant;
  LTypeKind: TTypeKind;
  LAttribute: TCustomAttribute;

begin
  Result := Nil;
  LContext := TRttiContext.Create;
  LType := LContext.GetType(T.ClassInfo);

  if Assigned(LType) then
  begin
    LJSONObject := TJSONObject.Create;
    try
      for I := 0 to Pred(Length(LType.GetFields)) do
      begin
        LField := LType.GetFields[I];
        LProperty := LType.GetProperties[I];

        LPropertyName := LProperty.Name.ToLower;

        for LAttribute in LProperty.GetAttributes do
          if (LAttribute is JSONNameAttribute) then
            LPropertyName := JSONNameAttribute(LAttribute).Value.ToLower;

        if LPropertyName.Equals(PROPERTY_DEFAULT_PAG_JSON) then
          continue;

        if (LPropertyName.Equals(AFieldName.ToLower)) then
        begin
          LTypeKind := LType.GetFields[I].FieldType.TypeKind;
          case LTypeKind of
            tkString, tkLString, tkWString, tkUString:
              begin
                LFieldValue := LField.GetValue(TObject(AEntity)).AsString;
                LJSONObject.AddPair(LPropertyName, String(LFieldValue));
              end;
            tkInteger:
              begin
                LFieldValue := LField.GetValue(TObject(AEntity)).AsInteger;
                LJSONObject.AddPair(LPropertyName, Integer(LFieldValue));
              end;
            tkInt64:
              begin
                LFieldValue := LField.GetValue(TObject(AEntity)).AsInt64;
                LJSONObject.AddPair(LPropertyName, Int64(LFieldValue));
              end;
            tkFloat:
              begin
                LFieldValue := LField.GetValue(TObject(AEntity)).AsCurrency;
                LJSONObject.AddPair(LPropertyName, Double(LFieldValue));
              end;
            tkClass:
              begin
                { if not Assigned(LProperty.GetValue(TObject(AEntity)).AsObject) then
                  continue; }
                // LJSONObject.AddPair(LPropertyName, LProperty.GetValue(TObject(AEntity)).AsObject);
              end;
            tkChar:
              begin
                LFieldValue := LField.GetValue(TObject(AEntity)).AsBoolean;
                LJSONObject.AddPair(LPropertyName, TJSONBool.Create(LFieldValue));
              end;
            tkEnumeration:
              begin
                LFieldValue := LField.GetValue(TObject(AEntity)).AsBoolean;
                LJSONObject.AddPair(LPropertyName, TJSONBool.Create(LFieldValue));
              end;
          else
            LJSONObject.AddPair(LPropertyName, LField.GetValue(TObject(AEntity)).AsString);
          end;
          Result := TStringStream.Create(TEncoding.UTF8.GetBytes(LJSONObject.ToJSON));
          Exit;
        end;
      end;

    finally
      LJSONObject.Free;
      LContext.Free;
      LType.Free;
    end;
  end;
end;

class function TWSWrapperConverter.EntitityToStream(const AEntity: TObject): TStringStream;
const
  PROPERTY_DEFAULT_PAG_JSON = 'asjson';
var
  LContext: TRttiContext;
  LType: TRttiType;
  LProperty: TRttiProperty;
  J: Integer;
  LPropertyName: String;
  LJSONArray: TJSONArray;
  LJSONObject: TJSONObject;
  LFieldValue, LArrayValue: TValue;
  LTypeKind: TTypeKind;
  LAttribute: TCustomAttribute;
  LEnumTypeInfo: PTypeInfo;
  lEnumName: String;
  LListValue: TObject;
  lArrayItem: TObject;
  LStringStreamAux: TStringStream;
  lJSONObj: TJSONObject;
  LIgnoreAttribute: Boolean;

  procedure IterateObjectListViaRTTI(AList: TObject; const AArray: TJSONArray);
  var
    LContext: TRttiContext;
    LListType: TRttiType;
    LMethod: TRttiMethod;
    LValue: TValue;
    LItem: TObject;
    I: Integer;
    LStringStreamAux2: TStringStream;
    JSONObject: TJSONObject;
  begin
    LContext := TRttiContext.Create;
    try
      LListType := LContext.GetType(AList.ClassType);

      // Checa se é uma lista genérica
      if AList.ClassName.Contains('TList<') or AList.ClassName.Contains('TObjectList<') then
      begin
        // Obtém o método 'ToArray' ou similar
        LMethod := LListType.GetMethod('ToArray');
        if Assigned(LMethod) then
        begin
          LValue := LMethod.Invoke(TValue.From(AList), []);

          if not LValue.IsEmpty and LValue.IsArray then
          begin
            for I := 0 to Pred(LValue.GetArrayLength) do
            begin
              LItem := LValue.GetArrayElement(I).AsObject;
              LStringStreamAux2 := EntitityToStream(LItem);
              if Assigned(LStringStreamAux2) then
              begin
                try
                  JSONObject := TJSONObject.ParseJSONValue(LStringStreamAux2.DataString) as TJSONObject;
                  if JSONObject <> nil then
                    AArray.Add(JSONObject);
                finally
                  LStringStreamAux2.Free;
                end;
              end;
            end;
          end;
        end;
      end
      else
        raise Exception.Create('O objeto fornecido não é uma TObjectList<T>');
    finally
      LContext.Free;
    end;
  end;

begin
  LIgnoreAttribute := False;
  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(AEntity.ClassInfo);

    if not Assigned(LType) then
      Exit(Nil);

    LJSONObject := TJSONObject.Create;
    try
      for LProperty in LType.GetProperties do
      begin
        LPropertyName := LProperty.Name.ToLower;

        // so mapeia caso tenho atributos JSONNAME
        for LAttribute in LProperty.GetAttributes do
        begin
          if LAttribute is WSWrapperConverter then
          begin
            LPropertyName := JSONNameAttribute(LAttribute).Value.ToLower;
            Break;
          end
          else if LAttribute is WSWrapperIgnore then
          begin
            LIgnoreAttribute := True;
            Break;
          end;
        end;

        if LIgnoreAttribute then
          continue;

        // Devido a usar a classe do Pkg, a property herdada é listada, assim ela é ignorada
        if LPropertyName.Equals(PROPERTY_DEFAULT_PAG_JSON) then
          continue;

        LTypeKind := LProperty.PropertyType.TypeKind;
        case LTypeKind of
          tkString, tkLString, tkWString, tkUString:
            begin
              LFieldValue := LProperty.GetValue(TObject(AEntity));
              LJSONObject.AddPair(LPropertyName, LFieldValue.AsString);
            end;
          tkInteger:
            begin
              LFieldValue := LProperty.GetValue(TObject(AEntity));
              LJSONObject.AddPair(LPropertyName, TJSONNumber.Create(LFieldValue.AsInteger));
            end;
          tkInt64:
            begin
              LFieldValue := LProperty.GetValue(TObject(AEntity));
              LJSONObject.AddPair(LPropertyName, TJSONNumber.Create(LFieldValue.AsInt64));
            end;
          tkFloat:
            begin
              LFieldValue := LProperty.GetValue(TObject(AEntity));
              LJSONObject.AddPair(LPropertyName, TJSONNumber.Create(LFieldValue.AsCurrency));
            end;
          tkClass:
            begin

              LFieldValue := LProperty.GetValue(TObject(AEntity));
              LListValue := LFieldValue.AsObject;

              if LListValue is TMemoryStream then
                continue;

              if not Assigned(LListValue) then
                continue;

              if LListValue.ClassName.Contains('TList<') or LListValue.ClassName.Contains('TObjectList<') then
              begin
                LJSONArray := TJSONArray.Create;
                IterateObjectListViaRTTI(LListValue, LJSONArray);
                LJSONObject.AddPair(LPropertyName, LJSONArray);
              end
              else
              begin
                LStringStreamAux := EntitityToStream(LListValue);
                if Assigned(LStringStreamAux) then
                begin
                  try
                    LJSONObject.AddPair(LPropertyName, TJSONObject.ParseJSONValue(LStringStreamAux.DataString)
                      as TJSONObject);
                  finally
                    LStringStreamAux.Free;
                  end;
                end;
              end;
            end;
          tkDynArray:
            begin
              LFieldValue := LProperty.GetValue(TObject(AEntity));

              if not LFieldValue.IsEmpty and LFieldValue.IsArray then
              begin
                LJSONArray := TJSONArray.Create;

                for J := 0 to Pred(LFieldValue.GetArrayLength) do
                begin
                  LArrayValue := LFieldValue.GetArrayElement(J);

                  if LArrayValue.IsEmpty then
                    continue;

                  lArrayItem := LArrayValue.AsObject;

                  if not Assigned(lArrayItem) then
                    continue;

                  LStringStreamAux := EntitityToStream(lArrayItem);
                  if Assigned(LStringStreamAux) then
                  begin
                    try
                      lJSONObj := TJSONObject.ParseJSONValue(LStringStreamAux.DataString) as TJSONObject;
                      if lJSONObj <> nil then
                        LJSONArray.Add(lJSONObj);
                    finally
                      LStringStreamAux.Free;
                    end;
                  end;
                end;

                LJSONObject.AddPair(LPropertyName, LJSONArray);
              end;

            end;
          tkChar:
            begin
              LFieldValue := LProperty.GetValue(TObject(AEntity));
              LJSONObject.AddPair(LPropertyName, TJSONBool.Create(LFieldValue.AsBoolean));
            end;
          tkEnumeration:
            begin
              LFieldValue := LProperty.GetValue(TObject(AEntity));

              if LProperty.PropertyType.Name.ToLower = 'boolean' then
              begin
                LJSONObject.AddPair(LPropertyName, TJSONBool.Create(LFieldValue.AsBoolean));
              end
              else
              begin
                LEnumTypeInfo := LProperty.PropertyType.Handle;
                if Assigned(LEnumTypeInfo) then
                begin
                  lEnumName := GetEnumName(LEnumTypeInfo, LFieldValue.AsOrdinal);
                  LJSONObject.AddPair(LPropertyName, TJSONNumber.Create(LFieldValue.AsOrdinal));
                end
              end;

            end;
        end;

      end;
      Result := TStringStream.Create(TEncoding.UTF8.GetBytes(LJSONObject.ToJSON))

    finally
      LJSONObject.Free;
    end;

  finally
    LContext.Free;
  end;
end;

end.
