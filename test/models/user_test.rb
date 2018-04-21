require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", mail: "user@example.com",
      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "mail should be present" do
    @user.mail = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "mail should not be too long" do
    @user.mail = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "mail validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.mail = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "mail validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.mail = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "mail addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.mail = @user.mail.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "mail addresses should be saved as lower-case" do
    mixed_case_mail = "Foo@ExAMPle.CoM"
    @user.mail = mixed_case_mail
    @user.save
    assert_equal mixed_case_mail.downcase, @user.reload.mail
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
