# fusioninventory

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with fusioninventory](#setup)
    * [Beginning with fusioninventory](#beginning-with-fusioninventory)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)

## Description

Module to manage Fusioninventory Agent installation on RedHat/CentOS and
Debian/Ubuntu based distribuitions.

## Setup

* Execute the following commando to install the module:
** puppet module install fusioninventory_agent-0.1.0.tar.gz

### Beginning with fusioninventory_agent

To start using seges-fusioninventory_agent module just do the following:

include ::fusioninventory_agent

OR

class { 'fusioninventory_agent': }

## Usage

The module accepts some parameters like install additional plugins for Check_MK agent:

class { '::fusioninventory_agent':
  server => 'http://localhost/glpi/plugins/fusioninventory/',
}

## Reference

### Parameters

* `server`
Specify the fusioninventory_agent server 
