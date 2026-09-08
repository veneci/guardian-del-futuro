import re
from collections import defaultdict

def analizar_logs(archivo_log):
    intentos_fallidos = defaultdict(int)
    escaneos = defaultdict(int)
    alertas = []

    with open(archivo_log, "r") as f:
        for linea in f:
            if "ssh | FAIL" in linea:
                ip = re.search(r'\d+\.\d+\.\d+\.\d+', linea).group()
                intentos_fallidos[ip] += 1
                if intentos_fallidos[ip] >= 3:
                    alertas.append(f"🚨 ALERTA: Fuerza bruta SSH desde {ip} ({intentos_fallidos[ip]} intentos)")

            if "scan" in linea:
                ip = re.search(r'\d+\.\d+\.\d+\.\d+', linea).group()
                escaneos[ip] += 1
                if escaneos[ip] >= 5:
                    alertas.append(f"🚨 ALERTA: Escaneo de puertos desde {ip} ({escaneos[ip]} eventos)")

            if "file | READ" in linea and "/etc/passwd" in linea:
                ip = re.search(r'\d+\.\d+\.\d+\.\d+', linea).group()
                alertas.append(f"🚨 ALERTA: Acceso a archivo sensible (/etc/passwd) desde {ip}")

    return alertas

alertas = analizar_logs("../logs/logs_simulados.log")

with open("../logs/alertas.log", "w") as f:
    for alerta in alertas:
        f.write(alerta + "\n")
        print(alerta)

print(f"✅ Alertas generadas: {len(alertas)}")
