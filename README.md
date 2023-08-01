# Pipeline Example  

Here we have a quick example of a simple project and a pipeline using the Duplo ci/cd piepline tools. 

## Dev Containers  

The dev container is tuned to use openvpn so private Duplo resources are available. You will need the following secrets in this repos secrets store:

### OpenVPN 

Set both of these secrets in the secrets for codespaces section in the repo settings. 

[Github Codespace Secrets Instructions](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-encrypted-secrets-for-your-codespaces)

Secret: `OPENVPN_CONFIG`  
The openvpn config file from your duplo user.

[OpenVPN Instructions on Duplo](https://docs.duplocloud.com/docs/gcp/prerequisites/connect-to-the-vpn)

Secret: `OPENVPN_AUTH`  
The openvpn auth file with username on first line and password on second line.

Example:
```
you@example.duplocloud.net
Password123
```