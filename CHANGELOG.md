cookbook-kafka CHANGELOG
===============

## 2.1.2

  - manegron
    - [6b7c1c1] Rescue get rol

## 2.1.1

  - Rafael Gomez
    - [113f52e] Remove an entrie of rb_malware in kafka_topics list

## 2.1.0

  - Pablo Pérez
    - [634ea48] Add rb_malware and rb_malware_post with namespaces

## 2.0.2

  - jnavarrorb
    - [c341fab] Remove executable permissions on non-executable files

## 2.0.1

  - nilsver
    - [63e2133] remove flush cache

## 2.0.0

  - Miguel Negrón
    - [a8c53f1] Merge pull request #29 from redBorder/bugfix/#21513_minimum_number_of_topic_default_partitions_should_be_2_for_1_node
  - Rafael Gomez
    - [d5d5934] Fix num.partitions to a static value of 2 in kafka_server.properties.erb
    - [fd10c61] Fix partitions value to a static number in topics_definitions.yml.erb

## 1.3.0

  - Miguel Negrón
    - [e26d375] Merge pull request #27 from redBorder/feature/#21232_refactor_license_system_ng
  - Rafael Gomez
    - [9583295] Fix typo in kafka_topics array for flow_post_discard

## 1.2.0

  - David Vanhoucke
    - [9c83148] listen to all interfaces
  - Miguel Alvarez
    - [8bd25f6] Fix kafka server properties
    - [960958d] Fix kafka check create topics
    - [d84f3dc] Fix offset replication factor

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
