# seges

#### Tabela de conteúdos

1. [Descrição](#descricao)
2. [Configuração - o básico para iniciar com seges](#configuracao)
    * [O que seges afeta](#o-que-seges-afeta)
    * [Requisitos de configuração](#requisitos-de-configuracao)
    * [Iniciando com seges](#inciando-com-seges)
3. [Utilização - Opções de configuração e funcionalidades adicionais](#utilizacao)
4. [Referências - referências das classes de definições do módulo](#referencias)
5. [Limitações - Compatibilidade de SO, etc.](#limitacoes)
6. [Notas de lançamento](#notas-de-lancamento)

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

Necessário instalar, no cliente, o agente do puppet conforme abaixo:

* curl -sS http://variante.redecamara.camara.gov.br/repositorio/ferramentas/puppet.install | bash
* No servidor do puppet, assinar o certificado do cliente
* Executar novamente o puppet no cliente

### Iniciando com seges

## Utilização

O servidor do puppet já possui uma configuração padrão caso nenhuma configuração de nó específica seja adicionada em /etc/puppetlabs/puppet/code/environment/production/manifests/nodes.

```
node 'default' {
  class { 'seges':
    basic_install => true,
  }
}
```

Exemplo de configuração de nó específico:

```
/etc/puppetlabs/puppet/code/environment/production/manifests/nodes/teste1.pp

node 'teste1' {
  class { 'seges':
    is_hypervisor => true,
    basic_install => true,
    users         => [ 'user1', 'user2', 'user3' ],
  }
}
```

## Referências

### hiera.yaml

Configurada a seguinte hierarquia de configuração:

* data/common.yaml:
  - Configurações comuns a todos as classes


* data/os:
  - Configurações específicas de SO por família/nome e/ou
família/nome e versão.
  - Exemplos:   
    - data/os/RedHat.yaml
    - data/os/RedHat/7.yaml

### configs.pp

Classe de manipulação dos arquivos de configuração.

* Configurações dos serviços de ntp (`chrony.ntp.conf` e `ntp.conf`)
* Configurações para autenticação LDAP (`nslcd.conf` e `pam_ldap.conf`)
* Desativação do Selinux
* Desativação do GSSAPIAuthentication via SSH

#### Classe::seges::configs

```
include seges::configs
```

### dellopenmanager.pp

Classe para instalação e configuração do DellOpenManager

#### Classe: seges::dellopenmanager

```
include seges::dellopenmanager
```

### libvirt.pp

Classe para instalação e configuração de servidores de virtualização KVM

#### Classe: seges::libvirt

```
include seges::libvirt
```

### packages.pp

Clase responsável pela instalação dos pacotes no sistema

#### Classe: seges::packages

```
include seges::packages
```

OU

```
seges::packages {
   packages_list   => [ 'git', 'httpd', 'mysql-server' ],
   install_options => '--disablerepo=epel'    
 }
 ```

## Limitações

O módulo foi configurado especificamente para atender a seção SEGES, que utiliza
os sistemas operacionais CentOS 6 e 7 e Ubuntu Server 16.04, além de configurações
específicas de usuários, pacotes do sistema, entre outras coisas a mais.

Com os devidos ajustes, o módulo pode ser utilizado por qualquer outra seção.

## Notas de Lançamento

* v0.1.2:
  - Migrado params.pp para hiera5.


* v0.1.1:
  - Migrado classes fusioninventory_agent e check_mk_agent para módulos independentes


* v0.1.0:
  - Criação do módulo para configuração automática dos hosts da seção
