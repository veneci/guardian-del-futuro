import random
import datetime

def generar_log():
    ips = ["192.168.1.100", "10.0.0.5", "172.16.0.200", "8.8.8.8"]
    usuarios = ["root", "admin", "walter", "user"]
    archivos = ["/etc/passwd", "/etc/shadow", "/var/log/auth.log"]

    ip = random.choice(ips)
    usuario = random.choice(usuarios)
    archivo = random.choice(archivos)
    hora = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    tipo = random.choice(["ssh_fail", "ssh_success", "file_access", "port_scan"])
    if tipo == "ssh_fail":
        return f"{hora} | ssh | FAIL | {ip} | usuario={usuario}"
    elif tipo == "ssh_success":
        return f"{hora} | ssh | SUCCESS | {ip} | usuario={usuario}"
    elif tipo == "file_access":
        return f"{hora} | file | READ | {ip} | archivo={archivo}"
    elif tipo == "port_scan":
        puertos = random.randint(5, 20)
        return f"{hora} | scan | {ip} | puertos_escaneados={puertos}"

# Generar 50 logs de prueba
with open("../logs/logs_simulados.log", "w") as f:
    for _ in range(50):
        f.write(generar_log() + "\n")

print("✅ Logs generados en logs/logs_simulados.log")
