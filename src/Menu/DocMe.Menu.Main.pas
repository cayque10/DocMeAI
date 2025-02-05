unit DocMe.Menu.Main;

interface

uses
  ToolsAPI,
  Vcl.Menus,
  System.Classes,
  DocMe.Documentation;

type
  TDocMeMenuMain = class(TNotifierObject, IOTAWizard)
  private
    /// <summary>
    /// Creates the main menu for the application.
    /// </summary>
    procedure CreateMenu;

    /// <summary>
    /// Adds submenus to the specified parent menu item.
    /// </summary>
    /// <param name="pParentMenu">The parent menu item to which submenus will be added.</param>
    procedure AddSubMenus(pParentMenu: TMenuItem);

    /// <summary>
    /// Creates a submenu item under the specified parent menu.
    /// </summary>
    /// <param name="pParent">The parent menu item for the new submenu.</param>
    /// <param name="pCaption">The caption to display for the submenu.</param>
    /// <param name="pName">The name identifier for the submenu.</param>
    /// <param name="pOnClick">The event handler to be called when the submenu is clicked.</param>
    /// <param name="pImageIndex">The index of the image to display next to the submenu (default is -1).</param>
    /// <returns>The created submenu item.</returns>
    function CreateSubMenu(pParent: TMenuItem; const pCaption, pName: string; pOnClick: TNotifyEvent;
      pImageIndex: Integer = -1): TMenuItem;

    /// <summary>
    /// Handles document element events.
    /// </summary>
    /// <param name="Sender">The source of the event.</param>
    procedure OnDocumentElements(Sender: TObject);

    /// <summary>
    /// Handles configuration events.
    /// </summary>
    /// <param name="Sender">The source of the event.</param>
    procedure OnConfigurations(Sender: TObject);
  protected
    /// <summary>
    /// Retrieves the ID string associated with the object.
    /// </summary>
    /// <returns>The ID string.</returns>
    function GetIDString: string;

    /// <summary>
    /// Retrieves the name associated with the object.
    /// </summary>
    /// <returns>The name string.</returns>
    function GetName: string;

    /// <summary>
    /// Retrieves the current state of the wizard.
    /// </summary>
    /// <returns>The current wizard state.</returns>
    function GetState: TWizardState;

    /// <summary>
    /// Executes the main functionality of the object.
    /// </summary>
    procedure Execute;
  public
    /// <summary>
    /// Initializes a new instance of the object.
    /// </summary>
    constructor Create;

    /// <summary>
    /// Finalizes the object and releases resources.
    /// </summary>
    /// <returns></returns>
    destructor Destroy; override;
  end;

procedure RegisterMenuWizard;

implementation

uses
  DocMe.Configurations;

procedure RegisterMenuWizard;
begin
  RegisterPackageWizard(TDocMeMenuMain.Create);
end;

{ TDocMeMenuMain }

procedure TDocMeMenuMain.AddSubMenus(pParentMenu: TMenuItem);
begin
  CreateSubMenu(pParentMenu, 'Document', 'miDocument', OnDocumentElements);
  CreateSubMenu(pParentMenu, 'Configurations', 'miConfigurations', OnConfigurations);
end;

constructor TDocMeMenuMain.Create;
begin
  CreateMenu;
end;

procedure TDocMeMenuMain.CreateMenu;
var
  lMenu: TMainMenu;
  lMenuName: string;
  lMenuItem: TMenuItem;
begin
  lMenu := (BorlandIDEServices as INTAServices).MainMenu;
  lMenuName := 'miDocMe';

  if lMenu.FindComponent(lMenuName) <> nil then
    lMenu.FindComponent(lMenuName).Free;

  lMenuItem := TMenuItem.Create(lMenu);
  lMenuItem.Name := lMenuName;
  lMenuItem.Caption := 'DocMeAI';
  lMenu.Items.Add(lMenuItem);

  AddSubMenus(lMenuItem);
end;

function TDocMeMenuMain.CreateSubMenu(pParent: TMenuItem; const pCaption, pName: string; pOnClick: TNotifyEvent;
  pImageIndex: Integer): TMenuItem;
var
  lSubMenu: TMenuItem;
begin
  lSubMenu := TMenuItem.Create(pParent);
  lSubMenu.Caption := pCaption;
  lSubMenu.Name := pName;
  lSubMenu.OnClick := pOnClick;

  if pImageIndex <> -1 then
    lSubMenu.ImageIndex := pImageIndex;

  pParent.Add(lSubMenu);
  Result := lSubMenu;
end;

destructor TDocMeMenuMain.Destroy;
begin
  inherited;
end;

procedure TDocMeMenuMain.OnConfigurations(Sender: TObject);
var
  lFrmDocMeConfigurations: TFrmDocMeAIConfigurations;
begin
  lFrmDocMeConfigurations := TFrmDocMeAIConfigurations.Create(nil);
  try
    lFrmDocMeConfigurations.ShowModal;
  finally
    lFrmDocMeConfigurations.Free;
  end;
end;

procedure TDocMeMenuMain.OnDocumentElements(Sender: TObject);
var
  lFrmDocumentation: TFrmDocMeAIDocumentation;
begin
  lFrmDocumentation := TFrmDocMeAIDocumentation.Create(nil);
  try
    lFrmDocumentation.ShowModal;
  finally
    lFrmDocumentation.Free;
  end;
end;

procedure TDocMeMenuMain.Execute;
begin

end;

function TDocMeMenuMain.GetIDString: string;
begin
  Result := Self.ClassName;
end;

function TDocMeMenuMain.GetName: string;
begin
  Result := Self.ClassName;
end;

function TDocMeMenuMain.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

end.
