# SmartCompre - Instruções do Projeto

## Objetivo
Desenvolver e aprimorar o aplicativo SmartCompre para Android.

## Tecnologia
- Flutter
- Dart
- VS Code

## Regras obrigatórias
1. Preservar todas as funcionalidades existentes.
2. Não modificar arquivos sem antes analisar o projeto.
3. Não atualizar dependências ou versões sem autorização.
4. Não apagar códigos ou arquivos existentes sem autorização.
5. Não alterar a arquitetura do projeto sem autorização.
6. Fazer uma melhoria por vez.
7. Sempre identificar a causa do problema antes de propor uma correção.
8. Analisar o código relacionado e suas dependências antes de modificar qualquer arquivo.
9. Informar previamente quais arquivos serão alterados e o motivo.
10. Modificar somente os arquivos necessários para a tarefa autorizada.
11. Nunca descartar, restaurar ou sobrescrever alterações anteriores sem autorização.
12. Não fazer refatorações, melhorias extras ou mudanças de interface fora do escopo autorizado.
13. Preservar cálculos, regras de negócio, navegação, persistência e compatibilidade dos dados.
14. Explicar quais arquivos serão modificados antes de qualquer alteração.
15. Após cada alteração, executar flutter analyze, quando autorizado, e apresentar o resultado.
16. Apresentar o diff completo dos arquivos modificados.
17. Informar riscos de regressão e sugerir testes funcionais.
18. Não executar flutter pub get, builds ou atualizações de dependências sem necessidade justificada e autorização.
19. Em caso de dúvida sobre o comportamento esperado, interromper e perguntar antes de modificar o código.
20. Após cada alteração, verificar possíveis erros.
21. Priorizar compatibilidade com Android.
22. Solicitar autorização antes de implementar mudanças.

## Segurança
O projeto possui uma cópia de backup.
Preservar o projeto original e trabalhar com alterações pequenas e verificáveis.

## Documentação do produto
- Manter a documentação pública e a documentação interna separadas: `docs/MANUAL_DO_USUARIO.md` é o manual público e a fonte única do conteúdo exibido no aplicativo; `docs/ROADMAP_DO_PROJETO.md` é o planejamento interno.
- O manual deve conter somente funcionalidades disponíveis, instruções de uso, regras observáveis pelo usuário, limitações conhecidas e histórico verificável. Não incluir nele ideias, planejamento ou detalhes estratégicos futuros.
- A tela do aplicativo deve carregar exclusivamente `docs/MANUAL_DO_USUARIO.md`. Nunca incluir o roadmap como asset nem apresentá-lo na interface do usuário.
- Antes de alterar uma funcionalidade, consultar o manual para entender e preservar o comportamento documentado e consultar o roadmap quando a mudança se relacionar a uma proposta futura.
- Ao criar, modificar ou remover uma funcionalidade, atualizar o manual na mesma etapa, incluindo o que mudou e as regras automáticas relevantes.
- Atualizar o roadmap conforme o andamento. Manter as propostas futuras no documento interno; só movê-las para o manual depois de confirmar a implementação e validação.
- No roadmap, identificar claramente ideias registradas, funcionalidades planejadas, itens em desenvolvimento, itens aguardando aprovação e itens implementados. Uma ideia ou fase proposta não é autorização para desenvolver.
- Nunca marcar uma funcionalidade como concluída sem verificar o código e executar as validações pertinentes.
- Registrar no histórico somente commits que já existam, com a data, a descrição e o hash real. Não antecipar nem inventar hashes para alterações sem commit.
