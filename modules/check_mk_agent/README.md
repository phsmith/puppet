# check_mk_agent

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with check_mk_agent](#setup)
    * [Beginning with check_mk_agent](#beginning-with-check_mk_agent)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)

## Description

Module to manage Check_MK agent installation on
RedHat/CentOS and Debian/Ubuntu based distribuitions and Windows systems.

## Setup

* Execute the following commando to install the module:
** puppet module install check_mk_agent-0.1.0.tar.gz

### Beginning with check_mk_agent

To start using seges-check_mk_agent module just do the following:

```
include ::check_mk_agent
```

OR

```
class { 'check_mk_agent': }
```

## Usage

The module accepts some parameters like install additional plugins for Check_MK agent:

```
class { '::check_mk_agent':
  plugins => [ 'lvm', 'mk_logins', 'mk_logwatch' ],
}
```

## Reference

### Parameters

* `version`
Check_MK agent version to be installed.
Defaults to version 1.2.6p12.

* `plugins`
A list of Check_MK agent plugins to be installed.

* `plugins_source`
Source url for downloading Check_MK agent plugins.

* `agent_source`
Source url for downloading Check_MK agent. Only valid for Linux systems.
