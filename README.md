# Desafio engenheiro de dados CB LAB - Otávio Oliveira Vieira
 
## Desafio 1

### 1. Descrição do esquema JSON 

O esquema do JSON representa um registro detalhado de transações. 
A estrutura geral contém dados da data de geração do registro, um identificador da loja e um lista (array) referente a comanda. 

Dentro da lista "GuestChecks", os objetos são encontrados dentro de um dicionário que descrevem a comanda com uso de identificadores e informações referente ao estado, valores e contexto da comanda. Possui também outras duas listas sendo elas: "taxes" e "detailLines".

A lista "taxes" é uma lista de dicionários assim como a lista "GuestChecks" e "detailLines". Ela possui todos os detalhes dos impostos aplicados na conta.

Já a lista "detailLines" descreve cada item consumido, possuindo dentro de si um dicionário/objeto referente ao item do menu.

#### Estrutura Geral - Dicionário/Objeto

O JSON representa um pedido de um cliente, feito em um local e data específico (locRef) e (curUTC), contendo também uma lista de comandas (GuestChecks).

    "curUTC": timestamp -> Timestamp UTC do momento que o dado foi gerado.

    "locRef": string -> Identificador da loja

    "guestChecks": array -> Lista de dados contendo os dados de uma ou mais comandas.

#### GuestChecks - Lista de dicionários

Cada objeto dentro do array, detalha um pedido.

    "guestCheckId": integer -> Identificador da comanda.

    "chkNum": integer -> Número da comanda.
    
    "opnBusDt": date -> Data de abertura do negócio.
    
    "opnUTC": datetime -> Data e hora de abertura da comanda em UTC.
    
    "opnLcl": datetime -> Data e hora de abertura da comanda em local.
    
    "clsdBusDt": date -> Data de fechamento do negócio.
    
    "clsdUTC": datetime -> Data e hora de fechamento da comanda.
    
    "clsdLcl": datetime -> Data e hora de fechamento da comanda em local.
    
    "lastTransUTC": timestamp -> Data e hora da ultima transação em UTC.
    
    "lastTransLcl": timestamp -> Data e hora da ultima transação em local.
    
    "lastUpdatedUTC": timestamp -> Data e hora da ultima atualização de qualquer dado em UTC.
    
    "lastUpdatedLcl": timestamp -> Data e hora da ultima atualização de qualquer dado em local.
    
    "clsdFlag": boolean -> Indicador de fechamento da comanda. True significa que a comanda está fechada e paga, False indicaria que a comanda ainda está aberta.
    
    "gstCnt": integer -> Contagem de clientes.
    
    "subTtl": numeric ou decimal -> subTotal da comanda. Valor total dos itens após a aplicação de descontos.
    
    "nonTxblSlsTtl": numeric ou decimal -> Total de vendas não tributáveis.
    
    "chkTtl": numeric ou decimal -> Valor Total da comanda. 
    
    "dscTtl": numeric ou decimal -> Valor total dos descontos aplicados. Um valor negativo indica redução no preço. 
    
    "payTtl": numeric ou decimal -> Valor total pago. Quantia que foi paga pelo cliente.
    
    "balDueTtl": numeric ou decimal -> Saldo devedor. Null indica que a conta foi totalmente paga.
    
    "rvcNum": integer -> Número do centro de receita.
    
    "otNum": integer -> Número do tipo do pedido.
    
    "ocNum": integer -> Número da categoria do pedido.
    
    "tblNum": integer -> Número da mesa.
    
    "tblName": string -> Nome da mesa.
    
    "empNum": integer -> Número do funcionario.
    
    "numSrvcRd": integer -> Número de rodadas de serviço. Quantas vezes a mesa foio atendida.
    
    "numChkPrntd": integer -> Número de vezes que a conta foi empresa.

#### taxes - Lista de dicionários

    "taxNum": integer -> Identificador da taxa.

    "txblSlsTtl": numeric ou decimal -> Valor do item antes do desconto.

    "taxCollTtl": numeric ou decimal -> Total do imposto coletado.

    "taxRate": integer -> Alíquota do imposto.

    "type": integer -> Tipo de calculo.

