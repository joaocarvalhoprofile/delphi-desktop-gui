unit DataTable.Form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Base.Form, SDButton, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, SDDBGrid, Vcl.StdCtrls, Vcl.ImgList, Data.DB,
  Data.Form, Vcl.Menus, Vcl.ComCtrls, System.Generics.Collections, JcDBGrid,
  JcPanel, Vcl.Imaging.pngimage, JcPageControl, JcButton;

type
  THackDBGrid = class(TDBGrid);

  TDataTable_Form = class(TData_Form)
    pnlMain: TPanel;
    PopupMenu: TPopupMenu;
    Exportar1: TMenuItem;
    pgcMain: TJcPageControl;
    tabTable: TTabSheet;
    tabCrud: TTabSheet;
    pnlTableTools: TPanel;
    pnlButtons: TPanel;
    btnAdd: TJcButton;
    btnEdit: TJcButton;
    btnView: TJcButton;
    pnlCrudButtons: TPanel;
    pnlCrudButtonsLeft: TPanel;
    btnSave: TJcButton;
    btnCancel: TJcButton;
    btnSaveAndAdd: TJcButton;
    pnlSearch: TPanel;
    pnlSearchEdit: TPanel;
    imgButtonSearch: TImage;
    lblSearchBy: TLabel;
    edtSearch: TEdit;
    btnSearchCustom: TJcButton;
    pnlCrud: TJcPanel;
    pnlTable: TJcPanel;
    SearchTable: TJcDBGrid;
    pnlCrudButtonsRight: TPanel;
    btnVoltar: TJcButton;
    BtnPrint: TJcButton;
    pnlFilter: TPanel;
    btnApplyFilter: TJcButton;
    procedure btn_menu_outrosClick(Sender: TObject);
    procedure DsrDataDataChange(Sender: TObject; Field: TField);
    procedure SearchTableTitleClick(Column: TColumn);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtSearchEnter(Sender: TObject);
    procedure edtSearchExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure imgButtonSearchClick(Sender: TObject);
    procedure btnSearchCustomClick(Sender: TObject);
    procedure SearchTableDblClick(Sender: TObject);
    procedure btnSaveAndAddClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnApplyFilterClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FSearchColumn: string;
    FSearchCustom: boolean;
    FSearchCaption: string;
    procedure DoAdjustWidth;
  protected
    procedure OperationControls; override;

    procedure ApplyStyles; override;
    procedure FindValidator(AValue: String; ANumCaracter: Integer = 0);
    procedure DoFilter; Override;
    procedure doApplyFilter; Override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property SearchCaption: string read FSearchCaption write FSearchCaption;
    property SearchColumn: string read FSearchColumn write FSearchColumn;
    property SearchCustom: boolean read FSearchCustom write FSearchCustom;
  end;

var
  DataTable_Form: TDataTable_Form;

implementation

{$R *.dfm}

uses DialogOkYesNo.Form, Styles.Colors;

{ TData_Form }

procedure TDataTable_Form.DoAdjustWidth;
var
  TotalColumnWidth, ColumnCount, GridClientWidth, Filler, i: Integer;
