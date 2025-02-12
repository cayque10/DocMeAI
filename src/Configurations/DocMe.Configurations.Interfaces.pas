unit DocMe.Configurations.Interfaces;

interface

uses
  DocMe.AI.ProviderTypes,
  DocMe.AI.Interfaces;

type
  IDocMeAIConfig = interface;

  IDocMeAIGit = interface
    ['{E812FC2A-9633-4822-BB8D-32698DE18E52}']
    /// <summary>
    /// Retrieves the file path as a string.
    /// </summary>
    /// <returns>
    /// A string containing the file path.
    /// </returns>
    function FilePath: string; overload;

    /// <summary>
    /// Sets the file path with the specified value.
    /// </summary>
    /// <param name="AValue">
    /// A string representing the file path to set.
    /// </param>
    /// <returns>
    /// An instance of <see cref="IDocMeAIGit"/> for method chaining.
    /// </returns>
    function FilePath(const AValue: string): IDocMeAIGit; overload;

    /// <summary>
    /// Retrieves the ignored extensions as a string.
    /// </summary>
    /// <returns>
    /// A string containing the ignored extensions.
    /// </returns>
    function IgnoreExtensions: string; overload;

    /// <summary>
    /// Sets the ignored extensions with the specified value.
    /// </summary>
    /// <param name="AExtensions">
    /// A string representing the extensions to ignore.
    /// </param>
    /// <returns>
    /// An instance of <see cref="IDocMeAIGit"/> for method chaining.
    /// </returns>
    function IgnoreExtensions(const AExtensions: string): IDocMeAIGit; overload;

    /// <summary>
    /// Retrieves the project path as a string.
    /// </summary>
    /// <returns>
    /// A string containing the project path.
    /// </returns>
    function ProjectPath: string; overload;

    /// <summary>
    /// Sets the project path with the specified value.
    /// </summary>
    /// <param name="AValue">
    /// A string representing the project path to set.
    /// </param>
    /// <returns>
    /// An instance of <see cref="IDocMeAIGit"/> for method chaining.
    /// </returns>
    function ProjectPath(const AValue: string): IDocMeAIGit; overload;

    /// <summary>
    /// Finalizes the configuration and returns an instance of <see cref="IDocMeAIConfig"/>.
    /// </summary>
    /// <returns>
    /// An instance of <see cref="IDocMeAIConfig"/> representing the finalized configuration.
    /// </returns>
    function &End: IDocMeAIConfig;
  end;

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
    /// Retrieves the current AI provider type.
    /// </summary>
    /// <returns>
    /// The current AI provider type as a <see cref="string"/>.
    /// </returns>
    function AIProviderTypeName: string;

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

    /// <summary>
    /// Retrieves an instance of the IAIModelsProvider interface.
    /// </summary>
    /// <returns>
    /// An instance of <see cref="IAIModelsProvider"/> that provides access to AI models.
    /// </returns>
    function AIModelsProvider: IAIModelsProvider;

    /// <summary>
    /// Retrieves an instance of the IDocMeAIGit interface.
    /// </summary>
    /// <returns>
    /// An instance of <see cref="IDocMeAIGit"/>.
    /// </returns>
    function AIGit: IDocMeAIGit;
  end;

implementation

end.
