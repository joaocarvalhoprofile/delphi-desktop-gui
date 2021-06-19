unit Data.Form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Base.Form,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB, JcButton, Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TData_Form = class(Tbase_form)
    DsrData: TDataSource;
    StatusBar: TStatusBar;
    pnlTitle: TPanel;
    lbl_title: TLabel;
    btnExit: TJcButton;
    procedure btnExitClick(Sender: TObject);
  private
    FStateOperation: TStateOperation;
    procedure SetStateOperation(const Value: TStateOperation);
  protected
    function DoShowOperation: Boolean;
    function InOperation: Boolean;
    function GetStateOperationString: string;
    procedure OperarionComponentControl;
    procedure OperationControls; virtual;

    function isEmpty: Boolean;
    function DoBeforeSave: string; virtual;
    procedure doBeforeAdd; virtual;
    procedure DoBeforeEdit; virtual;
    procedure DoBeforeDelete; virtual;
    procedure DoBeforeClose; virtual;
    procedure DoSearch; virtual;
    procedure DoFilter; virtual;
    procedure doApplyFilter; virtual;
    Function FormValid: Boolean; virtual;

    procedure DoView; virtual;
    procedure DoAdd; virtual;
    procedure DoEdit; virtual;
    procedure DoSave; virtual;
    procedure DoCancel; virtual;
    procedure DoSaveAndAdd; virtual;
    procedure DoClose; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property StateOperation: TStateOperation read FStateOperation write SetStateOperation;
  end;

var
  Data_Form: TData_Form;

implementation

{$R *.dfm}

uses DialogOkYesNo.Form;

{ TData_Form }

procedure TData_Form.doApplyFilter;
begin
  // code chield
end;

procedure TData_Form.DoBeforeAdd;
begin
  if not Assigned(DsrData.DataSet) then
    exit;

  if not DsrData.DataSet.Active then
     DsrData.Dataset.Open;
end;

procedure TData_Form.DoBeforeClose;
begin
  if not Assigned(DsrData.DataSet) then
    exit;

  if DsrData.State in [DsInsert, DsEdit] then
  begin
    if (Dialog.Mensagem('Existem alterações pendentes nesse registro '+#13+#13+
                        'Deseja salvar as alterações?', '', tdYesNo) = mrYes)  then
      DoSave
    else
      DsrData.DataSet.Cancel;
      DsrData.DataSet.Close;
  end;
end;

function TData_Form.DoBeforeSave: string;
begin
  if not InOperation then
    exit;
end;

procedure TData_Form.DoBeforeDelete;
begin
  if not Assigned(DsrData.DataSet) then
    exit;

  isEmpty;
end;

procedure TData_Form.DoBeforeEdit;
begin
  if not Assigned(DsrData.DataSet) then
    exit;

  isEmpty;
end;

procedure TData_Form.btnExitClick(Sender: TObject);
begin
  inherited;
  DoClose;
end;

constructor TData_Form.Create(AOwner: TComponent);
begin
  inherited;

  SetStateOperation(stAny);
end;

destructor TData_Form.Destroy;
begin

  inherited;
end;

procedure TData_Form.DoAdd;
begin
  SetStateOperation(stInsert);
  DoShowOperation;
  OperationControls;
end;

procedure TData_Form.DoSave;
begin
  SetStateOperation(stAny);
  DoShowOperation;
  OperationControls;
end;

procedure TData_Form.DoCancel;
begin
  SetStateOperation(stAny);
  DoShowOperation;
  OperationControls;
end;

procedure TData_Form.DoClose;
begin
  DoBeforeClose;
  Close;
end;

procedure TData_Form.DoEdit;
begin
  SetStateOperation(stUpdate);
  DoShowOperation;
  OperationControls;
end;

procedure TData_Form.DoFilter;
begin

end;

procedure TData_Form.DoSaveAndAdd;
begin
  
end;

procedure TData_Form.DoSearch;
begin

end;

function TData_Form.DoShowOperation: Boolean;
begin
  StatusBar.Panels[0].Text := GetStateOperationString;
end;

procedure TData_Form.DoView;
begin
  isEmpty;

  SetStateOperation(stView);
  DoShowOperation;
  OperationControls;
end;

function TData_Form.GetStateOperationString: string;
begin
   case FStateOperation of
    stInsert: Result := 'Incluindo';
    stUpdate: Result := 'Alterando';
    stView: Result := 'Visualizando';
    stAny: Result   := '';
  end;
end;

function TData_Form.InOperation: Boolean;
begin
  case FStateOperation of
    stInsert, stUpdate: Result := True;
    else
    Result := False;
  end;
end;

function TData_Form.isEmpty: Boolean;
begin
  result := false;
  if DsrData.DataSet.IsEmpty then
  begin
    Dialog.Mensagem('Nenhum registro selecionado !', '', tdOk);
    result := true;
    abort;
  end;
end;

procedure TData_Form.OperarionComponentControl;
begin

end;

procedure TData_Form.OperationControls;
begin
 // Implements in child
end;

procedure TData_Form.SetStateOperation(const Value: TStateOperation);
begin
  FStateOperation := Value;
end;

function TData_Form.FormValid: Boolean;
begin

end;

end.
