
require 'drb/drb'

# The URI to connect to
SERVER_URI="druby://127.0.0.1:40000"

# Start a local DRbServer to handle callbacks.
#
# Not necessary for this small example, but will be required
# as soon as we pass a non-marshallable object as an argument
# to a dRuby call.
DRb.start_service

config = DRbObject.new_with_uri(SERVER_URI)

p config.settings
