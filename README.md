# Infrastructure as Code

## Zadání

Cílem této semestrální práce je implementovat architekturu s konfigurovatelným počtem backendů a jedním load balancerem, s využitím nástrojů Terraform, Ansible a Docker. Jako cloudová služba bude použita univerzitní instance OpenNebula na nuada.zcu.cz. Backend a load balancer budou realizovány jako kontejnery, které lze sestavit a publikovat v repozitáři na GitHubu (s využitím GitHub Actions).

## Popis funkce

Implementovaný software se skládá z následujících komponent:

- **Load Balancer (NGINX)**: Zajišťuje distribuci zátěže mezi více backendy, čímž zajišťuje vysokou dostupnost a lepší výkon aplikace.
- **Backendy**: Služby, které zpracovávají požadavky zasílané load balancerem. Backendy jsou implementovány jako jednoduché Flask aplikace, které umožňují vyhledávání služeb definovaných v systému. Uživatel zadá název služby a pokud je nalezena, zobrazí se její podrobnosti. Počet backendů je konfigurovatelný.

## Požadavky na prostředí

Před zahájením implementace je třeba zajistit následující software:

### Výchozí prostředí

- **Dev Container**: Pokud je použito vývojové prostředí Dev Container, není třeba provádět žádné další instalace.

### Alternativní prostředí

- **Terraform**: Nainstalujte [Terraform](https://www.terraform.io/downloads.html) podle pokynů na oficiálních stránkách.
- **Ansible**: Nainstalujte [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) podle pokynů na oficiálních stránkách.

## Sestavení a spuštění aplikace

1. **Klonování repozitáře**

   Nejprve klonujte  a přejděte do repozitáře s projektem pomocí následujících příkazů:

   ```bash
   git clone https://github.com/RadekNolc/kiv-dce-sp1.git
   cd kiv-dce-sp1
   ```

2. Přejděte do složky **`infrastructure`**

   ```bash
   cd infrastructure
   ```

3. **Spuštění infrastruktury pomocí Terraformu**

   - **Inicializujte Terraform**: Inicializujte Terraform pro načtení všech potřebných pluginů a závislostí:

     ```bash
     terraform init
     ```

   - **Definujte proměnné**: Uložte proměnné do souboru `terraform.tfvars` s následujícím obsahem:

     ```hcl
     provider_endpoint = "<PROVIDER_ENDPOINT>"
     provider_username = "<PROVIDER_USERNAME>"
     provider_password = "<PROVIDER_PASSWORD>"

     vm_image_name = "<VM_IMAGE_NAME>"
     vm_image_url = "<VM_IMAGE_URL>"

     vm_ssh_privkey_path = "<VM_SSH_PRIVKEY_PATH>"
     vm_ssh_pubkey = "<VM_SSH_PUBKEY>"
     ```

   - **Vytvořte infrastrukturu**: Spusťte následující příkaz pro vytvoření infrastruktury:

     ```bash
     terraform apply
     ```

4. **Nasazení pomocí Ansible**

   - **Přejděte do složky**: Po úspěšném vytvoření infrastruktury pomocí Terraformu přejděte do složky `ansible`:

     ```bash
     cd ./ansible
     ```

   - **Spusťte Ansible playbook**: Pro nasazení backendů a load balanceru spusťte Ansible playbook:

     ```bash
     ansible-playbook -i inventory.ini cluster.yml
     ```

## Shrnutí

Tento projekt implementuje infrastrukturu s konfigurovatelným počtem backendů a jedním load balancerem pomocí nástrojů Terraform, Ansible a Docker. Využití univerzitní instance OpenNebula umožňuje flexibilní a efektivní nasazení celého řešení, přičemž všechny komponenty jsou realizovány jako kontejnery, což usnadňuje správu a škálování.

