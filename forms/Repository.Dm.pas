unit Repository.Dm;

interface

uses
  System.SysUtils, System.Classes;

type
  TRepository_dm = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Repository_dm: TRepository_dm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
