update mediawiki.revision 
set rev_timestamp = timestamp '2014-12-11 00:00:00-00'
where rev_id in (
select old_id from mediawiki.pagecontent where old_text like '%revision_date=2014-12-11%'
);

update mediawiki.revision 
set rev_timestamp = timestamp '2015-02-16 00:00:00-00'
where rev_id in (
select old_id from mediawiki.pagecontent where old_text like '%revision_date=2015-02-16%'
);

update mediawiki.revision 
set rev_timestamp = timestamp '2015-04-24 00:00:00-00'
where rev_id in (
select old_id from mediawiki.pagecontent where old_text like '%revision_date=2015-04-24%'
);

update mediawiki.revision 
set rev_timestamp = timestamp '2015-05-21 00:00:00-00'
where rev_id in (
select old_id from mediawiki.pagecontent where old_text like '%revision_date=2015-05-21%'
);