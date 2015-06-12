public with sharing class AR_DatePicker {
	
	public List<Integer> calendarYears {
		get {
			if (calendarYears == null)
			{
				calendarYears = new List<Integer>();
				for (Integer i = -10; i <= 3; i++)
				{
					calendarYears.add(system.today().addYears(i).year());
				}
			}
			return calendarYears;
		}
		set;
	}

}