trigger BotDataTrigger on Bot_Data__e (after insert) 
{
	BotDataHelper.HandleTrigger(Trigger.New);
}