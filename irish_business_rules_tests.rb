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
    expected = "invalid: http://www.xbrl-ie.net/public/ci/2012-12-01/gaap/core/2012-12-01/us-gaap-full-2012-12-01.xsd is not a valid schema"
    assert_equal expected, @response["schema_ref"], "schemaRef must be one of set allow by Irish Tax Authority"
  end

  def test_mandatory_tags_present
    expected = "invalid: the following tags are missing or empty uk-bus:EntityCurrentLegalOrRegisteredName"
    assert_equal expected, @response["mandatory_tags_present"], "Mandatory tags must be present"
  end

  def test_period_too_long_ago
    expected = "invalid: Period End Date is 2010-12-31 but must be 2011-12-31 or later"
    assert_equal expected, @response["period_dates"], "Period must be later than 2011"
  end

  def test_duplicate_facts
    expected_facts = []
    expected = { message: "invalid", duplicate_facts: expected_facts }
    assert_equal expected, @response["duplicate_facts"], "Cant have duplicate facts"
  end

  def text_context_scheme_consistency
    expected = "invalid: Contexts do not all use the same identifier and the same scheme"
    assert_equal expected, @response["context_scheme_consistent"], "Use only one scheme on all contexts"
  end

  def test_context_scheme_allowed
    expected = "invalid: http://tax.gov.uk is not a valid schema"
    assert_equal expected, @response["context_scheme_allowed"], "Invalid context scheme"
  end

  def test_cro_number_present
    expected = "invalid: Must tag CRO number if using http://www.cro.ie/ identifier scheme"
    assert_equal expected, @response["cro_number_required"], "CRO number is required"
  end

  def test_context_identifiers
    expected = "invalid: One or more context_identifer numbers malformed or missing"
    assert_equal expected, @response["context_identifiers"], "Missing or malformed context identifier"
  end

end