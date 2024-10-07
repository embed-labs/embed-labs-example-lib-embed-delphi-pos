unit embed_api;

interface

uses
  SysUtils, Classes, embed_lib;

type
  TEmbedApi = class
  private
    { Private declarations }
    lib: TEmbedLib;
    const
      STATUS_CODE = 'resultado.status_code';
  public
    constructor Create;
    destructor Destroy;
    function Configurar: string;
    function Iniciar: string;
    function Debito(Valor: string): string;
    function Credito(Valor: string; Parcelas: string): string;
    function GetStatus: string;
    function Finalizar: string;
  end;

implementation

constructor TEmbedApi.Create;
begin
  lib := TEmbedLib.Create('lib-embed-x86.dll');
  inherited Create;
end;

destructor TEmbedApi.Destroy;
begin
  lib.Free;
end;

function TEmbedApi.Configurar: string;
begin
  var Produto := 'pos'; // POS como produto de pagamento
  var SubProduto := '1'; // SubProduto do POS (pode ser o banco ou parceiro)
  var Token := ''; // Informações fornecidas pela integração
  var Username := ''; // Nome de usuário fornecido
  var Password := ''; // Senha fornecida
  var NumeroSerial := ''; // Número serial do POS
  var Input := Produto + ';'
            + SubProduto + ';'
            + Token + ';'
            + Username + ';'
            + Password + ';'
            + NumeroSerial;
  var Output := lib.Configurar(Input);
end;

function TEmbedApi.Iniciar: string;
begin
  var Operacao := 'pos';
  var Output := lib.Iniciar(Operacao);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.Debito(Valor: string): string;
begin
  var Operacao := 'debito';
  var Input := Operacao + ';' + Valor;
  var Output := lib.Processar(Input);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.Credito(Valor: string; Parcelas: string): string;
begin
  var Operacao := 'credito';
  var Input := Operacao + ';'
            + Valor + ';'
            + Parcelas + ';';
  var Output := lib.Processar(Input);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;



function TEmbedApi.GetStatus: string;
begin
  var Operacao := 'get_status';
  var Output := lib.Processar(Operacao);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.Finalizar: string;
begin
  var Operacao := '';
  var Output := lib.Finalizar(Operacao);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

end.

