# fusioninventory

#### Indice

1. Descrição
2. Instalação
3. Funcionabilidade do fusioninventory
4. Requerimentos de instalação
5. Iniciando com fusioninventory
6. Desenvolvimento e contribuição

## Descrição

Módulo Fusion inventory homologado na versão do Puppet v4.9.4, escrito e desenvolvido para funcionar na versão 4.x.x.

## Instalação

* Para instalar o módulo, basta copiar arquivos para a pasta:
* /etc/puppetlabs/code/environments/production/modules/fusioninventory
* Para verificar se o mesmo foi instalado corretamente digite o comando:
* puppet module list
* Verifique se aparece como parte do resultado: "seges-fusioninventory v0.1.1)"

### Funcionabilidade do fusioninventory

O módulo agente do fusioninventory serve para inventariar os servidores GNU\Linux, derivados de Debian e Red Hat e enviar as informações para o GLPI

### Requerimentos de instalação

Os requirementos para seu funcionando é sistemas derivados do Debian e Centos.

### Iniciando com fusioninventory

Para utiliza-los basta inserir os seguintes dados no node:

node "nome" {
  include fusioninventory
}

ou

class { "fusioninventory":
  server => 'http://localhost/glpi/plugins/fusioninventory' 
}

## Desenvolvimento e contribuição

Criado por Phillipe Smith Carvalho Chaves <phillipe.chaves@camara.leg.br>
