$clusterId = $OctopusParameters["Project.Rancher.Cluster.Id"]
$release = $OctopusParameters["Octopus.Release.Number"]

$name = $OctopusParameters["Project.Cluster.Name"]
$clusterUrl = $OctopusParameters["Project.Cluster.Url"]
$roles = "octopub,cm,cm-candidate,cm-$release"
$accountName = $OctopusParameters["Project.Cluster.Account.Name"]
$workerPoolName = "Hosted Ubuntu"
$feedName = "Docker Hub"
$image = $OctopusParameters["Platform.WorkerImage.WorkerTools"]

New-OctopusKubernetesTarget -name $name `
  -clusterUrl $clusterUrl `
  -octopusRoles $roles `
  -octopusAccountIdOrName $accountName `
  -octopusDefaultWorkerPoolIdOrName $workerPoolName `
  -healthCheckContainerImageFeedIdOrName $feedName `
  -healthCheckContainerImage $image `
  -updateIfExisting
  