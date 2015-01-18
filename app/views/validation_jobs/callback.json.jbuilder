json.result do
  if valid_presentation?
    json.valid 'true'
  else
    json.valid 'false'
  end

  json.checksum checksum
end
