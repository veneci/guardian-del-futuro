#!/bin/bash
echo "🚀 Iniciando Mini-SOC Walter Solutions"
cd ~/guardian-del-futuro/proyectos/mini-SOC
python3 src/generador_logs.py
python3 src/analizador_logs.py
echo "✅ Proceso completado. Revisá logs/alertas.log"
