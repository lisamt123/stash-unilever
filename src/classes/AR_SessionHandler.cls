/*
	Unilever

	Class Name: AR_SessionHandler

	Created by: Marc Saelzler | 2013-08-27

	Description: To handle the session and keep it alive, after the user logged in successfully.

	Timeline
	Date 					| Name 				| Description
	2013-08-27 15:29 (CET)	| Marc Saelzler 	| Initial development.
*/

public class AR_SessionHandler
{
	
	/*
		Creates session cookie and stores the agency id.
	*/
	public static Cookie getCookie(Id tmp_agencyId)
	{
		return new Cookie('uid', tmp_agencyId, null, null, null);
	}
	
	/*
		Sets session cookie in the current page reference
	*/
	public static void SetCookie(Id tmp_agencyId)
	{
		Cookie tmp_cookie = getCookie(tmp_agencyId);
		
		ApexPages.currentPage().setCookies(new Cookie[] { tmp_cookie });
	}
	
	/*
		Returns the agency id of the current session. If there's no session, it'll return null.
	*/
	public static String GetAgencyId()
	{
		system.debug(logginglevel.info, '### Getting Application Id from COOKIE...');
		String tmp_agencyId = null;
		
		Cookie tmp_cookie = ApexPages.currentPage().getCookies().get('uid');
		
		if(tmp_cookie != null)
		{
			tmp_agencyId = tmp_cookie.getValue();
			system.debug(logginglevel.info, 'COOKIE FOUND! ' + tmp_agencyId);
		} else 
		{
			system.debug(logginglevel.warn, 'NO COOKIE FOUND!');
		}
		
		return tmp_agencyId;
	}
	
	/*
		Does close the session. - Which means that it'll remove the agency id from the cookie entry.
	*/
	public static void CloseSession()
	{
		Cookie tmp_cookie = getCookie(null);
		
		ApexPages.currentPage().setCookies(new Cookie[] { tmp_cookie });
	}
}