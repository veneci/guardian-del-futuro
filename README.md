
## 📡 HXG Scan Pro

![Bash](https://img.shields.io/badge/Bash-5.2-blue?logo=gnu-bash)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange?logo=ubuntu)
![Estado](https://img.shields.io/badge/Estado-En%20Desarrollo-yellow)
![Licencia](https://img.shields.io/badge/Licencia-MIT-green)

**HXG Scan Pro** es un escáner de red escrito en Bash que:

- Detecta automáticamente la red local (`192.168.x.0/24`).
- Escanea dispositivos activos con `nmap` y `arp-scan`.
- Identifica puertos abiertos y servicios en ejecución.
- Genera un informe en **HTML** con diseño profesional.
- Abre el informe directamente en el navegador.

### ⚙️ Instalación

Clona el repositorio y entra en la carpeta:

```bash
git clone https://github.com/veneci/guardian-del-futuro.git
cd guardian-del-futuro
 
```
### 🔧 Requisitos
- Linux (probado en Ubuntu 22.04)
- `nmap`
- `arp-scan`
- Navegador web (Firefox, Chrome, Brave, Edge)

### ▶️ Uso

Ejecuta el script:

```bash
chmod +x hxg_scan_pro.sh
./hxg_scan_pro.sh

```
### 🤝 Contribución

Si quieres mejorar este proyecto:

1. Haz un fork del repositorio.
2. Crea una rama (`git checkout -b feature-nueva`).
3. Haz tus cambios y commit (`git commit -m "Agregar nueva función"`).
4. Haz push a la rama (`git push origin feature-nueva`).
5. Abre un Pull Request.

### 📄 Ejemplo de informe

![Informe HXG Scan Pro](captura_informe.png)


---

## 📬 Contacto
Si tienes problemas al ejecutar el script, escríbeme a **walter_aguirre2010@hotmail.com**  
Te lo explico paso a paso y con ejemplos simples.

### 📜 Licencia

Este proyecto está bajo la licencia MIT.  
Puedes usar, modificar y distribuir el código libremente, siempre que mantengas la referencia al autor original.

## 🛡️ Mini-SOC - Walter Solutions

Mini-SOC para detección de ataques.

### 📌 Detección de alertas
- Fuerza bruta SSH.
- Escaneo de puertos.
- Acceso a archivos sensibles.

### 🚀 Cómo usarlo
```bash
cd proyectos/mini-SOC
./run_mini_soc.s
