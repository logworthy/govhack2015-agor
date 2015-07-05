# AGORpedia


#Intro

The Australian Government Organisations Register (the Register) provides information on the function, composition, origins and other details of approximately 1,145 Australian Government entities, bodies and relationships. The Register replaces the List of Government Bodies and Governance Relationships, which was last published in 2009.

AGORpedia aims to provide an easy to use platform to view the Australian Government Organisation Register and track changes to it over time.

We have taken the AGOR releases available on data.gov.au and published them on MediaWiki.  The version history for an organisation is captured, with each article revision correctly timestamped to the relevant AGOR release.

Users can view the most recently released information for an organisation and compare this data with any previous data.gov.au AGOR release to detect changes.

#The Hack

An R script was used to download the AGOR CSV files from data.gov.au, and transform them into text strings that could be digested by MediaWiki.  python-mwapi was used to programmatically create the MediaWiki pages from the transformed text strings.  A MediaWiki template was used to ensure a consistent look and feel to the pages, and allow the style of all the displayed pages to be changed at once.  Finally, an SQL script was used to update the timestamps of the MediaWiki revisions.

Our tech stack:

    R
    Python
    Media Wiki
    python-mwapi
    PostgreSQL

#The Future

Currently only authorised users have permission to edit the MediaWiki.  On request, trusted government users could be given permission to update AGORpedia, providing an easy way to make updates as changes occur.  We would also add the ability to export the data back to CSV, so that datasets continue to be made available on data.gov.au, and an API to allow users to query AGOR dynamically.

#See also
* [AGORpedia on the GovHack2015 Hackerspace](https://hackerspace.govhack.org/content/agorpedia)
* [AGORpedia prototype!](http://agor.ourlocalstories.co)
* [AGOR website](http://www.finance.gov.au/resource-management/governance/agor/)
* [AGOR dataset](https://data.gov.au/dataset/australian-government-organisations-register)
