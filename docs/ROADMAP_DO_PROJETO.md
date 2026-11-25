# SmartCompre — Roadmap do Projeto

## Finalidade e status

Este documento é o registro interno da visão futura e das propostas de evolução do SmartCompre. Não é exibido no aplicativo e não representa autorização para desenvolver qualquer item. O [Manual do Usuário](./MANUAL_DO_USUARIO.md) documenta somente funcionalidades disponíveis e orientações de uso.

As fases abaixo são uma sugestão de sequência, não um compromisso. Podem ser reorganizadas conforme viabilidade técnica, custos e evolução do negócio.

### Situação atual das propostas

- **Ideias registradas:** possibilidades ainda sem planejamento aprovado.
- **Funcionalidades planejadas:** itens que venham a receber decisão explícita de planejamento; não implica implementação.
- **Em desenvolvimento:** nenhuma das propostas deste roadmap está identificada como em desenvolvimento nesta revisão.
- **Aguardando aprovação:** ampliar a padronização de textos para campos ainda não abrangidos requer definir escopo e regras.
- **Implementadas:** quando uma funcionalidade for confirmada no código e validada, removê-la das propostas e documentá-la como disponível no Manual do Usuário. Não marcar como concluída antes dessa confirmação.

## Visão estratégica

O objetivo de longo prazo do SmartCompre é evoluir de um aplicativo de listas e controle de gastos para uma plataforma colaborativa de informações de produtos, preços e estabelecimentos, capaz de ajudar o consumidor a comparar, economizar, solicitar compras e receber produtos em casa.

## Ideia anterior preservada

- **Padronização de textos:** ampliar, com regras específicas para cada finalidade, a padronização já existente para nomes de listas, estabelecimentos e categorias. Ainda não foi confirmada uma normalização central aplicada a todos os campos.

## Fase 1 — Aprimorar a experiência atual, listas, sugestões e captura por IA

- **A. Criação inteligente de listas**
  - Sugerir produtos já cadastrados no dispositivo conforme o usuário digita.
  - Permitir selecionar uma sugestão ou cadastrar um produto novo.
  - Respeitar categorias e tipos de estabelecimento.
  - Futuramente, integrar com um catálogo central compartilhado.
- **E. Evolução da captura de informações por inteligência artificial**
  - Melhorar o reconhecimento de produtos por imagens, etiquetas, códigos de barras e notas fiscais.
  - Identificar nome, marca, categoria, peso, volume, unidade e preço.
  - Diferenciar preços normais, promocionais, atacadistas e condições especiais.
  - Interpretar corretamente preço por unidade, quilo, litro e embalagem.
  - Reconhecer produtos semelhantes sem confundir marcas e tamanhos.
  - Utilizar nível de confiança da leitura e solicitar confirmação do usuário quando houver dúvida.
  - Aproveitar correções confirmadas para melhorar o reconhecimento.
  - Organizar as informações extraídas para envio futuro ao repositório central.
  - Prever privacidade, consentimento e proteção das imagens e dados enviados.

## Fase 2 — Cadastro inteligente de estabelecimentos, compartilhamento e comparação de preços

- **B. Compartilhamento de listas pelo WhatsApp**
  - Enviar uma lista por link e permitir que outro usuário abra ou importe a lista no SmartCompre.
  - Durante a compra, identificar produtos capturados ou selecionados e dar baixa automaticamente.
  - Mostrar os produtos que ainda faltam.
  - Futuramente, permitir compras simultâneas com sincronização entre usuários.
- **C. Comparação de preços**
  - Montar uma lista e escolher três estabelecimentos.
  - Comparar os preços de cada produto.
  - Calcular o total estimado em cada estabelecimento.
  - Destacar menores preços e economia potencial.
  - Tratar produtos sem preço disponível sem inventar valores.
- **D. Pesquisa e cadastro de estabelecimentos**
  - Oferecer pesquisa de estabelecimentos usando Google Places ou serviço apropriado do Google.
  - Permitir selecionar e confirmar o estabelecimento correto.
  - Preencher nome, endereço, cidade e localização, quando disponíveis.
  - Preservar o cadastro manual atual como alternativa.
  - Prever prevenção de estabelecimentos duplicados.

