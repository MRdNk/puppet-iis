define iis::manage_virtual_application($site_name, $site_path, $app_pool, $virtual_application_name = $title) {
  include 'iis::param::powershell'

  iis::createpath { "${site_name}-${virtual_application_name}-${site_path}":
    site_path => $site_path
  }

  exec { "CreateVirtualApplication-${site_name}-${virtual_application_name}" :
    command   => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; New-WebApplication -Name ${virtual_application_name} -Site ${site_name} -PhysicalPath ${site_path} -ApplicationPool ${app_pool}\"",
    path      => "${iis::param::powershell::path};${::path}",
    onlyif    => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; if((Test-Path \"IIS:\\Sites\\${site_name}\\${virtual_application_name}\")) { exit 1 } else { exit 0 }\"",
    require   => [ iis::createpath["${site_name}-${virtual_application_name}-${site_path}"], iis::manage_site[$site_name] ],
    logoutput => true,
  }
}
