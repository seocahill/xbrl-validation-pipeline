require_relative 'test_helper'

class ValidationTests < MiniTest::Test
  include TestHelpers

  def setup 
    @app = DummyApp::Base.new
  end

  def test_valid_file
    response = @app.arelle_validation("valid-file.html")
    refute_includes message_levels(response), "error", "no invalid messages"
  end

  def test_xml_well_formed
    response = @app.arelle_validation("invalid-xml.html")
    assert_includes message_levels(response), "error", "unescaped ampersand causes malformed error"
    assert_equal 2, error_messages(response).length, "two cases of rogue ampersand"
    expected = ["588", "936"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end

  def test_ixbrl_schema_validation
    response = @app.arelle_validation("non-numericx.html")
    assert_includes message_levels(response), "error", "incorrect nomNumieric tags throw errors"
    assert_equal 2, error_messages(response).length, "two errors"
    expected = ["587", "884"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end

  def test_ixbrl_specification_rules
    response = @app.arelle_validation("unused-tuple.html")
    assert_includes message_levels(response), "error", "Inline XBRL non-nil tuple requires content: ix:fraction, ix:nonFraction, ix:nonNumeric or ix:tuple - unused-tuple.html 5389\n"
    assert_equal 1, error_messages(response).length, "one errors"
    expected = ["5389"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end

  def test_dts_discovery
    response = @app.arelle_validation("invalid-concept-name.html")
    assert_includes message_levels(response), "error", "XBRL Load Error: XBRL element was not found in the loaded taxonomies."
    assert_equal 1, error_messages(response).length, "one errors"
    expected = ["2693"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end

  def test_schema_xbrl_and_taxonomy_validation
    response = @app.arelle_validation("invalid-boolean.html")
    assert_includes message_levels(response), "error", "Error message: cvc-datatype-valid.1.2.1: 'truex' is not a valid value for 'boolean'."
    assert_equal 1, error_messages(response).length, "one errors"
    expected = ["39"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end

  def test_xbrl_specification_rules_period_type
    response = @app.arelle_validation("invalid-context.html")
    assert_includes message_levels(response), "error",  'For an item element with periodType="duration," the period MUST contain a "forever" element or a set of "startDate" and "endDate" elements.'
    assert_equal 2, error_messages(response).length, "two errors"
    expected = ["849", "1771"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end

  def test_xbrl_specification_rules_dimensions
    response = @app.arelle_validation("invalid-dimensions.html")
    assert_includes message_levels(response), "error",  'Fact "x" context "y" dimensionally not valid'
    assert_equal 2, error_messages(response).length, "two errors"
    expected = ["824", "1642"]
    assert_empty expected - error_lines(response), "correct errors are detected"
  end
end