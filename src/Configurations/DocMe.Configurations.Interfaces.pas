unit DocMe.Configurations.Interfaces;

interface

uses
  DocMe.AI.ProviderTypes;

type

  IDocMeAIConfig = interface
    ['{9857474D-4922-41F4-8DE8-FDC56C2206A1}']

    /// <summary>
    /// Loads the configuration settings.
    /// </summary>
    /// <returns>
    /// An instance of IDocMeAIConfig containing the loaded configuration.
    /// </returns>
    function LoadConfig: IDocMeAIConfig;

    /// <summary>
    /// Saves the current configuration settings.
    /// </summary>
    /// <returns>
    /// An instance of IDocMeAIConfig containing the saved configuration.
    /// </returns>
    function SaveConfig: IDocMeAIConfig;

    /// <summary>
    /// Gets the API key.
    /// </summary>
    /// <returns>
    /// A string representing the API key.
    /// </returns>
    function ApiKey: string; overload;

    /// <summary>
    /// Sets the API key.
    /// </summary>
    /// <param name="Value">
    /// A string representing the API key to set.
    /// </param>
    /// <returns>
    /// An instance of IDocMeAIConfig for method chaining.
    /// </returns>
    function ApiKey(const AValue: string): IDocMeAIConfig; overload;

    /// <summary>
    /// Gets the AI model.
    /// </summary>
    /// <returns>
    /// A string representing the AI model.
    /// </returns>
    function ModelAI: string; overload;

    /// <summary>
    /// Sets the AI model.
    /// </summary>
    /// <param name="Value">
    /// A string representing the AI model to set.
    /// </param>
    /// <returns>
    /// An instance of IDocMeAIConfig for method chaining.
    /// </returns>
    function ModelAI(const AValue: string): IDocMeAIConfig; overload;

    /// <summary>
    /// Gets the maximum number of tokens.
    /// </summary>
    /// <returns>
    /// An integer representing the maximum number of tokens.
    /// </returns>
    function MaxTokens: Integer; overload;

    /// <summary>
    /// Sets the maximum number of tokens.
    /// </summary>
    /// <param name="Value">
    /// An integer representing the maximum number of tokens to set.
    /// </param>
    /// <returns>
    /// An instance of IDocMeAIConfig for method chaining.
    /// </returns>
    function MaxTokens(const AValue: Integer): IDocMeAIConfig; overload;

    /// <summary>
    /// Gets the temperature setting.
    /// </summary>
    /// <returns>
    /// A double representing the temperature setting.
    /// </returns>
    function Temperature: Double; overload;

    /// <summary>
    /// Sets the temperature setting.
    /// </summary>
    /// <param name="Value">
    /// A double representing the temperature setting to set.
    /// </param>
    /// <returns>
    /// An instance of IDocMeAIConfig for method chaining.
    /// </returns>
    function Temperature(const AValue: Double): IDocMeAIConfig; overload;

    /// <summary>
    /// Retrieves the current AI provider type.
    /// </summary>
    /// <returns>
    /// The current AI provider type as a <see cref="TDocMeAIProviderType"/>.
    /// </returns>
    function AIProviderType: TDocMeAIProviderType; overload;

    /// <summary>
    /// Sets the AI provider type and returns the corresponding configuration.
    /// </summary>
    /// <param name="AType">
    /// The AI provider type to set, specified as a <see cref="TDocMeAIProviderType"/>.
    /// </param>
    /// <returns>
    /// An interface to the AI configuration as <see cref="IDocMeAIConfig"/>.
    /// </returns>
    function AIProviderType(const AType: TDocMeAIProviderType): IDocMeAIConfig; overload;

    /// <summary>
    /// Gets the active state of the configuration.
    /// </summary>
    /// <returns>
    /// Returns a Boolean indicating whether the configuration is active.
    /// </returns>
    function Active: Boolean; overload;

    /// <summary>
    /// Sets the active state of the configuration.
    /// </summary>
    /// <param name="AValue">
    /// A Boolean value indicating the desired active state.
    /// </param>
    /// <returns>
    /// Returns an instance of <see cref="IDocMeAIConfig"/> for method chaining.
    /// </returns>
    function Active(const AValue: Boolean): IDocMeAIConfig; overload;
  end;

implementation

end.
