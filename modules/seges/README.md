# seges

#### Tabela de conteúdos

1. [Descrição](#descricao)
1. [Configuração - o básico para iniciar com seges](#configuracao)
    * [O que seges afeta](#o-que-seges-afeta)
    * [Requisitos de configuração](#requisitos-de-configuracao)
    * [Iniciando com seges](#inciando-com-seges)
1. [Utilização - Opções de configuração e funcionalidades adicionais](#utilizacao)
1. [Referências - referências das classes de definições do módulo](#referencias)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Descrição

O módulo Puppet 'seges' foi desenvolvido para gerenciar as configurações
mínimas necessárias para que os servidores da seção operem de acordo
com as definições pré-estabelecidas.

## Configuração

### O que seges afeta

O módulo instala, configura e gerencia diversas características do sistema como:

* Instalação de agentes de inventário e monitoramento
* Instalação de aplicativos e serviços básicos para o sistema
* Gerenciamento de usuários e autenticação via LDAP

### Requisitos de configuração 

Necessário instalar, no cliente, o agente do puppet da seguinte forma:

* curl -sS http://variante.redecamara.camara.gov.br/repositorio/ferramentas/puppet.install | bash
* No servidor do puppet, assinar o certificado do cliente
* Executar novamente o puppet no cliente

### Iniciando com seges

## Utilização

O servidor do puppet já possui uma configuração padrão caso nenhuma configuração de nó específica seja adicionada em /etc/puppetlabs/puppet/code/environment/production/manifests/nodes.

 node 'default' {
   class { 'seges':
     basic_install => true,
   }
 }

Exemplo de configuração de nó específico:
 
 /etc/puppetlabs/puppet/code/environment/production/manifests/nodes/teste1.pp

 node 'teste1' {
   class { 'seges':
     is_hypervisor => true,
     basic_install => true,
     users         => [ 'user1', 'user2', 'user3' ],
   }
 }

## Referências

### configs.pp

Classe de manipulação dos arquivos de configuração.

* Configurações dos serviços de ntp (`chrony.ntp.conf` e `ntp.conf`)
* Configurações para autenticação LDAP (`nslcd.conf` e `pam_ldap.conf`) 
* Desativação do Selinux
* Desativação do GSSAPIAuthentication via SSH

#### Classe: seges::configs

include seges::configs

### dellopenmanager.pp

Classe para instalação e configuração do DellOpenManager

#### Classe: seges::dellopenmanager 

include seges::dellopenmanager

### epelrepo.pp

Classe para instalação e configuração do repositório EPEL nos servidores CentOS/RedHat

#### Função: seges::epelrepo

 seges::epelrepo {'epel-release':
   ensure => installed,
   enable => true,
   source => 'http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm'
 }

### fusioninventory_agent.pp

Classe para instalação e configuração do agente de inventário para o GLPI

#### Classe: seges::fusioninventory_agent

 include seges::fusioninventory_agent

Ou

 seges::fusioninventory_agent {
   server => 'http://corsa.redecamara.camara.gov.br/glpi/plugins/fusioninventory/'
 }

### libvirt.pp

Classe para instalação e configuração de servidores de virtualização KVM

#### Classe: seges::libvirt

 include seges::libvirt

### packages.pp

Clase responsável pela instalação dos pacotes no sistema

#### Classe: seges::packages

 include seges::packages

OU

 seges::packages {
   packages_list   => [ 'git', 'httpd', 'mysql-server' ], 
   install_options => '--disablerepo=epel'    
 }
 
## Limitations

This is where you list OS compatibility, version compatibility, etc. If there
are Known Issues, you might want to include them under their own heading here.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel
are necessary or important to include here. Please use the `## ` header.
