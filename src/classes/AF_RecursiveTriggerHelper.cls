global class AF_RecursiveTriggerHelper {
   
  	private static boolean alreadyModified = false;

    public static boolean isAlreadyModified() {
        return alreadyModified;
    }
   
    public static void setAlreadyModified() {
        alreadyModified = true;
    }
}