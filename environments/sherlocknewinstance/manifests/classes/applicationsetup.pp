class applicationsetup {
  
    exec { "fk-w3-sherlock":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-w3-sherlock",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 3000,
    }
}
