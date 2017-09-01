ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require_relative 'dummy_app'
require_relative 'test_helper'

class IrishBusinessRulesTest < MiniTest::Test
  include TestHelpers

  def setup 
    @app = DummyApp::Base.new
    @response = @app.business_validation("invalid-ie-bus-rules.html")
  end

  def test_taxonomy_reference_check
    # skip "requires custom test to check if schemaRef value is valid for Irish Tax purposes"
    puts "response is #{@response}"
    assert_equal "valid", @response["schema_ref_test"], "schemaRef must be one of set allow by Irish Tax Authority"
  end

  def test_company_name
    skip # Company Name (uk- bus:EntityCurrentLegalOrRegisteredNa me) is missing
  end

  def test_start_date
    skip # Period Start Date (uk- bus:StartDateForPeriodCoveredByRep ort) is missing
     # Report period start date cannot be later than the selected Revenue accounting period start date (<value>).
  end

  def test_end_date_present
    skip # Period End Date (uk- bus:EndDateForPeriodCoveredByRepo rt) is missing
    # Period End Date (uk- bus:EndDateForPeriodCoveredByRepo rt) is <end_date> but must be 2011-12- 31 or later
    # Report period end date cannot be before the selected Revenue accounting period end date (<value>).
    # Report period end date must fall within the selected Revenue accounting period.
  end

  def test_profit_loss
    skip # Profit Loss Before Tax (uk- gaap:ProfitLossOnOrdinaryActivitiesBef oreTax or ifrs:ProfitLossBeforeTax) is missing
  end

  def test_duplicate_facts
    skip # Inconsistent duplicate facts, <fact name>, for context <context>.
  end

  def context_id_scheme
    skip # Context entity identifier scheme (<value>) is not supported n/a
  end

  def context_schemes_consistent
    skip # Contexts do not all use the same identifier and the same scheme.
  end

  def cro_number
    skip # Companies Registration Office Number (ie- common:CompaniesRegistrationOffice Number) is missing If there is at least one context entity where the identifier scheme is 'http://www.cro.ie/'
  end

  def context_entity_id
    skip # Context entity identifier (<value>) is not consistent with Revenue records (<value)>)
  end

end