begin
  ColumnCount := 0;

  for i := 0 to SearchTable.Columns.Count-1 do
  begin
    if SearchTable.Columns[i].Visible then
      ColumnCount := ColumnCount + 1;
  end;

  if ColumnCount = 0 then
    Exit;

  // compute total width used by grid columns and vertical lines if any
  TotalColumnWidth := 0;
  for i := 0 to ColumnCount-1 do
  begin
    if SearchTable.Columns[i].Visible then
      TotalColumnWidth := TotalColumnWidth + SearchTable.Columns[i].Width;
  end;

  if dgColLines in SearchTable.Options then
    // include vertical lines in total (one per column)
    TotalColumnWidth := TotalColumnWidth + ColumnCount;

  // compute grid client width by excluding vertical scroll bar, grid indicator,
  // and grid border
  GridClientWidth := SearchTable.Width - GetSystemMetrics(SM_CXVSCROLL);
  if dgIndicator in SearchTable.Options then
  begin
    GridClientWidth := GridClientWidth - IndicatorWidth;
    if dgColLines in SearchTable.Options then
      Dec(GridClientWidth);
  end;
  if SearchTable.BorderStyle = bsSingle then
  begin
    if SearchTable.Ctl3D then // border is sunken (vertical border is 2 pixels wide)
      GridClientWidth := GridClientWidth - 4
    else // border is one-dimensional (vertical border is one pixel wide)
      GridClientWidth := GridClientWidth - 2;
  end;

  // adjust column widths
  if TotalColumnWidth < GridClientWidth then
  begin
    Filler := (GridClientWidth - TotalColumnWidth) div ColumnCount;
    for i := 0 to ColumnCount-1 do
    begin
      if SearchTable.Columns[i].Visible then
        SearchTable.Columns[i].Width := SearchTable.Columns[i].Width + Filler;
    end;
  end
  else if TotalColumnWidth > GridClientWidth then
  begin
    Filler := (TotalColumnWidth - GridClientWidth) div ColumnCount;
    if (TotalColumnWidth - GridClientWidth) mod ColumnCount <> 0 then
      Inc(Filler);
    for i := 0 to ColumnCount-1 do
    begin
      if SearchTable.Columns[i].Visible then
        SearchTable.Columns[i].Width := SearchTable.Columns[i].Width - Filler;
    end;
  end;

end;

procedure TDataTable_Form.doApplyFilter;
begin
  inherited;
  pnlFilter.Visible := false;
end;

procedure TDataTable_Form.DoFilter;
begin
  inherited;
  pnlFilter.Visible := not pnlFilter.Visible;
end;

procedure TDataTable_Form.FindValidator(AValue: String; ANumCaracter: Integer);
begin
  if ANumCaracter > 0 then
  begin
    if Length(Trim(AValue)) < ANumCaracter then
    begin
      Dialog.Mensagem('Digite pelo menos ['+IntToStr(ANumCaracter)+'] caracteres para pesquisar', '', tdOk);
      Perform(WM_NEXTDLGCTL, 0, 0);
      abort;
    end;
  end;
end;

procedure TDataTable_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_F2 then
    edtSearch.SetFocus;

  if Key = VK_F3 then
    SearchTable.SetFocus;

end;

procedure TDataTable_Form.FormResize(Sender: TObject);
begin
  inherited;
  ApplyStyles;
  DoAdjustWidth;
  OperationControls;
end;

procedure TDataTable_Form.imgButtonSearchClick(Sender: TObject);
begin
  inherited;
  DoSearch;
end;

procedure TDataTable_Form.OperationControls;
begin
   case StateOperation of
    stInsert, stUpdate:
    begin;
      btnExit.Enabled       := false;
      btnSave.Enabled       := true;
      btnCancel.Enabled     := true;
      btnSaveAndAdd.Enabled := true;
      btnVoltar.Visible     := false;
      pgcMain.ActivePageIndex := 1;
    end;
    stView:
    begin
      btnExit.Enabled       := true;
      btnSave.Enabled       := false;
      btnCancel.Enabled     := false;
      btnSaveAndAdd.Enabled := false;
      btnVoltar.Visible     := true;
      pgcMain.ActivePageIndex := 1;
    end;
    stAny:
    begin
      btnExit.Enabled       := true;
      btnSave.Enabled       := true;
      btnCancel.Enabled     := true;
      btnSaveAndAdd.Enabled := true;
      btnVoltar.Visible     := false;
      pgcMain.ActivePageIndex := 0;
    end;
  end;
end;

procedure TDataTable_Form.btnSaveAndAddClick(Sender: TObject);
begin
  inherited;
  DoSaveAndAdd;
end;

procedure TDataTable_Form.btnSaveClick(Sender: TObject);
begin
  inherited;
  pgcMain.ActivePageIndex := 0;
  DoSave;
