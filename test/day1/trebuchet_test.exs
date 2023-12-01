defmodule Day1.TrebuchetTest do
  use ExUnit.Case
  alias Day1.Trebuchet

  describe "calc_calibration_value/1" do
    test "initial test" do
      expect_result = 142
      input = ["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"]

      assert expect_result === Trebuchet.calc_calibration_value(input)
    end
  end
end
