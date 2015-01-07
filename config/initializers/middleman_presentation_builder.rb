$LOAD_PATH.unshift Rails.root.join('lib').to_s unless $LOAD_PATH.split(/:/).include? Rails.root.join('lib').to_s

require 'English'
require 'open3'
require 'tmpdir'
require 'securerandom'
require 'fedux_org_stdlib/zipper'

require 'fedux_org_stdlib/core_ext/string/characterize'

require 'middleman_presentation_builder/errors'
require 'middleman_presentation_builder/utils'
require 'middleman_presentation_builder/presentation_config'
require 'middleman_presentation_builder/uploader'
require 'middleman_presentation_builder/command'

module MiddlemanPresentationBuilder
end

Rails.configuration.x.build_timeout = 10.minutes
