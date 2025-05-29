json.extract! message, :id, :text, :created_at
json.user do
  json.id       message.user.id
  json.username message.user.username
end
