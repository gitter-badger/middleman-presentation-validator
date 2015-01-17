$LOAD_PATH.unshift Rails.root.join('lib').to_s unless $LOAD_PATH.split(/:/).include? Rails.root.join('lib').to_s

require 'English'
require 'open3'
require 'tmpdir'
require 'securerandom'
require 'fedux_org_stdlib/zipper'

require 'fedux_org_stdlib/core_ext/string/characterize'

require 'middleman_presentation_validator/errors'
require 'middleman_presentation_validator/utils'
require 'middleman_presentation_validator/presentation_config'
require 'middleman_presentation_validator/uploader'
require 'middleman_presentation_validator/command'

module MiddlemanPresentationBuilder
end

Rails.configuration.x.build_timeout = 10.minutes
