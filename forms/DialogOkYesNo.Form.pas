unit DialogOkYesNo.Form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Base.Form, ExtCtrls, StdCtrls, JcPanel, JcButton, Vcl.Imaging.pngimage;

type
  TTypeDialog = (tdOk, tdYesNo);

  TFormDialogOKYesNo = class(Tbase_form)
    pnlMain: TPanel;
    lblMensagem: TLabel;
    pnlLogo: TPanel;
    imgExclamation: TImage;
    pnlButtons: TPanel;
    BtnYes: TJcButton;
    btnOk: TJcButton;
    btnNo: TJcButton;
    imgInterrogation: TImage;
    pnlbuttonLine: TPanel;
    pnltopLine: TPanel;
    FormAlert: TTimer;
    procedure BtnYesClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
    procedure FormAlertTimer(Sender: TObject);
  private
    FYesNO: TModalResult;
    { Private declarations }
  public
    { Public declarations }
    function Mensagem(AMSG1, AMSG2: String; ADialog: TTypeDialog): TModalResult;
    constructor Create(AOwner: TComponent); override;

    Property YesNO: TModalResult read FYesNO write FYesNO default mrNo;
  end;

function Dialog: TFormDialogOKYesNo;

implementation

uses
  System.Math;

var
  _FormDialogOKYesNo: TFormDialogOKYesNo;

{$R *.dfm}

{ TFormDialogYesNo }

procedure TremerForm(Form: HWND);
var
  R: TRect;
  x: integer;
  Esq, Topo: integer;
begin
  { Coordenadas do formulário }
  GetWindowRect( Form, R );

  for x := 0 to 1 do
  begin
    { Gera as posições aleatórias }
    Esq  := RandomRange( -7, 7 );
    Topo := RandomRange( -7, 7 );

    { Atribui a nova posição do formulário }
    SetWindowPos( Form, 0, R.Left + Esq, R.Top + Topo, R.Right - R.Left, R.Bottom - R.Top, 0 );

    { Tempo para mostrar que está tremendo o formulário }
    Sleep(20);
  end;

  { Retorna a posição do formulário }
  SetWindowPos( Form, 0, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top, 0 );
end;

function Dialog: TFormDialogOKYesNo;
begin
  if not Assigned(_FormDialogOKYesNo) then
    _FormDialogOKYesNo := TFormDialogOKYesNo.Create(nil);

  _FormDialogOKYesNo.FormAlert.Enabled := true;
  Result := _FormDialogOKYesNo;
end;

constructor TFormDialogOKYesNo.Create(AOwner: TComponent);
begin
  inherited;
  lblMensagem.Caption := '';
end;

procedure TFormDialogOKYesNo.BtnYesClick(Sender: TObject);
begin
  inherited;
  YesNO := mrYes;
  Close;
end;

procedure TFormDialogOKYesNo.btnOkClick(Sender: TObject);
begin
  inherited;
  YesNO := mrOk;
  Close;
end;

procedure TFormDialogOKYesNo.btnNoClick(Sender: TObject);
begin
  inherited;
  YesNO := MrNo;
  Close;
end;

function TFormDialogOKYesNo.Mensagem(AMSG1, AMSG2: String; ADialog: TTypeDialog): TModalResult;
var
 msg: string;
begin
  // Limpa Mensagens anteriores
  lblMensagem.Caption := '';
  btnOk.Visible := False;
  btnNo.Visible := false;
  BtnYes.Visible := false;
  imgInterrogation.Visible := False;
  imgExclamation.Visible := false;

  case ADialog of
    tdOk:
      begin
        imgExclamation.Visible := True;
        btnOk.Visible := True;
      end;
    tdYesNo:
      begin
        imgInterrogation.Visible := True;
        btnNo.Visible := True;
        BtnYes.Visible := True;
      end;
  end;

  if (Trim(AMSG1) <> '') and ((Trim(AMSG2) <> '')) then
    msg := AMSG1 + #13 + AMSG2
  else
    msg := AMSG1;

  lblMensagem.Caption := msg;

  _FormDialogOKYesNo.ShowModal;
  _FormDialogOKYesNo.BringToFront;

  Result := YesNO;
end;


procedure TFormDialogOKYesNo.FormAlertTimer(Sender: TObject);
begin
  inherited;
  FormAlert.Enabled := false;
  TremerForm(self.Handle);
end;

initialization

finalization
  if Assigned(_FormDialogOKYesNo) then
  begin
    _FormDialogOKYesNo.Free;
  end;

end.
