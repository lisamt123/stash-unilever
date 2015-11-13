/**********************************************************************
Name: OV_ContentLibrary
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: OV_ContentLibrary
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_ContentLibrary {
	public OV_ContentLibrary(Id id, String name) {
		this.pvtId = id;
		this.pvtName = name;	
	}


	public Id id { get{ return pvtId; } }

	public String name { get{ return pvtName; } }

	private Id pvtId;
	private String pvtName;
}