## Fase 3 — Infraestrutura do provedor e repositório central colaborativo

- **G. Repositório central e coleta colaborativa de dados**
  - Organizar e enviar ao provedor informações coletadas pelos usuários para construir uma base compartilhada e confiável.
  - Prever produtos, códigos de barras, marcas e categorias; preços e unidades de medida; estabelecimentos e localização.
  - Registrar data e horário da coleta.
  - Registrar a origem da informação: OCR, código de barras, digitação, nota fiscal ou atualização do estabelecimento.
  - Identificar a condição promocional.
  - Prever validação, deduplicação, atualização e indicador de confiabilidade.
  - Prever controle de acesso, consentimento e proteção de dados pessoais.
  - Integrar futuramente com comparação de preços, histórico e recomendações.

## Fase 4 — Histórico, confiabilidade, recompensas e participação dos estabelecimentos

- **H. Histórico e evolução dos preços**
  - Manter histórico por produto e estabelecimento.
  - Mostrar variação dos preços ao longo do tempo.
  - Identificar tendências e oportunidades de economia.
- **I. Recompensas por contribuições**
  - Incentivar usuários a enviar informações úteis e atualizadas.
  - Estudar descontos, pontos ou benefícios conforme a qualidade das contribuições.
- **J. Atualização pelos estabelecimentos**
  - Possibilitar que funcionários ou responsáveis atualizem preços.
  - Prever identificação e validação do estabelecimento.
- **K. Economia e logística**
  - Recomendar estabelecimentos considerando o custo total da lista.
  - Planejar compras em uma ou mais lojas.
  - Considerar distância, deslocamento, preço e economia potencial.

## Fase 5 — **F — Compras sob demanda e entrega em casa**: nova ideia estratégica

Estudar uma possível expansão do SmartCompre para uma plataforma que conecte consumidores a compradores e entregadores.

### Fluxo imaginado

1. O consumidor monta sua lista.
2. Informa endereço ou localização de entrega.
3. Escolhe um estabelecimento ou utiliza a comparação de preços.
4. O aplicativo apresenta uma estimativa do valor dos produtos.
5. O consumidor solicita que outra pessoa realize as compras.
6. Um comprador ou entregador disponível recebe a solicitação e pode aceitar o serviço.
7. O profissional vai ao estabelecimento, compra os produtos e registra os itens adquiridos.
8. O aplicativo atualiza a lista, mostrando itens comprados e pendentes.
9. O profissional entrega os produtos no endereço informado.
10. O consumidor acompanha a compra e recebe o pedido.

### Benefícios e modelo de negócio imaginados

- O consumidor economiza tempo, conhece previamente uma estimativa dos gastos e recebe os produtos em casa.
- O comprador/entregador recebe remuneração pela realização das compras e entrega.
- O SmartCompre pode receber comissão ou taxa de intermediação.

### Funcionalidades a estudar

- Cadastro e validação de compradores e entregadores.
- Disponibilidade, localização e distância.
- Distribuição de solicitações e aceitação de serviços.
- Cálculo transparente da taxa de serviço e entrega.
- Estimativa do custo dos produtos.
- Limite de orçamento autorizado pelo consumidor.
- Autorização para substituições de produtos.
- Tratamento de produtos indisponíveis.
- Registro de comprovantes e valores efetivamente pagos.
- Acompanhamento do andamento e entrega.
- Avaliação do serviço.
- Pagamentos seguros e divisão dos valores entre participantes.
- Regras de cancelamento, reembolso, responsabilidade e suporte.

**Estimativa e valor final:** o valor dos produtos antes da compra será uma estimativa. O aplicativo deverá deixar clara a diferença entre estimativa e valor final, considerando disponibilidade, promoções e alterações de preço.

**Condição para qualquer implementação:** este modelo precisa de estudo comercial, operacional, jurídico e financeiro antes de qualquer implementação.

## Fase 6 — Expansão para outros segmentos comerciais

- **L. Expansão para outros segmentos:** adaptar o sistema para controle de estoque e produtos de outros comércios, como vestuário e autopeças.
