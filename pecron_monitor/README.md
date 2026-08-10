# Home Assistant Add-on: Pecron Monitor Streamer

[![Open your Home Assistant instance and show the add app repository dialog with the repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fmat1990dj%2Fha-apps)

A real-time MQTT streaming bridge built specifically for **Pecron LFP portable power stations** (such as the E3800LFP). This add-on connects to your power station and streams real-time wattage, battery percentages, and temperatures directly into Home Assistant via MQTT for beautiful, responsive dashboards.

This add-on is a Home Assistant packaging wrapper that relies directly on the underlying core logic from @attractify-logan [pecron-monitor](https://github.com/attractify-logan/pecron-monitor) library.

---

## Features

* **Flexible Data Routing:** Support for high-speed Local LAN polling, Cloud-only connections, Cloud REST, or intelligent Automatic fallback tracking.
* **Instant Dashboard Updates:** Optimized to feed directly into advanced frontend cards like `power-flow-card-plus` without artificial delays.

---

## Installation

You can add this repository to your Home Assistant instance automatically by clicking the button below:

[![Open your Home Assistant instance and show the add app repository dialog with the repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fmat1990dj%2Fha-apps)

### Manual Installation
If you prefer to add it manually:
1. In Home Assistant, navigate to **Settings** $\rightarrow$ **Add-ons** $\rightarrow$ **Add-on Store**.
2. Click the three vertical dots in the upper-right corner and select **Repositories**.
3. Paste your GitHub repository URL: `[https://github.com/your-username/your-repo-name](https://github.com/mat1990dj/ha-apps)`
4. Click **Add**, close the dialog box, and scroll down to find **Pecron Monitor Streamer**.
5. Click **Install**.

---

## Configuration Settings

The add-on configuration tab is broken down into three logical sections to help organize your credentials:

### 1. Pecron Account Settings
* **Pecron Email Address:** The account login email used for your official mobile Pecron app.
* **Pecron Password:** The password linked to your mobile account profile.
* **Cloud Region:** Dropdown selector to align with your account's target cloud broker (`North America`, `Europe`, or `China`).

### 2. Pecron Device Parameters
* **Home Assistant Device Name:** The friendly identity given to this unit across your system entities (e.g., `Pecron3800LFP`).
* **Product Key:** The hardware family model identifier found inside your Pecron App's device details page.
* **Device Key (ID):** The specific hardware/serial key assigned to your physical power station.
* **Local Auth Key (Optional):** If you have extracted your local authentication token, pasting it here unlocks secure direct local LAN control. The Auth Key should be displayed on the logs the first time the App is started.
* **Device IP Address (Optional):** The static local IP of your Pecron unit on your home Wi-Fi network.
* **Data Routing Mode:** A selection menu allowing you to enforce strict `Local only` polling, `Cloud only` relays, `Cloud REST only`, or `Automatic` orchestration.

### 3. MQTT Broker Integration
* **MQTT Broker Hostname:** The target hostname or IP address of your MQTT Broker. (If you are using the official Mosquitto broker add-on, leave this as `core-mosquitto`).
* **MQTT Broker Port:** The port your broker communicates on (Default: `1883`).
* **MQTT Username / Password:** Your authorized security credentials required to publish states to your broker instance.

---

## Developer Roadmap & Native Updates
By default, this add-on compiles the required runtime container locally on your host hardware upon installation.

**BLE**: Since the underlaying library tries to access raw hardware ble capability, this probably does not work and relies purely on TCP/MQTT.

**Local MQTT to the Pecron Device**: While providing a `lan_ip` and `auth_key` enables a direct connection to the device on your local network, this driver operates as a hybrid system: **most device states, telemetry updates, and control commands still travel through Pecron's Cloud MQTT infrastructure.**

#### Communication Mechanisms Breakdown

* **Local TCP / Socket Connection**
  * **Requirements:** Requires both `lan_ip` and `auth_key` in the configuration.
  * **Role:** Connects directly to the Pecron unit over your local network for some low-latency status polling and direct local command execution.
  * **Scope:** Primarily handles local commands and telemetry (bypassed if telemetry provided via MQTT), additionally certain extended parameters or cloud-linked settings may still route through cloud endpoints.

* **Cloud MQTT Stream**
  * **Role:** Establishes a persistent MQTT connection directly with Pecron's remote cloud broker.
  * **Scope:** Carries real-time telemetry streaming, event notifications, and command broadcasts when local streaming is disabled, unsupported by the firmware, or offline.

* **Cloud REST API**
  * **Role:** Performs standard HTTPS REST requests to Pecron’s cloud servers.
  * **Scope:** Used during startup to authenticate your account credentials, fetch initial device keys, and act as a fallback state-retrieval mechanism if streaming drops.

#### How Connection Retries & Failovers Work

Depending on the **Connection Mode** selected in your add-on options, communication attempts follow a strict priority sequence:

1. **Automatic Mode (Default)**
   * **Step 1 (Local Attempt):** Tries to bind to the device directly via TCP using `lan_ip` and `auth_key`.
   * **Step 2 (Cloud MQTT Fallback):** If local binding fails or times out, it connects to Pecron's Cloud MQTT broker to resume streaming data.
   * **Step 3 (Cloud REST Fallback):** If the MQTT broker becomes unreachable, it falls back to periodic REST HTTP polling to maintain sensor state updates in Home Assistant.

2. **Local Only Mode (`--local`)**
   * Restricts all traffic to direct local TCP sockets using `lan_ip` and `auth_key`. Bypasses cloud MQTT streaming entirely.

3. **Cloud Only Mode (`--nolocal`)**
   * Forces all traffic through Pecron's Cloud MQTT streaming services, completely ignoring any local network options.

4. **Cloud REST Only Mode (`--rest-only`)**
   * Disables all real-time TCP and MQTT sockets, polling Pecron's cloud REST endpoints at regular intervals.

*Contributions, bug fixes, and dashboard layout examples are always welcome via Pull Requests!*
