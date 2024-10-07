unit embed_ui;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Vcl.Imaging.pngimage, embed_api;

type
  TEmbedUi = class(TForm)
    BtnDebito: TButton;
    BtnCredito: TButton;
    ImgEmbed: TImage;
    procedure BtnDebitoClick(Sender: TObject);
    procedure BtnCreditoClick(Sender: TObject);
    procedure ShowStatus(Status: string);
  private
    { Private declarations }
    api: TEmbedApi;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  EmbedUi: TEmbedUi;

implementation

{$R *.dfm}

constructor TEmbedUi.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  api := TEmbedApi.Create;
  api.Configurar;
end;

procedure TEmbedUi.BtnDebitoClick(Sender: TObject);
var
  ValorStr, Output: string;
begin
  ValorStr := InputBox('Débito', 'Digite o valor (em centavos):', '');
  api.Iniciar();
  ShowStatus('[POS] Iniciado');
  Output := api.Debito(ValorStr);
  if Output = '1' then
  begin
    ShowStatus('[POS] Débito');
    while Output = '1' do
    begin
      Output := api.GetStatus;
      if Output = '0' then
        ShowStatus('[POS] Autorizado')
      else if Output = '-1' then
        ShowStatus('[POS] Falha no processamento')
      else
        ShowStatus('[POS] Processando');
    end;
    Output := api.Finalizar;
    if Output = '0' then
        ShowStatus('[POS] Finalizado')
    else
      ShowStatus('[POS] Falha na confirmação');
  end
  else
  begin
    ShowStatus('[POS] Falha ao iniciar pagamento');
  end;
end;

procedure TEmbedUi.BtnCreditoClick(Sender: TObject);
var
  ValorStr, ParcelasStr, FinanciamentoStr, Output: string;
begin
  ValorStr := InputBox('Crédito', 'Digite o valor (em centavos):', '');
  ParcelasStr := InputBox('Crédito', 'Digite a quantidade de parcelas (1 a 99):', '');
  api.Iniciar();
  ShowStatus('[POS] Iniciado');
  Output := api.Credito(ValorStr, ParcelasStr);
  if Output = '1' then
  begin
    ShowStatus('[POS] Crédito');
    while Output = '1' do
    begin
      Output := api.GetStatus;
      if Output = '0' then
        ShowStatus('[POS] Autorizado')
      else if Output = '-1' then
        ShowStatus('[POS] Falha no processamento')
      else
        ShowStatus('[POS] Processando');
    end;
    Output := api.Finalizar;
    if Output = '0' then
        ShowStatus('[POS] Finalizado')
    else
      ShowStatus('[POS] Falha na confirmação');
  end
  else
  begin
    ShowStatus('[POS] Falha ao iniciar pagamento');
  end;
end;

procedure TEmbedUi.ShowStatus(Status: string);
begin
  ShowMessage(Status);
end;

end.
