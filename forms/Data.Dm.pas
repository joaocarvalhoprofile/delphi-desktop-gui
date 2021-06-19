unit Data.Dm;

interface

uses
  System.SysUtils, System.Classes;

type
  TData_dm = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Data_dm: TData_dm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TData_dm.DataModuleCreate(Sender: TObject);
begin
  RemoveDataModule(Self);
end;

end.
