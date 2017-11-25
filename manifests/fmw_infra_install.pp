class fmw_infra_install {
    $repo = hiera('forms_upg::staging_dir','/software')
    $filename = hiera('forms_upg::fmw_infra_install::installer', "fmw_12.2.1.3.0_infrastructure_Disk1_1of1.zip")
    $extract_to = hiera('forms_upg::fmw_infra_install::extract_to', '/tmp')
    $oracle_base = hiera('forms_upg::fmw_infra_install::oracle_base', '/opt/app/oracle')
    $mw_home = hiera('forms_upg::fmw_infra_install::mw_home', "${oracle_base}/middleware") 
    $wls_home = hiera('forms_upg::fmw_infra_install::wls_home', "${mw_home}/wlserver")
    $wl_home = hiera('forms_upg::fmw_infra_install::wl_home', "${wls_home}")
    $java_home = hiera('forms_upg::fmw_infra_install::java_home', "${oracle_base}/java")
    $ownr = hiera('forms_upg::owner','oracle')
    $grp  = hiera('forms_upg::group',  'oinstall')
  
    package { 'unzip':
        ensure => present,
    }
     
    exec{"mkdir -p ${oracle_base}/config":
        path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        unless => "test -d ${oracle_base}/config",
    }


    file { [ "${mw_home}", "${oracle_base}/config", "${oracle_base}/config/domains", "${oracle_base}/config/applications" ]: 
        ensure => directory,
        owner  => "${ownr}",
        group  => "${grp}",
        mode   => '0755',
    }

    archive { "${repo}/${filename}":
        ensure          => present,
        extract         => true,
        extract_path    => "${extract_to}",
        creates         => "${extract_to}/fmw_12.2.1.3.0_infrastructure.jar",
        cleanup         => true,
    }


}

