# encoding: utf-8
FactoryGirl.define do
  factory :presentation do
    sequence :generated_presentation_id do |n|
      "presentation_#{n}"
    end

    sequence :title do |n|
      "Title#{n}"
    end

    sequence :description do |n|
      "Description#{n}"
    end

    after(:create) do |presentation|
      presentation.releases << create(:release)
    end

    factory :presentation_with_versions do
      transient do
        releases_count 5
      end

      after(:create) do |presentation, evaluator|
        create_list(:release, evaluator.releases_count, presentation: presentation)
      end
    end
  end

  factory :release do
    date '29.10.2014'
    license 'CC BY 4.0'
    version_number 'v0.0.1'

    after(:create) do |release|
      release.authors << create(:author)
      release.speakers << create(:speaker)
    end

    #factory :release_with_author_and_speakers do
    #  transient do
    #    releases_count 5
    #  end

    #  after(:create) do |release, evaluator|
    #    create_list(:author, evaluator.releases_count, release: release)
    #    create_list(:speaker, evaluator.releases_count, release: release)
    #  end
    #end
  end

  factory :author do
    sequence :name do |n|
      "Author#{n}"
    end
  end

  factory :speaker do
    sequence :name do |n|
      "Speaker#{n}"
    end
  end
end
