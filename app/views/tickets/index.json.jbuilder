json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :title, :content, :comments, :status, :user_id, :assigned_to
  json.url ticket_url(ticket, format: :json)
end
