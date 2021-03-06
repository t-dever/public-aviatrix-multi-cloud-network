# public-aviatrix-multi-cloud-network

This project is an example of deploying a multi cloud network with aviatrix using reusable modules.

## How to modify code

```terminal
pip install -U -r requirements.txt
pre-commit install
```

If checkov pre-check is NOT working with python pre-commit check then run from docker container in powershell.

```powershell
cd public-aviatrix-multi-cloud-network
docker run -v ${pwd}:/lint -w /lint ghcr.io/antonbabenko/pre-commit-terraform:latest run -a
```

## Custom Build Agents

If you wish to run your terraform on custom build agents the repo below is a good starting point for deploying your own.
https://github.com/t-dever/azure-devops-build-agents

## IP Addressing Schema

### Azure - 10.0.0.0/12 (10.0.0.1 - 10.15.255.254)

```yaml
  south_central_us: 10.0.0.0/16 # (10.0.0.1 - 10.0.255.254)
    hub_vnet: 10.0.0.0/23
    gateway_subnet: 10.0.0.0/28
    spokes:
    - spoke1: 10.0.2.0/23
      gateway_subnet: 10.0.2.0/24
      virtual_machines: 10.0.3.0/24
  east_us: 10.1.0.0/16 # (10.1.0.1 - 10.1.255.254)
    hub_vnet: 10.1.0.0/23
    gateway_subnet: 10.1.0.0/28
    spokes:
    - spoke1: 10.1.2.0/23
      gateway_subnet: 10.1.2.0/24
      virtual_machines: 10.1.3.0/24
    - spoke2: 10.1.4.0/23
      gateway_subnet: 10.1.4.0/24
      virtual_machines: 10.1.5.0/24
```

### GCP - 10.16.0.0/12 (10.16.0.1 - 10.31.255.254)

```text
  East US 1 - 10.16.0.0/16 (10.16.0.1 - 10.16.255.254)
  - Hub VPC - 10.16.0.0/23
  - Spoke1 - 10.16.2.0/23
    - gateway-subnet - 10.16.2.0/24
    - virtual-machines -10.16.3.0/24
```

### AWS - 10.32.0.0/12 (10.32.0.1 - 10.47.255.254)

```text
  West US 1 - 10.32.0.0/16 (10.32.0.1 - 10.32.255.254)
  - Hub VPC - 10.32.0.0/23
  - Spoke1 - 10.32.2.0/23
```


