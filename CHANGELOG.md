cookbook-kafka CHANGELOG
===============

## 1.1.1

  - Miguel Negrón
    - [e8d7ed5] Add pre and postun to clean the cookbook

## 1.1.0

  - Miguel Negrón
    - [a909f27] Merge pull request #20 from redBorder/bugfix/#13550_restrain_login_permision
    - [7cd25da] Update README.md
    - [52deeb5] Update rpm.yml
  - Luis Blanco
    - [dd1da1a] add nologin param

## 1.0.10

  - Miguel Negrón
    - Fix cookbook lint

## 1.0.9

  - Miguel Alvarez
    - [a0413f1] Added pipeline differention between proxy and manager
    - [6fa2ecd] Fixed proxy on a new kafka broker
    - [2ce66be] Fixed pipelines auto generation

## 0.0.6
 [ejimenez]
- Added redborder-kafka install
- Added sysctl after package installation

## 0.0.5
 [ejimenez] 
- Changed permissions to kafka user and group
- typo on service resource sintax
- Fixed permissions in kafka dirs
- Fixed typo on memory assignation in sysconfig kafka

## 0.0.4
 [ejimenez] - Fixed bug in brokers.list creation

## 0.0.3
 [ejimenez] 
- fixed problem in kafka-consumer and zk_hosts
- Added port to producer template  
- Added options to kafka sysconfig

## 0.0.2
- [ejimenez] - Adapted configurations

## 0.0.1
- [ejimenez] - Initial release
