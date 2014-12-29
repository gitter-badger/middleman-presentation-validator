When(/^I create a zip archive named "(.*?)" from directory "(.*?)"$/) do |zipfile_name, directory|
  Zip::File.open(zipfile_name, Zip::File::CREATE) do |z|
    Dir.glob(File.join(directory, '**', '*')).each do |filename|
      z.add(
        Pathname.new(filename).relative_path_from(
          Pathname.new(File.dirname(directory))
        ).to_s, filename
      )
    end
  end
end

When(/^I succefully send a file named "(.*?)"$/) do |file|
  visit('/presentation/build')
  attach_file('source_presentation', file)
  click_button('upload')

  step %(the status code is "200")
end

Then(/the status code is "(.*?)"/) do |code|
  expect(page.status_code).to eq code.to_i
end

When(/^I send a valid presentation as zip file$/) do
  zipfile                = Tempfile.new(%w(presentation .src.zip))
  presentation_directory = absolute_path('.')

  step %(I create a zip archive named "#{zipfile.path}" from directory "#{presentation_directory}")
  step %(I succefully send a file named "#{zipfile.path}")
end

Then(/^I get back a build version of my presentation$/) do
  zipfile = Tempfile.new(%w(presentation build.zip))
  zipfile.write page.body
  binding.pry
  zipfile.close

  Zip::File.open(zipfile.path) do |z|
    entry = z.glob('*server*').first

    expect(entry).not_to be_nil
  end
end
