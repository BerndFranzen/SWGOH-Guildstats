								SWGOH Guild StaSIXtics

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

To speed up multiple consecutive runs and save bandwidth, results received from the server are cached for 24 hours.


PREREQUISITES
=============
- Microsoft Powershell 6.0.0 or higher (Windows, Mac, Linux)
- Your allycode registered and synched on swgoh.gg
- Your allycode(s) updated in the CONFIG-Accounts.csv file


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
- FLEET-*

GUILD-Member
------------
A list of all member of the guild with the following information:
- Name - Name of the player
- GP - Player's overall Galactic Power (GP)
- gpChar - Player's character GP
- gpShip - Player's ship GP
- CRancor - Amount of player's Relic 5 (or higher) chars that can participate in Challenge Rancor raids
- GLs - Number of Galactic Legends this player owns. Combine it with AFG and you know how many GLs the opponents guild has
  available at maximum as those, who haven't been online for at least one day, did not sign up for TW and therefore you won't
  face their GLs (requires the script to run as close after matchmaking as possible).
	
Member-*
--------
A list of all characters in a the member's roster with level 50 or higher with the following information:
- Name - Name of the character
- Power - The character's Galactic Power
- Gear - The character's gear level
- Speed - The character's speed
- MMScore - The calculated Mod Meta Score
- Mod summary or recommendation
	
What is the MMScore? the MMScore is intended to help you to learn from the best. It pulls all data from https://swgoh.gg/stats/mod-meta-report/guilds_100_gp/ and compares the character's mods against this meta list and calculates the score as follows:
- Matching mod set 20 points for 4-mod sets (e.g. Speed) and 10 points for 2-mod sets (e.g. Health) (max. 30)
- Matching primary attribute 5 points per mod (max. 30)
- Speed on primary or secondary attribute 5 points per mod (max. 30)
- All mod sets and primaries matching and speed on all mods 10 points

This results in a total possible MMScore of 100. If the score is not reached, the recommended mod sets and primaries are listed, otherwise the assigned mods are listed with their speed, mod set and primary attribute.

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

FLEET-*
-------
Not yet implemented.


KNOWN ISSUES
============
- None


CONTACT
=======
For bugs, feature requests, feedback and whtever, contacts us at swgoh-guildstats@outlook.com or join the project's 
GitHub page at https://github.com/BerndFranzen/SWGOH-Guildstats for discussion and latest releases.


SUPPORT THE PROJECT
===================
You find this tool helpful and want support further development? You can donate through PayPal using the contact mail-address.


Q&A
===
Q: Some players of my guild show with empty teams although they do have them. Why is this?
A: The script pulls all data from api.swgoh.gg and this system only has the data of those players that have an account on swgoh.gg

Q: How can I create custom teams?
A: Just edit the CONIFG-Teams.csv file and add whatever you want to have an analysis for. You need to add the DefId as specified in 
   the game itself as well as the display name you want to see in the list.

Q: What das IgnoreLead mean in the CONFIG-Teams.csv?
A: A weaker guild may not have that much Bossks available for a standard Bounty Hunter team but in DS-Hoth any Bounty counts,
   so for this team the script will just pick the 5 strongest bounties overall and doesn't set a team level to 0 just because
   the guild member doesn't have Bossk yet.

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


PLANNED FEATURES
================
- Ships - Define list of ships to analyze
- TB Platoons - Analysis of all platoons that can be filled during TB
- GL-Readiness - Analysis of character's relic levels compared to the requirements for each GL
- TB-Readiness - Analysis of hero charters used for Territory Battles
