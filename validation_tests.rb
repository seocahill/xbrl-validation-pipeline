ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require_relative 'dummy_app'
require_relative 'test_helper'

class ValidationTests < MiniTest::Test
  include TestHelpers

  def setup 
    @app = DummyApp::Base.new
  end

  def test_valid_file
    response = @app.request_validation("valid-file.html")
    refute_includes message_levels(response), "error", "no invalid messages"
  end

  def test_xml_well_formed
    response = @app.request_validation("invalid-xml.html")
    assert_includes message_levels(response), "error", "unescaped ampersand causes malformed error"
    assert_equal 2, error_messages(response).length, "two cases of rogue ampersand"
    expected = ["588", "936"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end

  def test_ixbrl_schema_validation
    response = @app.request_validation("non-numericx.html")
    assert_includes message_levels(response), "error", "incorrect nomNumieric tags throw errors"
    assert_equal 2, error_messages(response).length, "two errors"
    expected = ["587", "884"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end

  def test_taxonomy_reference_check
    skip "requires custom test to check if schemaRef value is valid for Irish Tax purposes"
  end

  def test_ixbrl_specification_rules
    response = @app.request_validation("unused-tuple.html")
    assert_includes message_levels(response), "error", "Inline XBRL non-nil tuple requires content: ix:fraction, ix:nonFraction, ix:nonNumeric or ix:tuple - unused-tuple.html 5389\n"
    assert_equal 1, error_messages(response).length, "one errors"
    expected = ["5389"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end

  def test_dts_discovery
    response = @app.request_validation("invalid-concept-name.html")
    assert_includes message_levels(response), "error", "XBRL Load Error: XBRL element was not found in the loaded taxonomies."
    assert_equal 1, error_messages(response).length, "one errors"
    expected = ["2693"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end

  def test_schema_xbrl_and_taxonomy_validation
    response = @app.request_validation("invalid-boolean.html")
    assert_includes message_levels(response), "error", "Error message: cvc-datatype-valid.1.2.1: 'truex' is not a valid value for 'boolean'."
    assert_equal 1, error_messages(response).length, "one errors"
    expected = ["39"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end

  def test_xbrl_specification_rules_period_type
    skip 'Error in "http://www.xbrl.org/uk/gaap/core/2009-09- 01#ControllingPartyUltimateControllingParty (true)." For an item element with periodType="duration," the period MUST contain a "forever" element or a set of "startDate" and "endDate" elements.'

  end

  def test_xbrl_specification_rules_dimensions
    skip
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