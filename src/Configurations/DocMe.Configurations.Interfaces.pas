unit DocMe.Configurations.Interfaces;

interface

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
    function ApiKey(const Value: string): IDocMeAIConfig; overload;

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
    function ModelAI(const Value: string): IDocMeAIConfig; overload;

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
    function MaxTokens(const Value: Integer): IDocMeAIConfig; overload;

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
    function Temperature(const Value: Double): IDocMeAIConfig; overload;
  end;

implementation

end.
