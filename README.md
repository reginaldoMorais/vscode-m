# VSCode Module Manager

Um gerenciador de módulos para o Visual Studio Code que permite habilitar/desabilitar extensões baseado em contextos de projeto.

![VSCode Module Manager](https://img.shields.io/badge/VSCode-Module%20Manager-007ACC?style=for-the-badge&logo=visual-studio-code&logoColor=white)

## Sumario

- [VSCode Module Manager](#vscode-module-manager)
  - [Sumario](#sumario)
  - [Descrição](#descrição)
  - [Recursos](#recursos)
  - [Instalação](#instalação)
  - [Configuração](#configuração)
    - [Arquivo de Configuração do Projeto](#arquivo-de-configuração-do-projeto)
    - [Database de Extensões](#database-de-extensões)
  - [Uso](#uso)
    - [Comandos Básicos](#comandos-básicos)
    - [Opções Disponíveis](#opções-disponíveis)
  - [Exemplos](#exemplos)
    - [Projeto Go com Docker](#projeto-go-com-docker)
    - [Modo Verbose com Simulação](#modo-verbose-com-simulação)
    - [Sem Módulos Padrão](#sem-módulos-padrão)
  - [Módulos Disponíveis](#módulos-disponíveis)
  - [Desenvolvimento](#desenvolvimento)
    - [Estrutura do Projeto](#estrutura-do-projeto)
    - [Adicionando Novos Módulos](#adicionando-novos-módulos)
  - [Notas](#notas)
  - [Git Flow](#git-flow)
    - [Criando uma branch de trabalho](#criando-uma-branch-de-trabalho)
    - [Criando uma release para Produção](#criando-uma-release-para-produção)
    - [Criando um hotfix de Produção](#criando-um-hotfix-de-produção)
    - [Commits](#commits)
  - [Contribuindo](#contribuindo)
  - [Team](#team)

## Descrição

O VSCode Module Manager é uma ferramenta de linha de comando que ajuda a gerenciar extensões do VSCode baseado em módulos de projeto. Ele permite que você defina quais extensões devem estar ativas para diferentes tipos de projetos (Go, Docker, Python, etc.), mantendo seu ambiente VSCode limpo e otimizado para cada contexto.

Para isso ele utiliza uma base de dados de extensões, classificadas em diferentes módulos (Go, Docker, Python, etc.), que podem ser ativados ou desativados de acordo com o contexto do projeto.

## Recursos

- Ativa/desativa extensões baseado no contexto do projeto
- Suporte a múltiplos módulos por projeto
- Módulos padrão configuráveis
- Interface de linha de comando intuitiva
- Suporte a modo verbose para debugging
- Modo simulação para testar configurações

## Instalação

1. Clone o repositório:

```bash
git clone [url-do-repositório]
cd vscode-m
```

2. Execute o script de instalação:

```bash
chmod +x install.sh
./install.sh
```

3. Recarregue seu shell:

```bash
source ~/.bashrc  # ou source ~/.zshrc
```

## Configuração

### Arquivo de Configuração do Projeto

Para definir o módulo de um projeto, basta criar um arquivo `.r3md-rc` na raiz do seu projeto com os módulo desejados, separados por vírgula. Por exemplo:

```txt
GO,DOCKER
```

OBS.: Caso seja informado um ou mais módulos via cli, eles serão priorizados sobre o arquivo `.r3md-rc`.

### Database de Extensões

O arquivo `extensions.info` mapeia extensões para módulos. Os módulos podem ser:

- `BASE`
- `REGULAR`
- `DOCKER`
- `DRAW`
- `GIT`
- `GO`
- `JS`
- `PROJECT`
- `PYTHON`
- `INFRA`
- `SECURITY`
- `SHARED`
- `THEME`
- `WORKSPACE`
- `IA`

Para adicionar uma nova extensão, basta adicionar uma linha no arquivo `extensions.info` no formato `extensão|módulo`. Por exemplo:

```txt
ms-python.python|PYTHON
ms-vscode.go|GO
golang.go|GO
ms-azuretools.vscode-docker|DOCKER
```

## Uso

### Comandos Básicos

```bash
# Abrir VSCode com configuração do arquivo .r3md-rc
vscode

# Especificar módulos via CLI (sobrescreve .r3md-rc)
vscode GO DOCKER

# Desabilitar todas as extensões
vscode -a

# Modo verbose (mostra detalhes)
vscode -v

# Modo simulação (não executa)
vscode -n

# Desabilitar módulos padrão
vscode -d
```

### Opções Disponíveis

- `-h`: Mostra ajuda"
- `-l`: Lista todos os módulos de extensões disponíveis para inclusão"
- `-v`: Modo verbose (mostra detalhes da execução)"
- `-s`: Não executa o comando, apenas mostra mostra uma simulação"
- `-d`: Desabilita a inclusão de módulos de extensões padrão ($DEFAULT_MODULES)"
- `-c`: Ignora todos os módulos de extensões e executa 'code .'"
- `-n`: Nova instancia com módulo extensões básico"
- `-r`: Nova instancia sem nenhuma extensão"

## Exemplos

### Projeto Go com Docker

```bash
# Via arquivo .r3md-rc
echo "GO,DOCKER" > .r3md-rc
vscode

# Ou via CLI
vscode GO DOCKER
```

### Modo Verbose com Simulação

```bash
vscode -v -n GO
```

### Sem Módulos Padrão

```bash
vscode -d GO
```

## Módulos Disponíveis

- ALL
- DOCKER
- DRAW
- GIT
- GO
- JS
- PROJECT
- PYTHON
- SHARED
- THEME
- WORKSPACE

## Desenvolvimento

### Estrutura do Projeto

```
.
├── install.sh           # Script de instalação
├── vscode-m            # Script principal
├── extensions.info     # Database de extensões
└── README.md          # Documentação
```

### Adicionando Novos Módulos

1. Adicione o mapeamento no arquivo `extensions.info`:

```txt
nova-extensao|NOVO_MODULO
```

exemplo:

```txt
ms-vscode.makefile-tools|REGULAR
```

2. Use o novo módulo:

```bash
vscode NOVO_MODULO
```

## Notas

- Os módulos padrão (BASE, REGULAR, DRAW, GIT, PROJECT, THEME) são sempre incluídos, a menos que desabilitados com `-d`
- Prioridade de configuração: CLI > .r3md-rc > Módulos Padrão
- O modo verbose `-v` é útil para debug e entender o comportamento do script

## Git Flow

Optamos por seguir o modelo de fluxo de trabalho para desenvolvimento de software **Git Flow**.

No Git do projeto existem as branches:

```text
master: todas as features que irão para produção
develop: todas as features, em desenvolvimento, que irão para homologação
```

### Criando uma branch de trabalho

Para trabalharmos em uma nova funcionalidade abrimos uma branch baseada na branch **develop**. Indicada para novas funcionalidades, refatoração ou correção de um bug (da develop):

```bash
git checkout develop
git checkout -b feature/assunto-abordado-na-branch
```

Essas branches de desenvolvimento devem ser mergeadas na branch **develop** após aprovação do PR (Pull Request).

### Criando uma release para Produção

Após testarmos a funcionalidade em staging e seja necessário subir para produção, criamos uma release branch de **develop**, de modo a ser mergeada na **master**:

```bash
git checkout develop
git checkout -b release/1.0.42
```

Após o merge com a **master**, criamos uma tag para marcar o changelog de deploy e por fim executamos o pipeline correspondente.

### Criando um hotfix de Produção

Para resolver problemas críticos em produção, que não podem esperar uma nova release, devemos criar uma nova branch baseada na **master** com o prefixo **hotfix**:

```bash
git checkout master
git checkout -b hotfix/correcao-de-determinado-item
```

Esta branch deve ser testada em staging e após ter seu PR aprovado, deve ser mergeada tanto na branch **master** quanto na **develop**.

Referência:
[Medium.com: Utilizando o fluxo Git Flow](https://medium.com/trainingcenter/utilizando-o-fluxo-git-flow-e63d5e0d5e04)

### Commits

Utilizamos uma convenção leve sobre as mensagens de commit. Ela fornece um conjunto fácil de regras para criar um histórico de confirmação explícito; o que facilita a criação de ferramentas automatizadas. Esta convenção se encaixa no [SemVer](https://semver.org/), descrevendo os recursos, as correções e as alterações mais recentes feitas nas mensagens de commit.

A mensagem de commit deve ser estruturada da seguinte maneira:

```text
tipo: mensagem do commit
```

ou

```text
tipo(escopo): mensagem do commit
```

Os commits contém os seguintes elementos estruturais, para comunicar melhor as intenções. São eles:

| Tipo         | Descrição                                                                  |
| ------------ | -------------------------------------------------------------------------- |
| **feat**     | Nova funcionalidade                                                        |
| **fix**      | Correções de bugs                                                          |
| **docs**     | Mudanças de Documentação                                                   |
| **style**    | Formatação de código, markup, espaço em branco, ponto e vírgula ausente... |
| **refactor** | Refatoração de código                                                      |
| **perf**     | Uma alteração de código que melhora o desempenho                           |
| **test**     | Adição ou refatoração de testes                                            |
| **ci**       | Relacionado a mudanças do pipeline do CI                                   |
| **chore**    | Atualização de tarefas                                                     |
| **revert**   | Reverte uma tarefa                                                         |

Exemplos:

```bash
git commit -m "fix: atualizando o response de modelo"
```

Um escopo pode ser fornecido após um tipo. Um escopo DEVE consistir em um substantivo que descreva uma seção da base de código entre parênteses, por exemplo:

```bash
git commit -m "feat(autorizador): recuperando autorização por id"
```

Referências:
[Git Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0-beta.4/)
[Sparkbox](https://seesparkbox.com/foundry/semantic_commit_messages)
[Karma](http://karma-runner.github.io/1.0/dev/git-commit-msg.html)

## Contribuindo

1. Fork o projeto
2. Crie sua feature branch (`git checkout -b feature/branch-name`)
3. Commit suas mudanças (`git commit -am 'feat: implements new feature'`)
4. Push para a branch (`git push origin feature/branch-name`)
5. Crie um Pull Request

## Team

[Reginaldo Morais](mailto:reginaldo.cmorais@gmail.com)
