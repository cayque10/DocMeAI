unit GeminiAPI.Entity;

interface

uses
  Utils.Pkg.Json.DTO,
  System.Generics.Collections,
  REST.Json.Types;

{$M+}

type
  TCandidatesTokensDetails = class;
  TContent = class;
  TParts = class;
  TPromptTokensDetails = class;

  TCandidatesTokensDetails = class
  private
    [JSONName('modality')]
    FModality: string;
    [JSONName('tokenCount')]
    FTokenCount: Integer;
  published
    property Modality: string read FModality write FModality;
    property TokenCount: Integer read FTokenCount write FTokenCount;
  end;

  TPromptTokensDetails = class
  private
    [JSONName('modality')]
    FModality: string;
    [JSONName('tokenCount')]
    FTokenCount: Integer;
  published
    property Modality: string read FModality write FModality;
    property TokenCount: Integer read FTokenCount write FTokenCount;
  end;

  TUsageMetadata = class(TJsonDTO)
  private
    [JSONName('candidatesTokenCount')]
    FCandidatesTokenCount: Integer;
    [JSONName('candidatesTokensDetails'), JSONMarshalled(False)]
    FCandidatesTokensDetailsArray: TArray<TCandidatesTokensDetails>;
    [GenericListReflect]
    FCandidatesTokensDetails: TObjectList<TCandidatesTokensDetails>;
    [JSONName('promptTokenCount')]
    FPromptTokenCount: Integer;
    [JSONName('promptTokensDetails'), JSONMarshalled(False)]
    FPromptTokensDetailsArray: TArray<TPromptTokensDetails>;
    [GenericListReflect]
    FPromptTokensDetails: TObjectList<TPromptTokensDetails>;
    [JSONName('totalTokenCount')]
    FTotalTokenCount: Integer;
    function GetCandidatesTokensDetails: TObjectList<TCandidatesTokensDetails>;
    function GetPromptTokensDetails: TObjectList<TPromptTokensDetails>;
  protected
    function GetAsJson: string; override;
  published
    property CandidatesTokenCount: Integer read FCandidatesTokenCount write FCandidatesTokenCount;
    property CandidatesTokensDetails: TObjectList<TCandidatesTokensDetails> read GetCandidatesTokensDetails;
    property PromptTokenCount: Integer read FPromptTokenCount write FPromptTokenCount;
    property PromptTokensDetails: TObjectList<TPromptTokensDetails> read GetPromptTokensDetails;
    property TotalTokenCount: Integer read FTotalTokenCount write FTotalTokenCount;
  public
    destructor Destroy; override;
  end;

  TParts = class
  private
    [JSONName('text')]
    FText: string;
  published
    property Text: string read FText write FText;
  end;

  TContent = class(TJsonDTO)
  private
    [JSONName('parts'), JSONMarshalled(False)]
    FPartsArray: TArray<TParts>;
    [GenericListReflect]
    FParts: TObjectList<TParts>;
    [JSONName('role')]
    FRole: string;
    function GetParts: TObjectList<TParts>;
  protected
    function GetAsJson: string; override;
  published
    property Parts: TObjectList<TParts> read GetParts;
    property Role: string read FRole write FRole;
  public
    destructor Destroy; override;
  end;

  TCandidates = class
  private
    [JSONName('avgLogprobs')]
    FAvgLogprobs: Double;
    [JSONName('content')]
    FContent: TContent;
    [JSONName('finishReason')]
    FFinishReason: string;
  published
    property AvgLogprobs: Double read FAvgLogprobs write FAvgLogprobs;
    property Content: TContent read FContent;
    property FinishReason: string read FFinishReason write FFinishReason;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TGeminiAPIEntity = class(TJsonDTO)
  private
    [JSONName('candidates'), JSONMarshalled(False)]
    FCandidatesArray: TArray<TCandidates>;
    [GenericListReflect]
    FCandidates: TObjectList<TCandidates>;
    [JSONName('modelVersion')]
    FModelVersion: string;
    [JSONName('usageMetadata')]
    FUsageMetadata: TUsageMetadata;
    function GetCandidates: TObjectList<TCandidates>;
  protected
    function GetAsJson: string; override;
  published
    property Candidates: TObjectList<TCandidates> read GetCandidates;
    property ModelVersion: string read FModelVersion write FModelVersion;
    property UsageMetadata: TUsageMetadata read FUsageMetadata;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TUsageMetadata }

destructor TUsageMetadata.Destroy;
begin
  GetPromptTokensDetails.Free;
  GetCandidatesTokensDetails.Free;
  inherited;
end;

function TUsageMetadata.GetCandidatesTokensDetails: TObjectList<TCandidatesTokensDetails>;
begin
  Result := ObjectList<TCandidatesTokensDetails>(FCandidatesTokensDetails, FCandidatesTokensDetailsArray);
end;

function TUsageMetadata.GetPromptTokensDetails: TObjectList<TPromptTokensDetails>;
begin
  Result := ObjectList<TPromptTokensDetails>(FPromptTokensDetails, FPromptTokensDetailsArray);
end;

function TUsageMetadata.GetAsJson: string;
begin
  RefreshArray<TCandidatesTokensDetails>(FCandidatesTokensDetails, FCandidatesTokensDetailsArray);
  RefreshArray<TPromptTokensDetails>(FPromptTokensDetails, FPromptTokensDetailsArray);
  Result := inherited;
end;

{ TContent }

destructor TContent.Destroy;
begin
  GetParts.Free;
  inherited;
end;

function TContent.GetParts: TObjectList<TParts>;
begin
  Result := ObjectList<TParts>(FParts, FPartsArray);
end;

function TContent.GetAsJson: string;
begin
  RefreshArray<TParts>(FParts, FPartsArray);
  Result := inherited;
end;

{ TCandidates }

constructor TCandidates.Create;
begin
  inherited;
  FContent := TContent.Create;
end;

destructor TCandidates.Destroy;
begin
  FContent.Free;
  inherited;
end;

{ TGeminiAPIEntity }

constructor TGeminiAPIEntity.Create;
begin
  inherited;
  FUsageMetadata := TUsageMetadata.Create;
end;

destructor TGeminiAPIEntity.Destroy;
begin
  FUsageMetadata.Free;
  GetCandidates.Free;
  inherited;
end;

function TGeminiAPIEntity.GetCandidates: TObjectList<TCandidates>;
begin
  Result := ObjectList<TCandidates>(FCandidates, FCandidatesArray);
end;

function TGeminiAPIEntity.GetAsJson: string;
begin
  RefreshArray<TCandidates>(FCandidates, FCandidatesArray);
  Result := inherited;
end;

end.
