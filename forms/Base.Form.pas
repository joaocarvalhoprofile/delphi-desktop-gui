unit Base.Form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TStateOperation = (stInsert, stUpdate, stView, stAny);

  Tbase_form = class(TForm)
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FTitle: String;
    FUser: String;
    FLevel: String;
    FUserPrint: Boolean;
    FUserRemove: Boolean;
    FUserUpdate: Boolean;
    FUserInsert: Boolean;
  Protected
    procedure ApplyStyles; virtual; abstract;
    procedure RoundComponent(componente: TWinControl; Y: String);
  public
    constructor Create(AOwner: TComponent); override;

    property User: String read FUser write FUser;
    function isAdministrator: Boolean;
    property Title: String read FTitle write FTitle;
    property Level: String read FLevel write FLevel;

    property UserInsert: Boolean read FUserInsert write FUserInsert default False;
    property UserUpdate: Boolean read FUserUpdate write FUserUpdate default False;
    property UserRemove: Boolean read FUserRemove write FUserRemove default False;
    property UserPrint: Boolean read FUserPrint write FUserPrint default False;
  end;

var
  base_form: Tbase_form;

implementation

{$R *.dfm}

procedure Tbase_form.RoundComponent(componente: TWinControl; Y: String);
var
   BX: TRect;
   mdo: HRGN;
begin
  with componente do
  begin
    BX  := ClientRect;
    mdo := CreateRoundRectRgn(BX.Left, BX.Top, BX.Right,
    BX.Bottom, StrToInt(Y), StrToInt(Y)) ;
    Perform(EM_GETRECT, 0, lParam(@BX)) ;
    InflateRect(BX, - 4, - 4) ;
    Perform(EM_SETRECTNP, 0, lParam(@BX)) ;
    SetWindowRgn(Handle, mdo, True) ;
    Invalidate;
  end;
end;

constructor Tbase_form.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  User := 'ROOT';
end;

procedure Tbase_form.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if not (ActiveControl is TCustomMemo) and
       not (ActiveControl is TCustomRichEdit) then
    begin
      Key := #0;
      Perform(WM_NEXTDLGCTL, 0, 0);
    end;
  end;
end;

function Tbase_form.isAdministrator: Boolean;
begin
  Result := (User = 'ADMIN') or (User = 'ROOT');
end;

end.
