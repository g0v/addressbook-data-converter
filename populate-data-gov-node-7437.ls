require! <[fs cheerio]>

correct_name = -> 
	badnames = 
		\高雄市那瑪夏區
		\高雄市桃源區
		\高雄市甲仙區
		\高雄市旗山區
		\花蓮縣秀林鄉
		\花蓮縣瑞穗鄉
		\花蓮縣光復鄉
		\花蓮縣玉里鎮
		\桃園縣楊梅市
		\金門縣烏坵鄉
		\金門縣烈嶼鄉
		\金門縣金寧鄉
		\金門縣金沙鎮
	if it in badnames then "#{it}戶政事務所" else it

orgmap = {}
orgs = require \./output/allorg_tmp.json
for org in orgs
	orgmap[org.name] = org

path = 'rawdata/organization/data-gov-node-7437-source.xml'

$ = cheerio.load (fs.readFileSync path, 'utf-8'), {xmlMode:true}
orgs = $ 'orgs' .find 'org' 
count = orgs.length

get = (o, q) -> o.find q .text!

orgs.each -> 
	obj = do
		name: correct_name (get @, 'orgname')
		address: get @, 'address'
		other_names: []
		contact_details: [
			{label: '機關電話', 'type': 'voice', 'value': get @, 'tel'}
			{label: '機關電郵', 'type': 'email', 'value': get @, 'email'}
			{label: '機關傳真', 'type': 'fax', 'value': get @, 'fax'}
		]
		note: get @, 'description'
		links: [ 
			* url: get @, 'website'
		]
	unless orgmap[obj.name]	
		orgmap[obj.name] = obj
	else
		orgmap[obj.name] <<< obj

console.log JSON.stringify [e for _, e of orgmap], null, 4