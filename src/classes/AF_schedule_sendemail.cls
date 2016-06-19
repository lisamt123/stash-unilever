global class AF_schedule_sendemail
  {
    public static void start()
      {
        //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        System.schedule('Send Email to CSCO super user', '0 25 15 * * ?', new AF_sendemail());
      }

  }