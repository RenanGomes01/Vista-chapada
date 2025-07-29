#!/bin/bash

# Script para otimização de imagens
# Reduz o tamanho das imagens mantendo a qualidade

echo "🔧 Iniciando otimização de imagens..."

# Verificar se o ImageMagick está instalado
if ! command -v convert &> /dev/null; then
    echo "❌ ImageMagick não encontrado. Instalando..."
    sudo apt-get update
    sudo apt-get install -y imagemagick
fi

# Criar diretório para imagens otimizadas
mkdir -p img/optimized

# Função para otimizar imagem
optimize_image() {
    local input="$1"
    local output="$2"
    local quality="$3"
    
    echo "📸 Otimizando: $input"
    
    # Redimensionar e otimizar
    convert "$input" -resize 1200x1200\> -quality "$quality" "$output"
    
    # Mostrar diferença de tamanho
    original_size=$(stat -c%s "$input")
    optimized_size=$(stat -c%s "$output")
    reduction=$((100 - (optimized_size * 100 / original_size)))
    
    echo "✅ $input: ${original_size}KB → ${optimized_size}KB (${reduction}% menor)"
}

# Otimizar imagens principais
echo "🖼️  Otimizando imagens principais..."

# Imagens grandes (1MB+) - reduzir significativamente
if [ -f "img/frontal.jpg" ]; then
    optimize_image "img/frontal.jpg" "img/optimized/frontal.jpg" 85
fi

if [ -f "img/diagonal.jpg" ]; then
    optimize_image "img/diagonal.jpg" "img/optimized/diagonal.jpg" 85
fi

if [ -f "img/fundo.jpg" ]; then
    optimize_image "img/fundo.jpg" "img/optimized/fundo.jpg" 85
fi

if [ -f "img/interior 2.jpg" ]; then
    optimize_image "img/interior 2.jpg" "img/optimized/interior-2.jpg" 85
fi

if [ -f "img/interior 1.jpg" ]; then
    optimize_image "img/interior 1.jpg" "img/optimized/interior-1.jpg" 85
fi

# Plantas - manter boa qualidade para detalhes
if [ -f "img/planta 3.jpg" ]; then
    optimize_image "img/planta 3.jpg" "img/optimized/planta-3.jpg" 90
fi

if [ -f "img/planta 2.jpg" ]; then
    optimize_image "img/planta 2.jpg" "img/optimized/planta-2.jpg" 90
fi

if [ -f "img/planta.jpg" ]; then
    optimize_image "img/planta.jpg" "img/optimized/planta.jpg" 90
fi

# Criar versões WebP para melhor performance
echo "🌐 Criando versões WebP..."

for img in img/optimized/*.jpg; do
    if [ -f "$img" ]; then
        webp_file="${img%.jpg}.webp"
        echo "🔄 Convertendo para WebP: $(basename "$img")"
        convert "$img" -quality 85 "$webp_file"
    fi
done

echo "✅ Otimização concluída!"
echo "📁 Imagens otimizadas salvas em: img/optimized/"
echo "💡 Para usar as imagens otimizadas, atualize os caminhos no HTML"