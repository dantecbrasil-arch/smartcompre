# SmartCompre — Manual do Usuário

## Sobre o SmartCompre

O SmartCompre ajuda a organizar compras por estabelecimento. É possível manter estabelecimentos e categorias, criar listas, cadastrar produtos manualmente ou ler informações de etiquetas com a câmera e consultar o histórico de listas.

O aplicativo é desenvolvido com Flutter e Dart para Android. Os dados são armazenados localmente no dispositivo usando SharedPreferences. O projeto não oferece conta de usuário nem sincronização em nuvem.

Na revisão deste manual, o ambiente disponível utilizou Flutter 3.44.8 e Dart 3.12.2. A versão declarada do aplicativo em pubspec.yaml é 1.0.5+14.

### Estado deste manual

Este arquivo é a fonte única do conteúdo do manual. O aplicativo carrega e apresenta este mesmo Markdown, sem manter uma segunda cópia do texto.

Os passos abaixo descrevem funcionalidades confirmadas no código. A organização de Minhas Listas por período e tipo está implementada e foi validada manualmente no celular.

## Como começar

1. Na tela inicial, toque em Estabelecimento e escolha um estabelecimento existente. Se ainda não houver um, use a opção de adicionar para cadastrá-lo.
2. Informe um Nome da Lista.
3. Toque em Criar Lista.
4. Na tela da lista, adicione produtos digitando os dados ou use a câmera para capturar uma etiqueta.

O estabelecimento e o nome da lista são necessários para habilitar a criação.

## Funcionalidades disponíveis

### Estabelecimentos

O cadastro de estabelecimentos pode ser aberto pelo campo Estabelecimento na tela inicial.

1. Toque no campo Estabelecimento.
2. Use a pesquisa ou percorra a lista, apresentada em ordem alfabética.
3. Toque em um estabelecimento para selecioná-lo.
4. Para cadastrar um novo, use o botão de adicionar e informe nome, cidade, endereço e tipo.
5. Selecione um estabelecimento cadastrado para acessar as opções de edição e exclusão.

O tipo escolhido determina as categorias padrão e personalizadas disponíveis para os produtos daquela lista.

### Tipos de estabelecimento

1. Na tela inicial, toque em Categorias.
2. Na tela Categorias, use o botão de gerenciamento de tipos no canto superior direito.
3. Tipos originais do aplicativo aparecem protegidos. Tipos personalizados podem ser adicionados, renomeados ou excluídos.

Ao renomear um tipo personalizado, o novo nome é aplicado às listas, estabelecimentos e produtos do catálogo vinculados; os demais dados desses registros e as categorias do tipo são preservados.

Não é possível excluir um tipo personalizado que tenha listas vinculadas. A mensagem informa a quantidade de listas. Se não houver listas vinculadas, a exclusão exige confirmação; estabelecimentos e produtos do catálogo associados passam para Outros. As categorias internas não são removidas e voltam a aparecer caso um tipo com o mesmo nome seja cadastrado novamente.

### Criar e preencher uma lista

1. Selecione um estabelecimento na tela inicial.
2. Digite o nome da lista e toque em Criar Lista.
3. Na tela da lista, escolha adicionar produto manualmente ou iniciar a captura pela câmera.
4. Confira os dados do produto antes de confirmar.

As alterações de produtos e o total da lista são salvos no dispositivo.

### Cadastro manual de produtos

1. Abra uma lista e escolha a opção para adicionar produto.
2. Informe o nome, o peso (quando aplicável), a quantidade e o preço unitário.
3. Selecione uma categoria disponível para o tipo do estabelecimento.
4. Confirme a inclusão.

Para alterar ou remover um produto, use as ações de edição ou exclusão exibidas junto ao item.

### Captura de etiquetas pela câmera

1. Na tela da lista, abra a captura pela câmera.
2. Posicione a etiqueta na área indicada e capture a imagem.
3. Confira o texto e os dados de produto e preço reconhecidos.
4. Se a etiqueta apresentar mais de uma opção de preço reconhecida, escolha a opção correta.
5. Revise e confirme os dados antes de salvar o produto.

O reconhecimento pode falhar se a etiqueta estiver desfocada, parcialmente coberta ou fora da área de captura. Confira sempre nome, categoria, peso, quantidade e preço; corrija os dados antes de confirmar quando necessário.

### Categorias

1. Na tela inicial, toque em Categorias.
2. Escolha um tipo de estabelecimento, original ou personalizado.
3. Consulte as categorias padrão e personalizadas daquele tipo.
4. Use a opção de adicionar para criar uma categoria personalizada.
5. Use as ações disponíveis para editar ou excluir categorias personalizadas.

Categorias padrão são protegidas contra edição e exclusão. As categorias exibidas são ordenadas alfabeticamente sem distinguir acentos. Categorias padrão e personalizadas com nomes equivalentes após normalizar espaços e ignorar maiúsculas/minúsculas aparecem uma única vez na interface; os registros persistidos não são removidos por essa apresentação.

### Minhas Listas

Na tela inicial, toque em Minhas Listas para consultar listas salvas, abrir seus detalhes ou solicitar a exclusão de uma lista.

A tela inicia no período Mês atual. Também é possível escolher diretamente mês e ano, ou selecionar Todas para consultar o histórico completo. Em cada período, as listas são agrupadas em pastas pelo tipo de estabelecimento. Tipos sem identificação válida ficam em Outros. Ao abrir uma pasta, as listas com data válida aparecem da mais recente para a mais antiga; registros sem data aparecem ao final como Data não informada em Todas. A exclusão de uma lista exige confirmação.

## Regras automáticas do aplicativo

