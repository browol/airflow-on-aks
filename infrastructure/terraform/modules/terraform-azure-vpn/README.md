# Terraform Azure VPN

## Usage

Apply the Terraform configuration using Terragrunt:

```bash
terragrunt run-all apply
```

To clean up the resources created by Terragrunt, run:

```bash
terragrunt run-all destroy
```

## Cost Estimation

```bash
infracost breakdown --path=.
Detected Terragrunt directory at .
  ✔ Downloading Terraform modules
  ✔ Evaluating Terraform directory
  ✔ Retrieving cloud prices to calculate costs

Project: .

 Name                                         Monthly Qty  Unit                Monthly Cost

 azurerm_public_ip.gateway_pip
 └─ IP address (static)                               730  hours                      $3.65

 azurerm_virtual_network_gateway.gateway
 ├─ VPN gateway (VpnGw2)                              730  hours                    $357.70
 ├─ VPN gateway P2S tunnels (over 128)    Monthly cost depends on usage: $7.30 per tunnel
 └─ VPN gateway data tranfer              Monthly cost depends on usage: $0.09 per GB

 OVERALL TOTAL                                                                      $361.35
──────────────────────────────────
7 cloud resources were detected:
∙ 2 were estimated, 1 of which usage-based costs, see https://infracost.io/usage-file
∙ 5 were free, rerun with --show-skipped to see details

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┓
┃ Project                                            ┃ Monthly cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━┫
┃ .                                                  ┃ $361         ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┛
```
