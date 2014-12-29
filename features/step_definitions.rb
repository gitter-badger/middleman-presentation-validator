require 'rss'

Given(/^a presentation registry at "(.*?)"$/) do |directory|
  create_dir directory
  step %(I cd to "#{directory}")
end

Given(/^a middleman presentation config file with:$/) do |string|
  step %(a file named ".middleman-presentation.yaml" with:), string
end

Given(/^a presentation fixture "(.*?)"$/) do |name|
  create name.to_sym
end

Given(/^a presentation fixture "(.*?)" with:$/) do |name, attributes|
  create name.to_sym, attributes.hashes.each_with_object({}) { |e, a| a[e['attribute']] = e['value'] }
end

Given(/^a presentation "(.*?)" with config file:$/) do |name, config|
  step %(a presentation registry at "#{ENV['PRESENTATIONS_DIRECTORY']}")
  step %(a middleman presentation config file with:), config
end

When(/^I request a list of presentations as json$/) do
  visit('/presentations.json')
end

When(/^I request to find new presentations$/) do
  visit('/admin/presentations/load')
end

Then(/^I should see:$/) do |string|
  expect(page).to have_content string
end

Then(/^I should see information about the presentation "(.*?)" in json response$/) do |title|
  presentations = Array(JSON.parse(page.body))
  result = presentations.any? { |p| p['presentation']['title'] == title }

  expect(result).to be true
end

When(/^I request a rss feed for available presentations$/) do
  visit('/presentations.rss')
end

Then(/^I should see information about the presentation "(.*?)" in rss feed$/) do |title|
  feed = RSS::Parser.parse(page.body)

  result = feed.items.any? { |i| i.title == title }
  expect(result).to be true
end

When(/^I request information about presentation "(.*?)" as json$/) do |name|
  visit("/presentations/#{name}.json")
end

Then(/^I should see the title "(.*?)" in json response$/) do |title|
  presentation = JSON.parse(page.body)
  expect(presentation['presentation']['title']).to eq title
end