#### detailLines - Lista de dicionários

    "guestCheckLineItemId": integer -> Identificador do item.

    "rvcNum": integer -> Número do centro de receita.

    "dtlOtNum": integer -> Número do detalhe do tipo do item.

    "dtlOcNum": integer -> Número do detalhe da categoria do item.

    "lineNum": integer -> Número da linha no pedido.

    "dtlId": integer -> Identificador do detalhe do item.

    "detailUTC": timestamp -> Data e hora da ultima atualização dos detalhes em UTC.

    "detailLcl": timestamp -> Data e hora da ultima atualização dos detalhes em local.

    "lastUpdateUTC": timestamp -> Data e hora da ultima atualização em UTC.

    "lastUpdateLcl": timestamp -> Data e hora da ultima atualização em local.

    "busDt": date -> Data comercial.

    "wsNum": integer -> Número da estação de trabalho.

    "dspTtl": numeric ou decimal -> Valor total de exibição do item.

    "dspQty": integer -> Quantidade.

    "aggTtl": integer -> Valor total agregado do item (preço unitário x quantidade).

    "aggQty": integer -> Quantidade agregada.

    "chkEmpId": integer -> Identificador do funcionário que registrou o item.

    "chkEmpNum": integer -> Funcionário que registrou o item.

    "svcRndNum": integer -> Número da rodada em que foi realizado o pedido.
    
    "seatNum": integer -> Número do assento.

#### menuItem - Dicionário

    "miNum": integer -> Número do item de menu.

    "modFlag": boolean -> Identidicador de modificador. False indica que o item não vai ter nenhuma modificação.

    "inclTax": numeric ou decimal -> Imposto incluso.

    "activeTaxes": string -> Impostos ativos. Vinculado ao imposto "taxNum": 28.

    "prcLvl": integer -> Nível de preço. Indica os diferentes preços pro mesmo produto, como o preço de happy hour ou preço normal.


### 2. Transcrição do JSON para tabelas SQL

O código SQL é encontrado no repositório com o nome script_erp.sql. 

Abaixo está o diagrama do esquema.

![alt text](<image.png>)

### 3. Descrição da abordagem escolhida 

A abordagem escolhida para a modelagem de dados foi o Esquema Estrela/Floco de neve, que consiste em organizar os dados em tabelas Fato, que contêm as métricas numéricas do negócio, e as tabelas Dimensão que armazenam os atributos descritivos que fornecem contexto. A estrutura recebe esse nome pois a tabela Fato é colocada no centro e as dimensões irradiando dela.

#### Tabelas Fato

Foi criada duas tabelas fato, uma para as comandas (GuestCheck) e outra para os Itens (guestCheckLineItemId). 

* **fato_comandas**: Contém uma linha para cada comanda. Ela inclui as datas de atualização e transação (dh_atu_comanda, dh_ultima_transacao), valor total da comanda (ttl_comanda), o total que foi pago e o total devedor (ttl_pago, ttl_devedor), quantidade de clientes da comanda (qtd_clientes), o número do centro de receita (num_centro_receita), o serviceCharge (valor_servico) e o tenderMedia (forma_pagamento).

* **fato_item**: Contém uma linha para cada item vendido. Suas métricas incluem o número do centro de receita (num_centro_receita), datas de atualização (dh_atu), número da estação de trabalho (num_estacao_trabalho), o valor e quantidade de exibição do item (ttl_item_exib, qtd_item_exib), valor e quantidade agregada do item (ttl_item_agg, qtd_item_agg), discount (desconto) e o errorCode (codigo_erro) 

#### Tabelas Dimensão

* dim_mesas: Descreve os dados das mesas, como o número, nome da mesa e quantidade de assentos.

* dim_data_comercio: Descreve a data de inicio e fechamento do dia comercial.

* dim_funcionario: Descreve o funcionário associado à comanda.

* dim_comanda: Descreve os atributos da comanda em si, como o seu número (chkNum), a data e hora de abertura e fechamento da comanda, status da comanda (ex.: Aberta - False, Fechada - True), número do tipo e categoria do pedido, número de rodadas de serviço e quantidade de vezes que a comanda foi impressa.

* dim_local: Descreve o local, com a referência e a data e hora de geração dos dados.

* dim_taxas: Descreve as taxas associadas aos valores e aos itens. Isso é feito usando o valor total do item, o valor total do imposto, a aliquota e o tipo de calculo.

* dim_detalhe_item: Descreve os atributos do item em si. Possui o número do detalhe do tipo e da categoria do item, as datas de atualização e o número da rodada de serviço que o item foi pedido.

* dim_funcionario_item: Descreve os funcionários que estão associados ao cadastro do item.

* dim_item_menu: Descreve cada item de menu vendido.

#### Relações

