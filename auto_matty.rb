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
	first_name = data['customer']['first_name']
	last_name = data['customer']['last_name']

	session = GoogleDrive::Session.from_service_account_key("AutoMatty-fe567505bfbf.json")
	sheet = session.spreadsheet_by_key("1I-jychFZpkSVI8oZoMv_aBepDc-ZOXEovtinFeAa0Dg").worksheets[0]

	line_items = data['line_items']
	line_items.each do |item|
		row = sheet.num_rows + 1
		sheet[row, 1] = date.strftime("%b %e, %l:%M %p")
		sheet[row, 2] = id
		sheet[row, 3] = item["title"]
		sheet[row, 4] = first_name
		sheet[row, 5] = last_name
		sheet[row, 6] = last_name == 'Barnes' ? 2 : 1
	end

	sheet.save

	"yay"
end
