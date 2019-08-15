require 'dotenv'
require './config/environment'
# require './src/controllers/application_controller'
# require './src/controllers/issue_controller'
# require './src/services/issue_service'

# use IssueService
use IssueController
run ApplicationController
