# Samostatná práce: Instalace Zabbixu 8.0 LTS

![Titulní ilustrace s logy Zabbix, Vagrant a Debian nad virtuálním serverem](Images/zabbix-8-cover.png)

## Cíl

Připravte reprodukovatelnou instalaci **Zabbix serveru 8.0 LTS** ve virtuálním stroji **Debian 13**. Virtuální stroj vytvořte pomocí **Vagrantu** a instalaci proveďte **shell skriptem** spuštěným jako Vagrant provisioning. Pro databázi použijte **MariaDB**. Na stejný stroj nainstalujte také Zabbix Agent 2 a zpřístupněte webové rozhraní.

Svůj studentský repozitář si vytvořte přes [odkaz k zadání v GitHub Classroom](https://osy.sposdk.cz/zadani/osy-2026-zbx8-inst). Výsledkem má být projekt, který lze spustit z čistého klonu příkazem `vagrant up`, bez ruční instalace balíčků uvnitř virtuálního stroje.

## 1. Virtuální stroj a automatizace

- Vytvořte `Vagrantfile` pro Debian 13 (například box `bento/debian-13`) a VirtualBox. Nastavte alespoň 2 CPU a 2 GB RAM; při nedostatku paměti na hostiteli můžete po zdůvodnění v dokumentaci parametry upravit.
- Nastavte hostname a přesměrování HTTP portu na `127.0.0.1` hostitelského počítače. SSH zpřístupněte přes `vagrant ssh`; případné vlastní přesměrování SSH omezte také na `127.0.0.1`.
- Připojte jeden nebo více shell skriptů pomocí `config.vm.provision "shell"`. Skripty musí být součástí repozitáře a musí instalaci dokončit bez ručního spouštění příkazů ve VM.
- Skript musí při chybě skončit nenulovým návratovým kódem. Opakované spuštění `vagrant provision` nesmí zničit existující databázi ani vyžadovat ruční opravu. Opakovatelnost scriptu není primárně nutná je jen výhodou. Nebude známkováno.

## 2. Instalace Zabbixu

Ve skriptu proveďte tyto kroky:

1. Přidejte **oficiální repozitář Zabbix 8.0 pro Debian 13** a nainstalujte balíčky pro Zabbix server s databází MySQL/MariaDB, webové rozhraní, Apache, SQL schéma a Zabbix Agent 2. Nepoužívejte balíčky Zabbixu z výchozího repozitáře Debianu.
2. Nainstalujte MariaDB, vytvořte databázi `zabbix` s kódováním `utf8mb4` a uživatele s přístupem pouze k této databázi. Počáteční schéma a data importujte právě jednou.
3. Nastavte připojení Zabbix serveru a webového rozhraní k databázi. Hesla nesmějí být zveřejněna v README, snímcích obrazovky ani v historii Git. Popište, jak se při spuštění předávají nebo vytvářejí.
4. Spusťte a povolte služby MariaDB, Zabbix server, Zabbix Agent 2 a Apache. Agenta nastavte tak, aby monitoroval místní server.
5. Dokončete prvotní nastavení webového rozhraní. V jeho záhlaví nastavte vlastní rozpoznatelný název serveru, například své jméno nebo školní identifikátor. Instalujte do systému `zabbix.conf.php` a nakonfigurujte ho tak aby nebylo nutné ručně procházet PHP wizard.

Při postupu vycházejte z [oficiální instalace Zabbixu](https://www.zabbix.com/download), [poznámek k balíčkům](https://www.zabbix.com/documentation/8.0/en/manual/installation/install/packages) a [požadavků Zabbixu 8.0](https://www.zabbix.com/documentation/8.0/en/manual/installation/requirements). Adresu a název instalačního balíčku repozitáře ověřte při práci podle aktuálního oficiálního návodu.

## 3. Ověření monitorování

- Otevřete webové rozhraní z hostitelského počítače. Uveďte přesnou adresu a port ve svém README.
- Přidejte místní Debian 13 jako hosta a přiřaďte vhodnou šablonu pro Zabbix Agent 2. V **Latest data** ukažte aktuální hodnoty z agenta.
- Importujte hosta `sposdk.cz` z některého souboru v adresáři [`Zabbix/export`](Zabbix/export/) a ověřte v **Latest data** hodnoty pro TLS/SSL certifikát `https://sposdk.cz`. Pokud import staršího exportu vyžaduje úpravu pro Zabbix 8.0, změnu popište a upravený export odevzdejte.
- Ověřte běh služeb příkazem `systemctl status` nebo `systemctl is-active`.

## 4. Odevzdání

Ve svém GitHub Classroom repozitáři odevzdejte:

- `Vagrantfile`, všechny provisioning skripty a případné konfigurační šablony;
- vlastní `README.md` s předpoklady, příkazy pro spuštění (`vagrant up`, `vagrant ssh`, `vagrant provision`), adresou webu, postupem ověření a popisem řešení potíží, na které jste narazili;
- snímky obrazovky v adresáři `Images/`: web s vaším názvem serveru, dostupný místní host a jeho aktuální data, monitoring certifikátu `sposdk.cz` a ověření běhu služeb;
- odkaz na repozitář v Teams.
- soubory zadání odstraňte a ponechte jen Vaši práci.

Do repozitáře neukládejte `.vagrant/`, virtuální disk, hesla ani soubory s tajnými údaji. Před odevzdáním ověřte projekt z čistého klonu nebo po `vagrant destroy` a novém `vagrant up`.

## Hodnocení (30 bodů)

| Kritérium | Body |
| --- | ---: |
| Funkční Vagrantfile s Debianem 13 a dostupným webem | 5 |
| Automatická instalace Zabbixu 8.0 LTS, MariaDB a webového rozhraní | 10 |
| Instalace agenta, místní host a aktuální data | 4 |
| Monitoring TLS/SSL certifikátu `sposdk.cz` | 4 |
| Opakovatelný provisioning a bezpečné zacházení s hesly | 3 |
| Dokumentace a požadované snímky obrazovky | 4 |

Soubory v adresáři [`Example`](Example/) zachycují starší řešení pro Zabbix 7.0. Nejsou hotovým řešením této práce; zejména jejich repozitář, parametry VM a práce s heslem nesplňují nové požadavky.
