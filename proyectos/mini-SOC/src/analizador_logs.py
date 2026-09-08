import re
from collections import defaultdict

def extraer_ip(linea):
    ip_match = re.search(r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b', linea)
    if ip_match:
        return ip_match.group()
    return None

def analizar_logs(archivo_log):
    intentos_fallidos = defaultdict(int)
    escaneos = defaultdict(int)
    alertas = []

    try:
        with open(archivo_log, "r") as f:
            for linea in f:
                ip = extraer_ip(linea)
                if not ip:
                    continue

                if "authentication failure" in linea.lower() or "failed password" in linea.lower():
                    intentos_fallidos[ip] += 1
                    if intentos_fallidos[ip] >= 3:
                        alertas.append(f"🚨 ALERTA: Fuerza bruta SSH desde {ip} ({intentos_fallidos[ip]} intentos)")

                if "scan" in linea.lower():
                    escaneos[ip] += 1
                    if escaneos[ip] >= 5:
                        alertas.append(f"🚨 ALERTA: Escaneo de puertos desde {ip} ({escaneos[ip]} eventos)")

                if "file" in linea.lower() and "/etc/passwd" in linea:
                    alertas.append(f"🚨 ALERTA: Acceso a archivo sensible (/etc/passwd) desde {ip}")

    except FileNotFoundError:
        print(f"❌ Error: No se encontró el archivo {archivo_log}")
        return []

    return alertas

if __name__ == "__main__":
    alertas = analizar_logs("/var/log/auth.log")

    with open("../logs/alertas.log", "w") as f:
        for alerta in alertas:
            f.write(alerta + "\n")
            print(alerta)

    print(f"✅ Alertas generadas: {len(alertas)}")
