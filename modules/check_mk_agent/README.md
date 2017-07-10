# check_agent

#### Indice

1. Descrição
2. Instalação
3. Funcionabilidade do check_agent
4. Requerimentos de instalação
5. Iniciando com check_agent
6. Desenvolvimento e contribuição

## Descrição

Módulo check_agent homologado na versão do Puppet v4.9.4, escrito e desenvolvido para funcionar na versão 4.x.x.

## Instalação

* Para instalar o módulo, basta copiar arquivos para a pasta:
* /etc/puppetlabs/code/environments/production/modules/check_agent
* Para verificar se o mesmo foi instalado corretamente digite o comando:
* puppet module list
* Verifique se aparece como parte do resultado: "seges-check_mk_agent (v0.1.1)"

### Funcionabilidade do check_agent

O módulo agente do check_agent serve para coletar dados referente a monitoramento de servidores GNU\Linux, derivados de Debian e Red Hat e enviar as informações para o Nagios\Check_mk

### Requerimentos de instalação

Os requirementos para seu funcionando é sistemas derivados do Debian e RedHat.

### Iniciando com check_agent

Para utiliza-los basta inserir os seguintes dados no node:

node "nome" {
  include check_mk_agent
}

ou

class { 'check_mk_agent': 
  noproxy => true,
}

## Desenvolvimento e contribuição

Criado por Phillipe Smith Carvalho Chaves (Seges)
Customizado por Luiz Guilherme Nunes Fernandes (Seges)
