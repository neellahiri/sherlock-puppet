class hudsoncommonsetup {
    
    exec { "infra-cli-source":
        command => "sudo echo 'deb http://10.47.4.220:80/repos/infra-cli/3 /' > /etc/apt/sources.list.d/infra-cli-svc.list",
        path => "/usr/bin/",
    }
    
    exec { "apt-get-update-infra":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["infra-cli-source"],
    }
    
    exec { "infra-cli-install":
        command => "sudo apt-get install --yes --allow-unauthenticated infra-cli",
        path => "/usr/bin/",
        require => Exec["apt-get-update-infra"],
    }
    
    exec { "adding-conman-alt-publish":
        command => "echo '10.85.58.179  pf-config-publish-alt.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["infra-cli-install"],
    }
    
    exec { "adding-conman-manage":
        command => "echo '10.85.58.180   pf-config-manage.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-conman-alt-publish"],
    }
    
    exec { "adding-conman-publish":
        command => "echo '10.85.58.179  pf-config-publish.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-conman-manage"],
    }
    exec { "adding-ops-statsd":
        command => "echo '10.65.100.54   ops-statsd.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-conman-publish"],
    }

    exec { "adding-config-service":
      command => "echo '10.85.42.9   configService' | sudo tee --append /etc/hosts",
      path => [ "/bin/", "/usr/bin" ] ,
      require => Exec["adding-ops-statsd"],
    }
    
    exec { "tcp-1":
        command => "echo 'net.core.somaxconn=1024' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-config-service"],
    }
    
    exec { "tcp-2":
        command => "echo 'net.ipv4.ip_local_port_range=15000    61000' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["tcp-1"],
    }
    
    exec { "tcp-3":
        command => "echo 'net.ipv4.tcp_fin_timeout=30' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["tcp-2"],
    } 
    
    exec { "tcp-4":
        command => "echo 'net.core.wmem_max=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-3"],
    }
    
    exec { "tcp-5":
        command => "echo 'net.ipv4.tcp_rmem= 10240 87380 12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-4"],
    }
    
    exec { "tcp-6":
        command => "echo 'net.ipv4.tcp_wmem= 10240 87380 12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-5"],
    }
    
    exec { "tcp-7":
        command => "echo 'net.core.netdev_max_backlog = 3000'  | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-6"],
    }
    
    exec { "tcp-8":
        command => "echo 'net.core.rmem_max=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-7"],
    }
    exec { "tcp-9":
        command => "echo 'net.core.wmem_default=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-8"],
    }
    exec { "tcp-10":
        command => "echo 'net.core.rmem_default=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-9"],
    }
    
    exec { "tcp-apply":
        command => "sudo sysctl --system",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["tcp-10"],
    }   
}
