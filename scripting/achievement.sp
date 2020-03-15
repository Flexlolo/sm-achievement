/*
COMPILE OPTIONS
*/

#pragma semicolon 1
#pragma newdecls required

/*
INCLUDES
*/

#include <sourcemod>
#include <lololib>
#include <printqueue>

/*
PLUGIN INFO
*/

public Plugin myinfo = 
{
	name			= "Achievement",
	author			= "Flexlolo",
	description		= "Fake achievement messages",
	version			= "1.0.0",
	url				= "github.com/Flexlolo/"
}

/*
GLOBAL VARIABLES
*/

#define CONSOLE_ACHIEVEMENTS 			"[Achievements]"
#define CHAT_ACHIEVEMENTS 				"\x072f4f4f[\x07ff6347Achievements\x072f4f4f]"
#define CHAT_VALUE 						"\x07ff6347"
#define CHAT_SUCCESS 					"\x07FFC0CB"
#define CHAT_ERROR 						"\x07DC143C"

/*
NATIVES AND FORWARDS
*/

public void OnPluginStart()
{
	RegAdminCmd("sm_achievement", Command_Achievement, ADMFLAG_GENERIC, "Achievement message");
}

/*
COMMANDS
*/

public Action Command_Achievement(int client, int args)
{
	if (args)
	{
		char sArgs[256];
		GetCmdArgString(sArgs, sizeof(sArgs));

		if (StrContains(sArgs, " ", false) != -1)
		{
			char sArg[2][128];
			ExplodeString(sArgs, " ", sArg, sizeof(sArg), sizeof(sArg[]), true);

			ArrayList hTargets = lolo_Target_Process(client, sArg[0], true);

			if (hTargets != null)
			{
				if (hTargets.Length == 0)
				{
					if (client)
					{
						QPrintToChat(client, "%s %sInvalid target", CHAT_ACHIEVEMENTS, CHAT_ERROR);
					}
					else
					{
						PrintToServer("%s Invalid target", CONSOLE_ACHIEVEMENTS);
					}
				}
				else
				{
					for (int i; i < hTargets.Length; i++)
					{
						int target = hTargets.Get(i);

						Achievement_Event(target, sArg[1]);
					}
				}
			}

			lolo_CloseHandle(hTargets);
		}
	}

	return Plugin_Handled;
}


stock void Achievement_Event(int client, const char[] sMessage)
{
	char sName[32];
	GetClientName(client, sName, sizeof(sName));

	int team = GetClientTeam(client);

	char sTeam[10];
	lolo_GetTeamColorString(team, sTeam, sizeof(sTeam));

	QPrintToChatAll("%s%s \x01has earned the achievement \x05%s", sTeam, sName, sMessage); 
}