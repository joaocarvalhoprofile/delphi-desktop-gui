unit Main.Form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,  System.Variants,
  Graphics, Controls, Forms, Dialogs, Menus, Registry,
  ComCtrls, ExtCtrls, ImgList, StdCtrls, Mask,
  ToolWin, ActnMan, ActnColorMaps, Vcl.ActnCtrls, Vcl.ActnMenus,
  Base.Form, Vcl.Imaging.pngimage, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ActnPopup, System.Classes, System.Actions, Vcl.ActnList, Vcl.Buttons,
  JcPanel, JcButton, JcTDIForm, Vcl.CategoryButtons;

type
  TMain_Form = class(Tbase_form)
    TimerLogin: TTimer;
    pnlLayout: TPanel;
    pnlMain: TPanel;
    pnlForm: TPanel;
    JcTDIForm: TJcTDIForm;
    pnlTitle: TPanel;
    lblSoftwarePartner: TLabel;
    lblByEzHelp: TLabel;
    PnlTerminate: TPanel;
    BtnTerminate: TSpeedButton;
    pnlMinimize: TPanel;
    btnMinimize: TSpeedButton;
    pnlHelp: TPanel;
    btnHelp: TSpeedButton;
    pnlTitleConfig: TPanel;
    btnTitleConfig: TSpeedButton;
    pnlTitleUser: TPanel;
    btnTitleUser: TSpeedButton;
    imgMenu: TImage;
    pnlMenu: TJcPanel;
    pnlMenuTop: TJcPanel;
    pnlMenuSearch: TJcPanel;
    ImgMenuSearch: TImage;
    edtMenuSearch: TEdit;
    MainMenu: TMainMenu;
    TrVMenu: TTreeView;
    Imagens: TImageList;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TimerLoginTimer(Sender: TObject);
    procedure img_LicencaOffClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure img_LicencaOnClick(Sender: TObject);
    procedure Act_AlterarSenhaExecute(Sender: TObject);
    procedure Act_LogoffExecute(Sender: TObject);
    procedure btn_barsClick(Sender: TObject);
    procedure img_top_userClick(Sender: TObject);
    procedure BtnTerminateClick(Sender: TObject);
    procedure BtnTerminateMouseEnter(Sender: TObject);
    procedure BtnTerminateMouseLeave(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure TrVMenuDblClick(Sender: TObject);
    procedure TrVMenuKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure TrVMenuGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure TrVMenuGetSelectedIndex(Sender: TObject; Node: TTreeNode);
  private
    FModuloSelecionado: String;
    Fmodule: string;
    Fsystem: string;
  protected
    function AppAntesSair: Boolean; virtual;
    function AppSair: Boolean; virtual;
    function doLogin: Boolean; Virtual;
    function DoAlterarSenha: Boolean; Virtual;
    function DoLogoff: Boolean; Virtual;

    procedure ExibirMenu(AAcao: Boolean = false);
    function ShowForm(AForm: TBase_Form; AAction: String; Acoplado: Boolean = True):Boolean; virtual;

    procedure CriaDiretorios; virtual;
    procedure Environment(AAcao: Boolean); virtual;
    procedure VerificarLicenca(ACNPJ: String); virtual;
    procedure AbreLicenca(); virtual;

    procedure ApplyStyles; override;
  public
    constructor create();

    procedure CriarMenuUsuario(MenuTreeView: TTreeView; MainMenu: TMainMenu; fMenu: TMenu); virtual;

    property system: string read Fsystem write Fsystem;
    property module: string read Fmodule write Fmodule;
  end;

var
  Main_Form: TMain_Form;

implementation

{$R *.dfm}

uses DialogOkYesNo.Form;

     //ParAtivarLicenca.Form,
     //ParActionMenu.Form,
     //ParPerfil.Form,
     //ParUsuario.Form;

function TMain_Form.AppAntesSair: Boolean;
begin
  Result := true;

  if JcTDIForm.getFormNum > 0 then
  begin
    Dialog.Mensagem('Existem janelas abertas.', 'Por favor feche todas as janelas antes de encerrar a aplicação !', tdOk);
    Result := False;
    abort;
  end;
end;

procedure TMain_Form.ApplyStyles;
begin
  inherited;

end;

function TMain_Form.AppSair: Boolean;
begin
  Result := true;

  AppAntesSair;

  if (Dialog.Mensagem('Confirma o fechamento da aplicação ?', '', tdYesNo) = mrNo)  then
  begin
    Result := False;
    Abort;
  end;

  Application.Terminate;
end;

procedure TMain_Form.AbreLicenca();
begin
  TimerLogin.Enabled := True;
end;

procedure TMain_Form.VerificarLicenca(ACNPJ: String);
begin

end;

procedure TMain_Form.CriaDiretorios;
begin

end;

procedure TMain_Form.CriarMenuUsuario(MenuTreeView: TTreeView; MainMenu: TMainMenu; fMenu: TMenu);
var
   i, j, l, posic:integer;
   a, b, c: string;
   mI, mS, mSS: TMenuItem;
   n,tn,stn: TTreeNode;
begin

   MenuTreeView.Items.Clear;
   tn := nil;
   stn := nil;
   for i := 0 to MainMenu.Items.Count - 1 do
   begin
     mI := fMenu.Items[i];
     a  := mI.Caption;
     posic := pos('&', a);
     if posic > 0 then
        Delete(a,posic,1);
     if mI.Visible then
     begin
       n := MenuTreeView.Items.AddChildObject(tn, a, fmenu.items[i]);

       for j := 0 to mI.Count - 1 do
       begin
         mS := mI.Items[j];
         if mS.Visible then
         begin
           b := mS.Caption;
           posic := pos('&', b);
           if posic > 0 then
             Delete(b,posic,1);
           if b <> '-' then
             stn := MenuTreeView.Items.AddChildObject(n,b,mI.Items[j]);

           for l := 0 to ms.Count -1 do
           begin
             mSS := mS.Items[l];
             if mSS.Visible then
             begin
               c := mSS.Caption;
               posic := pos('&',c);
               if posic > 0 then
                 Delete(c,posic,1);
               if c <> '-' then
                 MenuTreeView.Items.AddChildObject(stn, c,mS.Items[l]);
             end;
           end;
         end;
       end;
     end;
   end;
end;

function TMain_Form.DoAlterarSenha: Boolean;
begin
  Result := False;
  AppAntesSair;
  Environment(False);
end;

function TMain_Form.DoLogin: Boolean;
begin
  Result := False;
end;

function TMain_Form.DoLogoff: Boolean;
begin
 Result := False;
 AppAntesSair;
 Environment(False);
end;

procedure TMain_Form.Environment(AAcao: Boolean);
var
  sMensagem: String;
begin
  Caption := Application.Title;
  sMensagem := '';
  FormatSettings.DecimalSeparator := ',';

  if (FormatSettings.CurrencyString <> 'R$ ') and (FormatSettings.CurrencyString <> 'R$') then
    sMensagem := 'o símbolo da moeda deve ser ''R$ '' e está ''' +
      FormatSettings.CurrencyString + '''';

  if Copy(UpperCase(FormatSettings.ShortDateFormat),1,10) <> 'DD/MM/YYYY' then
  begin
    if sMensagem <> '' then
      sMensagem := ' e '+#13;
    sMensagem := sMensagem +
      'o estilo da data abreviada deve ser   ''dd/MM/aaaa''  e está   ''' +
          FormatSettings.ShortDateFormat + '''';
  end;

  if FormatSettings.DateSeparator <> '/' then
  begin
    if sMensagem <> '' then
      sMensagem := ' e '+#13;
    sMensagem := sMensagem +
      'o separador de Data deve ser ''/'' e está ''' + FormatSettings.DateSeparator + '''';
  end;

  if FormatSettings.TimeSeparator <> ':' then
  begin
    if sMensagem <> '' then
      sMensagem := ' e '+#13;
    sMensagem := sMensagem +
      'o separador de Hora deve ser '':'' e está ''' + FormatSettings.TimeSeparator + '''';
  end;

  if sMensagem > '' then begin
    ShowMessage('Acerte a configuração regional do Windows' + #13 + #13 +
      'Configure o Windows em botão Iniciar, Configurações,' + #13 +
      'Painel de Controle, Configurações Regionais para Português(Brasileiro)' +
      #13 + 'Verifique : '+ #13 + #13 + #13 + sMensagem + '.');

    // Finaliza a aplicação
    Application.Terminate;
  end;

//  if AAcao then
//  begin
//    pnl_Menu.Visible         := True;
//   // Self.Caption             := SD_CAPTION;
//    TimerLogin.Enabled       := True;
//  end
//  else
//  begin
//    pnl_Menu.Visible         := False;
////    Act_ActionMenu.Visible   := False;
////    Act_Perfil.Visible       := False;
////    Act_Usuario.Visible      := False;
////    Self.Caption             := SD_CAPTION;
//    TimerLogin.Enabled       := False;
//  end;
end;

procedure TMain_Form.TimerLoginTimer(Sender: TObject);
begin
  inherited;
  TimerLogin.Enabled := False;
end;

procedure TMain_Form.TrVMenuDblClick(Sender: TObject);
var
  T: TTreeView;
begin
  T := Sender as TTreeView;
  if Assigned(T) and
     Assigned(T.Selected) and
     Assigned(T.Selected.Data) and
     (TObject(T.Selected.Data) is TMenuItem) and
     Assigned(TMenuItem(T.Selected.Data).OnClick) then
    TMenuItem(T.Selected.Data).OnClick(Self);
end;

procedure TMain_Form.TrVMenuGetImageIndex(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  if Node.HasChildren then
  begin
    if node.Expanded then
      node.ImageIndex := 1
    else
      node.ImageIndex := 0
  end
  else
  begin
    node.ImageIndex := 2;
  end;
end;

procedure TMain_Form.TrVMenuGetSelectedIndex(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TMain_Form.TrVMenuKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  T: TTreeView;
begin
  if key = vk_Return then
  begin
    T := Sender as TTreeView;
    if Assigned(T) and
       Assigned(T.Selected) and
       Assigned(T.Selected.Data) and
       (TObject(T.Selected.Data) is TMenuItem) and
       Assigned(TMenuItem(T.Selected.Data).OnClick) then
      TMenuItem(T.Selected.Data).OnClick(Self);
  end;
end;

procedure TMain_Form.ExibirMenu(AAcao: Boolean = false);
begin
//  if AAcao then
//  begin
//    if pnl_left.Width = 50 then
//    begin
//      pnl_left.Width := 250;
//      img_icon.Visible := false;
////      img_logo.Visible := true;
//
////      pnl_menu_modulos.Visible := false;
////      pnl_menu_actions.Visible := true;
//    end;
//  end
//  else
//  begin
//    if pnl_left.Width = 50 then
//    begin
//      pnl_left.Width := 250;
//      img_icon.Visible := false;
////      img_logo.Visible := true;
//
////      pnl_menu_modulos.Visible := false;
////      pnl_menu_actions.Visible := true;
//    end
//    else if pnl_left.Width = 250 then
//    begin
//      pnl_left.Width := 50;
//      img_icon.Visible := true;
////      img_logo.Visible := false;
//
////      pnl_menu_modulos.Visible := true;
////      pnl_menu_actions.Visible := false;
//    end
//  end;
end;

function TMain_Form.ShowForm(AForm: TBase_Form; AAction: String; Acoplado: Boolean): Boolean;
begin
  //if UsuarioTemAcesso(AForm, AAction) = nil then
  //begin
  //  Dialog.Mensagem('Erro ao verificar permissão do usuário para este módulo !', '', tdOK);
  //  abort;
  //end;

  // Habilita Visualizacao dos forms
  if not JcTDIForm.Visible then
  begin
    pnlMenu.Visible := False;
    JcTDIForm.Visible := True;
    JcTDIForm.Align := alClient;
  end;

  if Acoplado then
  begin
    if not JcTDIForm.getFormName(AForm) then
      JcTDIForm.addForm(AForm);
  end
  else
    AForm.ShowModal;
end;

procedure TMain_Form.btnMinimizeClick(Sender: TObject);
begin
  inherited;
  Application.Minimize;
end;

procedure TMain_Form.BtnTerminateClick(Sender: TObject);
begin
  inherited;
  AppSair;
end;

procedure TMain_Form.BtnTerminateMouseEnter(Sender: TObject);
begin
  inherited;
  PnlTerminate.Color := clred;
end;

procedure TMain_Form.BtnTerminateMouseLeave(Sender: TObject);
begin
  inherited;
  PnlTerminate.Color := $00393A3E;
end;

procedure TMain_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
//  if Key = vk_F12 then
//  begin
//    if not pnl_Menu.Visible then
//    begin
//      JcTDIForm.Visible := False;
//      pnl_Menu.Visible  := True;
//      pnl_Menu.Align    := alClient;
//    end;
//
//    abort;
//  end;
end;

procedure TMain_Form.FormShow(Sender: TObject);
begin
  inherited;
  CriarMenuUsuario(TrVMenu, MainMenu, MainMenu);
end;

procedure TMain_Form.img_LicencaOffClick(Sender: TObject);
begin
  inherited;
  AbreLicenca;
end;

procedure TMain_Form.img_LicencaOnClick(Sender: TObject);
begin
  inherited;
  AbreLicenca;
end;

procedure TMain_Form.img_top_userClick(Sender: TObject);
var
   pt : TPoint;
begin
    pt.x := TButton(Sender).Left + 1;
    pt.y := TButton(Sender).Top + TButton(Sender).Height + 1;
    pt := Self.ClientToScreen( pt );
//    pup_Usuario.popup( pt.x, pt.y );
end;

procedure TMain_Form.btn_barsClick(Sender: TObject);
begin
  ExibirMenu();
end;

constructor TMain_Form.create;
begin

end;

procedure TMain_Form.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  if not AppAntesSair then
    CanClose := False
  else
  begin
    if not AppSair then
    begin
      CanClose := False;
      Abort;
    end;

    CanClose := True;
  end;
end;

procedure TMain_Form.FormCreate(Sender: TObject);
Var
  LoginSucesso: Boolean;
begin
  // Efetua Login
  LoginSucesso := True;

  // Cria ambiente
  Environment(True);
  CriaDiretorios;
  ExibirMenu();
  Application.Title := Caption ;
end;

// Acctions

procedure TMain_Form.Act_AlterarSenhaExecute(Sender: TObject);
begin
  inherited;
  DoAlterarSenha;
end;

procedure TMain_Form.Act_LogoffExecute(Sender: TObject);
begin
  inherited;
  DoLogoff;
end;

end.
