# contrail-scripts

OpenContrail Scripts

## contrailpin.rb

Contrailpin is a little script to generate a [repo config](https://code.google.com/p/git-repo/) config file. With pinned sha/tags.

### Modes

#### Fixed date mode

Init contrail sandbox with the state of all repo at 2014-03-01

```ruby
DATE=2014-03-01 ruby contrailpin.rb
```

See `/tmp/manifest.xml` file and `/tmp/contrail_2014-03-01.yml`

#### Latest trunk (default mode)

Init contrail sandbox with the latest trunk state

```ruby
VNC=../../../contrail-vnc/noauth.xml ruby contrailpin.rb
```

See `/tmp/manifest.xml`

#### Using a tree refs.

Init contrail sandbox with a tree reference.

```ruby
VNC=../../../contrail-vnc/noauth.xml REF=1.06 ruby contrailpin.rb
```

See `/tmp/manifest.xml`

#### With a Yaml config

Init contrail sandbox with the latest trunk state

```ruby
VNC=../../../contrail-vnc/noauth.xml YML=/tmp/contrail_2014-04-19.yml ruby contrailpin.rb
```

See `/tmp/manifest.xml`

### XML repo file generated

```xml
<?xml version="1.0"?>
<manifest>
<remote name="github" fetch="https://github.com/Juniper"/>

<default revision="refs/heads/master" remote="github"/>

<project name="contrail-build" remote="github" path="tools/build" revision="bc09452987d7ecd76e1885531775d3be79bcd415">
  <copyfile src="SConstruct" dest="SConstruct"/>
</project>
<project name="contrail-controller" remote="github" path="controller" revision="7550b95a00b5e116cc4f4769dbebbfd7f2709b31"/>
<project name="contrail-vrouter" remote="github" path="vrouter" revision="3ea54210edd41bfa28ae8d18510a19e236f50467"/>
<project name="contrail-third-party" remote="github" path="third_party" revision="8bea02c7c2e349f188054d4b2bda73fed2ba21c0"/>
<project name="contrail-generateDS" remote="github" path="tools/generateds" revision="8adef2bfb628ec38b4954c4681ab6b66b0273569"/>
<project name="contrail-sandesh" remote="github" path="tools/sandesh" revision="efc06673b9f5b5b133f1db85a49512c5d863e86c"/>
<project name="contrail-packages" remote="github" path="tools/packages" revision="ab0699099026477acdb446457fd742770e681abe">
  <copyfile src="packages.make" dest="packages.make"/>
</project>
<project name="contrail-nova-vif-driver" remote="github" path="openstack/nova_contrail_vif" revision="998212ebce184192c80025592133b40b0e6b97f9"/>

</manifest>
```

## jenkins.sh

Jenkins.sh is a little script to init a sandbox and install pre-req. packages in order to build all opencontrail packages (including ifmap)

```bash
bash jenkins.sh
```
