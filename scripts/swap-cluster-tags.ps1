$ErrorActionPreference = "Stop";

# Define working variables
$octopusURL = $OctopusParameters["Octopus.Web.ServerUri"]
$octopusAPIKey = $OctopusParameters["Project.Octopus.ApiKey"]
$header = @{ "X-Octopus-ApiKey" = $octopusAPIKey; "Content-Type" = "text/json" }
$spaceId = $OctopusParameters["Octopus.Space.Id"]
$machineId = $OctopusParameters["Octopus.Machine.Id"]

# Get space
$space = (Invoke-RestMethod -Method Get -Uri "$octopusURL/api/spaces/all" -Headers $header) | Where-Object {$_.Name -eq $spaceName}

# Get machine
$machine = (Invoke-RestMethod -Method Get -Uri "$octopusURL/api/$spaceId/machines/$machineId" -Headers $header)

$roleToAdd = ""
$roleToRemove = ""

if ($machine.Roles -Contains "cm-inactive") {
  Write-Host "found tag cm-inactive, moving to cm-to-destroy"
  $roleToRemove = "cm-inactive"
  $roleToAdd = "cm-to-destroy"
}
elseif ($machine.Roles -Contains "cm-active") {
  Write-Host "found tag cm-active, moving to cm-to-inactive"
  $roleToRemove = "cm-active"
  $roleToAdd = "cm-inactive"
}
elseif ($machine.Roles -Contains "cm-candidate") {
  Write-Host "found tag cm-candidate, moving to cm-to-active"
  $roleToRemove = "cm-candidate"
  $roleToAdd = "cm-active"
}
else {
  Write-Host "Found no matching tags, exiting"
  exit 0
}

$machine.Roles = $machine.Roles | Where-Object { $_ -ne $roleToRemove }
$machine.Roles += $roleToAdd

Invoke-RestMethod -Method Put -Uri "$octopusURL/api/$spaceId/machines/$machineId" -Body ($machine | ConvertTo-Json -Depth 10) -Headers $header
