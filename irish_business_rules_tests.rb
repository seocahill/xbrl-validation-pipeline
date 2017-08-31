ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require_relative 'dummy_app'
require_relative 'test_helper'

class IrishBusinessRulesTest < MiniTest::Test
  include TestHelpers

  def setup 
    @app = DummyApp::Base.new
  end

  def test_taxonomy_reference_check
    skip "requires custom test to check if schemaRef value is valid for Irish Tax purposes"
  end

  def test_revenue_business_rules
    skip "tested on client right now but could do it here"
    # Company Name (uk- bus:EntityCurrentLegalOrRegisteredNa me) is missing
    # Period Start Date (uk- bus:StartDateForPeriodCoveredByRep ort) is missing
    # Period End Date (uk- bus:EndDateForPeriodCoveredByRepo rt) is missing
    # Period End Date (uk- bus:EndDateForPeriodCoveredByRepo rt) is <end_date> but must be 2011-12- 31 or later
    # Profit Loss Before Tax (uk- gaap:ProfitLossOnOrdinaryActivitiesBef oreTax or ifrs:ProfitLossBeforeTax) is missing
    # Inconsistent duplicate facts, <fact name>, for context <context>.
    # Context entity identifier scheme (<value>) is not supported n/a
    # Contexts do not all use the same identifier and the same scheme.
    # Companies Registration Office Number (ie- common:CompaniesRegistrationOffice Number) is missing If there is at least one context entity where the identifier scheme is 'http://www.cro.ie/'
    # Context entity identifier (<value>) is not consistent with Revenue records (<value)>)
    # Report period start date cannot be later than the selected Revenue accounting period start date (<value>).
    # Report period end date cannot be before the selected Revenue accounting period end date (<value>).
    # Report period end date must fall within the selected Revenue accounting period.
  end
end