Como o JSON fornecido corresponde a um determinado pedido com um único item, referente a um único item de menu, a tabela fato_item é considerada uma tabela ponte entre a fato_comandas e a dim_detalhe_item. Pois uma comanda pode ter vários itens e cada item supostamente pode ser pedido em outras comandas, e esse mesmo item vai sempre corresponder a um único item de menu.

#### Justificativa

Escolhi o esquema Estrela/Floco de neve pois esses modelos foram projetados pensando em otimizar consultas analiticas e em serem eficazes para responder perguntas de negócio. Isso faz com que operações de agregação como "SUM", "COUNT" e junções "JOIN" sejam mais rápidas e perfomáticas, acelerando e facilitando a exploração de grandes volumes de dados.

E também é um modelo que permite grande escalabilidade e manutenibilidade do banco de dados, pois se for necessário adicionar algum campo ou algum atributo, é só adicionar uma nova coluna e incluir a sua chave na tabela fato, sem precisar analisar e reestruturar as tabelas existentes.

#### Preocupações e consequências

Ao estudar o JSON e os dados, vi que o guestChecks e o detailLines possuem o objeto "empNum" que acredito ser referente ao número do funcionário, e ao ver que cada "empNum" é diferente do outro apesar de estarem na mesma comanda me fez pensar que eles referem a coisas diferentes, assim, não seria correto criar somente uma dimensão funcionário para os dois. Dito isso, acredito que a melhor forma de lidar com esses dados é criar uma dimensão para cada, resultando na dim_funcionario e na dim_funcionario_item, mesmo que a dim_funcionario ficasse somente com a chave num_funcionario. Ter a dimensão criada reduz parte do trabalho caso seja necessário adicionar campos ou colunas sobre o funcionário, e também evita a adição dessas colunas na tabela Fato.

## Desafio 2

### 1. Por que armazenar as respostas das APIs?

Armazenar as respostas da api é extremamente importante principalmente para o reprocessamento de dados. Caso aconteça algum erro no código que transforma o JSON nas tabelas, podemos corrigir o código e assim reprocessar os arquivos JSON sem precisar refazer as requisições na API. Dessa forma, conseguimos separar o sistema que coleta os dados da API do sistema que transforma esses dados em tabelas, aumentando a manutenibilidade e independência dos processos.

Outro ponto importante, é que o arquivo JSON serve como uma cópia fiel do que a API retornou, agindo como fonte de verdade e sendo possível usar esses dados para auditorias, e também para descobrir novos insights usando os dados de formas diferentes.

### 2. Estrutura de pastas para armazenamento dos dados

Os dados seriam armazenados nessa estrutura:

`\datalake\bronze\files\CashManagementDetails\loja_storeId\dados_YYYYMMDD.json`

`\datalake\bronze\files\ChargeBack\loja_storeId\dados_YYYYMMDD.json`

`\datalake\bronze\files\FiscalInvoice\loja_storeId\dados_YYYYMMDD.json`

`\datalake\bronze\files\GuestChecks\loja_storeId\dados_YYYYMMDD.json`

`\datalake\bronze\files\Transactions\loja_storeId\dados_YYYYMMDD.json`

Escolhi esse formato para facilitar a questão de ordenação e auditoria dos dados. Os dados seriam obtidos por meio dos endpoints em que cada um deles teria sua própria pasta, e dentro dessa pasta os dados seriam divididos pelo id da loja "storeId", criando assim a mascara da pasta, e o arquivo gerado teria a mascara de ano, mês e dia correspondente ao "busId". Esse formato iria facilitar o ordenamento por data e também por loja, agilizando a busca de um dado de uma loja específica em um dia específico. Após a armazenagem dos dados, os dados passariam por um tratamento para serem carregados nas tabelas e a cada tratamento eles seriam colocados em pastas diferentes sendo "silver" para dados intermediários prontos para análise exploratória, e "gold" para dados refinados prontos para serem aplicados em ferramentas de BI e dashboards.

### 3. Implicação da alteração na resposta do endpoint

A alteração no JSON ia implicar em erros no processo de transformação dos dados, especificamente no pipeline de ETL, que ao tentar processar o dado guestChecks.taxes ia gerar um erro de execução ou, no pior cenário, gerar dados nulos, incorretos ou até mesmo realizar exclusões silenciosas, causando perda e inconsistência nos dados.
Esse erro ia gerar a necessidade da manutenção do pipeline e também do reprocessamento dos dados históricos.