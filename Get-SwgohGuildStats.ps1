<#

    SWGOH Guild StaSIXtics Tool Build 22-46 (c)2022 SuperSix/Schattenlegion

#>

<#

    Mod Sets

    1 - Health (2)
    2 - Offense (4)
    3 - Defense (2)
    4 - Speed (4)
    5 - Crit Chance (2)
    6 - Crit Damage (4)
    7 - Potency (2)
    8 - Tenacity (2)

#>

$ModSetShort = ("","HE","OF","DE","SP","CC","CD","PO","TE")

# CSS for output table form

$Debug = $false

$header = @"
<style>

    h1 {
        font-family: Arial, Helvetica, sans-serif;
        color: #e68a00;
        font-size: 28px;
    }
    
    h2 {
        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        font-size: 16px;
    }
   
   table {
		font-size: 12px;
		border: 0px; 
		font-family: Arial, Helvetica, sans-serif;
	} 
	
    td {
		padding: 4px;
		margin: 0px;
		border: 0;
	}
	
    th {
        background: #395870;
        background: linear-gradient(#49708f, #293f50);
        color: #fff;
        font-size: 11px;
        padding: 10px 15px;
        vertical-align: middle;
	}

    tbody tr:nth-child(even) {
        background: #f0f0f2;
        vertical-align: middle;
    }

</style>

"@

function CheckPrerequisites() {
    
    Clear-Host

    Write-Host "SWGOH Guild StaSIXtics Tool Build 22-46 (c)2022 SuperSix/Schatten-Legion" -ForegroundColor Green

    Write-Host

    # Check if all prerequisites are met

    if ($PSVersionTable.Version -lt 6.0.0) {Write-Host "ERROR - This script requires Powershell 6.0.0 or higher" -ForegroundColor Red; Break}

    if ((get-Item .\CONFIG-Accounts.csv -ErrorAction SilentlyContinue) -eq $null) {Write-Host "ERROR - Config file CONFIG-Accounts.csv missing"-ForegroundColor Red; Break}

    if ((get-Item .\CONFIG-Teams.csv -ErrorAction SilentlyContinue) -eq $null) {Write-Host "ERROR - Config file CONFIG-Teams.csv missing"-ForegroundColor Red; Break}

    if ((Invoke-WebRequest -uri http://api.swgoh.gg).StatusCode -ne 200) {Write-Host "ERROR - Cannot connect to api.swgoh.gg" -ForegroundColor Red; Break}

    $ParseModule = Get-Module PSParseHTML -ListAvailable -ErrorAction SilentlyContinue

    If ($ParseModule -eq $null) { Install-Module -Name PSParseHTML -AllowClobber -Force }

}

# MAIN

CheckPrerequisites

$AccountInfo = Import-Csv ".\CONFIG-Accounts.csv" -Delimiter ";"

$TeamList = Import-Csv ".\CONFIG-Teams.csv" -delimiter ";" | Sort-Object TeamName

$AllAllyCodes = $AccountInfo.Allycodes.Split(",")

Write-Host "Loading support data" -ForegroundColor Green

$UnitsList = ((Invoke-WebRequest -Uri http://api.swgoh.gg/units -ContentType "application/json" ).Content | ConvertFrom-Json).data

$UnitsList | Select-Object Name,Base_id | Sort-Object Name | ConvertTo-Html -Head $header | out-File ".\GAME-NameMapping.htm" -Encoding UTF8

$RawMetaInfo = (Invoke-WebRequest https://swgoh.gg/stats/mod-meta-report/guilds_100_gp/).Content 

$RawMetaInfo = $RawMetaInfo.Replace('<div class="collection-char-set collection-char-set1 collection-char-set-max" data-toggle="tooltip" data-title="','')

$RawMetaInfo = $RawMetaInfo.Replace('<div class="collection-char-set collection-char-set2 collection-char-set-max" data-toggle="tooltip" data-title="','')

$RawMetaInfo = $RawMetaInfo.Replace('<div class="collection-char-set collection-char-set3 collection-char-set-max" data-toggle="tooltip" data-title="','')

$RawMetaInfo = $RawMetaInfo.Replace('<div class="collection-char-set collection-char-set4 collection-char-set-max" data-toggle="tooltip" data-title="','')

$RawMetaInfo = $RawMetaInfo.Replace('<div class="collection-char-set collection-char-set5 collection-char-set-max" data-toggle="tooltip" data-title="','')

$RawMetaInfo = $RawMetaInfo.Replace('<div class="collection-char-set collection-char-set6 collection-char-set-max" data-toggle="tooltip" data-title="','')

$RawMetaInfo = $RawMetaInfo.Replace('<div class="collection-char-set collection-char-set7 collection-char-set-max" data-toggle="tooltip" data-title="','')

$RawMetaInfo = $RawMetaInfo.Replace('<div class="collection-char-set collection-char-set8 collection-char-set-max" data-toggle="tooltip" data-title="','')

$RawMetaInfo = $RawMetaInfo.Replace("Crit Chance","Critical-Chance")

$RawMetaInfo = $RawMetaInfo.Replace("Critical Chance","Critical-Chance")

$RawMetaInfo = $RawMetaInfo.Replace("Crit Damage","Critical-Damage")

$RawMetaInfo = $RawMetaInfo.Replace("Critical Damage","Critical-Damage")

$RawMetaInfo = $RawMetaInfo.Replace("&#x27;","'")

$RawMetaInfo = $RawMetaInfo.Replace("&quot;",'"')

$RawMetaInfo = $RawMetaInfo.Replace('" data-container="body"></div>','')

$RawMetaList = $RawMetaInfo | ConvertFrom-HtmlTable 

$ModTeamObj=[ordered]@{Name="";"Power"=0;"Gear"="";"Speed"=0;"MMScore"=0;"Mod-Sets"="";"Transmitter"="";"Receiver"="";"Processor"="";"Holo-Array"="";"Data-Bus"="";"Multiplexer"=""}

# Start guild analysis

ForEach ($GuildAllyCode in $AllAllyCodes) {

    # Load guild data, including list of all guild member's allycodes

    Write-Host "Loading guild data for allycode",$GuildAllyCode -foregroundcolor green

    $RosterInfo = (Invoke-WebRequest ("http://api.swgoh.gg/player/" + $GuildAllyCode) -SkipHttpErrorCheck -ErrorAction SilentlyContinue).Content | ConvertFrom-Json

    $GuildInfo = ((Invoke-WebRequest ("http://api.swgoh.gg/guild-profile/" + $RosterInfo.data.guild_id) -SkipHttpErrorCheck  -ErrorAction SilentlyContinue ).Content | ConvertFrom-Json).Data
 
    $MemberList = $GuildInfo.members | Sort-Object player_name
    
    # Create subdirs for guild if not present

    $GuildSubDir = Get-ChildItem (".\GUILD-" + $GuildInfo.Name) -ErrorAction SilentlyContinue

    if ($GuildSubDir -eq $null) { $Dummy = New-Item -Path (".\GUILD-" + $GuildInfo.Name ) -ItemType Directory -Erroraction silentlycontinue}

    # Build per-user guild statistics and prepare for overall guilt statistics

    $GuildStats = $MemberList | Select-Object player_name,galactic_power,gpchar,gpship | Sort-Object galactic_power -Descending

    $GuildStats | Add-Member -Name CRancor -MemberType NoteProperty -Value 0

    $GuildStats | Add-Member -Name "GLs" -MemberType NoteProperty -Value 0

    # Get full available player information from the server and store in an array for further analysis

    Write-Host "Loading player information for",$GuildInfo.Name -foregroundcolor green
    
    $Team=@{}

    ForEach ($Member in ($Memberlist | Where-Object {$_.ally_code -ne $null})) { 

        Write-Progress -Activity $Member.player_name -PercentComplete 0

        $ModRoster=@()

        $RosterInfo = (Invoke-WebRequest ("http://api.swgoh.gg/player/" + $Member.ally_code) -SkipHttpErrorCheck  -ErrorAction SilentlyContinue ).Content | ConvertFrom-Json

        $ModList = $RosterInfo.mods | Where-Object {$_.level -eq 15 -and $_.Rarity -ge 5}

        $ModRosterInfo = $RosterInfo.Units.Data | Where-Object {$_.combat_type -eq 1 -and $_.Level -ge 50}

        ForEach ($Char in $ModRosterInfo) {

            $ModTeam = New-Object PSObject -Property $ModTeamObj
    
            $ModTeam.Name = $Char.Name

            $ModTeam.Speed = $Char.stats.5

            $ModTeam.Power = $Char.power
    
            if ($Char.relic_tier -gt 2) {

                $ModTeam.Gear = "R" + ($Char.relic_tier -2)

            } else {

                $ModTeam.Gear = "G" + ($Char.gear_level)
            }
            
            $MMScore = 0

            $EquippedModsets = $Char.mod_set_ids

            $EquippedMods = $ModList | Where-Object {$_.character -like $Char.base_id}

            $RequiredMods = ($RawMetaList | Where-Object {$_.Character -eq ($Char.name)})
    
            $RequiredModSets = $RequiredMods.Sets.Split().Replace("-"," ") | sort
    
            if ($RequiredModSets -contains "Offense" -and $EquippedModsets -contains 2) {$MMScore += 20}

            if ($RequiredModSets -contains "Speed" -and $EquippedModsets -contains 4) {$MMScore += 20}

            if ($RequiredModSets -contains "Critical Damage" -and $EquippedModsets -contains 6) {$MMScore += 20}
            
            if ($RequiredModSets -contains "Health" -and $EquippedModsets -contains 1) { $MMScore += 10 * (($RequiredModSets | Where-Object {$_ -like "Health"}).count,($EquippedModsets | Where-Object {$_ -eq 1}).Count | measure -Minimum).Minimum }
            
            if ($RequiredModSets -contains "Defense" -and $EquippedModsets -contains 3) { $MMScore += 10 * (($RequiredModSets | Where-Object {$_ -like "Defense"}).count,($EquippedModsets | Where-Object {$_ -eq 3}).Count | measure -Minimum).Minimum }
            
            if ($RequiredModSets -contains "Critical Chance" -and $EquippedModsets -contains 5) {$MMScore += 10 * (($RequiredModSets | Where-Object {$_ -like "Critical Chance"}).count,($EquippedModsets | Where-Object {$_ -eq 5}).Count | measure -Minimum).Minimum }
            
            if ($RequiredModSets -contains "Potency" -and $EquippedModsets -contains 7) {$MMScore += 10 * (($RequiredModSets | Where-Object {$_ -like "Potency"}).count,($EquippedModsets | Where-Object {$_ -eq 7}).Count | measure -Minimum).Minimum }
            
            if ($RequiredModSets -contains "Tenacity" -and $EquippedModsets -contains 8) { $MMScore += 10 * (($RequiredModSets | Where-Object {$_ -like "Tenacity"}).count,($EquippedModsets | Where-Object {$_ -eq 8}).Count | measure -Minimum).Minimum }
            
            ForEach ($Slot in (1,2,3,4,5,6)) {
    
                $SelectedMod = $EquippedMods | Where-Object {$_.slot -eq $Slot}

                switch ($Slot) {
                    
                    1 { $RequiredPrimaries = "Offense"; $SlotName = "Transmitter" }
                    
                    2 { $RequiredPrimaries = ($RequiredMods.Receiver).Split(" / "); $SlotName = "Receiver"  }
                    
                    3 { $RequiredPrimaries = "Defense"; $SlotName = "Processor" }
                    
                    4 { $RequiredPrimaries = ($RequiredMods."Holo-Array").Split(" / "); $SlotName = "Holo-Array" }
                    
                    5 { $RequiredPrimaries = ($RequiredMods."Data-Bus").Split(" / "); $SlotName = "Data-Bus"  }
                    
                    6 { $RequiredPrimaries = ($RequiredMods.Multiplexer).Split(" / "); $SlotName = "Multiplexer" }
    
                    Default {}
                }
    
                $RequiredPrimaries = $RequiredPrimaries.Replace("-"," ")
    
                if ($RequiredPrimaries -contains $SelectedMod.primary_stat.name) {$MMScore += 5}
    
                if ($SelectedMod.primary_stat.stat_id -eq 5 -or $SelectedMod.secondary_stats.stat_id -contains 5) { 
                    
                    $MMScore += 5

                    if ($SelectedMod.primary_stat.stat_id -eq 5) {
                    
                        $ModSpeed = ("{0:00}" -f [int]$SelectedMod.primary_stat.display_value) + " - " + $ModSetShort[$SelectedMod.set] + " - " +  $SelectedMod.primary_stat.name
                    
                    } else {
                        
                        $ModSpeed = ("{0:00}" -f [int]($SelectedMod.secondary_stats | Where-Object {$_.Stat_id -eq 5}).display_value) + " - " + $ModSetShort[$SelectedMod.set] + " - " +  $SelectedMod.primary_stat.name
                        
                    }

                    $ModTeam.($SlotName) = $ModSpeed
                                    
                }        
    
            }
            
            ForEach ($ModSet in $RequiredModSets) {
    
                $ModTeam."Mod-Sets" += $ModSet  + " / "

            }

            $ModTeam."Mod-Sets" = $ModTeam."Mod-Sets".trim(" / ").Replace("/ /","/").trim(" / ")

            if ($MMScore -eq 90) {
            
                $MMScore = 100 
            
            } else {
    

                    # $ModTeam."Mod-Sets" = $ModTeam."Mod-Sets".trim(" / ").Replace("/ /","/").trim(" / ")
    
                    $ModTeam.Transmitter = "Offense"
                    
                    $ModTeam.Receiver = $RequiredMods.Receiver.Replace("-"," ")

                    $ModTeam.Processor = "Defense"
                    
                    $ModTeam."Holo-Array" = $RequiredMods."Holo-Array".Replace("-"," ")
                    
                    $ModTeam."Data-Bus" = $RequiredMods."Data-Bus".Replace("-"," ")
                    
                    $ModTeam.Multiplexer = $RequiredMods.Multiplexer.Replace("-"," ")
                    
            }
    
            $ModTeam.MMScore = $MMScore
            
            $ModRoster = $ModRoster + $ModTeam
    
        }
    
        $ModRoster = $ModRoster | Sort-Object @{Expression="Power"; Descending=$true}
    
        $ModRoster | ConvertTo-Html -Head $header | Out-File (".\GUILD-" + $GuildInfo.Name + "\MEMBER-" + $Member.player_name + ".htm" ) -Encoding unicode -ErrorAction SilentlyContinue
    
        $CRancor = ($RosterInfo.units.data | Where-Object {$_.Relic_tier -ge 7}).Count
                
        $GuildStats[$GuildStats.player_name.indexof($Member.player_name)].CRancor = $CRancor

        $GLCount =($RosterInfo.units.data | Where-Object {$_.is_galactic_legend -eq $true}).Count
                
        $GuildStats[$GuildStats.player_name.indexof($Member.player_name)].GLs = $GLCount

        $Team[$Member.player_name] = $RosterInfo
       
    }

    # Generating team statistics for all teams defined in CONFIG-Teams.csv

    Write-Host "Calculating team statistics" -foregroundcolor green

    If ($Debug) { $StartTime = Get-Date}

    $HelperObj=@{Gear="";Speed=0;Power=0}

    ForEach ($TeamData in $TeamList){

        $TeamName=$TeamData.TeamName

        $MemberDefId=$TeamData.MemberDefId.Split(",")

        $MemberDisplayName=$TeamData.MemberDisplayName.Split(",")

        $TeamObj=[ordered]@{Name="";"T-Lvl"=0;"T-GP"=0;"T-Spd"=0}

        ForEach($TeamMember in $MemberdisplayName) { $TeamObj.add($TeamMember,0) }

        $Farmlist=@()

        ForEach ($Member in $Memberlist) {

            $Farmuser = New-Object PSObject –Property $TeamObj
                
            $RosterInfo = $Team[$Member.player_name]

            $FarmUser.Name = $Member.player_name

            $i=0;
            
            $HelperList = @()
            
            While ($i -lt $MemberDefId.Count) {

                $Helper = New-Object PSObject -Property $HelperObj

                $FarmUserRoster = $RosterInfo.units.data| Where-Object {$_.base_id -like $MemberDefId[$i]}

                if ($FarmUserRoster.Gear_level -ge 1) {$FarmUser.($MemberDisplayName[$i])="G{0:00}" -f $FarmUserRoster.Gear_level} else {$FarmUser.($MemberDisplayName[$i])="--"}

                if (($FarmUserRoster.gear | Where-Object {$_.is_obtained -eq $true}).count -gt 0) {  $FarmUser.($MemberDisplayName[$i]) = ($FarmUser.($MemberDisplayName[$i])) + "+" + ($FarmUserRoster.gear | where {$_.is_obtained -eq $true}).count }

                if ($FarmUserRoster.Relic_tier -gt 2) {$FarmUser.($MemberDisplayName[$i]) = "R{0:00}" -f ($FarmUserRoster.Relic_tier - 2)}

                $Helper.Gear = $FarmUser.($MemberDisplayName[$i])

                $Helper.Speed = $FarmUserRoster.Stats.5

                $Helper.Power= $FarmUserRoster.Power

                if ($FarmUserRoster.ability_data -ne $null) {

                    if ($i -eq 0) { 

                        $Zetas = $FarmUserRoster.ability_data | Where-Object {$_.is_zeta -eq $true}
                        
                        $Omicrons = $FarmUserRoster.ability_data | Where-Object {$_.is_omicron -eq $true}
                        

                    } else {

                        $Zetas = $FarmUserRoster.ability_data | Where-Object {$_.is_zeta -eq $true -and $_.id -notlike "leaderskill*"}    
                        
                        $Omicrons = $FarmUserRoster.ability_data | Where-Object {$_.is_omicron -eq $true -and $_.id -notlike "leaderskill*"}    

                    }
                
                    $AppliedZetas = $Zetas | Where-Object {$_.has_zeta_learned -eq $true}
                    
                    $AppliedOmicrons = $Omicrons | Where-Object {$_.has_omicron_learned -eq $true}

                    If ($Zetas.count -eq $AppliedZetas.count -and ($Zetas -ne $null)) { $FarmUser.($MemberDisplayName[$i]) = "z" + $FarmUser.($MemberDisplayName[$i]) }

                    If ($Omicrons.count -eq $AppliedOmicrons.count -and ($Omicrons -ne $null)) { $FarmUser.($MemberDisplayName[$i]) = "o" + $FarmUser.($MemberDisplayName[$i])}
                    
                }

                If ($FarmUserRoster.has_ultimate -eq $true) { $FarmUser.($MemberDisplayName[$i]) = "u" + $FarmUser.($MemberDisplayName[$i])}
            
                $HelperList += $Helper
                
                $i+=1

            }

            $MemberGear = $HelperList[1..($HelperList.count -1)] | Sort-Object -Property Gear,Speed -Descending

            If ($MemberGear.count -ge 4) {
                
                $TeamSpeed = $HelperList[0].Speed
                
                $TeamPower = $HelperList[0].Power
                
                ForEach ($Pwr in $MemberGear[0..3]) {

                        $TeamSpeed += $Pwr.Speed
                        
                        $TeamPower += $Pwr.Power

                    }
            
                $FarmUser."T-Lvl" = ((($HelperList[0].Gear),($MemberGear[3].Gear)) | Measure-Object -minimum).minimum
            
                $FarmUser."T-Spd" = [int]($TeamSpeed / 5)
                
                $Farmuser."T-GP" = '{0:N0}' -f $TeamPower

            } else {
                
                $FarmUser."T-Lvl" = ($HelperList.Gear | Measure-Object -Minimum).minimum

                $TeamSpeed = 0

                ForEach ($Pwr in $MemberGear[0..3]) {

                    $TeamSpeed += $Pwr.Speed

                }
        
                $FarmUser."T-Spd" = [int]($TeamSpeed / ($HelperList.Count))
            
            }

            if (($TeamData.IgnorePartialTeams -like "false") -or ($FarmUser."T-Lvl" -ne "--")) {$FarmList=$FarmList+$FarmUser}

        }

        $FarmList = $Farmlist | Sort-Object @{Expression="T-Lvl"; Descending=$true},@{Expression="T-GP"; Descending=$true},@{Expression="Name"}

        $FarmList | ConvertTo-Html -Title $TeamName -Head $header| Out-File (".\GUILD-" + $GuildInfo.Name + "\TEAM-" + $TeamName + ".htm") -Encoding Unicode

    }

    if ($Debug) { Write-Host "Runnning Time",((Get-Date) - $StartTime)}

    # Write per-user guild statistics 

    $GuildStats | ConvertTo-Html -Head $header | Out-File (".\GUILD-" + $GuildInfo.Name + "\GUILD-Member.htm") -Encoding unicode

    $GuildSummary |  ConvertTo-Html -Head $header | Out-File (".\GUILD-" + $GuildInfo.Name + "\GUILD-Summary.htm") -Encoding unicode

    # Store all HTML files in a ZIP archive using guild name

    Compress-Archive -Path (".\GUILD-" + $GuildInfo.Name + "\*.htm") -DestinationPath (".\GUILD-" + $Guildinfo.Name + ".zip") -Update

}    