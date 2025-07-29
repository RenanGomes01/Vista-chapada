#!/bin/bash

# Script de Monitoramento de Performance e SEO
# Vista dos Guimarães

echo "🔍 Iniciando monitoramento de performance e SEO..."
echo "=================================================="

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para verificar tamanho do site
check_site_size() {
    echo -e "\n${BLUE}📊 Verificando tamanho do site...${NC}"
    
    # Calcular tamanho total
    total_size=$(du -sh . --exclude=.git --exclude=node_modules 2>/dev/null | cut -f1)
    echo -e "Tamanho total do site: ${GREEN}$total_size${NC}"
    
    # Verificar imagens grandes
    echo -e "\n${YELLOW}🔍 Procurando imagens grandes (>500KB):${NC}"
    find . -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" | xargs ls -lh 2>/dev/null | awk '$5 ~ /[0-9]+[KMG]/ && $5 > 500K {print $5, $9}' || echo "Nenhuma imagem grande encontrada"
}

# Função para verificar SEO básico
check_seo_basics() {
    echo -e "\n${BLUE}🔍 Verificando SEO básico...${NC}"
    
    # Verificar se index.html existe
    if [ -f "index.html" ]; then
        echo -e "✅ index.html encontrado"
        
        # Verificar meta tags
        if grep -q "meta name=\"description\"" index.html; then
            echo -e "✅ Meta description presente"
        else
            echo -e "${RED}❌ Meta description ausente${NC}"
        fi
        
        if grep -q "meta name=\"keywords\"" index.html; then
            echo -e "✅ Meta keywords presente"
        else
            echo -e "${YELLOW}⚠️  Meta keywords ausente (opcional)${NC}"
        fi
        
        # Verificar título
        if grep -q "<title>" index.html; then
            title=$(grep "<title>" index.html | sed 's/.*<title>\(.*\)<\/title>.*/\1/')
            title_length=${#title}
            if [ $title_length -le 60 ]; then
                echo -e "✅ Título otimizado ($title_length caracteres): $title"
            else
                echo -e "${YELLOW}⚠️  Título muito longo ($title_length caracteres)${NC}"
            fi
        else
            echo -e "${RED}❌ Tag title ausente${NC}"
        fi
        
        # Verificar alt text nas imagens
        img_count=$(grep -c "<img" index.html)
        alt_count=$(grep -c "alt=" index.html)
        echo -e "📸 Imagens: $img_count, com alt text: $alt_count"
        
    else
        echo -e "${RED}❌ index.html não encontrado${NC}"
    fi
}

# Função para verificar arquivos importantes
check_important_files() {
    echo -e "\n${BLUE}📁 Verificando arquivos importantes...${NC}"
    
    files=("sitemap.xml" "robots.txt" "index.html")
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "✅ $file encontrado"
        else
            echo -e "${RED}❌ $file ausente${NC}"
        fi
    done
}

# Função para verificar performance de imagens
check_image_optimization() {
    echo -e "\n${BLUE}🖼️  Verificando otimização de imagens...${NC}"
    
    if [ -d "img/optimized" ]; then
        echo -e "✅ Diretório de imagens otimizadas encontrado"
        
        # Contar imagens otimizadas
        optimized_count=$(find img/optimized -name "*.jpg" -o -name "*.webp" | wc -l)
        echo -e "📸 Imagens otimizadas: $optimized_count"
        
        # Verificar tamanho das imagens otimizadas
        echo -e "\n${YELLOW}Tamanho das imagens otimizadas:${NC}"
        find img/optimized -name "*.jpg" -o -name "*.webp" 2>/dev/null | xargs ls -lh | awk '{print $5, $9}' || echo "Nenhuma imagem otimizada encontrada"
        
    else
        echo -e "${YELLOW}⚠️  Diretório de imagens otimizadas não encontrado${NC}"
    fi
}

# Função para verificar responsividade
check_responsiveness() {
    echo -e "\n${BLUE}📱 Verificando responsividade...${NC}"
    
    if [ -f "index.html" ]; then
        if grep -q "viewport" index.html; then
            echo -e "✅ Meta viewport presente"
        else
            echo -e "${RED}❌ Meta viewport ausente${NC}"
        fi
        
        if grep -q "media=" index.html; then
            echo -e "✅ CSS responsivo detectado"
        else
            echo -e "${YELLOW}⚠️  CSS responsivo não detectado${NC}"
        fi
    fi
}

# Função para gerar relatório
generate_report() {
    echo -e "\n${BLUE}📋 Gerando relatório...${NC}"
    
    report_file="relatorio_performance_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "Relatório de Performance e SEO - Vista dos Guimarães"
        echo "Data: $(date)"
        echo "=================================================="
        echo ""
        
        # Informações do sistema
        echo "Informações do Sistema:"
        echo "- Sistema: $(uname -s)"
        echo "- Kernel: $(uname -r)"
        echo "- Data: $(date)"
        echo ""
        
        # Tamanho do site
        echo "Tamanho do Site:"
        du -sh . --exclude=.git --exclude=node_modules 2>/dev/null
        echo ""
        
        # Arquivos importantes
        echo "Arquivos Importantes:"
        for file in "index.html" "sitemap.xml" "robots.txt"; do
            if [ -f "$file" ]; then
                echo "✅ $file"
            else
                echo "❌ $file"
            fi
        done
        echo ""
        
        # Imagens
        echo "Análise de Imagens:"
        find . -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" 2>/dev/null | wc -l | xargs echo "Total de imagens:"
        find . -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" 2>/dev/null | xargs ls -lh 2>/dev/null | awk '$5 ~ /[0-9]+[KMG]/ {print $5, $9}' | head -10
        echo ""
        
    } > "$report_file"
    
    echo -e "📄 Relatório salvo em: ${GREEN}$report_file${NC}"
}

# Função principal
main() {
    echo -e "${GREEN}🚀 Monitoramento de Performance e SEO${NC}"
    echo "Site: Vista dos Guimarães"
    echo "Data: $(date)"
    echo ""
    
    check_site_size
    check_seo_basics
    check_important_files
    check_image_optimization
    check_responsiveness
    generate_report
    
    echo -e "\n${GREEN}✅ Monitoramento concluído!${NC}"
    echo -e "${BLUE}💡 Dicas:${NC}"
    echo "- Execute este script semanalmente"
    echo "- Use Google PageSpeed Insights para análise detalhada"
    echo "- Monitore o Google Search Console"
    echo "- Mantenha as imagens otimizadas"
}

# Executar função principal
main