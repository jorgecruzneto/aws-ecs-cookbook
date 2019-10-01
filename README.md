# ECS Cookbook
*Alguns experimentos com o serviço ECS da Amazon e Terraform.*

Antes de executar este código, crie um arquivo de extensão **.tfvars** com o seguinte conteúdo:

```
access_key = "seu-access-key-vai-aqui"
secret_key = "seu-secret-key-vai-aqui"
```

Para este exemplo, criei o arquivo **production.tfvars**, e para verificar se o plano de execução está correto, utilize o comando a seguir:

```
terraform plan -var-file=production.tfvars
```

Se tudo deu certo (espero que sim) execute o comando a seguir para provisionar a infra:

```
terraform apply -var-file=production.tfvars
```

Para desprovisionar:

```
terraform destroy -var-file=production.tfvars
```

Se tiver interesse de aprender junto comigo é só chamar, e se viu algum erro abra uma issue ...
