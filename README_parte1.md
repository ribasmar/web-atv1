# Parte 1 — Gerenciador de Tarefas

Aplicação web construída em Next.js (App Router) com TypeScript, que permite visualizar usuários e tarefas mockados, filtrar tarefas por usuário e cadastrar tarefas via formulário com feedback visual.

## Entidades consumidas

As entidades modeladas na Tarefa 1.2 são **Usuário** e **Tarefa**, com relação 1:N (um usuário possui várias tarefas, referenciadas por `usuarioId`).

## Componentes criados

### `UsuarioCard` (`app/components/UsuarioCard.tsx`)

Componente funcional client-side responsável por exibir os dados de um único usuário. Recebe via props o objeto `usuario`, o estado `selecionado`, a contagem `quantidadeTarefas` e o callback `onSelecionar`. Consome os campos `id`, `nome` e `email` do mock `usuarios`. Ao ser clicado, dispara o callback para que a página alterne o filtro de tarefas.

### `TarefaCard` (`app/components/TarefaCard.tsx`)

Componente funcional puramente apresentacional (Server Component). Recebe uma `tarefa` e o `nomeUsuario` resolvido pelo componente pai. Consome os campos `id`, `data`, `descricao` e `prioridade` do mock `tarefas`. Aplica uma cor de borda lateral diferente para cada prioridade (verde, amarelo, vermelho).

### `ListaTarefas` (`app/components/ListaTarefas.tsx`)

Componente de listagem que recebe um array de `tarefas` (já filtrado pelo pai) e o array de `usuarios` para resolver o nome de cada responsável. Renderiza cada item através do `TarefaCard` em uma lista estruturada (`<ul>`/`<li>`). Trata o caso de lista vazia com mensagem própria.

### `FormularioTarefa` (`app/components/FormularioTarefa.tsx`)

Componente client-side de formulário controlado. Possui campo de texto (`descricao`), campo de data (`data`), campo de seleção (`<select>` de `prioridade` com três opções) e botão de submissão. Não persiste dados. Após submissão válida, exibe mensagem de sucesso e limpa todos os campos; após 3 segundos a mensagem é ocultada. Inclui validação mínima da descrição com mensagem de erro.

## Gerenciamento de estado

O `useState` principal vive em `app/page.tsx` e controla `usuarioSelecionadoId: string | null`. Esse estado determina o subconjunto de tarefas passado ao `ListaTarefas`. Clicar em um `UsuarioCard` alterna a seleção (clicar no mesmo usuário desfaz o filtro). O componente `FormularioTarefa` também gerencia estado local próprio (campos do formulário, mensagem de sucesso e erro).

## Justificativa da biblioteca de CSS

Foi adotado **Tailwind CSS**, instalado por padrão pelo `create-next-app`. As razões da escolha:

- **Integração nativa com Next.js**: configurado via PostCSS sem ajustes adicionais, eliminando atrito de setup.
- **Escopo implícito**: classes utilitárias aplicadas inline evitam colisão de seletores globais, dispensando convenções como BEM ou CSS-in-JS.
- **Tree-shaking automático**: apenas as classes efetivamente usadas chegam ao bundle final, mantendo o CSS leve.
- **Iteração rápida**: ajustes visuais não exigem alternar entre arquivos `.tsx` e `.css`, o que é vantajoso no escopo deste projeto, onde não há necessidade de tematização avançada nem design system próprio.
- **Sem custo de runtime**: diferente de soluções CSS-in-JS, o Tailwind gera CSS estático em build, sem overhead em tempo de execução.

## Como rodar

```bash
npm install
npm run dev
```

Acesse `http://localhost:3000`.