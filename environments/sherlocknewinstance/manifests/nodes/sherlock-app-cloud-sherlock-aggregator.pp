node /^sherlock-app-cloud-sherlock-aggregator/ {
        include commonsetup
        include applicationsources
        include haproxy
        include applicationsetup
        include cosmos
        include alertz
        
        Class['commonsetup'] -> Class['applicationsources'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-app-cloud/ {
        include commonsetup
        include applicationsources
        include applicationsetup
        include cosmos
        include alertz
        
        Class['commonsetup'] -> Class['applicationsources'] ->  Class['haproxy'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}
