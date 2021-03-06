class arthurdeploynongeo {

    $envVersion = "HEAD"
    $envName = "sherlock-nongeo-arthur-env"
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "1"
    
    exec { "arthur-source":
        command => "sudo reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $envName --appkey $appkey --version $envVersion  | sudo tee /etc/apt/sources.list.d/sherlock-arthur.list ",
        path => "/usr/bin/",
    }
    
    exec { "apt-get-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        logoutput => false,
        require => Exec["arthur-source"]
    }
    
    exec { "fk-arthur-streaming":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-arthur-streaming",
        path => "/usr/bin",
        logoutput => false,
        tries => 2,
        timeout => 300,
        require => Exec["apt-get-update"],
    }

}

