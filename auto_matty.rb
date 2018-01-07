require 'sinatra'
require 'json'
require 'google_drive'
require 'date'

get '/' do
  "Hello World, I'm Otto Matty"
end

post '/fulfilled' do
	data = JSON.parse request.body.read

	id = data['id']
	date = DateTime.iso8601(data['created_at'])
	total_price = "$#{data["total_price"]}"
	first_name = data['customer']['first_name']
	last_name = data['customer']['last_name']
	email = data['customer']['email']

	file = open("nicknames.txt")
	nicknames = file.read.split(/\n/)
	file.close

	prng = Random.new
	nickname = nicknames[prng.rand(nicknames.length) - 1]

	envConfig = ENV['DRIVE']

	io = envConfig != nil ? StringIO.new(envConfig) : "AutoMatty-fe567505bfbf.json"

	session = GoogleDrive::Session.from_service_account_key(io)

	sheet = session.spreadsheet_by_url('https://docs.google.com/spreadsheets/d/1q1haSv60cbKH_vPuZ9Iz82glrsF3jGZKVFwIc2kHLPw/edit').worksheets[0]

	line_items = data['line_items']
	line_items.each do |item|
		row = sheet.num_rows + 1
		sheet.insert_rows(row, 1)
		sheet[row, 1] = item["title"]
		sheet[row, 2] = total_price
		sheet[row, 3] = "#{first_name} \"#{nickname}\" #{last_name}"
		sheet[row, 4] = email
		sheet[row, 5] = date.strftime("%b %e, %l:%M %p")
	end
	sheet.save

	"#{first_name} added"
end
