# DesafioCB

## Desafio 1

### 1. Descrição do esquema JSON 

O esquema do JSON representa um registro detalhado de transações. 
A estrutura geral contém dados da data de geração do registro, um identificador da loja e um lista (array) referente a comanda. 

Dentro da lista "GuestChecks", os objetos são encontrados dentro de um dicionário que descrevem a comanda com uso de identificadores e informações referente ao estado, valores e contexto da comanda. Possui também outras duas listas sendo elas: "taxes" e "detailLines".

A lista "taxes" é uma lista de dicionários assim como a lista "GuestChecks" e "detailLines". Ela possui todos os detalhes dos impostos aplicados na conta.

Já a lista "detailLines" descreve cada item consumido, possuindo dentro de si um dicionário/objeto referente ao item do menu.

### Estrutura Geral - Dicionário/Objeto

O JSON representa um pedido de um cliente, feito em um local específico (locRef) e contendo também uma lista de comandas (GuestChecks).

    "curUTC": timestamp -> Timestamp UTC do momento que o dado foi gerado.

    "locRef": string -> Identificador da loja

    "guestChecks": array -> Lista de dados contendo os dados de uma ou mais comandas.

### GuestChecks - Lista de dicionários

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
    
    "nonTxblSlsTtl": integer -> Total de vendas não tributáveis.
    
    "chkTtl": numeric ou decimal -> Valor Total da comanda. 
    
    "dscTtl": integer -> Valor total dos descontos aplicados. Um valor negativo indica redução no preço. 
    
    "payTtl": numeric ou decimal -> Valor total pago. Quantia que foi paga pelo cliente.
    
    "balDueTtl": boolean -> Saldo devedor. Null indica que a conta foi totalmente paga.
    
    "rvcNum": integer -> Número do centro de receita.
    
    "otNum": integer -> Número do tipo do pedido.
    
    "ocNum": integer -> Número da categoria do pedido.
    
    "tblNum": integer -> Número da mesa.
    
    "tblName": string -> Nome da mesa.
    
    "empNum": integer -> Número do funcionario.
    
    "numSrvcRd": integer -> Número de rodadas de serviço. Quantas vezes a mesa foio atendida.
    
    "numChkPrntd": integer -> Número de vezes que a conta foi empresa.

### taxes - Lista de dicionários

    "taxNum": integer -> Identificador da taxa.

    "txblSlsTtl": numeric ou decimal -> Valor do item antes do desconto.

    "taxCollTtl": numeric ou decimal -> Total do imposto coletado.

    "taxRate": integer -> Alíquota do imposto.

    "type": integer -> Tipo de calculo.

### detailLines - Lista de dicionários

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

    "dspTtl": integer -> Valor total de exibição do item.

    "dspQty": integer -> Quantidade.

    "aggTtl": integer -> Valor total agregado do item (preço unitário x quantidade).

    "aggQty": integer -> Quantidade.

    "chkEmpId": integer -> Identificador do funcionário que registrou o item.

    "chkEmpNum": integer -> Funcionário que registrou o item.

    "svcRndNum": integer -> Número da rodada em que foi realizado o pedido.
    
    "seatNum": integer -> Número do assento.

### menuItem - Dicionário

    "miNum": integer -> Número do item de menu.

    "modFlag": boolean -> Identidicador de modificador. False indica que o item não vai ter nenhuma modificação.

    "inclTax": numeric ou decimal -> Imposto incluso.

    "activeTaxes": string -> Impostos ativos. Vinculado ao imposto "taxNum": 28.

    "prcLvl": integer -> Nível de preço. Indica os diferentes preços pro mesmo produto, como o preço de happy hour ou preço normal.
