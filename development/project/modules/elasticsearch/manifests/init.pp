
class elasticsearch {

  require java::openjre
  #require sysconfig::misc

  file { '/etc/elasticsearch':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '0644'
  }
  exec { 'wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.tar.gz':
    cwd => '/etc/elasticsearch',
    unless => 'ls /etc/elasticsearch/bin/elasticsearch'
  }
  -> exec { 'tar -xzvf elasticsearch-1.0.1.tar.gz':
    cwd => '/etc/elasticsearch',
    unless => 'ls /etc/elasticsearch/bin/elasticsearch'
  }
  -> exec { 'mv elasticsearch-1.0.1/* . && rm -rf elasticsearch-1.0.1.tar.gz':
    cwd => '/etc/elasticsearch',
    timeout => 0,
    unless => 'ls /etc/elasticsearch/bin/elasticsearch'
  }
  -> exec { 'plugin -install elasticsearch/elasticsearch-analysis-icu/2.0.0':
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/etc/elasticsearch/bin" ],
    cwd => '/etc/elasticsearch/bin',
    unless => 'ls /etc/elasticsearch/plugins/analysis-icu'
  }
  -> exec { 'plugin -install mobz/elasticsearch-head':
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/etc/elasticsearch/bin" ],
    cwd => '/etc/elasticsearch/bin',
    unless => 'ls /etc/elasticsearch/plugins/head'
  }
  -> exec { 'plugin -install lukas-vlcek/bigdesk':
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/etc/elasticsearch/bin" ],
    cwd => '/etc/elasticsearch/bin',
    unless => 'ls /etc/elasticsearch/plugins/bigdesk'
  }
  -> exec { 'elasticsearch':
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/etc/elasticsearch/bin" ],
    cwd => '/etc/elasticsearch/bin',
    unless => 'curl localhost:9200'
  }
}
