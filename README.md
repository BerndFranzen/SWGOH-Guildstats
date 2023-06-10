							SWGOH Guild StaSIXtics - 23-23
							==============================

					Everything You Always Wanted to Know About Your Guild's Characters and Ships* 

		(*But Were Afraid to Ask any of Your Guild Members to dig through all that Data and Compile that Information for You)


PURPOSE
========
This script is intended to give guild officers an overview over the teams that the guild has available for Raids, Territory Wars,
Territory Battles and whatever is still to come to the SWGOH holotables.

It was made highly customizable so that you can build your own teams once and run an analysis whenever required instead of digging
through numerous bots and websites.

The output will be a set of HTML files (which are created in a sub directory named after the guild) that you can view and share with 
your guild mates and these files are also put into a ZIP file "GuildStat-<GuildName> as it is capable of running the analysis for 
multiple guilds (like partner guilds who share one analyst or even Territory Wars once you found out an allycode of a member of the 
opponent's guild (e.g. through swgoh.gg).


PREREQUISITES
=============
- Microsoft Powershell 6.2.0 or higher (Windows, Mac, Linux)
- PSParseHTML Powershell Module (by EvotecIT), installed automatically if not present 
- Your allycode registered and synched on swgoh.gg
- Your allycode(s) updated in the CONFIG-Accounts.csv file

CONFIG-Accounts.csv
-------------------
The file has 1 parameters per line:
- Your (or someone else's allycode)

OUTPUT
======
The script gives you a set of HTML files with different content

GAME-NameMapping
----------------
This file contains all character and ship names currently available in the game and the internal name used to identify this object
language-independant.

GUILD-<guild name>
------------------
For each guild an individual subdirectory is created that contains the following set of files (see below for further descriptions).
- GUILD-Member
- TEAM-*
- MEMBER-*

GUILD-Member
------------
A list of all member of the guild with the following information:
- Name		Name of the player
- GP		Player's overall Galactic Power (GP)
- gpChar	Player's character GP
- gpShip	Player's ship GP
- GLs	Number of Galactic Legends this player owns. Combine it with AFG and you know how many GLs the opponents guild has
  available at maximum as those, who haven't been online for at least one day, did not sign up for TW and therefore you won't
  face their GLs (requires the script to run as close after matchmaking as possible).
- KL0 - KL6	Number of characters that a player has for the individual difficulty level on the Krayt Dragon Raid 
	
Member-*
--------
A list of all characters in a the member's roster with level 50 or higher with the following information:
- Name - Name of the character
- Power - The character's Galactic Power
- Gear - The character's gear level
- Speed - The character's speed
- MMScore - The calculated Mod Meta Score (see below for further explanation)
- Mod summary or recommendation

TEAM-*
------
This is the analysis for the pre-defined (and/or customized) teams with the following information:
- Name - Name of the player
- T-Lvl - Overall gear-level of the team. If the team has 5 or less members, the level is defined by the character with the
  lowest gear. This can be either. If the team has more than 5 members, the first character is regarded as lead-character,
  except if specified differently (see below) and the overall level will be the lower value if the lead's gear and the 4
  strongest other characters in the list.
- T-GP - Overall Galactic Power of the team identified as for T-Lvl
- T-Spd - The average speed of the team identified as for T-Lvl
- Characters - The gear-level of each character, either "G"ear or "Relic". 
  If the character has all Zetas applied, this is shown by a prepending "z". For non-lead characters, lead-zetas are ignored. 
  If the character has all Omicrons applied, this is shown by a prepending "o". 
  If the character is a GL and has his Ultimate applied, this is shown by a prepending "u".

KNOWN ISSUES
============
- None

MMScore
=======
NOTE: There is no absolute truth in modding, this tool just compares the mods to the current meta. You my find it usefull to mod a character differently for another game mode (JKL for example) or as it takes a different role in the squad that you play it in. This is only a SUGGESTION!

What is the MMScore? the MMScore is intended to help you to learn from the best. It pulls all data from https://swgoh.gg/stats/mod-meta-report/guilds_100_gp/ and compares the character's mods against this meta list and calculates the score as follows:
- Matching mod set 20 points for 4-mod sets (e.g. Speed) and 10 points for 2-mod sets (e.g. Health) (max. 30)
- Matching primary attribute 5 points per mod (max. 30)
- Speed on primary or secondary attribute 5 points per mod (max. 30)
- All mod sets and primaries matching and speed on all mods 10 points

This results in a total possible MMScore of 100. If the score is not reached, the recommended mod sets and primaries are listed, otherwise the assigned mods are listed with their speed, mod set and primary attribute.

If a char has reached an MMScore of 100, the rarity of each mod will be evaluated as well as when sclicing a mod from 5A to 6E, both, primary and all secondary get a status boost which increases the mod's value.
- For each mod with a rarity of 6* extra 5 points are added (max. 30)
- If all mods have been sliced to 6A extra 20 points are added

This results in a total possible MMScore of 150. All 6* mods equipped are printed in BOLD to highlight them and show you were you still can improve.

So there are basically 3 levels to achieve:
- 100 - all mods follow the current meta for this char and every mod has Speed on either primary or secondary attribute
- 130 - all mods have additionally been sliced to 6*
- 150 - all mods have additionally been sliced to 6A

NOTE: Mods below 5* and Level 15 are filtered and regarded as not present.

	
	
CONTACT
=======
For bugs, feature requests, feedback and whtever, contacts us at swgoh-guildstats@outlook.com or join the project's 
GitHub page at https://github.com/BerndFranzen/SWGOH-Guildstats for discussion and latest releases.


Q&A
===
Q: Some players of my guild show with empty teams although they do have them. Why is this?
A: The script pulls all data from api.swgoh.gg and this system only has the data of those players that have an account on swgoh.gg

Q: How can I create custom teams?
A: Just edit the CONIFG-Teams.csv file and add whatever you want to have an analysis for. You need to add the DefId as specified in 
   the game itself as well as the display name you want to see in the list.

Q: How do I know what is the DefId for a certain char?
A: On each run, the script will create a file called GAME-NameMapping.htm that shows the display name and the corresponding
   DefId of each character and ship

Q: In the CONFIG-Accounts.csv there are 2 allycodes, do I have to provide 2 allycodes as well?
A: No, that's only required if you're also doing statistics for a partner guild or want to find out more about your guild's 
   Territory War opponents.

Q: Who do I find out an allycode of one of the oponent guild's member?
A: Try a web search with "swgoh.gg" and the guild name in it, hopefully, they will have an swgoh.gg profile and then you just pick
   one member and grab the allycode. Otherwise you have to find the guild through the ingame guild search, open it up, browse through
   the member list and do a web search for each individual member name together with "swgoh.gg", hopefully at least one member has
   an swgoh.gg profile.
	
Q: Why does an MMScore of a character drop although I modded according to the recommendations?
A: Because it's Meta and this is constantly changing so you may need to re-mod from time to time.

Q: When I try to run the script on Windows I get an error preventing the execution because it's not signed.
A: You can exempt the script with the command "Unblock-File <script-name>".

Q: I have upgrades my chars but why do the pages still show the old values?
A: swgoh.gg only updates the stats every 24 hours. You can force a manual update once every 24 hours or become a "Patron" at swgoh.gg 
   for a small fee (€3.50/month), which reduces the automatic update intervall to 1 hour and grants you 5 manual refreshes per day.


PLANNED FEATURES
================
- Ships - Define list of ships to analyze
- TB Platoons - Analysis of all platoons that can be filled during TB
- GL-Readiness - Analysis of character's relic levels compared to the requirements for each GL
- TB-Readiness - Analysis of hero charters used for Territory Battles
