# Projeto Minsait: Automatização da Criação de VM na Azure com Docker e WordPress

## Descrição

Este projeto, que foi o desafio final para o programa JP e 40+ da minsait, utiliza o Terraform para provisionar uma máquina virtual (VM) na Azure, configurar Docker na VM e implantar containers do MySQL e WordPress. Todo o processo é automatizado, sem necessidade de intervenção manual.

## Pré-requisitos

- Conta na Azure
- [Terraform](https://www.terraform.io/downloads.html) instalado na máquina local
- Chave SSH configurada

## Estrutura do Projeto

```bash
projeto-minsait/
├── main.tf
├── install_docker.sh
└── README.md
```

## Passo a Passo para Executar o Projeto

1. **Configurar a Chave SSH**
   - Gere uma chave SSH se ainda não tiver:
     ```
     ssh-keygen -t rsa -b 4096 -C "seu_email@gmail.com"
     ```
   - Adicione a chave pública ao arquivo `main.tf`.

2. **Aplicar a Configuração do Terraform**
   - Navegue até o diretório do projeto:
```
     cd /caminho/para/projeto-minsait
```
   - Inicialize o Terraform:
   ```
     terraform init
  ```
  - Verifique o código 
```
terraform plan
```
   - Aplique a configuração para criar a VM:
   ```
     terraform apply
   ```

3. **Conectar à VM e Instalar o Docker**
   - Acesse a VM usando SSH:
      ```
     ssh -i /caminho/para/sua_chave.pem usuario@ip_da_vm
      ```
 

- Certifique-se de ajustar variáveis e configurações conforme necessário no `main.tf` e `install_docker.sh`.

## Desenvolvedor
 [<img src="https://avatars.githubusercontent.com/u/95446979?s=400&u=3e0aa8e257965dd0bc8b5277665399e50835c05a&v=4" width=115><br><sub>Igor Galdino Beltrão do Nascimento</sub>](https://github.com/igorbeltrao1)
