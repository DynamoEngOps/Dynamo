<#
   Date: 07/04/2019
   Purpose: Pre Build Script of Dynamo
#>

#=====================ASM Configuration=====================#

$ASMBranch = "225_0_0"
$ASM = "asm-a-lib_win_release_intel64_v140"
$ASMVer = "225.0.0"
$ASMBinPackageName = "asm-a_win_release_intel64_v140"
$ASMBin = "$ASMBinPackagename.$ASMVer"

#=====================TSP=====================#
$TSPLINESVer = "7.1.1"
$TSPLINESBin = "tsplines-a_win_release_intel64_v140.$TSPLINESVer"

#=====================TBB=====================#
$TBB = "TBB-2017U5-0226_win_release_intel64_v140"
$TBBVer = "1.0.1"
$TBBBin = "$TBB.$TBBVer"

#=====================Directories=====================#

$NugetConfig = "C:\Jenkins\workspace\Dynamo\DynamoPerformance-CI\master\config\nuget.config"
$MSBuildProjectDirectory = "C:\Jenkins\workspace\Dynamo\Dynamo\DYN-1822"
$PackageDirectory = "$MSBuildProjectDirectory\asm\asm_sdk_$ASMBranch\packages"
$MSBuildProjectDirectory = "C:\Jenkins\workspace\Dynamo\Dynamo\DYN-1822"
$DynamoExtern = "$MSBuildProjectDirectory\extern"

#Make Directory
New-Item -Path "$MSBuildProjectDirectory\asm\asm_sdk_$ASMBranch" -Name "packages" -ItemType "directory" -Force

#Donwload ASM
Set-Location -Path $PackageDirectory
C:\Nuget\nuget.exe install -configFile $NugetConfig $ASM -version $ASMVer

#ASM Copy
Copy-Item "$PackageDirectory\$ASMBin\bin\*" -Destination "$DynamoExtern\LibG_$ASMBranch\" -Recurse

#TSP Copy
Copy-Item "$PackageDirectory\$TSPLINESBin\bin\*.dll" -Destination "$DynamoExtern\LibG_$ASMBranch\"

#TBB Copy
Copy-Item "$PackageDirectory\$TBBBin\bin\*.dll" -Destination "$DynamoExtern\LibG_$ASMBranch\"


#Docker configuration
docker pull artifactory.dev.adskengineer.net/docker-local-v2/dynamo/buildtools2017sdk81

docker run -m 8GB --cpus=4 -d -t --mount type=bind,source=C:\Jenkins\workspace\Dynamo\Dynamo,target=c:\WorkspaceDynamo --name build-test artifactory.dev.adskengineer.net/docker-local-v2/dynamo/buildtools2017sdk81