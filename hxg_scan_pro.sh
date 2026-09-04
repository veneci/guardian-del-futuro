#!/bin/bash
# ================================================================
# HXG SCAN PRO - Escáner de red profesional (versión HTML + navegador)
# Autor: Walter
# Descripción: Barrido exhaustivo de red con informe en HTML
#              Genera un informe .html y lo abre en el navegador.
# ================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   HXG SCAN PRO - Escáner de red${NC}"
echo -e "${BLUE}========================================${NC}"

# Detectar IP local
MI_IP=$(ip a | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -d'/' -f1 | head -1)
RED=$(echo $MI_IP | cut -d'.' -f1-3)
RANGO="$RED.0/24"

echo -e "${GREEN}[1/7] Red detectada:${NC} $RANGO"
echo -e "${GREEN}[1/7] Tu IP:${NC} $MI_IP"

# Instalar herramientas
echo -e "${YELLOW}[2/7] Verificando herramientas...${NC}"
if ! command -v nmap &> /dev/null; then
    echo -e "${YELLOW}  nmap no instalado. Instalando...${NC}"
    sudo apt install nmap -y
fi
if ! command -v arp-scan &> /dev/null; then
    echo -e "${YELLOW}  arp-scan no instalado. Instalando...${NC}"
    sudo apt install arp-scan -y
fi
echo -e "${GREEN}  ✅ Herramientas listas.${NC}"

# Escaneo de dispositivos
echo -e "${YELLOW}[3/7] Escaneando dispositivos activos...${NC}"
nmap -sn $RANGO -oG /tmp/nmap_hosts.txt > /dev/null 2>&1
grep "Up" /tmp/nmap_hosts.txt | awk '{print $2}' > /tmp/ips_nmap.txt
sudo arp-scan $RANGO 2>/dev/null | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | awk '{print $1}' >> /tmp/ips_arp.txt
cat /tmp/ips_nmap.txt /tmp/ips_arp.txt | sort -u > /tmp/ips_final.txt
TOTAL_IPS=$(cat /tmp/ips_final.txt | wc -l)
echo -e "${GREEN}  ✅ Dispositivos encontrados:${NC} $TOTAL_IPS"

# Generar informe HTML
FECHA=$(date +%Y%m%d_%H%M%S)
INFORME="$SCRIPT_DIR/informe_red_$FECHA.html"

echo -e "${YELLOW}[4/7] Generando informe HTML...${NC}"

cat > $INFORME << EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>HXG Scan Pro - Informe de Red</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f4f4f4; }
        .container { max-width: 900px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        .info { background: #ecf0f1; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .device { background: #f9f9f9; border-left: 4px solid #3498db; margin: 15px 0; padding: 10px; border-radius: 5px; }
        .device h3 { margin: 0; color: #2c3e50; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { padding: 8px; border: 1px solid #ddd; text-align: left; }
        th { background: #34495e; color: white; }
        .footer { text-align: center; margin-top: 20px; font-size: 14px; color: #777; }
    </style>
</head>
<body>
<div class="container">
    <h1>📡 HXG Scan Pro - Informe de Red</h1>
    <div class="info">
        <p><strong>Fecha:</strong> $(date '+%d/%m/%Y %H:%M:%S')</p>
        <p><strong>Red escaneada:</strong> $RANGO</p>
        <p><strong>Dispositivos encontrados:</strong> $TOTAL_IPS</p>
    </div>
EOF

# Agregar cada dispositivo al HTML
echo -e "${YELLOW}[5/7] Escaneando dispositivos...${NC}"
CONTADOR=0
for IP in $(cat /tmp/ips_final.txt); do
    CONTADOR=$((CONTADOR+1))
    echo -e "${BLUE}  [$CONTADOR/$TOTAL_IPS] Analizando:${NC} $IP"
    cat >> $INFORME << EOF
    <div class="device">
        <h3>📌 Dispositivo: $IP</h3>
EOF
    TCP=$(nmap -sV -p- -T4 $IP 2>/dev/null | grep -E "open" | head -3)
    if [ -n "$TCP" ]; then
        cat >> $INFORME << EOF
        <p><strong>Puertos TCP abiertos:</strong></p>
        <pre>$TCP</pre>
EOF
    else
        cat >> $INFORME << EOF
        <p><strong>Puertos TCP abiertos:</strong> ✅ Ninguno</p>
EOF
    fi
    cat >> $INFORME << EOF
    </div>
EOF
done

# Cerrar HTML
cat >> $INFORME << EOF
    <div class="footer">
        <p>Generado por HXG Scan Pro - Walter Solutions</p>
    </div>
</div>
</body>
</html>
EOF

# Limpiar archivos temporales
rm /tmp/nmap_hosts.txt /tmp/ips_nmap.txt /tmp/ips_arp.txt /tmp/ips_final.txt 2>/dev/null

# ================================================================
# LIMPIEZA Y ABRIR EN NAVEGADOR
# ================================================================
echo -e "${YELLOW}[6/7] Limpiando herramientas...${NC}"
sudo apt remove --purge arp-scan libencode-perl libtext-csv-perl libtext-csv-xs-perl -y 2>/dev/null
sudo apt autoremove -y 2>/dev/null
echo -e "${GREEN}  ✅ Herramientas eliminadas.${NC}"

echo -e "${YELLOW}[7/7] Abriendo informe en el navegador...${NC}"
if command -v brave-browser &> /dev/null; then
    brave-browser $INFORME &
elif command -v google-chrome &> /dev/null; then
    google-chrome $INFORME &
elif command -v firefox &> /dev/null; then
    firefox $INFORME &
elif command -v microsoft-edge &> /dev/null; then
    microsoft-edge $INFORME &
else
    xdg-open $INFORME &
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ DIAGNÓSTICO COMPLETADO${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "📄 Informe HTML guardado en: ${YELLOW}$INFORME${NC}"
echo -e "🌐 El informe se abrió en tu navegador."
echo -e "========================================"