end;

procedure TDataTable_Form.btnSearchCustomClick(Sender: TObject);
begin
  inherited;
  DoFilter;
end;

procedure TDataTable_Form.btnViewClick(Sender: TObject);
begin
  inherited;
  DoView;
end;

procedure TDataTable_Form.btnVoltarClick(Sender: TObject);
begin
  inherited;
  DoCancel;
  pgcMain.ActivePageIndex := 0;
end;

procedure TDataTable_Form.btnCancelClick(Sender: TObject);
begin
  inherited;
  pgcMain.ActivePageIndex := 0;
  DoCancel;
end;

procedure TDataTable_Form.btnAddClick(Sender: TObject);
begin
  inherited;
  DoAdd;
end;

procedure TDataTable_Form.btnApplyFilterClick(Sender: TObject);
begin
  inherited;
  doApplyFilter;
end;

procedure TDataTable_Form.btnEditClick(Sender: TObject);
begin
  inherited;
  DoEdit;
end;

procedure TDataTable_Form.SearchTableDblClick(Sender: TObject);
begin
  inherited;
  DoEdit;
end;

procedure TDataTable_Form.ApplyStyles;
begin
  RoundComponent(btnExit, '50');

  RoundComponent(pnlTableTools, '10');
  RoundComponent(btnAdd, '5');
  RoundComponent(btnEdit, '5');
  RoundComponent(btnView, '5');

  RoundComponent(pnlSearchEdit, '5');
  RoundComponent(btnSearchCustom, '5');

  RoundComponent(pnlCrudButtons, '10');
  RoundComponent(btnSave, '5');
  RoundComponent(btnCancel, '5');
  RoundComponent(btnSaveAndAdd, '5');

  self.Color       := COLOR_BACKGROUND;
  lbl_title.Color  := $00F5EFE7;

  pnlTableTools.Color  := $00F5EFE7;
  pnlSearch.Color      := clWindow;
  pnlSearchEdit.Color  := clWindow;

  SearchTable.Font.Size  := FONT_H7;
  SearchTable.Font.Color := FONT_COLOR4;
  SearchTable.Font.Name  := 'Segoe UI';

  SearchTable.TitleFont.Size  := FONT_H6;
  SearchTable.TitleFont.Name  := 'Segoe UI';
  SearchTable.TitleFont.Color := FONT_COLOR4;
end;

procedure TDataTable_Form.btn_menu_outrosClick(Sender: TObject);
var
   pt : TPoint;
begin
    pt.x := TButton(Sender).Left + 1;
    pt.y := TButton(Sender).Top + TButton(Sender).Height + 1;
    pt := Self.ClientToScreen( pt );
    PopupMenu.popup( pt.x, pt.y );
end;

constructor TDataTable_Form.Create(AOwner: TComponent);
begin
  inherited;

  SearchCustom   := false;
end;

destructor TDataTable_Form.Destroy;
begin

  inherited;
end;

procedure TDataTable_Form.DsrDataDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  THackDBGrid(SearchTable).DefaultRowHeight := 30;
  THackDBGrid(SearchTable).ClientHeight := (30 * THackDBGrid(SearchTable).RowCount) + 30;

  DoAdjustWidth;
end;

procedure TDataTable_Form.SearchTableTitleClick(Column: TColumn);
begin
  inherited;
  SearchCaption := Column.Title.Caption;
  SearchColumn  := Column.Title.Column.FieldName;

  if trim(SearchCaption) <> '' then
    edtSearch.TextHint := 'Buscar por ' + SearchCaption;
end;

procedure TDataTable_Form.edtSearchEnter(Sender: TObject);
begin
  inherited;
  if trim(SearchCaption) <> '' then
    lblSearchBy.Caption := SearchCaption +': '
  else
    lblSearchBy.Caption := SearchCaption;
end;

procedure TDataTable_Form.edtSearchExit(Sender: TObject);
begin
  inherited;
  lblSearchBy.Caption := ' ';
end;

end.

