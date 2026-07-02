# Home Assistant Add-on: Pecron Monitor Streamer

[![Home Assistant Add-on Store](https://img.shields.io/badge/Home%20Assistant-Add--on%20Store-blue.svg?style=flat-for-the-badge)](https://my.home-assistant.io/redirect/supervisor_add_repository/?repository_url=https://github.com/mat1990dj/ha-apps/pecron_monitor)

A real-time MQTT streaming bridge built specifically for **Pecron LFP portable power stations** (such as the E3800LFP). This add-on connects to your power station and streams real-time wattage, battery percentages, and temperatures directly into Home Assistant via MQTT for beautiful, responsive dashboards.

This add-on is a Home Assistant packaging wrapper that relies directly on the underlying core logic from Logan's [pecron-monitor](https://github.com/attractify-logan/pecron-monitor) library.

---

## Features

* **Flexible Data Routing:** Support for high-speed Local LAN polling, Cloud-only connections, Cloud REST, or intelligent Automatic fallback tracking.
* **Instant Dashboard Updates:** Optimized to feed directly into advanced frontend cards like `power-flow-card-plus` without artificial delays.

---

## Installation

You can add this repository to your Home Assistant instance automatically by clicking the button below:

[![Open your Home Assistant instance and show the add-on store with a specific repository pre-filled.](https://my.home-assistant.io/badges/supervisor_add_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_repository/?repository_url=https://github.com/mat1990dj/ha-apps/pecron_monitor)

### Manual Installation
If you prefer to add it manually:
1. In Home Assistant, navigate to **Settings** $\rightarrow$ **Add-ons** $\rightarrow$ **Add-on Store**.
2. Click the three vertical dots in the upper-right corner and select **Repositories**.
3. Paste your GitHub repository URL: `https://github.com/your-username/your-repo-name`
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
* **Local Auth Key (Optional):** If you have extracted your local authentication token, pasting it here unlocks secure direct local LAN control.
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

*Contributions, bug fixes, and dashboard layout examples are always welcome via Pull Requests!*
