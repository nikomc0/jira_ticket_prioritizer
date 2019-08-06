require 'dotenv'
require './src/controllers/application_controller'
require './src/controllers/issue_controller'

use IssueController
run ApplicationController
