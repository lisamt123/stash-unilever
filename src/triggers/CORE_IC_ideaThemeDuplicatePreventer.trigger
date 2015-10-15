/* This Trigger Prevents from Duplicate Titles being entered for Idea Campaigns 
** Initial Written By : Mindtree on 01-Jun-2015
*/

trigger CORE_IC_ideaThemeDuplicatePreventer on IdeaTheme
                               (before insert, before update) {

    Map<String, IdeaTheme> ideaThemeMap = new Map<String, IdeaTheme>();
    for (IdeaTheme ideaTheme : System.Trigger.new) {
        
        // Make sure we don't treat a Title that 
        // isn't changing during an update as a duplicate.
    
        if ((IdeaTheme.Title != null) &&
                (System.Trigger.isInsert ||
                (ideaTheme.Title != 
                    System.Trigger.oldMap.get(ideaTheme.Id).Title))) {
        
            // Make sure another new Title isn't also a duplicate 
    
            if (ideaThemeMap.containsKey(ideaTheme.Title)) { ideaTheme.Title.addError('Another new idea campaign has the ' + 'same title.');
            } else {
                ideaThemeMap.put(ideaTheme.Title, IdeaTheme);
            }
       }
    }
    
    // Using a single database query, find all the idea campaigns in 
    
    // the database that have the same title as any
    
    // of the idea campaigns being inserted or updated.
    
    for (IdeaTheme ideaTheme : [SELECT Title FROM IdeaTheme
                      WHERE Title IN :ideaThemeMap.KeySet()]) { IdeaTheme newIdeaTheme = ideaThemeMap.get(IdeaTheme.Title);
        newIdeaTheme.Title.addError('An Idea Campaign with this title ' + 'already exists.');
    }
}