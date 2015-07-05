#agor.py
import private
import mwapi
import csv

con = mwapi.MWApi(host='http://agor.ourlocalstories.co', api_path='/api.php')

con.login(private.USER, private.PASS)

edit_token = con.get_tokens()

f = open('/home/anon/govhack2015-agor/mw.csv', 'r')

dr = csv.DictReader(f)

for row in dr:

	con.post(
		action='edit'
		, title=row['Entity']
		, text=row['V1']
		, token=edit_token['edittoken']
	)