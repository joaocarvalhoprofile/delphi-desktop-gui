unit Progress.Form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Base.Form, ExtCtrls, StdCtrls, JcPanel, JcProgressBar;

type
  TProgress_Form = class(TBase_Form)
    JcPanel1: TJcPanel;
    jcProgressBar: TJcProgressBar;
    lblMsg: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Mensagem(AValue: String; AProgress: Integer = 50);
    constructor Create(AOwner: TComponent); override;
  end;

function Aguarde: TProgress_Form;

implementation

var
  _FormProgress: TProgress_Form;

function Aguarde: TProgress_Form;
begin
  if not Assigned(_FormProgress) then
    _FormProgress := TProgress_Form.Create(nil);
  Result := _FormProgress;
end;

{$R *.dfm}

{ TProgress_Form }

constructor TProgress_Form.Create(AOwner: TComponent);
begin
  inherited;
  lblMsg.Caption := '';
end;

procedure TProgress_Form.Mensagem(AValue: String; AProgress: Integer);
begin
  if Trim(AValue) <> '' then
  begin
    _FormProgress.Show;
    _FormProgress.BringToFront;
    lblMsg.Caption := AValue;
    jcProgressBar.Position := AProgress;
    jcProgressBar.Refresh;
    Application.ProcessMessages;
  end
  else
  begin
    _FormProgress.Hide;
  end;
end;

initialization

finalization
  if Assigned(_FormProgress) then
    _FormProgress.Free;

end.
