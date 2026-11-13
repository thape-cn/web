# frozen_string_literal: true

require "test_helper"

class JsonCompatibilityTest < ActiveSupport::TestCase
  test "Rails JSON serialization retains HTML escaping and timestamp precision" do
    payload = {message: "<>&\u2028\u2029", created_at: Time.utc(2026, 11, 13, 1, 2, 3, 456_000)}

    json = payload.to_json

    assert_includes json, '\u003c\u003e\u0026\u2028\u2029'
    assert_equal({
      "message" => payload[:message],
      "created_at" => "2026-11-13T01:02:03.456Z"
    }, ActiveSupport::JSON.decode(json))
  end

  test "Rails JSON supports top level scalar values" do
    ["text", 42, true, false].each do |value|
      json = ActiveSupport::JSON.encode(value)

      assert_equal JSON.generate(value), json
      assert_equal value, ActiveSupport::JSON.decode(json)
      assert_equal value, ActiveSupport::JSON.load(json)
    end

    assert_equal "null", ActiveSupport::JSON.encode(nil)
    assert_nil ActiveSupport::JSON.decode("null")
    assert_nil ActiveSupport::JSON.load("null")
  end
end
