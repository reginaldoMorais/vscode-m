#!/bin/bash

# Cores para o terminal
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
WHITE='\033[1;37m'
BOLD='\033[1m'
LIGHT_YELLOW='\033[0;93m'
LIGHT_CYAN='\033[0;96m'
NC='\033[0m' # No Color

# Diretórios e arquivos
INSTALL_DIR="$HOME/bin/scripts"
SCRIPT_NAME="vscode-m"
EXECUTABLE_NAME="vscode-m"
DB_NAME="extensions.info"
RC_ENTRY="
# VSCode Module Manager
export PATH=\"\$HOME/bin/scripts:\$PATH\"
alias vscode=\"vscode-m\"
"

# Função para mostrar o cabeçalho
show_header() {
    echo -e "${BLUE}"
    echo '┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓'
    echo -e "┃                                                                ┃"
    echo -e "┃      ${WHITE}██╗   ██╗███████╗    ██████╗ ██████╗ ██████╗ ███████╗${BLUE}     ┃"
    echo -e "┃      ${WHITE}██║   ██║██╔════╝   ██╔════╝██╔═══██╗██╔══██╗██╔════╝${BLUE}     ┃"
    echo -e "┃      ${WHITE}██║   ██║███████╗   ██║     ██║   ██║██║  ██║█████╗  ${BLUE}     ┃"
    echo -e "┃      ${WHITE}╚██╗ ██╔╝╚════██║   ██║     ██║   ██║██║  ██║██╔══╝  ${BLUE}     ┃"
    echo -e "┃       ${WHITE}╚████╔╝ ███████║   ╚██████╗╚██████╔╝██████╔╝███████╗${BLUE}     ┃"
    echo -e "┃        ${WHITE}╚═══╝  ╚══════╝    ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝${BLUE}     ┃"
    echo -e "┃                                                                ┃"
    echo -e "┃                     ${GREEN}Module Manager ${LIGHT_YELLOW}v1.0.0                      ${BLUE}┃"
    echo -e "┃                            ${PURPLE}INSTALLER                           ${BLUE}┃"
    echo -e "┃                                                                ┃"
    echo -e "┃                                                                ┃"
    echo '┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛'
    echo -e "${NC}"
}

# Adicione a chamada da função logo após as definições de constantes:
show_header

# Função para mostrar mensagens
log() {
    local message="$1"
    local color="${2:-$LIGHT_CYAN}"    # Cor padrão: LIGHT_CYAN
    local indent="${3:-0}"       # Indentação padrão: 0

    # Cria a indentação baseada no número de tabs
    local tabs=""
    for ((i=0; i<indent; i++)); do
        tabs="    $tabs"  # 4 espaços por tab
    done

    echo -e "${color}${tabs}${message}${NC}" >&2
}

# Função para obter permissões de forma compatível
get_permissions() {
    local file="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        stat -f "%OLp" "$file"
    else
        # Linux
        stat -c %a "$file"
    fi
}

# Verifica se os arquivos necessários existem
if [ ! -f "$SCRIPT_NAME" ] || [ ! -f "$DB_NAME" ]; then
    log "● Erro: Arquivos $SCRIPT_NAME e/ou $DB_NAME não encontrados no diretório atual" "$YELLOW"
    exit 1
fi

# Remove diretório de instalação se existir
if [ -d "$INSTALL_DIR" ]; then
    log "● Removendo instalação anterior..."
    rm -rf "$INSTALL_DIR"
fi

# Cria diretório de instalação
log "● Criando diretório de instalação..."
mkdir -p "$INSTALL_DIR"

# Copia os arquivos
log "● Copiando arquivos..."
cp "$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
cp "$DB_NAME" "$INSTALL_DIR/$DB_NAME"

# Configura permissões
log "● Configurando permissões..."
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Função para atualizar arquivo RC
update_rc() {
    local rc_file="$1"

    if [ -f "$rc_file" ]; then
        log "● Verificando $rc_file..."

        # Remove entrada antiga se existir
        if grep -q "VSCode Module Manager" "$rc_file"; then
            log "● Removendo configuração antiga de $rc_file..." "$CYAN" 1
            local tmp_file=$(mktemp)
            sed '/# VSCode Module Manager/,+2d' "$rc_file" > "$tmp_file"
            mv "$tmp_file" "$rc_file"
        fi

        # Adiciona nova entrada
        log "● Adicionando nova configuração em $rc_file..." "$CYAN" 1
        echo "$RC_ENTRY" >> "$rc_file"
        return 0
    fi
    return 1
}

# Atualiza .bashrc e .zshrc
updated=0
if update_rc "$HOME/.bashrc"; then
    updated=1
fi

if update_rc "$HOME/.zshrc"; then
    updated=1
fi

if [ $updated -eq 0 ]; then
    log "● Nenhum arquivo RC encontrado (.bashrc ou .zshrc)" "$YELLOW"
    exit 1
fi

# Atualiza o DB_FILE no script instalado
log "● Atualizando caminho do database no script..."
# Preserva as permissões do arquivo original
original_perms=$(get_permissions "$INSTALL_DIR/$SCRIPT_NAME")
temp_file=$(mktemp)
sed "s|DB_FILE=.*|DB_FILE=\"$INSTALL_DIR/$DB_NAME\"|" "$INSTALL_DIR/$SCRIPT_NAME" > "$temp_file"
cat "$temp_file" > "$INSTALL_DIR/$SCRIPT_NAME"
chmod "$original_perms" "$INSTALL_DIR/$SCRIPT_NAME"
rm "$temp_file"

log "\n\n✔ Instalação concluída!" "$GREEN"
log "\n● Para começar a usar, execute o comando 'source' para atualizar a sessão do seu shell:" "$LIGHT_CYAN"
log "  source ~/.bashrc" "$WHITE"
log "  ou" "$LIGHT_CYAN"
log "  source ~/.zshrc" "$WHITE"