- **Nome da lista:** ao salvar, remove espaços no início e no fim, reduz sequências de espaços a um só, converte o texto para minúsculas e deixa maiúscula a primeira letra da frase. Acentos e caracteres especiais são preservados.
- **Nome do produto digitado manualmente:** ao salvar uma inclusão ou edição manual, reduz espaços redundantes e coloca cada palavra em formato de título, preservando acentos. O texto identificado por OCR não recebe essa transformação.
- **Categoria de produto novo incluído manualmente:** ao salvar, usa a normalização existente para deixar a primeira letra maiúscula, as demais minúsculas e preservar acentos. Categorias de produtos já salvos não são migradas automaticamente.
- **Estabelecimentos:** ao salvar, remove espaços nas extremidades e reduz espaços repetidos. Nomes, cidades e endereços têm capitalização própria; “iFood” e abreviações de endereço recebem tratamento específico, e palavras de ligação ficam minúsculas em cidades e endereços, exceto no início.
- **Categorias:** ao criar uma categoria personalizada, remove espaços nas extremidades, reduz espaços repetidos, converte o texto para minúsculas e deixa maiúscula a primeira letra da frase. As opções são separadas por tipo de estabelecimento. A lista apresentada combina categorias padrão e personalizadas, elimina duplicidades equivalentes por espaços e caixa e ordena sem diferenciar acentos. Essa operação de interface não modifica os dados persistidos.
- **Total do produto:** quando há peso maior que zero, o subtotal é calculado como peso multiplicado pelo preço unitário; caso contrário, usa quantidade multiplicada pelo preço unitário.
- **Total da lista:** é atualizado a partir dos subtotais dos produtos.
- **Datas:** listas criadas recebem a data e hora atuais. Um registro antigo sem data válida não recebe uma data inventada; a tela de detalhes o apresenta como Data não informada.
- **Leitura de etiqueta:** o texto reconhecido é processado para identificar dados de preço e classificar a etiqueta como baseada em peso ou unidade. O resultado deve ser revisado antes de salvar.

## Telas e navegação

- **Tela inicial:** seleção de estabelecimento, nome da lista, criação de lista, Minhas Listas, Categorias e Ajuda / Manual do Usuário.
- **Estabelecimentos:** aberta pelo campo Estabelecimento na tela inicial; permite pesquisa, seleção, cadastro, edição e exclusão.
- **Produtos da lista:** aberta após criar uma lista ou ao abrir uma lista salva; permite incluir, capturar, editar e excluir produtos.
- **Categorias:** acessada pela tela inicial e organizada primeiro por tipo de estabelecimento.
- **Minhas Listas:** acessada pela tela inicial; permite abrir uma lista salva e solicitar sua exclusão.
- **Ajuda / Manual do Usuário:** acessível pelo botão correspondente na tela inicial; exibe este documento.

## Dados e privacidade

As listas, o catálogo de produtos, os estabelecimentos e as categorias personalizadas são mantidos localmente no dispositivo. A desinstalação do aplicativo ou a limpeza dos dados do app pode remover esses registros, conforme o comportamento do Android e do dispositivo. O SmartCompre não disponibiliza sincronização de conta ou cópia de segurança própria na nuvem.

## Histórico de atualizações

Marcos confirmados no histórico Git do projeto. Os hashes abaixo pertencem a commits existentes; alterações locais ainda não commitadas não recebem hash neste histórico.

- **2026-11-25 — 7ebc0c9cd6750e97fc4480dc18dbe4423839083e:** ordenação alfabética e deduplicação de categorias na apresentação.
- **2026-11-22 — d25089f74ccb98ef3729c0c83aac5779c8d2ce56:** estabilização do cadastro, captura, edição e exclusão de produtos.
- **2026-10-13 — 1789c303f3c9225153b369dd3634f70dd460ff40:** gerenciamento de categorias personalizadas por tipo de estabelecimento.
- **2026-10-13 — f36be46893521b8f4be49e760d1502c9fb8c0231:** persistência de categorias por tipo.
- **2026-09-30 — a562e875baaa63f774a46ac7be996dd41ca8348e:** cadastro, consulta, edição e exclusão de estabelecimentos.
- **2026-08-26 — 6c2ab7a4c2c0c947f3a036ef2318daaeed89c239:** correção do parser de etiquetas por peso para lidar com ruído do OCR.
- **2026-08-26 — 17faa21282e0da1a45dbaf0dca59a2e3343feaaf:** conclusão do OCR V2 com validação financeira.
- **2026-08-26 — 70ef9eb2bf1da6d1b9693a32da41f56bc93256ac:** ordenação de categorias e indicação de duplicidades.
- **2026-08-26 — bc9d95361142b2463eb0853af5692619cbe8f36f:** integração de categorias no cadastro e edição de produtos.
- **2026-08-26 — c35db5f70f95c2afaf1ba6547e9d5ab42dd7b031:** edição e exclusão de categorias.
- **2026-08-23 — 9dbfb0e953865106938c5f8525b95478c1d755ae:** suporte a múltiplos preços reconhecidos em etiquetas.
- **2026-08-17 — 05267fcbeaf3832a82dea72eda54a53d12be0ffa:** estrutura de classificação e parsers do OCR V2.
- **2026-08-05 — 625666a833eec4c01e5a9397d3db0af4c924c781:** integração do OCR às listas existentes.

## Limitações conhecidas

- Registros antigos podem não conter uma data válida. Eles não são alterados para inventar datas; aparecem sem data e não entram em filtros que dependem de mês e ano.
- O reconhecimento de etiquetas não garante leitura correta em todas as condições. Revise os dados antes de confirmar.
- Há telas auxiliares no código que não estão ligadas à navegação visível da tela inicial. Este manual descreve apenas os fluxos acessíveis pelo aplicativo.
- Os dados são locais; não há sincronização em nuvem nem cópia de segurança própria do SmartCompre.
