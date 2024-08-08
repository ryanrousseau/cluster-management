$clusterId = $OctopusParameters["Project.Terraform.Cluster.Id"]
$release = $OctopusParameters["Octopus.Release.Number"]

$name = $OctopusParameters["Project.Cluster.Name"]
$clusterUrl = $OctopusParameters["Project.Cluster.Url"]
$roles = "octopub,cm,cm-candidate,cm-$release"
$accountName = $OctopusParameters["Project.Cluster.Account.Name"]
$workerPoolName = "Hosted Ubuntu"
$feedName = "Docker Hub"
$image = $OctopusParameters["Platform.WorkerImage.WorkerTools"]
$resourceGroup = $OctopusParameters["Project.Cluster.ResourceGroup"]

New-OctopusKubernetesTarget -name $name `
  -clusterUrl $clusterUrl `
  -octopusRoles $roles `
  -octopusAccountIdOrName $accountName `
  -clusterName $name `
  -clusterResourceGroup $resourceGroup `
  -octopusDefaultWorkerPoolIdOrName $workerPoolName `
  -healthCheckContainerImageFeedIdOrName $feedName `
  -healthCheckContainerImage $image `
  -updateIfExisting
  