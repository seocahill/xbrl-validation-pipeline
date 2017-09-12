require_relative 'test_helper'

class IrishBusinessRulesInvalidDocumentTest < MiniTest::Test
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
    expected = "invalid: Period End Date is 2010-10-31 but must be 2011-12-31 or later"
    assert_equal expected, @response["period_dates"], "Period must be later than 2011"
  end

  def test_duplicate_facts
    assert_equal "invalid", @response["duplicate_facts"]["message"], "Cant have duplicate facts"

    duplicate_facts = @response["duplicate_facts"]["duplicate_facts"]
    # whitespace error in director name
    actual = duplicate_facts.find { |f| f["name"] == "uk-bus:NameEntityOfficer" }
    refute_nil actual, "director name duplicate fact"
    assert_equal [751, 731], [actual["line_number"], actual["conflicting_fact"]["line_number"]], "director name conflict line numbers"

    # negative and positive currency value for the same fact
    actual = duplicate_facts.select {|f| f["name"] == "uk-gaap:ProfitLossAccountReserve" }
    assert_equal actual.length, 2, "negative and positive currency value duplicate facts"
    assert_equal [2055, 2019], [actual[0]["line_number"], actual[0]["conflicting_fact"]["line_number"]], "currency value conflict line numbers"
    assert_equal [2555, 2019], [actual[1]["line_number"], actual[1]["conflicting_fact"]["line_number"]], "currency value conflict line numbers"

    # incorrect context for comparative with opening and closing balance e.g. shareholders funds
    actual = duplicate_facts.select {|f| f["name"] == "ie-common:LoansQuasiLoansDirectors"}
    assert_equal [5756, 5728], [actual[0]["line_number"], actual[0]["conflicting_fact"]["line_number"]], "currency value conflict line numbers"

    # nonNumeric tag added to adjacent column of text row in error
    actual = duplicate_facts.find {|f| f["name"] == "uk-aurep:StatementOnScopeAuditReport"}
    refute_nil actual, "wrongly tagged duplicate fact"
    assert_equal [1743, 1733], [actual["line_number"], actual["conflicting_fact"]["line_number"]], "wrongly tagged text line numbers"
  end

  def test_context_scheme_consistency
    expected = "invalid: Contexts do not all use the same identifier and the same scheme"
    assert_equal expected, @response["context_scheme_consistent"], "Use only one scheme on all contexts"
  end

  def test_context_scheme_allowed
    expected = "invalid: http://tax.gov.uk/ is not a valid scheme"
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

  def test_ixbrl_validation
    message_1 = "-1:-1: ERROR: cvc-length-valid: Value '\n                          \n                        ' with length = '52' is not facet-valid with respect to length '0' for type '#AnonType_fixedItemType'."
    message_2 = "-1:-1: ERROR: cvc-complex-type.2.2: Element 'uk-direp:DirectorSigningReport' must have no element [children], and the value must be valid."
    actual = @response["validate_schema"]
    assert_equal actual["message"], "invalid"
    assert_equal actual["errors"].length, 2
    assert_includes actual["errors"], message_1
    assert_includes actual["errors"], message_2
  end

end

class IrishBusinessRulesValidDocumentTest < MiniTest::Test

  def test_valid_document_passes_validation
    response = DummyApp::Base.new.business_validation("valid-file.html")
    expected = response.values.map { |v| v.is_a?(Hash) ? v["message"] : v }.uniq
    
    assert_equal ["valid"], expected, "All valiations should pass"
  end
end