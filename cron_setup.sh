#!/bin/bash

# Script para configurar monitoramento automático
# Vista dos Guimarães

echo "🔧 Configurando monitoramento automático..."

# Verificar se o script de monitoramento existe
if [ ! -f "monitor_performance.sh" ]; then
    echo "❌ Script monitor_performance.sh não encontrado!"
    exit 1
fi

# Tornar executável
chmod +x monitor_performance.sh

# Criar diretório para logs
mkdir -p logs

# Função para adicionar ao crontab
setup_cron() {
    echo "📅 Configurando cron jobs..."
    
    # Backup do crontab atual
    crontab -l > /tmp/crontab_backup 2>/dev/null || echo "" > /tmp/crontab_backup
    
    # Adicionar jobs de monitoramento
    cat >> /tmp/crontab_backup << EOF

# Monitoramento Vista dos Guimarães
# Executar monitoramento semanal (domingo às 9h)
0 9 * * 0 cd /workspace && ./monitor_performance.sh >> logs/monitor_weekly.log 2>&1

# Otimização de imagens mensal (primeiro domingo do mês às 8h)
0 8 1-7 * 0 cd /workspace && ./optimize_images.sh >> logs/optimize_monthly.log 2>&1

# Backup do site (todo domingo às 10h)
0 10 * * 0 cd /workspace && tar -czf backup_\$(date +\%Y\%m\%d).tar.gz --exclude=.git --exclude=node_modules . >> logs/backup.log 2>&1
EOF

    # Instalar novo crontab
    crontab /tmp/crontab_backup
    
    echo "✅ Cron jobs configurados com sucesso!"
    echo ""
    echo "📋 Jobs configurados:"
    echo "- Monitoramento semanal: Domingos às 9h"
    echo "- Otimização mensal: Primeiro domingo do mês às 8h"
    echo "- Backup semanal: Domingos às 10h"
    echo ""
    echo "📁 Logs serão salvos em: logs/"
}

# Função para verificar status
check_status() {
    echo "🔍 Verificando status do monitoramento..."
    
    # Verificar se os scripts existem
    if [ -f "monitor_performance.sh" ]; then
        echo "✅ Script de monitoramento encontrado"
    else
        echo "❌ Script de monitoramento não encontrado"
    fi
    
    if [ -f "optimize_images.sh" ]; then
        echo "✅ Script de otimização encontrado"
    else
        echo "❌ Script de otimização não encontrado"
    fi
    
    # Verificar cron jobs
    echo ""
    echo "📅 Cron jobs ativos:"
    crontab -l | grep -E "(monitor|optimize|backup)" || echo "Nenhum job encontrado"
    
    # Verificar logs
    if [ -d "logs" ]; then
        echo ""
        echo "📁 Logs disponíveis:"
        ls -la logs/ 2>/dev/null || echo "Nenhum log encontrado"
    fi
}

# Função para remover monitoramento
remove_monitoring() {
    echo "🗑️  Removendo monitoramento automático..."
    
    # Backup do crontab atual
    crontab -l > /tmp/crontab_backup 2>/dev/null || echo "" > /tmp/crontab_backup
    
    # Remover jobs relacionados ao projeto
    sed -i '/Vista dos Guimarães/d' /tmp/crontab_backup
    sed -i '/monitor_performance.sh/d' /tmp/crontab_backup
    sed -i '/optimize_images.sh/d' /tmp/crontab_backup
    
    # Instalar crontab limpo
    crontab /tmp/crontab_backup
    
    echo "✅ Monitoramento removido!"
}

# Menu principal
show_menu() {
    echo ""
    echo "🔧 Configuração de Monitoramento - Vista dos Guimarães"
    echo "====================================================="
    echo "1. Configurar monitoramento automático"
    echo "2. Verificar status"
    echo "3. Remover monitoramento"
    echo "4. Executar teste manual"
    echo "5. Sair"
    echo ""
    read -p "Escolha uma opção (1-5): " choice
    
    case $choice in
        1)
            setup_cron
            ;;
        2)
            check_status
            ;;
        3)
            remove_monitoring
            ;;
        4)
            echo "🧪 Executando teste manual..."
            ./monitor_performance.sh
            ;;
        5)
            echo "👋 Até logo!"
            exit 0
            ;;
        *)
            echo "❌ Opção inválida!"
            show_menu
            ;;
    esac
}

# Executar menu se não houver argumentos
if [ $# -eq 0 ]; then
    show_menu
else
    case $1 in
        "setup")
            setup_cron
            ;;
        "status")
            check_status
            ;;
        "remove")
            remove_monitoring
            ;;
        "test")
            ./monitor_performance.sh
            ;;
        *)
            echo "Uso: $0 [setup|status|remove|test]"
            echo "Ou execute sem argumentos para menu interativo"
            exit 1
            ;;
    esac
fi