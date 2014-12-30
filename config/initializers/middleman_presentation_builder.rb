$LOAD_PATH.unshift Rails.root.join('lib').to_s unless $LOAD_PATH.split(/:/).include? Rails.root.join('lib').to_s

require 'English'
require 'open3'
require 'tmpdir'
require 'zip'
require 'zip/filesystem'
require 'securerandom'

require 'fedux_org_stdlib/core_ext/string/characterize'

require 'middleman_presentation_builder/errors'
require 'middleman_presentation_builder/utils'
require 'middleman_presentation_builder/build_orchestrator'
require 'middleman_presentation_builder/presentation_config'
require 'middleman_presentation_builder/uploaded_presentation'
require 'middleman_presentation_builder/built_presentation'
require 'middleman_presentation_builder/presentation_builder'
require 'middleman_presentation_builder/command'

module MiddlemanPresentationBuilder
end
